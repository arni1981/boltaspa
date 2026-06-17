import "@hotwired/turbo-rails"
import "controllers"

import 'custom/turbo_stream_actions'

if (document.body.dataset.environment == 'development') {
  import('debugging/hotwire')
}

