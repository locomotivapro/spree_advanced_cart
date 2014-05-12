Spree::Stock::Estimator.class_eval do

  def initialize(order, shipping_method_id=nil)
    @order = order
    @currency = @order.currency
    @shipping_method_id = shipping_method_id
  end

  def shipping_methods(package)

    ship_methods = if @shipping_method_id
                     package.shipping_methods.select { |sm| sm.id == @shipping_method_id }
                   else

                     package.shipping_methods.select do |ship_method|
                       calculator = ship_method.calculator
                       begin
                         calculator.available?(package) &&
                           ship_method.include?(order.ship_address) &&
                           (calculator.preferences[:currency].nil? ||
                            calculator.preferences[:currency] == currency)
                       rescue Exception => exception
                         log_calculator_exception(ship_method, exception)
                       end
                     end
                   end
    ship_methods
  end

end
