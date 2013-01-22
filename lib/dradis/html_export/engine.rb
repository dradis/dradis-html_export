module Dradis
  module HtmlExport
    class Engine < ::Rails::Engine

      # Standard Rails Engine stuff
      isolate_namespace Dradis::HtmlExport
      engine_name 'dradis_html_export'

      # use rspec for tests
      config.generators do |g|
        g.test_framework :rspec
      end

      # Connect to the Framework
      include Dradis::Core::Plugins::Base

      plugin_name 'HTML export'
      provides :export

      Dradis::Core::Plugins::register(Dradis::HtmlExport)

      initializer "dradis.html_export.init_category" do |app|
        Dradis::Core::Category.find_or_create_by_name( HtmlExport::Configuration.category )
      end
    end
  end
end
