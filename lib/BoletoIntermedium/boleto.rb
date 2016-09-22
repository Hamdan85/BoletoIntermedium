class Boleto
  include BoletoIntermedium

  attr_accessor :configuration

  attr_accessor :payment_slip
  attr_accessor :value_in_cents
  attr_accessor :due_date

  attr_accessor :field1
  attr_accessor :field_dv
  attr_accessor :field2
  attr_accessor :field_dv
  attr_accessor :field3
  attr_accessor :field_dv
  attr_accessor :field4
  attr_accessor :field5

  def initialize(fields = {})
    @payment_slip     = fields[:payment_slip] ? fields[:payment_slip].to_s[0..6].rjust(7, '0') : '0000000'
    @value_in_cents   = (fields[:value_in_cents] || 0).to_s[0..9].rjust(10, '0')
    @due_date         = (fields[:due_date] ? BoletoIntermedium.bank_epoque(fields[:due_date]) : BoletoIntermedium.bank_epoque(Date.today + 1.week)).to_s[0..3].rjust(4, '0')

    config = BoletoIntermedium.configuration

    self.field1 = config.bank_code + config.currency_code + config.agency + config.product + config.wallet[0]
    self.field2 = config.wallet[1] + config.system + @payment_slip
    self.field3 = config.account

    @field5 = @due_date + @value_in_cents
  end

  def field1=(str)
    @field1 = str
    @field1_dv = BoletoIntermedium.module_10(str).to_s
    set_field_4
  end

  def field2=(str)
    @field2 = str
    @field2_dv = BoletoIntermedium.module_10(str).to_s
    set_field_4
  end

  def field3=(str)
    @field3 = str
    @field3_dv = BoletoIntermedium.module_10(str).to_s
    set_field_4
  end

  def set_field_4
    @field4 = BoletoIntermedium.module_11(bar_code_without_verifier).to_s
  end

  def bar_code_without_verifier
    config = BoletoIntermedium.configuration

    config.bank_code +
        config.currency_code +
        due_date +
        value_in_cents +
        config.agency +
        config.product +
        config.wallet +
        config.system +
        payment_slip +
        config.account
  end

  def bar_code
    bar_code_without_verifier[0..3] + BoletoIntermedium.module_11(bar_code_without_verifier).to_s + bar_code_without_verifier[-39..-1]
  end

  def digitable_line
    (@field1 || '') +
        (@field1_dv || '') +
        (@field2 || '') +
        (@field2_dv || '') +
        (@field3 || '') +
        (@field3_dv || '') +
        (@field4 || '') +
        (@field5 || '')
  end

  def formatted_digitable_line
    digitable_line[0..4] +
        '.' + digitable_line[5..9] +
        ' ' + digitable_line[10..14] +
        '.' + digitable_line[15..20] +
        ' ' + digitable_line[21..25] +
        '.' + digitable_line[26..31] +
        ' ' + digitable_line[32] +
        ' ' + digitable_line[33..46]
  end

end