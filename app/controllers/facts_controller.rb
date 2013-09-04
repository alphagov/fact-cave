class FactsController < ApplicationController
  def show
    @fact = Fact.find_by(:slug => params[:slug])
    render json: FactPresenter.new(@fact, view_context)
  end
end
