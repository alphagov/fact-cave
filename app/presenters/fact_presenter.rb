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
      id: @view_context.fact_url(@fact.slug),
      details: {
        description: @fact.description,
        value: @fact.value
      },
      name: @fact.name,
      updated_at: @fact.updated_at
    }
  end
end
