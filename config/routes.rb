FactCave::Application.routes.draw do

  root :to => Proc.new {[200, {}, ["Fact Cave"]]}
end
