class StripeIpnController < ApplicationController
  protect_from_forgery except: :create
  skip_before_action :verify_authenticity_token, only: :create
  before_action :authenticate_user!, except: :create


  def create
    event = Stripe::Event.retrieve params[:id]

    case
    when event.type == "charge.refunded"
      ipn_refund event
    when event.type == "charge.succeeded"
      ipn_charge event
    when event.type == "invoice.payment_succeeded"
      ipn_subscription event
    end

    render nothing: true
  end

  private
  def ipn_charge event
    unless event.data.object.metadata.to_h.blank?
      invoice = Invoice.find_by id: event.data.object.metadata.invoice_id
      if event.data.object.paid
        # Xác nhận thanh toán thành công
        # create invoice
        invoice.update_attributes charge_id: event.data.object.id, status: :paid
      else
        # Xác nhận thanh thoán không thành công
        # Ta gửi email thông báo cho user
        invoice.update_attributes charge_id: event.data.object.id, status: :unpaid
      end
    end
  end

  def ipn_refund event
    unless event.data.object.metadata.to_h.blank?
      invoice = Invoice.find_by id: event.data.object.metadata.invoice_id
      if event.data.object.paid
        invoice.update_attributes status: :refuned, reason: "Requested by Customer"
      else
        invoice.update_attributes reason: "Refund fails. Please try again", status: :paid
      end
    end
  end

  def ipn_subscription event
    invoice = Invoice.find_by id: event.data.object.lines.data.first.metadata.invoice_id
    if event.data.object.paid
      invoice.update_attributes status: :paid, charge_id: event.data.object.id
    else
      invoice.update_attributes status: :unpaid, charge_id: event.data.object.id
    end
  end
end
