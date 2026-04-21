Rails.application.config.i18n.default_locale = :is
Rails.application.config.i18n.available_locales = %i[is en]
Rails.application.config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]
