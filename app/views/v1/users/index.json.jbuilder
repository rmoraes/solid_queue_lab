# frozen_string_literal: true


json.users(@users) do |user|
  json.created_at user.created_at
  json.updated_at user.updated_at
  json.id user.id
  json.status user.status
  json.name user.name
  json.kind user.kind
end
