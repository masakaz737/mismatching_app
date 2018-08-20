Rails.application.routes.draw do

  root 'static_pages#index'

  devise_for :users
  resources :users do
    resources :questionnaires
  end

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
end
