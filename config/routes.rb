Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :notes do
    resources :tags, only: [:create]
  end

  resources :tags, only: [:destroy]

end
