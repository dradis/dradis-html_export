module Dradis
  module Plugins
    module HtmlExport
      class Engine < ::Rails::Engine

        # Standard Rails Engine stuff
        isolate_namespace Dradis::HtmlExport
        engine_name 'dradis_html_export'

        # use rspec for tests
        config.generators do |g|
          g.test_framework :rspec
        end

        # Connect to the Framework
        include Dradis::Core::Plugins::Base

        plugin_name 'HTML export'
        provides :export

        Dradis::Core::Plugins::register(Dradis::HtmlExport)

        initializer "dradis.html_export.init_category" do |app|
          Dradis::Core::Category.find_or_create_by_name( HtmlExport::Configuration.category ) if Dradis::Configuration.table_exists?
        end

        # # TODO: could we use this instead?
        # # https://github.com/spree/spree_analytics/blob/079949fd0e6d9ec87eefd8e3b9c70b5aa3bf25d3/lib/spree_analytics/engine.rb
        # # Configuration
        # # mattr_accessor :app_id, :site_id, :token, :api_url, :data_url
        # # self.template = ''
        # class Configuration < Dradis::Core::Configurator
        #   configure :namespace => 'htmlexport'
        #   setting :category, :default => 'HtmlExport ready'
        #   # setting :template, :default => Rails.root.join( 'vendor', 'plugins', 'html_export', 'template.html.erb' )
        #   setting :template, :default => '/Users/etd/dradis/git/dradis-html_export/template.html.erb'
        # end

      end
    end
  end
end
