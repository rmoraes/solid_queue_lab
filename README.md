# 🚀 Solid Queue Lab

This is a Ruby on Rails project designed to experiment with and demonstrate background job concepts using Solid Queue.

Follow the instructions below to set up and run the local environment.

## Installation

Before you begin, make sure you have **Ruby** and **Bundler** installed.

1. Install dependencies:
   ```sh
   bundle install
   ```

2. Set up the database:
   ```sh
   rails db:create db:migrate db:seed
   ```

## Running the project

To start the local server, run:

```sh
rails server
rails solid_queue:start
```

The project will be available with Swagger at: **http://localhost:3000/docs**



## Job Examples

This README provides usage examples and explanations for different types of background jobs using [SolidQueue](https://github.com/rails/solid_queue) with ActiveJob in a Ruby on Rails application.

---

## ✅ Simple Job
```ruby
class SimpleJob < ApplicationJob
  queue_as :default

  def perform(name)
    Rails.logger.info "Hello, #{name}!"
  end
end

# Usage
SimpleJob.perform_later("Alice")
```

---

## 🔼 Priority Job
```ruby
class PriorityJob < ApplicationJob
  queue_as :default

  def perform(task)
    Rails.logger.info "Performing high-priority task: #{task}"
  end
end

# Usage with priority
PriorityJob.set(priority: 5).perform_later("urgent-task")
```

---

## ⏳ Scheduled Job
```ruby
class ScheduledJob < ApplicationJob
  queue_as :default

  def perform(message)
    Rails.logger.info "Scheduled message: #{message}"
  end
end

# Usage with future execution
ScheduledJob.set(wait_until: 10.minutes.from_now).perform_later("Hello in 10 minutes")
```

---

## 🔁 Recurring Job (Cron-like)
```ruby
class RecurringReportJob < ApplicationJob
  queue_as :default

  def perform
    Rails.logger.info "Generating recurring report..."
  end
end

# Registering recurring task
SolidQueue::RecurringTask.create!(
  key: 'daily_report',
  class_name: 'RecurringReportJob',
  schedule: 'every 1 day',
  queue_name: 'default'
)
```

---

## 🚦 Job with Semaphore (Concurrency Control)
```ruby
class ExclusiveJob < ApplicationJob
  queue_as :default

  def perform
    SolidQueue::Semaphore.with("exclusive-key", limit: 1) do
      Rails.logger.info "Running job exclusively"
    end
  end
end

# Usage
ExclusiveJob.perform_later
```

---

## 🔗 Job with Dependency (Blocked Execution)
```ruby
class DependentFirstStepJob < ApplicationJob
  queue_as :default

  def perform
    Rails.logger.info "✅ FirstStepJob executed"
  end
end

class DependentSecondStepJob < ApplicationJob
  queue_as :default

  def perform
    Rails.logger.info "➡️  SecondStepJob executed (after FirstStepJob)"
  end
end

class DependentThirdStepJob < ApplicationJob
  queue_as :default

  def perform
    Rails.logger.info "🏁 ThirdStepJob executed (after SecondStepJob)"
  end
end

# Usage with chaining
job_a = DependentFirstStepJob.perform_later
job_b = DependentSecondStepJob.set(blocked_by: job_a).perform_later
job_c = DependentThirdStepJob.set(blocked_by: job_b).perform_later
```

---

## 🔁 Retryable Job
```ruby
class RetryableJob < ApplicationJob
  queue_as :default

  retry_on StandardError, wait: 5.seconds, attempts: 3

  def perform
    raise "Random failure" if rand > 0.3
    Rails.logger.info "Successfully performed retryable job"
  end
end

# Usage
RetryableJob.perform_later
```

---

## ✅ Notes
- Always set `ActiveJob::Base.queue_adapter = :solid_queue` in test or initializer when testing SolidQueue-specific behavior.
- To observe retry or delayed behavior, make sure `bin/rails solid_queue:start` is running in development/test.
- Use `.set(...)` with options like `wait`, `wait_until`, `priority`, `blocked_by` for fine control over job behavior.

---

## 📦 References
- [SolidQueue GitHub](https://github.com/rails/solid_queue)
- [ActiveJob Docs](https://guides.rubyonrails.org/active_job_basics.html)

