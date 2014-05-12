Spree::Stock::Coordinator.class_eval do

  def initialize(order, shipping_method_id=nil)
    @order, @shipping_method_id = order, shipping_method_id
  end

  def estimate_packages(packages)
    estimator = Spree::Stock::Estimator.new(order, @shipping_method_id)
    packages.each do |package|
      package.shipping_rates = estimator.shipping_rates(package)
    end
    packages
  end

end
