module Dradis
  module Plugins
    module HtmlExport
      class BaseController < Dradis::Plugins::Export::BaseController

        def index
          exporter = Dradis::Plugins::HtmlExport::Exporter.new(params)
          html     = exporter.export

          render html: html.html_safe
        end
      end
    end
  end
end
