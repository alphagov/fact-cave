FactCave::Application.routes.draw do
  match "facts/:slug" => "facts#show"
end
