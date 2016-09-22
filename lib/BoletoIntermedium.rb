require "BoletoIntermedium/version"
require "../lib/BoletoIntermedium/configuration"
require "../lib/BoletoIntermedium/boleto"
require "active_support/all"

module BoletoIntermedium

  class << self
    attr_accessor :configuration
  end

  def self.configure
    @configuration ||= Configuration.new
    yield(configuration || @configuration)
    @configuration
  end

  class Configuration

    attr_reader   :bank_code
    attr_reader   :currency_code
    attr_reader   :agency
    attr_reader   :product
    attr_reader   :wallet
    attr_reader   :system
    attr_accessor :account

    def initialize(fields = {})
      @bank_code = '077'
      @currency_code = '9'
      @agency = '1'
      @product = '000'
      @wallet = '12'
      @system = '10'

      self.account = fields[:account] if fields[:account]
    end

    def account=(str)
      @account = str.to_s[0..9].rjust(10, '0')
    end
  end

  private

  def self.bank_epoque(date)
    (date - Date.new(1997,10,7)).to_i
  end

  def self.module_10(str)
    str  = str.chars.reverse
    i    = 2
    sum  = 0
    res  = 0

    str.each do |char|
      res = char.to_i * i
      sum += res > 9 ? (res - 9) : res
      i = i == 2 ? 1 : 2
    end

    if (sum % 10) == 0
      0
    else
      10 - (sum % 10)
    end
  end

  def self.module_11(str)
    peso = 2
    soma = 0

    str = str.chars.reverse

    str.each do |char|
      soma += char.to_i * peso
      peso = (peso == 9) ? 2 : peso + 1
    end

    if soma % 11 == 0
      1
    else
      11 - (soma % 11)
    end
  end
end
