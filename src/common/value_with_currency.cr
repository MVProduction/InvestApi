require "json"

class ValueWithCurrency
    getter currency : String
    getter value : Float64

    # Создаёт из JSON
    def self.from_json(value : JSON::Any)
        return ValueWithCurrency.new(value["currency"].as_s, value["value"].to_s.to_f64)
    end

    def initialize(@currency, @value)        
    end

    def to_s(io : IO)
        io.puts ("currency: #{currency} value: #{value}")
    end
end