Dradis::Plugins::HtmlExport::Engine.routes.draw do
  resources :projects, only: [] do
    resource :report, only: [:create], path: '/export/html/reports'
  end
end
