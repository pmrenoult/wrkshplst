json.array!(@events) do |event|
  json.extract! event, :id, :title, :description, :date_begin, :date_end
  json.url event_url(event, format: :json)
end