Rails.application.routes.draw do
  resources :conversations, only: [:index, :show, :create, :update, :destroy]
  resources :chat_messages, only: [:create]

  get "/conversations/:id/messages", to: "conversations#messages"
  post "/messages", to: "chat_messages#create"
end
