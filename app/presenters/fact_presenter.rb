class FactPresenter
  def initialize(fact, view_context)
    @fact = fact
    @view_context = view_context
  end

  def as_json(options = {})
    {
      response_info: {
        status: options[:status] || "ok",
      },
      id: @fact.slug,
      name: @fact.name,
      description: @fact.description,
      value: @fact.value,
      updated_at: @fact.updated_at
    }
  end
end
