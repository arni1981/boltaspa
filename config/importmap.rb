# Pin npm packages by running ./bin/importmap
enable_integrity!

# Core application and framework libraries
pin 'application'
pin '@hotwired/turbo-rails', to: 'turbo.min.js'
pin '@hotwired/stimulus', to: 'stimulus.min.js'
pin '@hotwired/stimulus-loading', to: 'stimulus-loading.js'

# JavaScript controllers and custom code
pin_all_from 'app/javascript/controllers', under: 'controllers'
pin_all_from 'app/javascript/custom', under: 'custom'
pin_all_from 'app/javascript/debugging', under: 'debugging', preload: false

# Third-party libraries
pin 'sweetalert2' # @11.26.24
