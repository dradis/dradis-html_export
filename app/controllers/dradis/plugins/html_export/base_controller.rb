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
          html     = exporter.export do |filename, template|
            destination_path = Rails.root.join("app/views/tmp/#{filename}")
            FileUtils.mkdir_p(File.dirname(destination_path))
            FileUtils.cp(template, destination_path)
          end

          render html: html.html_safe
        end
      end

    end
  end
end
