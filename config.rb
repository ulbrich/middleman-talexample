require 'lib/custom_helpers'
require 'lib/tal/configuration'

helpers CustomHelpers

application_id = 'sampleapp'
variants = []

TAL::Configuration.device_configurations(application_id).each do |config|
  url = "/#{application_id}-#{config.device_brand}-#{config.device_model}.html"

  variants << [config.device_brand, config.device_model, url]

  proxy url, '/app.html',
    :locals => { :config => config, :application_id => application_id },
    :ignore => true, :layout => false
end

data.store('variants', variants)

set :css_dir, 'stylesheets'
set :js_dir, 'javascripts'
set :images_dir, 'images'

# Build-specific configuration
configure :build do
  # For example, change the Compass output style for deployment
  activate :minify_css

  # Minify Javascript on build
  activate :minify_javascript

  # Use relative URLs
  # activate :relative_assets

  # Compress PNGs after build
  # First: gem install middleman-smusher
  # require "middleman-smusher"
  # activate :smusher

  # Or use a different image path
  # set :http_path, "/Content/images/"
end
