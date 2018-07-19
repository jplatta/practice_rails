Rails.application.routes.draw do
  
  scope "api" do
    resources :words
  end

  root 'main#index'

  get 'main/index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
