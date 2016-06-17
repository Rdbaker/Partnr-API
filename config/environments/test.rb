Rails.application.configure do
  # The test environment is used exclusively to run your application's
  # test suite. You never need to work with it otherwise. Remember that
  # your test database is "scratch space" for the test suite and is wiped
  # and recreated between test runs. Don't rely on the data there!
  config.cache_classes = true

  # Do not eager load code on boot. This avoids loading your whole application
  # just for the purpose of running a single test. If you are using a tool that
  # preloads Rails for running tests, you may have to set it to true.
  config.eager_load = false

  # Configure static asset server for tests with Cache-Control for performance.
  config.serve_static_files = true
  config.static_cache_control = 'public, max-age=3600'

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Raise exceptions instead of rendering exception templates.
  config.action_dispatch.show_exceptions = false

  # Disable request forgery protection in test environment.
  config.action_controller.allow_forgery_protection = false

  # Tell Action Mailer not to deliver emails to the real world.
  # The :test delivery method accumulates sent emails in the
  # ActionMailer::Base.deliveries array.
  config.action_mailer.delivery_method = :test
  config.action_mailer.default_url_options = { :host => 'localhost:3000' }

  # Print deprecation notices to the stderr.
  config.active_support.deprecation = :stderr

  # something about the new version of rails etc..
  config.active_record.raise_in_transactional_callbacks = true

  # set up the mailer - don't send anything through in the testing environment
  # config.action_mailer.delivery_method = :smtp
  Rails.application.config.host = 'http://localhost:3000'
  # config.action_mailer.default_url_options = { :host => 'localhost:3000' }
  # config.action_mailer.smtp_settings = { :address => "localhost", :port => 1025 }

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
