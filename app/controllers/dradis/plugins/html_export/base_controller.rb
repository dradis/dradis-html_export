module Dradis
  module Plugins
    module HtmlExport

      class BaseController < Dradis::Frontend::AuthenticatedController
        # This method cycles throw the notes in the reporting category and creates
        # a simple HTML report with them.
        #
        # It uses the template at: ./vendor/plugins/html_export/template.html.erb
        def index
          doc = Dradis::Plugins::HtmlExport::Exporter.export(params)
          render :type => 'text/html', :text => doc
        end
      end

    end
  end
end