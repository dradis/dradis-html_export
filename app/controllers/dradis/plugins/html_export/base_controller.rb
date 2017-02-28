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
          export_manager_hash = session[:export_manager].with_indifferent_access
          exporter            = Dradis::Plugins::HtmlExport::Exporter.new
          html                = exporter.export(export_manager_hash)

          render type: 'text/html', text: html
        end
      end

    end
  end
end
