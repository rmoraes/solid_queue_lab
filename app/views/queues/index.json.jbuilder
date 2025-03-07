# frozen_string_literal: true


json.queues(@queues) do |queue|
  json.created_at queue.created_at
  json.updated_at queue.updated_at

  json.name queue.queue_name
  json.class_name queue.class_name
  json.arguments queue.arguments
  json.priority queue.priority
  json.scheduled_at queue.scheduled_at
  json.finished_at queue.finished_at
end
