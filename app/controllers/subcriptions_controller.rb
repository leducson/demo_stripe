class SubcriptionsController < ApplicationController
  before_action :load_plan, only: :create

  def create
    Stripe.api_key = ENV["STRIPE_SECRET_KEY"]
    token = params[:token]
    info = Stripe::Token.retrieve(token)

    customer = Stripe::Customer.create(
      source: token,
      email: info.email
    )

    @invoice = @plan.invoices.create price: @plan.price, status: :no_invoice_due, name: @plan.name

    Stripe::Subscription.create(
      :customer => customer.id,
      :metadata => {
        invoice_id: @invoice.id
      },
      :items => [
        { plan: @plan.plan_stripe_id }
      ]
    )

    redirect_to payments_success_path
  rescue
    @plan.invoices.create(
      price: (@plan.price * 100),
      status: :cancel
    )
    redirect_to payments_cancel_path
  end

  private
  def load_plan
    @plan = Plan.find_by id: params[:plan_id]
  end

  def get_token_info
    info = Stripe::Token.retrieve(token)
  end
end
