FactCave::Application.routes.draw do
  get "facts/:slug" => "facts#show"
end
