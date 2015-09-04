Rails.application.routes.draw do
  get 'users/edit_profile'
  put 'users/update_profile', to: 'users#update_profile', as: :users_update_profile

  devise_for :users
  get 'pages/welcome'
  root 'pages#welcome'
end
