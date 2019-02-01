Dradis::Plugins::HtmlExport::Engine.routes.draw do
  root to: 'base#index'

  get 'gateway_index', to: 'base#gateway_index'
end
