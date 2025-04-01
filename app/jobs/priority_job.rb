# =============================
# Job with Priority

# Priority Values
# 0 → Highest priority (executed first)
# 1-4 → High priority
# 5 → Medium priority (default if not specified)
# 6-9 → Low priority
# 10+ → Lowest priority (executed last)

# =============================
# Jobs with lower priority number are processed first.

class PriorityJob < ApplicationJob
  queue_as :default

  def perform(task)
    Rails.logger.info "Processing task: #{task}"
  end
end

# Usage:
# PriorityJob.set(priority: 5).perform_later("urgent-task")
