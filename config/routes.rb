Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'users#index'

  resource :session, only: [:new, :create, :destroy]

  resources :users, only: [:new, :update, :create, :show, :index, :edit] do
    resources :comments, only: [:create, :show, :update, :destroy, :edit]
    resources :goals, only: [:create, :destroy, :edit, :update, :show] do
      get '/complete', action: 'complete'
    end
  end

  resources :goals, only: [] do
    resources :comments, only: [:create, :show, :update, :destroy, :edit]
  end

end
