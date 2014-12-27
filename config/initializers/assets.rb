# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# get the controller specific js (coffee) and css files
Rails.application.config.assets.precompile += %w( welcome.js )
Rails.application.config.assets.precompile += %w( welcome.css )
Rails.application.config.assets.precompile += %w( loggedin.js )
Rails.application.config.assets.precompile += %w( loggedin.css )
Rails.application.config.assets.precompile += %w( messages.js )
Rails.application.config.assets.precompile += %w( messages.css )
