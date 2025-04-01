# frozen_string_literal: true

# =============================
# Simple Job
# =============================
# A basic job that just performs a task immediately.

class SimpleJob < ApplicationJob
  queue_as :default

  def perform(name)
    Rails.logger.info "Hello, #{name}!"
  end
end

# Usage:
# SimpleJob.perform_later("Alice")
