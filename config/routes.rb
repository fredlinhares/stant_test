Rails.application.routes.draw do
  resources :tracks
  resources :presentations, only: [:show, :new, :edit, :create, :update, :destroy]

  root "tracks#index"
end
