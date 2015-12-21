module Dradis
  module Plugins
    module HtmlExport
      class BaseController < Dradis::Plugins::Export::BaseController
        # This method cycles throw the notes in the reporting category and creates
        # a simple HTML report with them.
        #
        # It uses the template at: ./vendor/plugins/html_export/template.html.erb
        def index

          # these come from Export#create
          export_manager_hash   = session[:export_manager].with_indifferent_access
          content_service_class = export_manager_hash[:content_service].constantize

          exporter = Dradis::Plugins::HtmlExport::Exporter.new(
            content_service: content_service_class.new(plugin: Dradis::Plugins::HtmlExport)
          )

          doc = exporter.export(export_manager_hash)

          render type: 'text/html', text: doc
        end
      end

    end
  end
end
