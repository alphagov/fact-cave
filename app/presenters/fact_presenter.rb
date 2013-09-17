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
        formatted_value: formatted_value
      },
      name: @fact.name,
      updated_at: @fact.updated_at
    }
  end

  def formatted_value
    case @fact.class.name
    when "CurrencyFact"
      formatted_currency_value
    when "DateFact"
      formatted_date_value
    when "NumericFact"
      formatted_numeric_value
    else
      @fact.value
    end
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

  def formatted_currency_value
    currency_symbol = CurrencyFact.currency_symbols[@fact.currency_code.downcase]
    amount = sprintf("%.2f", @fact.value) 
    amount = @view_context.number_with_delimiter(amount)
    if currency_symbol
      "#{currency_symbol}#{amount}"
    else
      "#{amount} #{CurrencyFact.currency_codes.key(@fact.currency_code)}"
    end
  end

  def formatted_date_value
    @fact.value.strftime("%e %B %Y")
  end

  def formatted_numeric_value
    value = @fact.value % 1 == 0 ? @fact.value.to_i : @fact.value 
    "#{@view_context.number_with_delimiter(value)}#{@fact.unit}"
  end

end
