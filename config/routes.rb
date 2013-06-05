FactCave::Application.routes.draw do
  
  get "facts/:slug" => "facts#show"

  namespace :admin do
    
    resources :facts

    root :to => "facts#index"
  end

  get "facts/:slug" => "facts#show"

  root :to => Proc.new {[200, {}, ["Fact Cave"]]}

end
