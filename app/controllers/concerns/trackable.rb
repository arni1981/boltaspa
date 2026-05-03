# app/controllers/concerns/trackable.rb
module Trackable
  extend ActiveSupport::Concern

  included do
    after_action :track_visit
  end

  private

  def track_visit
    Visit.create(
      path: request.fullpath,
      user_agent: request.user_agent,
      remote_ip: request.remote_ip,
      user: Current&.user
    )
  rescue StandardError => e
    Rails.logger.warn "Visit Tracking Error: #{e.message}"
  end

  def admin_route?
    request.path.start_with?('/admin')
  end
end
