require "json"
require "crest"

require "./tinkoff_api_constants"
require "./tinkoff_market_instrument"
require "./tinkoff_candle_interval"

# Rest API Тинькоффа
class TinkoffRestApi
    # Преобразует json в список TinkoffMarketInstrument
    private def self.parseInstruments(json : JSON::Any) : Array(TinkoffMarketInstrument)
        res = Array(TinkoffMarketInstrument).new

        json.as_a.each do |x|
            instrument = TinkoffMarketInstrument.new(
                figi: x["figi"].as_s,
                isin: x["isin"]?.try &.as_s,
                lot: x["lot"].as_i,
                currency: x["currency"].as_s,
                name: x["name"].as_s,
                type: x["type"].as_s)
            res.push(instrument)
        end

        return res
    end

    # Возвращает список облигаций
    # /market/bonds
    def self.getMarketBonds(token : String) : Array(TinkoffMarketInstrument)
        response = Crest.get(
            "#{SANDBOX_URL}/market/bonds",
            headers: {"Content-Type" => "application/json", "Authorization" => "Bearer #{token}"},  
        )        

        payload = JSON.parse(response.body)["payload"]        
        instruments = parseInstruments(payload["instruments"])
        
        return instruments
    end

    # Возвращает список валют
    # /market/currencies
    def self.getMarketCurrency(token : String) : Array(TinkoffMarketInstrument)
        response = Crest.get(
            "#{COMMON_URL}/market/currencies",
            headers: {"Content-Type" => "application/json", "Authorization" => "Bearer #{token}"},
        )        

        payload = JSON.parse(response.body)["payload"]        
        instruments = parseInstruments(payload["instruments"])
        
        return instruments
    end

    # Возвращает инструменты в портфеле
    # /portfolio
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

    # Возвращает валютные позиции по портфелю
    # /portfolio/currencies
    def self.getPortfolioCurrencies(token : String) : Array(TinkoffPortfolioCurrencyPosition)
        response = Crest.get(
            "#{COMMON_URL}/portfolio/currencies",
            headers: {"Content-Type" => "application/json", "Authorization" => "Bearer #{token}"},  
        )    

        res = Array(TinkoffPortfolioCurrencyPosition).new

        payload = JSON.parse(response.body)["payload"]
        currencies = payload["currencies"].as_a
        currencies.each do |x|
            currency = TinkoffPortfolioCurrencyPosition.new(
                currency: x["currency"].to_s,
                balance: x["balance"].to_s.to_f64,
                blocked: x["blocked"]?.try &.to_s.to_f64
            )

            res.push(currency)
        end

        return res
    end

    # Возвращает значения свечей инструмента
    # /market/candles
    def self.getMarketCandles(token : String, figi : String, from : Time, to : Time, interval : TinkoffCandleInterval) : Array(TinkoffCandleData)
        fromIso = Time::Format::ISO_8601_DATE_TIME.format(from)
        toIso = Time::Format::ISO_8601_DATE_TIME.format(to)

        response = Crest.get(
            "#{COMMON_URL}/market/candles",
            headers: {"Content-Type" => "application/json", "Authorization" => "Bearer #{token}"},
            params: {:figi => figi, :from => fromIso, :to => toIso, :interval => interval.to_s }
        )    

        payload = JSON.parse(response.body)["payload"]
        candles = payload["candles"].as_a

        res = Array(TinkoffCandleData).new
        
        candles.each do |x|
            candle = TinkoffCandleData.new(
                figi: x["figi"].to_s,
                interval: TinkoffCandleInterval::Day,
                open: x["o"].to_s.to_f64,
                close: x["c"].to_s.to_f64,
                high: x["h"].to_s.to_f64,
                low: x["l"].to_s.to_f64,
                volume: x["v"].to_s.to_f64,
                time: Time::Format::ISO_8601_DATE_TIME.parse(x["time"].to_s)
            )
            res.push(candle)
        end

        return res
    end    
end