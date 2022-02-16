module Dradis
  module Plugins
    module HtmlExport
      class TemplatePresenter < BasePresenter
        presents :template

        def title
          return template if template.is_a?(String)

          "#{template.title} - #{content_tag(:small, template.template_file)}".html_safe
        end
      end
    end
  end
end
