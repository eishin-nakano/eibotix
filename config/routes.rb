Rails.application.routes.draw do
  get 'authentication' => 'static_pages#authentication_form'
  post 'authentication' => 'static_pages#authentication'
  post 'callback' => 'line_bot#callback'
end
