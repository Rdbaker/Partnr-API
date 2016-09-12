require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)


module Partnr
  class Application < Rails::Application
    @@MAJOR_VERSION = '1'
    @@MINOR_VERSION = '2'
    @@PATCH_VERSION = '2'

    # use rspec for testing
    config.generators do |g|
      g.test_framework :rspec
    end

    # load the libraries
    config.autoload_paths += %W(#{config.root}/lib)

    # return the version number
    def version
      @@MAJOR_VERSION+'.'+@@MINOR_VERSION+'.'+@@PATCH_VERSION
    end

    # include bower_components folder to search for assets
    config.assets.paths << Rails.root.join('vendor', 'assets', 'bower_components')

    config.paths.add File.join('app', 'api'), glob: File.join('**', '*.rb')
    config.autoload_paths += Dir[Rails.root.join('app', 'models', '*/')]
    config.autoload_paths += Dir[Rails.root.join('app', 'api', '*')]
    config.autoload_paths += Dir[Rails.root.join('app', 'api', 'v1', 'helpers')]
    config.autoload_paths += Dir[Rails.root.join('app', 'api', 'v1', 'entities')]
    config.autoload_paths += Dir[Rails.root.join('app', 'api', 'v1', 'entities', 'profile')]

    # NPM asset paths
    Rails.root.join('node_modules').to_s.tap do |npm_path|
      config.sass.load_paths << npm_path
      config.assets.paths << npm_path
    end
    # Precompile Bootstrap fonts
    config.assets.precompile << %r(bootstrap-sass/assets/fonts/bootstrap/[\w-]+\.(?:eot|svg|ttf|woff2?)$)

    # specify middleware order so CORS is before warden (devise)
    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins 'partnr-up.com'
        resource '/api/v1', :headers => :any, :methods => [:get, :post, :options, :put, :patch], :credentials => true, :max_age => 600
      end
    end
  end
end
