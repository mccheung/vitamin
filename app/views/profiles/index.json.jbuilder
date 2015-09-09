json.array!(@profiles) do |profile|
  json.extract! profile, :id, :nickname, :address, :lng, :lat, :user_id
  json.url profile_url(profile, format: :json)
end
