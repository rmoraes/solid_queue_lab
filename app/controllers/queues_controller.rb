class QueuesController < ApplicationController
  before_action :set_job, only: %i[retry destroy]

  #
  #
  # GET /queues
  # ================================
  # Lists all jobs from SolidQueue.
  #
  # This action fetches all records from the solid_queue_jobs table,
  # ordered by most recently created first.
  #
  # Useful for inspecting the job queue, status, and metadata for monitoring purposes.
  #
  # Response: JSON array of job records
  #
  def index
    jobs = SolidQueue::Job.order(created_at: :desc).limit(100)

    render json: jobs
  end

  #
  #
  # GET /queues/ready
  # ================================
  # Lists all jobs that are ready to be executed.
  #
  # This action queries the solid_queue_ready_executions table,
  # which contains jobs that are enqueued and ready to be picked up by a worker process.
  #
  # It includes the associated job metadata.
  #
  # Response: JSON array of ready executions with job details
  #
  def ready
    executions = SolidQueue::ReadyExecution.includes(:job)

    render json: executions.as_json(include: :job)
  end

  #
  #
  # GET /queues/running
  # ================================
  # Lists all currently running jobs.
  #
  # This action queries the solid_queue_claimed_executions table,
  # which represents jobs that have been claimed by a worker process
  # and are currently being executed.
  #
  # It includes associated job metadata and the process info that is executing the job.
  #
  # Response: JSON array of claimed executions with job and process data
  #
  def running
    executions = SolidQueue::ClaimedExecution.includes(:job, :process)

    render json: executions.as_json(include: [ :job, :process ])
  end

  #
  #
  # GET /queues/failed
  # ================================
  # Lists all jobs that failed during execution.
  #
  # This action queries the solid_queue_failed_executions table,
  # which stores executions that raised an exception or failed to complete successfully.
  #
  # It includes the associated job metadata, such as arguments, error details, and retry attempts.
  #
  # Response: JSON array of failed executions with job details
  #
  def failed
    executions = SolidQueue::FailedExecution.includes(:job)

    render json: executions.as_json(include: :job)
  end

  #
  #
  # GET /queues/scheduled
  # ================================
  # Lists all jobs scheduled for future execution.
  #
  # This action queries the solid_queue_scheduled_executions table,
  # which stores jobs that have a `scheduled_at` timestamp set in the future.
  #
  # These jobs will only be moved to the ready queue when their scheduled time arrives.
  #
  # It includes the associated job metadata.
  #
  # Response: JSON array of scheduled executions with job details
  #
  def scheduled
    executions = SolidQueue::ScheduledExecution.includes(:job)

    render json: executions.as_json(include: :job)
  end

  #
  #
  # GET /queues/recurring
  # ================================
  # Lists all recurring tasks configured to run periodically.
  #
  # This action queries the solid_queue_recurring_tasks table,
  # which contains tasks scheduled to run on a recurring basis using cron-like expressions
  # (e.g., every 5 minutes, daily, etc.).
  #
  # These tasks automatically enqueue jobs according to the defined schedule.
  #
  # Response: JSON array of recurring tasks
  #
  def recurring
    tasks = SolidQueue::RecurringTask.all

    render json: tasks
  end

  #
  #
  # GET /queues/status
  # ================================
  # Returns a summary of job counts by queue status.
  #
  # This action provides an aggregated overview of the current state of the job queue,
  # including counts for:
  # - Ready jobs (enqueued and waiting)
  # - Running jobs (being executed by a worker)
  # - Failed jobs (executions with error)
  # - Scheduled jobs (waiting for scheduled time)
  # - Recurring tasks (cron-like definitions)
  #
  # Useful for monitoring dashboards and health checks.
  #
  # Response: JSON object with counts by status
  #
  def status
    render json: {
      ready: SolidQueue::ReadyExecution.count,
      running: SolidQueue::ClaimedExecution.count,
      failed: SolidQueue::FailedExecution.count,
      scheduled: SolidQueue::ScheduledExecution.count,
      recurring: SolidQueue::RecurringTask.count
    }
  end

  #
  #
  # POST /queues/:id/retry
  # ================================
  # Retries a job by its ID.
  #
  # This action attempts to re-enqueue a previously created job (e.g. failed, completed, or scheduled),
  # by locating the job record in the solid_queue_jobs table and extracting its original class and arguments.
  #
  # Steps:
  # - Finds the job by ID.
  # - Validates the job exists.
  # - Attempts to constantize the job class (e.g. "MyJob" => MyJob).
  # - Extracts original arguments from the job payload.
  # - Re-enqueues the job using `perform_later`, preserving queue and priority.
  #
  # Returns:
  # - 200 OK on success
  # - 404 if job is not found
  # - 422 if the job class cannot be constantized
  #
  # Response: JSON object with status message
  #
  def retry
    if @job.nil?
      render json: { error: "Job not found" }, status: :not_found
      return
    end

    job_class = @job.class_name.safe_constantize

    if job_class.nil?
      render json: { error: "Job class not found or not constantizable" }, status: :unprocessable_entity
      return
    end

    args = @job.arguments["arguments"]

    job_class.set(queue: @job.queue_name, priority: @job.priority).perform_later(*args)

    render json: { message: "Job retried successfully" }, status: :ok
  end

  #
  #
  # DELETE /queues/:id
  # ================================
  # Deletes a job and all associated executions.
  #
  # This action looks up a job in the solid_queue_jobs table by its ID.
  # If the job is found, it is deleted along with all related records in:
  # - solid_queue_ready_executions
  # - solid_queue_failed_executions
  # - solid_queue_scheduled_executions
  # - solid_queue_claimed_executions
  # - solid_queue_blocked_executions
  # - solid_queue_recurring_executions
  #
  # (Assuming a model-level callback handles cleanup, like `after_destroy` in SolidQueue::Job.)
  #
  # Returns:
  # - 200 OK if the job was found and deleted
  # - 404 if the job does not exist
  #
  # Response: JSON message confirming deletion
  #
  def destroy
    if @job.nil?
      render json: { error: "Job not found" }, status: :not_found
      return
    end

    @job.destroy

    render json: { message: "Job and associated executions deleted successfully" }, status: :ok
  end


  private

  def set_job
    @job = SolidQueue::Job.find_by(id: params[:id])
  end
end
