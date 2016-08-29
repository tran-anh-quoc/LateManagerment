json.errors do
  json.array! [] do |error|
     json.message error[:message]
     json.code    error[:code]
  end
end
json.success true
