module FactsHelper
  def currency_format_options(selected)
    options = FactPresenter.currency_codes.to_a
    grouped_options = ['Common', options.select {|o| common_currency?(o)}], ['All', options]
    grouped_options_for_select(grouped_options, selected)
  end
  
  def fact_type(fact)
    if fact.class == Fact
      'Text'
    else
      fact.class.name.gsub('Fact','')
    end
  end

  private

  def common_currency?(currency)
    %w(EUR CNY GBP USD).include?(currency.last)
  end
end
