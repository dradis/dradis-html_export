module Dradis
  module Plugins
    module HtmlExport

      class Exporter # < Dradis::Plugins::Export::Base

        # Add auto_link support to the ERB processor (see rails_autolink)
        include ::ActionView::Helpers::TextHelper

        def export(args={})
          template_content = begin
            if args[:template]
              File.read(args[:template])
            else
              "<h1>No :template provided</h1>"
            end
          end

          # category_name = params.fetch(:category_name, Dradis::Core::Configuration.report)
          reporting_cat = args.fetch(:category, Dradis::Core::Category.report)
          reporting_notes_num = Dradis::Core::Note.where(category_id: reporting_cat).count
          title = "Dradis Framework - v#{Dradis::Core::VERSION::STRING}"
          notes = Dradis::Core::Note.where(category_id: reporting_cat)
          issues = Dradis::Core::Issue.find(Dradis::Core::Node.issue_library.notes.pluck(:id))

          erb = ERB.new(template_content)
          erb.result(binding)
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