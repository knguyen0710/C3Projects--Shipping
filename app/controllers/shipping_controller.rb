class ShippingController < ApplicationController

  # where the route goes from the API call
  # TEST URL:
  # http://localhost:3001/shipping?o_state=WA&o_city=seattle&o_zip=98109&state=UT&city=park%20city&zip=84098&packages[][length]=2&packages[][width]=2&packages[][height]=2&packages[][weight]=2&packages[][length]=3&packages[][width]=3&packages[][height]=3&packages[][weight]=3

  def calc_rates

    destination = new_location(params[:state], params[:city], params[:zip])
    origin = new_location(params[:o_state], params[:o_city], params[:o_zip])
    all_packages = new_package(params[:packages])

    shipping_options = calc_shipping_options(origin, destination, all_packages)

    # turn this into a json object to send back to bEtsy app
    unless shipping_options.empty?
      render json: shipping_options.as_json(except: [:created_at, :updated_at])
    else
      render json: {}, status: 204
    end
  end

  # def log_completed_shipment
    # another API call from bEtsy to our API to log which shipping method/cost, etc. they checked out with
  # end

##################################################
private

  def new_location(state, city, zip)
    ActiveShipping::Location.new( :country => 'US',
                                  :state => state,
                                  :city => city,
                                  :zip => zip)
  end

  def new_package(packages)
    all_packages = []
    packages.each do |p|
      all_packages << ActiveShipping::Package.new(p[:weight].to_f, [p[:length].to_i, p[:width].to_i, p[:height].to_i], :units => :imperial)
    end

    return all_packages
  end

  def calc_shipping_options(origin, destination, packages)
    ups_options = UpsApi.new.calc_ups_options(origin, destination, packages)
    fedex_options = FedexApi.new.fedex_rates(origin, destination, packages)

    shipping_options = ups_options + fedex_options
  end
end
