module Dradis
  module Plugins
    module HtmlExport
      class TemplatePresenter < BasePresenter
        presents :template

        def self.each_template(&block)
          templates.each(&block)
        end

        def self.templates
          if defined?(Dradis::Pro)
            ReportTemplateProperties.all.where(plugin_name: :html_export).order(:title)
          else
            Dir["%s/*" % templates_dir].map { |t| File.basename(t) }.sort
          end
        end

        def self.templates_dir
          File.join(::Configuration::paths_templates_reports, 'html_export')
        end

        def title
          return template if template.is_a?(String)

          content_tag(:span, "#{template.title} - ") +
            content_tag(:small, template.template_file)
        end

        def filename
          return template if template.is_a?(String)

          template.template_file
        end
      end
    end
  end
end
