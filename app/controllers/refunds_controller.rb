class RefundsController < ApplicationController
  before_action :load_invoice, only: :create

  def create
    Stripe.api_key = ENV["STRIPE_SECRET_KEY"]

    refund = Stripe::Refund.create({
      charge: @invoice.charge_id
    })

    if refund.status = "succeeded" && refund.object == "refund"
      @invoice.refuning!
      flash.now[:success] = "Refund payment is processing"
    else
      flash.now[:success] = "Refund payment is failed"
    end
  rescue
    flash.now[:success] = "Refund payment is failed"
  end

  private
  def load_invoice
    @invoice = Invoice.find_by id: params[:invoice_id]
  end
end
