json.array!(@items) do |item|
  json.extract! item, :id, :name, :intro, :user_id
  json.url item_url(item, format: :json)
end
