require "./tinkoff_candle_interval"

# Информация о свече
class TinkoffCandleData
   getter figi : String 
   getter interval : TinkoffCandleInterval
   getter open : Float64
   getter close : Float64
   getter high : Float64
   getter low : Float64
   getter volume : Float64
   getter time : Time

   def initialize(@figi, @interval, @open, @close, @high, @low, @volume, @time)
   end
end