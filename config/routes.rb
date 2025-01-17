Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'welcome#index'
  get '/', to: 'welcome#index'

  get "/merchants", to: "merchants#index"
  get "/merchants/new", to: "merchants#new"
  get "/merchants/:id", to: "merchants#show"
  post "/merchants", to: "merchants#create"
  get "/merchants/:id/edit", to: "merchants#edit"
  patch "/merchants/:id", to: "merchants#update"
  delete "/merchants/:id", to: "merchants#destroy"

  get "/items", to: "items#index"
  get "/items/:id", to: "items#show"
  get "/items/:id/edit", to: "items#edit"
  patch "/items/:id", to: "items#update"
  get "/merchants/:merchant_id/items", to: "items#index"
  get "/merchants/:merchant_id/items/new", to: "items#new"
  post "/merchants/:merchant_id/items", to: "items#create"
  delete "/items/:id", to: "items#destroy"
  get '/merchants/:merchant_id/items/:item_id', to: 'items#show'

  get "/items/:item_id/reviews/new", to: "reviews#new"
  post "/items/:item_id", to: "reviews#create"
  get '/reviews/:review_id/edit', to: 'reviews#edit'
  patch '/reviews/:review_id', to: 'reviews#update'
  delete '/reviews/:review_id', to: 'reviews#destroy'

  patch "/cart/:item_id/increment", to: 'cart#increment_item_quantity'
  patch "/cart/:item_id/decrement", to: 'cart#decrement_item_quantity'
  patch "/cart/:item_id", to: 'cart#update'
  get "/cart", to: 'cart#index'
  post "/cart", to: 'cart#destroy'
  delete "/cart/:item_id", to: 'cart#remove_item'

  get '/orders/search', to: 'orders#search'
  get '/orders/:order_id/verified_order', to: 'orders#verified_show'
  get '/orders/new', to: 'orders#new'
  post '/orders', to: 'orders#create'
  get '/orders/:order_id', to: 'orders#show'
  delete '/orders/:order_id', to: 'orders#destroy'
  get '/orders/:order_id/edit', to: 'orders#edit'
  patch '/orders/:order_id', to: 'orders#update'
  delete '/orders/:order_id/items/:item_id', to: 'orders#destroy_item'

end
