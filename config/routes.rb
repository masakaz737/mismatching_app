Rails.application.routes.draw do

  root 'static_pages#index'

  devise_for :users
  resources :users do
    resources :questionnaires
  end

  resources :conversations do
    resources :messages
  end

  resources :relationships

  get 'notifications/:id/link_through', to: 'notifications#link_through', as: :link_through
  get 'notifications', to: 'notifications#index'
  get 'messages/:id/message_link_through', to: 'messages#message_link_through', as: :message_link_through

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
end
