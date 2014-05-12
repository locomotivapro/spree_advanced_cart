Spree::Order.class_eval do

  def create_proposed_shipments(shipping_method_id = nil)
    adjustments.shipping.delete_all
    shipments.destroy_all

    packages = Spree::Stock::Coordinator.new(self, shipping_method_id).packages
    packages.each do |package|
      shipments << package.to_shipment
    end

    shipments
  end

end
