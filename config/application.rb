require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)


module Partnr
  class Application < Rails::Application
    @@MAJOR_VERSION = '0'
    @@MINOR_VERSION = '1'
    @@PATCH_VERSION = '1'

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
  end
end
