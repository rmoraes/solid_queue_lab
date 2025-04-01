# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RetryableJob, type: :job do
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
  it 'retries manually like retry_on would do' do
    class FakeRetryJob < ApplicationJob
      cattr_accessor :attempts
      self.attempts = 0

      def perform
        self.class.attempts += 1
        raise "fail" if self.class.attempts < 3
      end
    end

    job = FakeRetryJob.new

    begin
      job.perform
    rescue => e
      job.retry_job(wait: 0.1)
    end

    begin
      job.perform
    rescue => e
      job.retry_job(wait: 0.1)
    end

    job.perform

    expect(FakeRetryJob.attempts).to eq(3)
  end
end
