module Dradis
  module Plugins
    module HtmlExport

      class Exporter < Dradis::Plugins::Export::Base

        def title
          @title ||= if Dradis.constants.include?(:Pro)
                       "Dradis Professional Edition v#{Dradis::Pro.version}"
                     else
                       "Dradis Community Edition v#{Dradis::CE.version}"
                     end
        end

        def sort_issues(issues, template_properties)
          return unless issues.any? && template_properties&.sort_field

          sort_by = template_properties.sort_field

          logger.debug { "Template properties define a sort field: #{sort_by}. Sorting..." }

          # FIXME: Assume the Field :type is :number, so cast .to_f and sort
          issues.to_a.sort! do |a, b|
            b.fields.fetch(sort_by, '0').to_f <=> a.fields.fetch(sort_by, '0').to_f
          end

          logger.debug { 'Done sorting.' }
        end

        def export(args = {})
          template_path       = options.fetch(:template)
          template_properties = ::ReportTemplateProperties.find_by_template_file(File.basename(template_path)) rescue nil

          logger.debug { "Report title: #{title}"}

          issues = content_service.all_issues
          sort_issues(issues, template_properties)

          # FIXME: This is an ugly piece of code and the list of nodes should
          # come from the ContentService.
          nodes = issues.map(&:evidence).flatten.map(&:node).uniq

          locals = {
            issues: issues,
            nodes: nodes,
            notes: content_service.all_notes,
            project: project,
            reporting_cat: content_service.report_category,
            title: title,
            user: options[:user]
          }

          logger.debug { "Found #{locals[:notes].count} notes assigned to the reporting category." }

          if issues.any?
            logger.debug{ "Found #{issues.count} issues affecting #{nodes.count} nodes" }
          else
            logger.warning { "No issue library node found in this project" }
          end

          # Render template
          ApplicationController.render(
            file: template_path,
            layout: false,
            locals: locals
          )
        end
      end
    end
  end
end
