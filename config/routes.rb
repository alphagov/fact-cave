FactCave::Application.routes.draw do
  
  get "facts/:slug" => "facts#show"

  namespace :admin do
    root :to => "facts#index"
  end

  root :to => Proc.new {[200, {}, ["Fact Cave"]]}

end
