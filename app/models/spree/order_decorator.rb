Spree::Order.class_eval do
  def create_cart_shipment(shipping_method_id)
    adjustments.shipping.delete_all
    shipments.destroy_all

    packages = Spree::Stock::Coordinator.new(self).packages
  end
end
