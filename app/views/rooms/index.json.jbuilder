json.array!(@rooms) do |room|
  json.extract! room, :id, :url, :time, :price, :status, :requirements, :description, :discarded
  json.url room_url(room, format: :json)
end
