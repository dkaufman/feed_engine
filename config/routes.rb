Hungrlr::Application.routes.draw do

  #constraints(NoSubdomain) do
    match "/home" => "pages#home"
    match '/auth/:provider/callback' => 'authentications#create'

    devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

    devise_scope :user do
      get '/signup' => 'devise/registrations#new'
      get '/login' => 'devise/sessions#new'
    end

    resources :growls, :images, :links, :messages
    resource :dashboard

    namespace :api do
        namespace :v1 do
          resources :images
          resources :meta_data
        end
    end
    root :to => 'pages#home'
  #end

  constraints(Subdomain) do
    match '/' => 'growls#show'
  end
end
