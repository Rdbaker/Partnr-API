Rails.application.configure do
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  # Adds additional error checking when serving assets at runtime.
  # Checks for improperly declared sprockets dependencies.
  # Raises helpful error messages.
  config.assets.raise_runtime_errors = true

  # set things up for local email forwarding
  config.action_mailer.delivery_method = :smtp
  Rails.application.config.host = 'http://localhost:3000'
  config.action_mailer.default_url_options = { :host => 'localhost:3000' }
  config.action_mailer.smtp_settings = { :address => "localhost", :port => 1025 }

  Rails.application.config.s3_host = "partnr-dev-assets.s3-us-west-2.amazonaws.com"

  # set up aws
  Aws.config={
    :access_key_id => 'AKIAJUUWSQI2SFDTT5ZQ',
    :secret_access_key => '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',
    :region => 'us-west-2'
  }

  config.paperclip_defaults = {
    :storage => :s3,
    :s3_region => 'us-west-2',
    :s3_credentials => {
      :bucket => 'partnr-dev-assets',
      :access_key_id => 'AKIAJUUWSQI2SFDTT5ZQ',
      :secret_access_key => '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'
    }
  }
end

