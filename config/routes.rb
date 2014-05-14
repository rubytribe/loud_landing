LoudLanding::Application.routes.draw do

  root to: 'home#index'

  resources :home,  only: :index
  resources :posts, only: :index

end
