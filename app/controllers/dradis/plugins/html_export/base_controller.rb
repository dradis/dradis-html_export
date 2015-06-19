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
          export_manager = session[:export_manager].with_indifferent_access

          exporter = Dradis::Plugins::HtmlExport::Exporter.new(
            content_service: export_manager[:content_service].constantize.new
          )

          doc = exporter.export(
            template: export_manager[:template]
          )

          render type: 'text/html', text: doc
        end
      end

    end
  end
end