Spree::OrdersController.class_eval do

  def estimate_shipping_cost
    @order = current_order(lock: true)
    # default attributes for stub address
    country_id = params[:country_id] || Spree::Config[:default_country_id]
    address_attrs = { :zipcode => params[:zipcode],
                      :country_id => country_id }

    @zipcode = params[:zipcode]
    @order.ship_address = Spree::Address.new(address_attrs)
    package = Spree::Stock::Coordinator.new(@order).packages.first
    @shipping_rates = package.shipping_rates
    #@shipping_rates = Spree::Stock::Estimator.new(@order).shipping_rates(package)
    @esc_values = @shipping_rates.map do |sr|
        error = nil
        begin
          rate = sr.cost
        rescue Spree::ShippingError => ex
          error = ex.message.sub("Shipping Error: ", '')
        rescue Net::HTTPServiceUnavailable
          error = nil # carrier is unavailable atm, don't show this shipping method in the list
        end
        [sr.name, rate, error, sr.shipping_method.id]
      end.select{|sr| sr[1] || sr[2]}. # a shipping calculator can return nil for the price if error occurred
          sort_by{|sr| sr[1] ? sr[1] : Float::MAX} # mimic default spree_core behavior, preserve asc cost order

    respond_with do |format|
      format.html do
        flash[:notice] = @esc_values.collect{|name, price| "#{name} #{price}" }.join("<br />").html_safe if @esc_values.present?
        redirect_to cart_path
      end
      format.js do
        render :action => :estimate_shipping_cost
      end
    end
  end

  def apply_shipping_cost
    @order = current_order(lock: true)
    shipping_method_id = params[:shipping_method_id]
    @order.create_cart_shipment(shipping_method_id)
  end

end
