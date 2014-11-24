json.data do
  json.partial! "photo", collection: @photos, :as => :p
end

json.paging do
  json.current_page @photos.current_page
  json.total_pages @photos.total_pages
  json.per_page @photos.limit_value
  json.next_url (@photos.last_page?)? nil : v1_photos_url( :page => @photos.next_page )
  json.previous_url (@photos.first_page?)? nil : v1_photos_url( :page => @photos.prev_page )
end