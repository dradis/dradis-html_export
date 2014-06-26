require 'dradis/core'

require 'dradis/html_export/engine'

require 'dradis/html_export/processor'
require 'dradis/html_export/version'

module Dradis
  module HtmlExport

    # TODO: could we use this instead?
    # https://github.com/spree/spree_analytics/blob/079949fd0e6d9ec87eefd8e3b9c70b5aa3bf25d3/lib/spree_analytics/engine.rb
    # Configuration
    # mattr_accessor :app_id, :site_id, :token, :api_url, :data_url
    # self.template = ''
    class Configuration < Dradis::Core::Configurator
      configure :namespace => 'htmlexport'
      setting :category, :default => 'HtmlExport ready'
      # setting :template, :default => Rails.root.join( 'vendor', 'plugins', 'html_export', 'template.html.erb' )
      setting :template, :default => '/Users/etd/dradis/git/dradis-html_export/template.html.erb'
    end
  end
end
