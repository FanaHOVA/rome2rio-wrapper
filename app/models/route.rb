class Route < ActiveRecord::Base

  def fetch_routes
    endpoint = "https://rome2rio12.p.mashape.com/Search?oName=#{origin}&dName=#{destination}"

    req = HTTParty.get(endpoint,
                       headers: { 'X-Mashape-Key' => ENV['MASHAPE_KEY'],
                                  'Accept' => 'application/json' }
                      )

    (JSON.parse req.body)['routes']
  end

  def options
    api_data = fetch_routes

    {
      flights_info: extract_info(api_data, 'fly'),
      trains_info: extract_info(api_data, 'train'),
      bus_info: extract_info(api_data, 'bus')
    }
  end

  def extract_info(data, identifier)
    costs = []
    durations = []

    data.each do |route|
      if /#{identifier}/ =~ route['name'].downcase
        # Se il nome della route e' "Fly ...." i viaggi in bus/treno partendo
        # dalla destinazione non devono essere contati come viaggi in treno/bus
        next if (/fly/ =~ route['name'].downcase) == 0 && identifier != 'fly'

        costs << route['indicativePrice']['price']
        durations << route['duration']
      end
    end

    return nil if costs.empty?

    avg_minutes = (durations.sum.to_f / durations.count)

    {
      avg_price: (costs.sum.to_f / costs.count) * 0.89,
      avg_duration: Time.at(avg_minutes * 60).utc.strftime('%H:%M')
    }
  end
end
