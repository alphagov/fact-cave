class UpdateVatRateType < Mongoid::Migration
  def self.up
    vat_rate_fact = Fact.where(slug: 'vat-rate').first
    if vat_rate_fact
      vat_rate_fact = vat_rate_fact.becomes(NumericFact)
      vat_rate_fact.value = 20
      vat_rate_fact.unit = '%'
      vat_rate_fact.save!
    end
  end

  def self.down
  end
end
