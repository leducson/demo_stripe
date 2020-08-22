class SubcriptionsController < ApplicationController
  before_action :load_product, only: :create

  def create
    ActiveRecord::Base.transaction do
      Stripe.api_key = ENV["STRIPE_SECRET_KEY"]

      product = Stripe::Product.create(
        name: "#{@product.name} - premium Subscription",
        type: "service"
      )

      plan = Stripe::Plan.create(
        amount: @product.price.to_i * 100,
        interval: "month",
        product: product.id,
        currency: "usd",
        id: "premium-monthly"
      )

      customer = Stripe::Customer.retrieve("cus_Hq27N0NRJJnMkl")

      invoice = @product.invoices.create(
        price: @product.price * 100,
        status: :no_invoice_due
      )
      Stripe::Subscription.create(
        customer: customer.id,
        items: [
          { plan: "premium-monthly" }
        ],
        metadata: {
          invoice_id: invoice.id
        }
      )
    end
  end

  private
  def load_product
    @product = Product.find_by id: params[:product_id]
  end
end
