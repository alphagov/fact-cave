module FactsHelper
  def currency_format_options(selected)
    options = Fact.currency_codes.to_a
    grouped_options = ['Common', options.select {|o| common_currency?(o)}], ['All', options]
    grouped_options_for_select(grouped_options, selected)
  end
  
  def numeric_format_options
    options = Fact::NUMERIC_FORMATS.keys.map(&:to_s)
    options.collect{ |fmt| [fmt.titlecase, fmt]}.unshift(["None"])
  end

  private

  def common_currency?(currency)
    %w(EUR GBP USD).include?(currency.last)
  end
end
