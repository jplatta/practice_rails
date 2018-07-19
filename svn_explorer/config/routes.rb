Rails.application.routes.draw do


  root 'pages#home'

  get '/', to: 'pages#home'

  get '/about', to: 'pages#about'

  get '/user', to: 'users#show'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  get '/svn/:path', to: 'svn#show', as: 'svn'

  resources :users, :only => [:show, :destroy]
end
