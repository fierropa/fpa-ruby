Rails.application.routes.draw do

  resources :comparisons
  resources :documents
  get 'documents/index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'main#index'
end
