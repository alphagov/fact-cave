class FactsController < ApplicationController
  def show
    @fact = Fact.find_by_slug!(params[:slug])
  end
end
