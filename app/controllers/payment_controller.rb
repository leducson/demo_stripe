class PaymentController < ApplicationController
  before_action :load_product, only: :create

  def create
    Stripe.api_key = ENV["STRIPE_SECRET_KEY"]
    token = params[:token]

    begin
      charge = Stripe::Charge.create(
        :amount => 10000,
        :currency => "usd",
        :source => token,
        :description => "Example charge",
        :metadata => {"invoice_number" => "ABCD", "invoice_id" => 1234}
      )

      redirect_to stripes_success_index_path
    rescue Stripe::CardError => e
      redirect_to root_path
    end
  end

  private
  def load_product
    @product = Product.find_by id: params[:product_id]
  end
end
