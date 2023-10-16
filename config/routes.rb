Rails.application.routes.draw do
  resources :tracks
  post "/tracks/load_file", to: "tracks#load_file"
  resources :presentations, only: [:show, :new, :edit, :create, :update, :destroy]

  root "tracks#index"
end
