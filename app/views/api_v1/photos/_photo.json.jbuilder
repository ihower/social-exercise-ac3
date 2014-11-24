    json.url v1_photo_url(p)
    json.user_id p.user_id
    json.description p.description
    json.created_at p.created_at
    json.updated_at p.updated_at

    json.image_original_url asset_url(p.image.url)
    json.image_medium_url asset_url(p.image.url(:medium))
    json.image_thumb_url asset_url(p.image.url(:thumb))

    json.image_file_name p.image_file_name
    json.image_content_type p.image_content_type
    json.image_file_size p.image_file_size
    json.image_updated_at p.image_updated_at