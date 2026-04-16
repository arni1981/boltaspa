class ApplicationJob < ActiveJob::Base
  BASE_URL = "https://api.football-data.org/v4/competitions/".freeze

  def football_data(endpoint)
    url = BASE_URL + endpoint

    connection = Faraday.new(url: url) do |f|
      f.headers["X-Auth-Token"] = Rails.app.creds.require('FOOTBALL_DATA_AUTH_TOKEN'.downcase)
      f.request :json
      f.response :json
    end

    connection.get.body
  end
end
