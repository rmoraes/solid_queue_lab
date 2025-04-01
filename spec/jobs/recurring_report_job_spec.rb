# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RecurringReportJob, type: :job do
  before do
    # Use the :solid_queue adapter to persist jobs in the database as SolidQueue::Job records.
    # This is required when testing job attributes like priority, queue name, or arguments,
    # or when asserting database-level job behavior.
    ActiveJob::Base.queue_adapter = :solid_queue
  end


  #
  #
  # Create a recurring task that schedules the RecurringReportJob to run every 5 minutes.
  # This will insert a record into the `solid_queue_recurring_tasks` table.
  #
  it 'can be configured as a recurring task' do
    # Create a recurring task that runs every 5 minutes, with a unique key identifier.
    task = SolidQueue::RecurringTask.create!(
      key: RecurringReportJob.name.underscore.dasherize,
      class_name: 'RecurringReportJob',
      schedule: 'every 5 minutes',
      queue_name: 'default'
    )

    expect(task.schedule).to eq('every 5 minutes')
    expect(task.class_name).to eq('RecurringReportJob')
  end
end
