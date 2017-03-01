module Dradis
  module Plugins
    module HtmlExport
      class BaseController < Dradis::Plugins::Export::BaseController
        # This method cycles throw the notes in the reporting category and creates
        # a simple HTML report with them.
        #
        # It uses the template at: ./vendor/plugins/html_export/template.html.erb
        def index
          exporter = Dradis::Plugins::HtmlExport::Exporter.new(export_options)
          html     = exporter.export

          render type: 'text/html', text: html
        end
      end

    end
  end
end
