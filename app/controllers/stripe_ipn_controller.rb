class StripeIpnController < ApplicationController
  protect_from_forgery except: :create
  skip_before_action :verify_authenticity_token, only: :create
  before_action :authenticate_user!, except: :create


  def create
    event = Stripe::Event.retrieve params[:id]
    invoice = Invoice.find_by id: event.data.object.metadata.invoice_id

    if event.type == "charge.succeeded" && event.data.object.paid
      # Xác nhận thanh toán thành công
      # create invoice
      invoice.update_attributes charge_id: event.data.object.id, status: :paid
    else
      # Xác nhận thanh thoán không thành công
      # Ta gửi email thông báo cho user
      invoice.update_attributes charge_id: event.data.object.id, status: :unpaid
    end

binding.pry
    render nothing: true
  end
end
