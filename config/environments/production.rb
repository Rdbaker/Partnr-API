Rails.application.configure do
  # Code is not reloaded between requests.
  config.cache_classes = true

  # Eager load code on boot. This eager loads most of Rails and
  # your application in memory, allowing both threaded web servers
  # and those relying on copy on write to perform better.
  # Rake tasks automatically ignore this option for performance.
  config.eager_load = true

  # Full error reports are disabled and caching is turned on.
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Disable Rails's static asset server (Apache or nginx will already do this).
  config.serve_static_files = false

  # Compress JavaScripts and CSS.
  config.assets.js_compressor = :uglifier
  config.assets.css_compressor = :sass

  # Do not fallback to assets pipeline if a precompiled asset is missed.
  config.assets.compile = false

  # Generate digests for assets URLs.
  config.assets.digest = true

  # Set to :debug to see everything in the log.
  config.log_level = :info

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation cannot be found).
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners.
  config.active_support.deprecation = :notify

  # Use default logging formatter so that PID and timestamp are not suppressed.
  config.log_formatter = ::Logger::Formatter.new

  # Do not dump schema after migrations.
  config.active_record.dump_schema_after_migration = false

  Rails.application.config.host = 'http://partnr.org'
  config.action_mailer.default_url_options = { :host => 'partnr.org' }
  config.action_mailer.smtp_settings = {
    :user_name => 'partnremailer',
    :password => 'P4rtnrS3nds3m4ilsN0w',
    :domain => 'smtp.sendgrid.net',
    :address => 'smtp.sendgrid.net',
    :port => 587,
    :authentication => :plain,
    :enable_starttls_auto => true
  }

  Rails.application.config.s3_host = "partnr-prd-assets.s3-us-west-2.amazonaws.com"

  # set up aws
  Aws.config={
    :access_key_id => 'AKIAI7HEL2GZ6EWUYEUA',
    :secret_access_key => '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',
    :region => 'us-west-2'
  }

  config.paperclip_defaults = {
    :storage => :s3,
    :s3_region => 'us-west-2',
    :s3_credentials => {
      :bucket => 'partnr-prd-assets',
      :access_key_id => 'AKIAI7HEL2GZ6EWUYEUA',
      :secret_access_key => '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'
    }
  }
end
