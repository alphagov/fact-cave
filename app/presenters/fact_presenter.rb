class FactPresenter
  def initialize(fact, view_context)
    @fact = fact
    @view_context = view_context
  end

  def as_json(options = {})
    {
      _response_info: {
        status: options[:status] || "ok",
      },
      id: fact_id_url,
      details: {
        description: @fact.description,
        value: @fact.value,
        formatted_value: @fact.formatted_value
      },
      name: @fact.name,
      updated_at: @fact.updated_at
    }
  end

  private

  # Returns the url to be used as the id in the JSON response.
  #
  # When requested thorugh the public_api endpoint (distunguised by the
  # presence of the `API-PREFIX` HTTP header), this is the public API URL.
  #
  # For other requests, this is the fact-cave direct URL.
  def fact_id_url
    api_prefix = @view_context.request.headers["HTTP_API_PREFIX"]
    if api_prefix.present?
      "#{Plek.current.website_root}/#{api_prefix}#{@view_context.fact_path(@fact.slug)}"
    else
      @view_context.fact_url(@fact.slug)
    end
  end
end
