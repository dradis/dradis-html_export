module Dradis
  module Plugins
    module HtmlExport
      class ExportsController < Dradis::Plugins::Export::BaseController
        # This method cycles throw the notes in the reporting category and creates
        # a simple HTML report with them.
        #
        # It uses the template at: ./vendor/plugins/html_export/template.html.erb
        def create
          options = export_params.merge(template: @template_file)
          exporter = Dradis::Plugins::HtmlExport::Exporter.new(options)
          html = exporter.export

          render html: html.html_safe
        end
      end
    end
  end
end
