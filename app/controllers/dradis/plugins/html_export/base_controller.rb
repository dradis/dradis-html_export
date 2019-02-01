module Dradis
  module Plugins
    module HtmlExport
      class BaseController < Dradis::Plugins::Export::BaseController
        skip_before_action :ensure_tester, only: [:gateway_index]

        def index
          render_html
        end

        # This action is similar to the index action but skips the tester check
        # for the gateway.
        def gateway_index
          render_html
        end

        private

        # This method cycles throw the notes in the reporting category and creates
        # a simple HTML report with them.
        #
        # It uses the template at: ./vendor/plugins/html_export/template.html.erb
        def render_html
          exporter = Dradis::Plugins::HtmlExport::Exporter.new(export_options)
          html     = exporter.export

          render html: html.html_safe
        end
      end

    end
  end
end
