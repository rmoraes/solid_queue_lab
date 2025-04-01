# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ScheduledJob, type: :job do
  before do
    # Use the :solid_queue adapter to persist jobs in the database as SolidQueue::Job records.
    # This is required when testing job attributes like priority, queue name, or arguments,
    # or when asserting database-level job behavior.
    ActiveJob::Base.queue_adapter = :solid_queue
  end


  it 'enqueues job with future timestamp' do
    # Define a time 10 minutes from now for the job to be scheduled
    time = 10.minutes.from_now

    # Enqueue the job with a `wait_until` parameter so it is not executed immediately,
    # but scheduled for future execution.
    expect {
      described_class.set(wait_until: time).perform_later('hello')
    }.to change(SolidQueue::ScheduledExecution, :count).by(1)

    # Retrieve the last scheduled execution to verify the job was scheduled correctly.
    scheduled = SolidQueue::ScheduledExecution.last

    # Assert that the job was scheduled to run approximately at the expected time,
    # allowing a margin of 1 second for time differences.
    expect(scheduled.scheduled_at).to be_within(1.second).of(time)
  end
end
