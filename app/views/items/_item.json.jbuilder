json.extract! item, :id, :name, :description, :images, :price, :category, :user_id, :created_at, :updated_at
json.url item_url(item, format: :json)
json.description item.description.to_s
json.images do
  json.array!(item.images) do |image|
    json.id image.id
    json.url url_for(image)
  end
end
