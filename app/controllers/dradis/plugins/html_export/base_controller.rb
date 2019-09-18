module Dradis
  module Plugins
    module HtmlExport
      class BaseController < Dradis::Plugins::Export::BaseController

        def index
          exporter = Dradis::Plugins::HtmlExport::Exporter.new(export_params)
          html     = exporter.export

          render html: html.html_safe
        end

        private

        def export_params
          params.permit(:project_id, :template)
        end
      end
    end
  end
end
