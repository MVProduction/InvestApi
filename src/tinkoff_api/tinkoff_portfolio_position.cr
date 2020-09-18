require "../common/value_with_currency"

# Информация о позиции в портфеле
class TinkoffPortfolioPosition
    getter figi : String
    getter ticker : String
    getter isin : String?
    getter instrumentType : String
    getter balance : Float64
    getter blocked : Float64?
    getter expectedYield : ValueWithCurrency
    getter lots : Int32
    getter averagePositionPrice : ValueWithCurrency
    getter averagePositionPriceNoNkd : ValueWithCurrency?
    getter name : String

    def initialize(@figi, @ticker, @isin, @instrumentType, @balance, @blocked,
        @expectedYield, @lots, @averagePositionPrice, @averagePositionPriceNoNkd, @name)
    end

    def to_s(io : IO)
        io.puts ("name: #{name} figi: #{figi} ticker: #{ticker} isin: #{isin} instrumentType: #{instrumentType} balance: #{balance} blocked: #{blocked} expectedYield: #{expectedYield} lots: #{lots} averagePositionPrice: #{averagePositionPrice} averagePositionPriceNoNkd: #{averagePositionPriceNoNkd}")
    end
end