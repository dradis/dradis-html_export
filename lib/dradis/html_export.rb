require 'dradis/core'

require 'dradis/html_export/actions'
require 'dradis/html_export/processor'
require 'dradis/html_export/version'

module Dradis
  module HTMLExport
    class Configuration < Dradis::Core::Configurator
      configure :namespace => 'htmlexport'
      setting :category, :default => 'HTMLExport ready'
      # setting :template, :default => Rails.root.join( 'vendor', 'plugins', 'html_export', 'template.html.erb' )
      setting :template, :default => '/Users/etd/dradis/git/dradis-html_export/template.html.erb'
    end
  end
end

# This includes the export plugin module in the dradis export plugin repository
module Plugins
  module Export
    include Dradis::HTMLExport
  end
end
