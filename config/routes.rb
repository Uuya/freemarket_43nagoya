Rails.application.routes.draw do

  devise_for :users, controllers: {
    registrations:      'users/registrations',
    sessions:           'users/sessions',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  devise_scope :user do
    get  'snsphone/new',   to: "snsphone#new"
    post 'snsphone/new',   to: "snsphone#create"
    get  'membership/new', to: "membership#new"
    post 'membership/new', to: "membership#create"
    get  'phone/new',      to: "phone#new"
    post 'phone/new',      to: "phone#create"
    get  'address/new',    to: "address#new"
    post 'address/new',    to: "address#create"
    get  'credit/new',     to: "credit#new"
    post 'credit/create',  to: "credit#create"
  end

  root 'products#index'

  resources :users, only: :show do
    resource :logout, only: :show
    resource :identification, only: [:edit, :update]
    resource :profile, only: [:edit, :update, :show]
  end

  resources :products do
    collection do
      get 'list'
    end
  end

  resources :purchases, only: [:show, :update]

end
