Dradis::Plugins::HtmlExport::Engine.routes.draw do
  resources :projects, only: [] do
    resource :export, only: [:create]
  end
end
