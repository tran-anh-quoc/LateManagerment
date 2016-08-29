json.errors do
  json.array! @errors do |error|
     json.message error[:message]
     json.code    error[:code]
  end
end
json.success false
