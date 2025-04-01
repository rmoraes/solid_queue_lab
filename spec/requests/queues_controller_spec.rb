# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe QueuesController, type: :request do
  #
  # API Documentation for Solid Queue Monitoring
  #

  before do
    ActiveJob::Base.queue_adapter = :solid_queue

    SolidQueue::BlockedExecution.delete_all
    SolidQueue::ClaimedExecution.delete_all
    SolidQueue::FailedExecution.delete_all
    SolidQueue::ReadyExecution.delete_all
    SolidQueue::RecurringExecution.delete_all
    SolidQueue::ScheduledExecution.delete_all
    SolidQueue::RecurringTask.delete_all
    SolidQueue::Job.delete_all
  end

  #
  #
  # Lists all jobs (raw data from solid_queue_jobs)
  #
  path '/queues' do
    get('List all jobs') do
      tags 'queues'
      description 'List all registered jobs'
      produces 'application/json'
      consumes 'application/json'

      response(200, 'successful') do
        run_test!
      end
    end
  end

  #
  #
  # Lists jobs that are ready to be executed
  #
  path '/queues/ready' do
    get('List jobs ready to be executed') do
      tags 'queues'
      description 'Jobs ready to run'
      produces 'application/json'
      consumes 'application/json'

      response(200, 'successful') do
        run_test!
      end
    end
  end

  #
  #
  # Lists jobs currently running (claimed by workers)
  #
  path '/queues/running' do
    get('List jobs currently being executed') do
      tags 'queues'
      description 'Jobs currently running'
      produces 'application/json'
      consumes 'application/json'

      response(200, 'successful') do
        run_test!
      end
    end
  end

  #
  #
  # Lists jobs that failed during execution
  #
  path '/queues/failed' do
    get('List jobs that failed during execution') do
      tags 'queues'
      description 'Failed jobs'
      produces 'application/json'
      consumes 'application/json'

      response(200, 'successful') do
        run_test!
      end
    end
  end

  #
  #
  # Lists jobs that are scheduled for future execution
  #
  path '/queues/scheduled' do
    get('List jobs scheduled for future execution') do
      tags 'queues'
      description 'Scheduled (future) jobs'
      produces 'application/json'
      consumes 'application/json'

      response(200, 'successful') do
        run_test!
      end
    end
  end

  #
  #
  # Lists recurring tasks configured with cron/frequency
  #
  path '/queues/recurring' do
    get('List recurring tasks configured to run periodically') do
      tags 'queues'
      description 'Recurring tasks (cron-like)'
      produces 'application/json'
      consumes 'application/json'

      response(200, 'successful') do
        run_test!
      end
    end
  end

  #
  #
  # Summary of job counts by status (useful for dashboards)
  #
  path '/queues/status' do
    get('Returns job queue status summary') do
      tags 'queues'
      description 'Provides a count summary of jobs by status (ready, running, failed, scheduled, recurring)'
      produces 'application/json'
      consumes 'application/json'

      response(200, 'successful') do
        schema type: :object,
          properties: {
            ready: { type: :integer },
            running: { type: :integer },
            failed: { type: :integer },
            scheduled: { type: :integer },
            recurring: { type: :integer }
          },
          required: %w[ready running failed scheduled recurring]


        run_test!
      end
    end
  end

  #
  #
  # Retries a job by its ID (re-enqueues with same class/args)
  #
  path '/queues/{id}/retry' do
    post('Retry a job by ID') do
      tags 'queues'
      description 'Retries a job with the given ID by re-enqueueing it using the original job_class and arguments.'
      produces 'application/json'
      consumes 'application/json'
      parameter name: :id, in: :path, type: :string, description: 'Job ID'

      response(200, 'Job retried successfully') do
        let(:job_class) do
          Class.new(ActiveJob::Base) do
            def self.name
              "TestJob"
            end

            def perform(*args); end
          end
        end

        before do
          stub_const("TestJob", job_class)

          SolidQueue::Job.create!(
            class_name: "TestJob",
            queue_name: "default",
            priority: 0,
            arguments: { 'arguments' => [ 1, 2, 3 ] }
          )
        end

        let(:id) { SolidQueue::Job.last.id }

        run_test!
      end

      response(404, 'Job not found') do
        let(:id) { '999999' }
        run_test!
      end

      response(422, 'Job class not found or not constantizable') do
        before do
          SolidQueue::Job.create!(
            class_name: "NonExistentJob",
            queue_name: "default",
            priority: 0,
            arguments: { 'arguments' => [] }
          )
        end

        let(:id) { SolidQueue::Job.last.id }

        run_test!
      end
    end
  end

  #
  #
  # Deletes a job by ID and cleans associated execution records
  #
  path '/queues/{id}' do
    delete('Delete a job by ID') do
      tags 'queues'
      description 'Deletes a job and all related execution records by job ID'
      parameter name: :id, in: :path, type: :string, description: 'Job ID'
      produces 'application/json'
      consumes 'application/json'

      response(200, 'Job deleted successfully') do
        before do
          @job = SolidQueue::Job.create!(
            class_name: "ScheduledJob",
            queue_name: "default",
            priority: 0,
            scheduled_at: 10.minutes.from_now,
            arguments: {
              "job_class" => "ScheduledJob",
              "job_id" => SecureRandom.uuid,
              "queue_name" => "default",
              "arguments" => [ "Hello in 10 minutes" ],
              "executions" => 0,
              "exception_executions" => {},
              "enqueued_at" => Time.now.utc.iso8601,
              "scheduled_at" => 10.minutes.from_now.iso8601,
              "locale" => "en",
              "timezone" => "UTC"
            }
          )
        end

        let(:id) { @job.id }

        run_test!
      end

      response(404, 'Job not found') do
        let(:id) { '999999' }
        run_test!
      end
    end
  end
end
