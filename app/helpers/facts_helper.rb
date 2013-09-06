module FactsHelper
  def numeric_format_options
    options = Fact::NUMERIC_FORMATS.keys.map(&:to_s)
    options.collect{ |fmt| [fmt.titlecase, fmt]}.unshift(["None"])
  end
end
