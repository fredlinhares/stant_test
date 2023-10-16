json.extract! presentation, :id, :title, :duration_in_minutes, :track_id, :previous_presentation_id, :is_lightning, :morning, :created_at, :updated_at
json.url presentation_url(presentation, format: :json)
