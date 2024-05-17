Rails.application.routes.draw do
  resources :conversations, only: [:index, :show, :create, :update, :destroy]
  resources :messages, only: [:create]

  get "/conversations/:id/messages", to: "conversations#messages"
end
