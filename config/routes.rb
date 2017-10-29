Rails.application.routes.draw do
  get 'sessions/create'

  get 'sessions/destroy'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'works#root'

  post '/logout', to: 'users#logout', as: 'logout'

  get '/auth/:provider/callback', to: 'users#login'
  # get 'auth/failure', to: redirect('/')

  resources :sessions, only: [:create, :destroy]

  resources :works
  post '/works/:id/upvote', to: 'works#upvote', as: 'upvote'

  resources :users, only: [:index, :show]
end
