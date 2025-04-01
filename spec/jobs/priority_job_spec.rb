# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PriorityJob, type: :job do
  before do
    # Use the :solid_queue adapter to persist jobs in the database as SolidQueue::Job records.
    # This is required when testing job attributes like priority, queue name, or arguments,
    # or when asserting database-level job behavior.
    ActiveJob::Base.queue_adapter = :solid_queue
  end

  #
  #
  #
  # Enqueue a job with a custom priority of 5 using perform_later.
  # This tells SolidQueue to persist the job in the database with the specified priority.
  #
  it 'enqueues with priority' do
    expect {
      described_class.set(priority: 5).perform_later('urgent')
    }.to change(SolidQueue::Job, :count).by(1)

    # Fetch the most recently enqueued job from the database.
    # SolidQueue::Job stores all job metadata including priority, arguments, and class name.
    job = SolidQueue::Job.order(created_at: :desc).first

    # Assert that the priority is correctly set and that the arguments were passed as expected.
    expect(job.priority).to eq(5)
    expect(job.arguments['arguments']).to include('urgent')
  end
end
