module Dradis
  module Plugins
    module HtmlExport

      class Exporter < Dradis::Plugins::Export::Base
        # Add auto_link support to the ERB processor (see rails_autolink)
        include ::ActionView::Helpers::TextHelper
        # For auto_link feature (requires #mail_to)
        include ::ActionView::Helpers::UrlHelper
        # For 'markup' method
        include ::ApplicationHelper

        def export(args = {})
          template_path       = options.fetch(:template)
          template_properties = ::ReportTemplateProperties.find_by_template_file(File.basename(template_path)) rescue nil

          # Build title
          title = if Dradis.constants.include?(:Pro)
                    "Dradis Professional Edition v#{Dradis::Pro.version}"
                  else
                    "Dradis Community Edition v#{Dradis::CE.version}"
                  end
          logger.debug{ "Report title: #{title}"}

          # Prepare notes
          reporting_cat = content_service.report_category
          notes = content_service.all_notes
          logger.debug{ "Found #{notes.count} notes assigned to the reporting category."}

          # Prepare issues
          issues = content_service.all_issues
          if issues
            # Sort our issues based on the ReportTemplateProperties rules.
            if template_properties && template_properties.sort_field
              sort_by = template_properties.sort_field

              logger.debug{ "Template properties define a sort field: #{sort_by}. Sorting..." }

              # FIXME: Assume the Field :type is :number, so cast .to_f and sort
              issues.to_a.sort! do |a, b|
                b.fields.fetch(sort_by, '0').to_f <=> a.fields.fetch(sort_by, '0').to_f
              end

              logger.debug{ "Done." }
            end

            # FIXME: This is an ugly piece of code and the list of nodes should
            # come from the ContentService.
            nodes = issues.map(&:evidence).flatten.map(&:node).uniq

            logger.debug{ "Found #{issues.count} issues affecting #{nodes.count} nodes" }
          else
            logger.warning { "No issue library node found in this project" }
          end

          # Render template
          erb = ERB.new( File.read(template_path) )
          erb.result( binding )
        end
      end
    end
  end
end
