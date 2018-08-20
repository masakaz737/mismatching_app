Rails.application.routes.draw do

  root 'static_pages#index'

  devise_for :users
  resources :users

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
end
