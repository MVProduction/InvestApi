require "json"
require "crest"

require "./tinkoff_api_constants"
require "./tinkoff_market_instrument"

# Rest API Тинькоффа
class TinkoffRestApi
    # Возвращает список облигаций
    def self.getBonds(token : String) : Array(TinkoffMarketInstrument)
        response = Crest.get(
            "#{SANDBOX_URL}/market/bonds",
            headers: {"Content-Type" => "application/json", "Authorization" => "Bearer #{token}"},  
        )

        res = Array(TinkoffMarketInstrument).new

        payload = JSON.parse(response.body)["payload"]        
        instruments = payload["instruments"].as_a
        instruments.each do |x|
            instrument = TinkoffMarketInstrument.new(
                figi: x["figi"].as_s,
                isin: x["isin"].as_s,
                lot: x["lot"].as_i,
                currency: x["currency"].as_s,
                name: x["name"].as_s,
                type: x["type"].as_s)
            res.push(instrument)
        end

        return res
    end

    # Возвращает инструменты в портфеле
    def self.getPortfolio(token : String) : Array(TinkoffPortfolioPosition)        
        response = Crest.get(
            "#{COMMON_URL}/portfolio",
            headers: {"Content-Type" => "application/json", "Authorization" => "Bearer #{token}"},  
        )        

        res = Array(TinkoffPortfolioPosition).new

        payload = JSON.parse(response.body)["payload"]        

        positions = payload["positions"].as_a        
        positions.each do |x|
            if x["averagePositionPriceNoNkd"]?
                averagePositionPriceNoNkd = ValueWithCurrency.from_json(x["averagePositionPriceNoNkd"])
            end

            instrument = TinkoffPortfolioPosition.new(
                figi: x["figi"].as_s,
                ticker: x["ticker"].as_s,
                isin: x["isin"]?.try &.as_s,
                instrumentType: x["instrumentType"].as_s,
                balance: x["balance"].to_s.to_f64,
                blocked: x["blocked"]?.try &.to_s.to_f64,
                expectedYield: ValueWithCurrency.from_json(x["expectedYield"]),
                lots: x["lots"].as_i,
                averagePositionPrice: ValueWithCurrency.from_json(x["averagePositionPrice"]),
                averagePositionPriceNoNkd: averagePositionPriceNoNkd,
                name: x["name"].as_s
            )
            res.push(instrument)
        end

        return res
    end
end