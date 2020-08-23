User.create email: "le.duc.son@sun-asterisk.com", password: "Aa@123456"

i = 1
price = 50
6.times do |i|
  i = i + 1
  price = price + 50
  Product.create(name: "Product #{i}", price: price)
end
Stripe.api_key = ENV["STRIPE_SECRET_KEY"]

product = Stripe::Product.create(
  name: "Basic Plan",
  type: "service"
)

plan = Stripe::Plan.create(
  amount: 30000,
  interval: "month",
  product: product.id,
  currency: "usd",
  id: "basic_plan_3"
)

Plan.create(name: product.name, plan_stripe_id: plan.id, price: plan.amount.to_f / 100, interval: "month")

product = Stripe::Product.create(
  name: "Gold Plan",
  type: "service"
)

plan = Stripe::Plan.create(
  amount: 60000,
  interval: "year",
  product: product.id,
  currency: "usd",
  id: "gold_plan_3"
)

Plan.create(name: product.name, plan_stripe_id: plan.id, price: plan.amount.to_f / 100, interval: "year")
