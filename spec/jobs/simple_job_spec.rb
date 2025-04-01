# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SimpleJob, type: :job do
  before do
    # Use the :test adapter to prevent actual job persistence or execution.
    # This allows using matchers like `have_enqueued_job` and keeps the queue in memory.
    ActiveJob::Base.queue_adapter = :test
  end

  #
  #
  # This test ensures that when the job is executed immediately using `perform_now`,
  # it logs the expected message using Rails.logger.
  #
  it 'logs a simple message' do
    logger = double("Logger")
    allow(Rails).to receive(:logger).and_return(logger)
    expect(logger).to receive(:info).with('Hello, Alice!')

    described_class.perform_now('Alice')
  end

  #
  #
  # This test ensures that calling `perform_later` correctly enqueues the job
  # with the expected arguments and to the default queue.
  #
  it 'enqueues a job' do
    expect {
      described_class.perform_later('Alice')
    }.to have_enqueued_job(SimpleJob).with('Alice').on_queue('default')
  end
end
