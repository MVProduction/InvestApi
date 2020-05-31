# Информация об облигации с биржи moex
class MoexBondInfo
    # Полное название
    getter fullname : String
    # Идентификатор
    getter isin : String
    # Текущий номинал
    getter faceValue : Float64
    # Начальный номинал
    getter initialFaceValue : Float64
    # Тип валюты
    getter currency : String
    # Уровень листинга
    getter listLevel : Int32
    # Размер выпуска
    getter issueSize : Int64
    # Дата выпуска
    getter issueDate : Time
    # Дата погашения
    getter endDate : Time
    # Частота выплаты купона в год
    getter couponFrequency : Int32
    # Дата выплаты купона
    getter couponDate : Time
    # Процент купона. Может и не быть
    getter couponPercent : Float64
    # Дата оферты    
    getter offerDate : Time?
    # Цена в процентах
    getter price : Float64

    def initialize(
        @fullname, 
        @isin, 
        @faceValue, 
        @initialFaceValue, 
        @currency, 
        @listLevel, 
        @issueSize, 
        @issueDate, 
        @endDate, 
        @couponFrequency, 
        @couponDate, 
        @couponPercent, 
        @offerDate,
        @price)
    end   

    # Преобразует в json
    def to_json(json : JSON::Builder)
        json.object do
            json.field "fullname", fullname
            json.field "isin", isin
            json.field "faceValue", faceValue
            json.field "initialFaceValue", initialFaceValue
            json.field "currency", currency
            json.field "listLevel", listLevel
            json.field "endDate", endDate
            json.field "couponFrequency", couponFrequency
            json.field "couponDate", couponDate
            json.field "couponPercent", couponPercent
            json.field "offerDate", offerDate
            json.field "price", price
        end
    end        
end