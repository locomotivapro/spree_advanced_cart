Spree::Core::Engine.routes.draw do

  get "/estimate_shipping_cost", :to => 'orders#estimate_shipping_cost'

end
