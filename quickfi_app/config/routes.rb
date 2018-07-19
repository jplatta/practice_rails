Rails.application.routes.draw do
  root 'pages#home'

  get '/', to: 'pages#home'
  get '/about', to: 'pages#about'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  get '/signup', to: 'users#new'
  post '/signup', to: 'users#create'

  get '/charts', to: 'transactions#charts', as: :charts

  get '/month/:month/:year', to: 'transactions#month', as: :month

  get '/import', to: 'imports#new'

  post '/import', to: 'imports#upload'

  get '/import/edit', to: 'imports#edit'

  post '/import/save', to: 'imports#save'

  resources :users do
    #resources :categories, only: [:index, :new, :create, :edit, :update]
    resources :transactions, only: [:index, :new, :create, :edit, :update, :destroy, :month]
    resources :categories, only: [:index, :new, :create, :edit, :update, :destroy]
    #get '/month/:date', to: 'transactions#month'
  end

end
