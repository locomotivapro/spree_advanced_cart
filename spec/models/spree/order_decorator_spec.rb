require "spec_helper"

describe Spree::Order do
  describe "#create_proposed_shipments" do
    it "pass shipment_id to Stock Estimator" do
      order = create :order_with_line_items
      shipping_method = create :shipping_method
      packages = double "bla", packages: []

      expect( Spree::Stock::Coordinator ).to receive(:new).with(order, shipping_method.id).and_return(packages)
      order.create_proposed_shipments(shipping_method.id)
    end
  end

end
