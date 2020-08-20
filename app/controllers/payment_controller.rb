class PaymentController < ApplicationController
  before_action :load_product, only: :create

  def create
    Stripe.api_key = ENV["STRIPE_SECRET_KEY"]
    token = params[:token]

    begin
      @invoice = @product.invoices.create(
        price: (@product.price * 100),
        status: :no_invoice_due
      )

      charge = Stripe::Charge.create(
        :amount => @product.price.to_i * 100,
        :currency => "usd",
        :source => token,
        :description => "Payment for #{@product.name}",
        :metadata => {
          invoice_id: @invoice.id
        }
      )

      redirect_to payments_success_path
    rescue Stripe::CardError => e
      @product.invoices.create(
        price: (@product.price * 100),
        status: :cancel
      )
      redirect_to payments_cancel_path
    end
  end

  private
  def load_product
    @product = Product.find_by id: params[:product_id]
  end
end
