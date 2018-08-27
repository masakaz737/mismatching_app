Rails.application.routes.draw do

  root 'static_pages#index'

  devise_for :users
  resources :users, only:[:show, :edit, :update] do
    resources :questionnaires, only:[:new, :create, :edit, :update]
  end

  resources :conversations, only:[:index, :create] do
    resources :messages, only:[:index, :create]
  end

  resources :relationships, only:[:show, :new, :create]

  get 'notifications/:id/link_through', to: 'notifications#link_through', as: :link_through
  get 'notifications', to: 'notifications#index'
  get 'messages/:id/message_link_through', to: 'messages#message_link_through', as: :message_link_through

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
end
