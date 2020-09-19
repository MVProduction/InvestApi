# Описание позиции валюты в портфеле
class TinkoffPortfolioCurrencyPosition
    getter currency : String
    getter balance : Float64
    getter blocked : Float64?

    def initialize(@currency, @balance, @blocked)        
    end
end