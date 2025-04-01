# frozen_string_literal: true

# =============================
# Scheduled (Delayed) Job
# =============================
# Job will run at a specific time in the future.

class ScheduledJob < ApplicationJob
  queue_as :default

  def perform(message)
    Rails.logger.info "Scheduled message: #{message}"
  end
end

# Usage:
# ScheduledJob.set(wait: 10.minutes).perform_later(Hello in 10 minutes)
# ScheduledJob.set(wait_until: Time.now + 10.minutes).perform_later("Hello in 10 minutes")
