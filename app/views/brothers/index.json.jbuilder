json.array!(@brothers) do |brother|
  json.extract! brother, :id, :name, :phone, :email, :year
  json.url brother_url(brother, format: :json)
end
