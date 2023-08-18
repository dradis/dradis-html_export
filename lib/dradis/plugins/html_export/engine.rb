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
        provides :export, :rtp
        description 'Generate advanced HTML reports'

        initializer 'dradis-html_export.disable_by_default' do
          ActiveSupport.on_load(:configuration) do
            unless ::Configuration.find_by_name('html_export:enabled')
              Dradis::Plugins::HtmlExport::Engine.disable!
            end
          end
        end

        initializer 'dradis-html_export.mount_engine' do
          Rails.application.routes.append do
            # Enabling/disabling integrations calls Rails.application.reload_routes! we need the enable
            # check inside the block to ensure the routes can be re-enabled without a server restart
            if Dradis::Plugins::HtmlExport::Engine.enabled?
              mount Dradis::Plugins::HtmlExport::Engine => '/', as: :html_export
            end
          end
        end

        initializer 'dradis-html_export.include_helper' do
          ActiveSupport.on_load(:action_view) do
            Dradis::Plugins::HtmlExport::Exporter.include(ApplicationHelper)
          end
        end
      end
    end
  end
end
