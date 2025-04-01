# frozen_string_literal: true

# =============================
# Recurring Job (Cron-like)
# =============================
# This is configured using SolidQueue::RecurringTask directly.

# The schedule can use syntax like:
# "every 1h";
# "every day at 9am";
# even cron: "cron: '0 0 * * *'".

class RecurringReportJob < ApplicationJob
  queue_as :default

  def perform
    Rails.logger.info "Generating recurring report..."
  end
end

# Usage:

# Creates a recurring task every 5 minutes
#
# SolidQueue::RecurringTask.create!(
#   job_class: "RecurringReportJob",
#   schedule: "every 5 minutes",
#   queue_name: "default"
# )
#

# Creates a recurring task that runs every day at midnight
#
# SolidQueue::RecurringTask.create!(
#  job_class: "RecurringReportJob",
#  schedule: "cron: '0 0 * * *'",
#  queue_name: "default"
# )
