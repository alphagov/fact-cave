class FactsController < ApplicationController
  def show
    @fact = Fact.find_by_slug!(params[:slug])
    render json: @fact.attributes.delete_if { |k, v| v.nil? }
  end
end
