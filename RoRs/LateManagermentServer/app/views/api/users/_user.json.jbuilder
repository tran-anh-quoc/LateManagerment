json.extract! user, :id, :name, :image, :nickname, :email, :provider, :uid, :sign_in_count, :current_sign_in_at, :last_sign_in_at

urls = [
  { rel: 'self', href: api_user_url(user, format: :json) }
]

json._links do
  json.array!(urls) do |url|
    json.extract! url, :rel, :href
  end
end
