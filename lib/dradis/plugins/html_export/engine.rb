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

        addon_settings :html_export do
          settings.default_enabled = false
        end if defined?(Dradis::Pro)

        initializer 'dradis-html_export.mount_engine' do
          Rails.application.reloader.to_prepare do
            # By default, this engine is loaded into the main app. So, upon app
            # initialization, we first check if the DB is loaded and the Configuration
            # table has been created, before checking if the engine is enabled
            ActiveRecord::Base.lease_connection do
              if ::Configuration.table_exists?
                Rails.application.routes.append do
                  # Enabling/disabling integrations calls Rails.application.reload_routes! we need the enable
                  # check inside the block to ensure the routes can be re-enabled without a server restart
                  if Engine.enabled?
                    mount Engine => '/', as: :html_export
                  end
                end
              end
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
