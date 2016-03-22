class RoutesController < ApplicationController
  def show
    options = Route.new(origin: params[:origin],
                        destination: params[:destination]).options

    unless options[:flights_info].nil?
      @flights_price = options[:flights_info][:avg_price].round(2)
      @flights_duration = options[:flights_info][:avg_duration]
    else
      @no_flights = true
    end

    unless options[:trains_info].nil?
      @trains_price = options[:trains_info][:avg_price].round(2)
      @trains_duration = options[:trains_info][:avg_duration]
    else
      @no_trains = true
    end

    unless options[:bus_info].nil?
      @bus_price = options[:bus_info][:avg_price].round(2)
      @bus_duration = options[:bus_info][:avg_duration]
    else
      @no_bus = true
    end
  end
end
