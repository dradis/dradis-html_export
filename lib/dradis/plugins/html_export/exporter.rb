module Dradis
  module Plugins
    module HtmlExport

      class Exporter < Dradis::Plugins::Export::Base

        def export(args = {})
          log_report

          # Render template
          ApplicationController.render(
            file: options.fetch(:template),
            layout: false,
            locals: {
              categorized_issues: categorized_issues,
              content_service: content_service,
              issues: issues,
              nodes: nodes,
              notes: notes,
              project: project,
              reporting_cat: content_service.report_category,
              tags: tags,
              title: title,
              user: options[:user]
            }
          )
        end

        private
        def log_report
          logger.debug { "Report title: #{title}" }
          logger.debug { "Template properties define a sort field: #{sort_field}" }

          if issues&.any?
            logger.debug { "Found #{issues.count} issues affecting #{nodes.count} nodes" }
          else
            logger.warn { 'No issue library node found in this project' }
          end

          logger.debug { "Found #{notes.count} notes assigned to the reporting category." }
        end

        def nodes
          # FIXME: This is an ugly piece of code and the list of nodes should
          # come from the ContentService.
          @nodes ||= issues.map(&:evidence).flatten.map(&:node).uniq
        end

        def notes
          @notes ||= content_service.all_notes
        end

        def issues
          @issues ||= sort_issues content_service.all_issues.includes(:tags)
        end

        def categorized_issues
          @categorized_issues ||= tags
            .each_with_object({}) { |tag, hash| hash[tag.id] = issues.select { |issue| issue.tags.include?(tag) } }
            .tap { |hash| hash[:untagged] = issues.select { |issue| issue.tags.empty? } }
        end

        def sort_field
          @sort_field ||= begin
            template_path = options.fetch(:template)
            properties = ::ReportTemplateProperties.find_by_template_file(File.basename(template_path)) rescue nil
            properties&.sort_field
          end
        end

        def sort_issues(unsorted_issues)
          return unsorted_issues unless unsorted_issues.any? && sort_field

          # FIXME: Assume the Field :type is :number, so cast .to_f and sort
          unsorted_issues.sort do |a, b|
            b.fields.fetch(sort_field, '0').to_f <=> a.fields.fetch(sort_field, '0').to_f
          end
        end

        def tags
          @tags ||= project.tags
        end

        def title
          @title ||= if Dradis.constants.include?(:Pro)
                       "Dradis Professional Edition v#{Dradis::Pro.version}"
                     else
                       "Dradis Community Edition v#{Dradis::CE.version}"
                     end
        end
      end
    end
  end
end
