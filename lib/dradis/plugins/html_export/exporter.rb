module Dradis
  module Plugins
    module HtmlExport

      class Exporter < Dradis::Plugins::Export::Base
        # Add auto_link support to the ERB processor (see rails_autolink)
        include ::ActionView::Helpers::TextHelper
        # For auto_link feature (requires #mail_to)
        include ::ActionView::Helpers::UrlHelper

        def export(args = {})
          community_edition   = Dradis.constants.include?(:Core)
          model_namespace     = community_edition ? Dradis::Core : nil
          logger              = args.fetch(:logger, Rails.logger)
          template_path       = args.fetch(:template)
          template_properties = ::ReportTemplateProperties.find_by_template_file(File.basename(template_path)) rescue nil
          project             = args[:project]
          reporting_cat       = args.fetch(:category, model_namespace::Category.report)

          # Build title
          title = community_edition ? "Dradis Framework" : "Dradis Professional Edition"
          title += "- v"
          title += community_edition ? Dradis::Core::VERSION::STRING : Core::Pro::VERSION::STRING
          logger.debug{ "Report title: #{title}"}

          # Prepare notes
          notes = model_namespace::Note.where(category_id: reporting_cat)
          logger.debug{ "Found #{notes.count} notes assigned to #{reporting_cat.name}."}

          # Prepare issues
          issuelib = model_namespace::Node.issue_library
          if issuelib
            note_ids = issuelib.notes.map(&:id)
            issues = model_namespace::Issue.find(note_ids)

            # Sort our issues based on the ReportTemplateProperties rules.
            if template_properties && template_properties.sort_field
              sort_by = template_properties.sort_field

              logger.debug{ "Template properties define a sort field: #{sort_by}. Sorting..." }

              # FIXME: Assume the Field :type is :number, so cast .to_f and sort
              issues.sort! do |a, b|
                b.fields.fetch(sort_by, '0').to_f <=> a.fields.fetch(sort_by, '0').to_f
              end

              logger.debug{ "Done." }
            end

            # FIXME: This is an ugly piece of code
            nodes = model_namespace::Evidence.where(issue_id: note_ids).includes(:node).collect(&:node).uniq

            logger.debug{ "Found #{issues.count} issues affecting #{nodes.count} nodes" }
          else
            logger.warning { "No issue library node found in this project" }
          end

          # Render template
          erb = ERB.new( File.read(template_path) )
          erb.result( binding )
        end

        private
        def markup(text)
          return unless text.present?

          output = text.dup
          Hash[ *text.scan(/#\[(.+?)\]#[\r|\n](.*?)(?=#\[|\z)/m).flatten.collect{ |str| str.strip } ].keys.each do |field|
            output.gsub!(/#\[#{Regexp.escape(field)}\]#[\r|\n]/, "h4. #{field}\n\n")
          end

          auto_link(RedCloth.new(output, [:filter_html, :no_span_caps]).to_html, sanitize: false ).html_safe
        end
      end
    end
  end
end
