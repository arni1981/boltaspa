# app/controllers/concerns/trackable.rb
module Trackable
  extend ActiveSupport::Concern

  included do
    after_action :track_visit
  end

  private

  def track_visit
    # Filter for "Quiet Luxury": only track successful HTML requests
    return unless should_track_request?

    # If using Solid Queue, you'd call a Job here. 
    # Otherwise, direct creation is fine for low-to-mid traffic.
    Visit.create(
      path: request.fullpath,
      user_agent: request.user_agent,
      remote_ip: request.remote_ip,
      user: Current&.user
    )
  rescue StandardError => e
    # Log the error but never crash the user's request for a tracking failure
    Rails.logger.warn "Visit Tracking Error: #{e.message}"
  end

  def should_track_request?
    request.format.html? && 
      response.status == 200 && 
      !request.xhr? && 
      !admin_route?
  end

  def admin_route?
    # Adjust this regex to match your admin namespace
    request.path.start_with?('/admin')
  end
end