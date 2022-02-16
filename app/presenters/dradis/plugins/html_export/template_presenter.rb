module Dradis
  module Plugins
    module HtmlExport
      class TemplatePresenter < BasePresenter
        presents :template

        def title
          return template if template.is_a?(String)

          "#{template.title} - #{content_tag(:small, template.template_file)}".html_safe
        end

        def filename
          return template if template.is_a?(String)

          template.template_file
        end
      end
    end
  end
end
