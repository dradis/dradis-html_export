module Dradis
  module Plugins
    module HtmlExport
      class BaseController < Dradis::Plugins::Export::BaseController
        before_action :validate_scope

        # This method cycles throw the notes in the reporting category and creates
        # a simple HTML report with them.
        #
        # It uses the template at: ./vendor/plugins/html_export/template.html.erb
        def index
          exporter = Dradis::Plugins::HtmlExport::Exporter.new(
            export_options.merge(scope: @scope.to_sym)
          )
          html = exporter.export

          render html: html.html_safe
        end

        private

        def validate_scope
          @scope = params[:scope]

          unless @scope == 'all' || @scope == 'published'
            raise 'Something fishy is going on...'
          end
        end
      end
    end
  end
end
