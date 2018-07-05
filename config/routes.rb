AcademicBenchmarksApi::Engine.routes.draw do
  match '/authorities', to: 'api#authorities', via: [:get, :post]
  match '/publications', to: 'api#publications', via: [:get, :post]
  match '/documents', to: 'api#documents', via: [:get, :post]
  match '/sections', to: 'api#sections', via: [:get, :post]
  match '/education_levels', to: 'api#education_levels', via: [:get, :post]
  match '/standards', to: 'api#standards', via: [:get, :post]
  match '/children', to: 'api#children', via: [:get, :post]
  match '/detail', to: 'api#detail', via: [:get, :post]
  match '/alignable', to: 'api#alignable', via: [:get, :post]
end
