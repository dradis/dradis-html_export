module Dradis
  module Plugins
    module HtmlExport
      BASE_CONTROLLER = Dradis.constants.include?(:Pro) ? ProjectScopedController : Dradis::Frontend::AuthenticatedController

      class BaseController < BASE_CONTROLLER
        # This method cycles throw the notes in the reporting category and creates
        # a simple HTML report with them.
        #
        # It uses the template at: ./vendor/plugins/html_export/template.html.erb
        def index
          # these come from Export#create
          export_manager = session[:export_manager].with_indifferent_access

          exporter = Dradis::Plugins::HtmlExport::Exporter.new
          doc = exporter.export(export_manager)

          render type: 'text/html', text: doc
        end
      end

    end
  end
end
