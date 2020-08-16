Rails.application.routes.draw do
  devise_for :users
  root :to => "dashboard#index"
  resources :dashboard, only: :index
  post "payment", to: "payment#create", as: "payment"
  post "stripe_ipn", to: "stripe_ipn#create", as: "stripe_ipn"
  get "payments/success", to: "stripes/success#index", as: "payments/success"
  get "payments/cancel", to: "stripes/cancel#index", as: "payments/cancel"

end
