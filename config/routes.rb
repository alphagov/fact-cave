FactCave::Application.routes.draw do

  namespace :admin do

    resources :facts

    root :to => "facts#index"
  end

  get "facts/:slug" => "facts#show", :as => :fact

  get "/healthcheck" => Proc.new {[200, {}, ["OK"]]}

  root :to => Proc.new {[200, {}, ["Fact Cave"]]}

end
