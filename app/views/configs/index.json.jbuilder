json.array!(@configs) do |config|
  json.extract! config, :id, :key, :value
  json.url config_url(config, format: :json)
end
