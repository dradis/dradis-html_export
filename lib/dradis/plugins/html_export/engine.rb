module Dradis
  module Plugins
    module HtmlExport
      class Engine < ::Rails::Engine

        # Standard Rails Engine stuff
        isolate_namespace Dradis::Plugins::HtmlExport
        engine_name 'dradis_html_export'

        # use rspec for tests
        config.generators do |g|
          g.test_framework :rspec
        end

        # Connect to the Framework
        include Dradis::Plugins::Base

        # plugin_name 'HTML export'
        provides :export
        description 'Generate advanced HTML reports'


        initializer 'dradis-html_export.mount_engine' do
          Rails.application.routes.append do
            mount Dradis::Plugins::HtmlExport::Engine => '/export/html'
          end
        end

        config.after_initialize do
          # Dradis::Plugins::HtmlExport::Exporter needs ::ApplicationHelper
          # module from the main app. Here we are forcing that class to be
          # loaded once the main app is loaded, so it can use
          # 'include ;;ApplicationHelper' without surprises
          require 'dradis/plugins/html_export/exporter'
        end
      end
    end
  end
end
