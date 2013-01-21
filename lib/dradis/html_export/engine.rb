module Dradis
  module HtmlExport
    class Engine < ::Rails::Engine
      include Dradis::Core::Plugins::Base
      isolate_namespace Dradis::HtmlExport
      engine_name 'dradis_html_export'

      plugin_name 'HTML export'
      provides :export

      Dradis::Core::Plugins::register(Dradis::HtmlExport)
    end
  end
end
