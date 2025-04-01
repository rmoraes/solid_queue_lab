Rails.application.config.to_prepare do
  SolidQueue::Job.class_eval do
    after_destroy :cleanup_executions

    private

    def cleanup_executions
      SolidQueue::ReadyExecution.where(job_id: id).delete_all
      SolidQueue::ScheduledExecution.where(job_id: id).delete_all
      SolidQueue::FailedExecution.where(job_id: id).delete_all
      SolidQueue::ClaimedExecution.where(job_id: id).delete_all
      SolidQueue::RecurringExecution.where(job_id: id).delete_all
      SolidQueue::BlockedExecution.where(job_id: id).delete_all
    end
  end
end
