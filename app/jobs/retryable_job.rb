# =============================
# Retryable Job
# =============================
# Retries automatically on failure.

class RetryableJob < ApplicationJob
  retry_on StandardError, wait: 1.second, attempts: 3

  cattr_accessor :calls
  self.calls = 0

  def perform
    self.class.calls += 1
    Rails.logger.info "Attempt ##{self.class.calls}"
    raise "fail" if self.class.calls < 3
    Rails.logger.info "Success on attempt ##{self.class.calls}"
  end
end

# Usage:
# RetryableJob.perform_later
