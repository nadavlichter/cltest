Rails.application.routes.draw do
  get 'thumbnail', to: 'thumbnail#api'
  get 'thumbnail/api'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
