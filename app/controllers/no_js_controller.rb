class NoJsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def show
    # Log the event to your Rails log or a dedicated table
    Rails.logger.warn "NOSCRIPT: user_id: #{Current.user&.id} url: #{params[:url]}"

    # Return a 1x1 transparent GIF
    send_data(
      Base64.decode64('R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7'),
      type: 'image/gif',
      disposition: 'inline'
    )
  end
end
