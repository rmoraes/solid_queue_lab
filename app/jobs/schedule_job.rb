
# O SolidQueue suporta agendamentos de jobs, mas não tem suporte nativo para CRON Jobs (jobs recorrentes).
# ou seja vc pode agendar um job para um determinada data, mas ele não ira repetir



# Isso agenda o job para rodar amanhã às 03:00 AM. Esse tipo de agendamento é suportado pelo SolidQueue.
# ScheduleJob.set(wait_until: Time.current.tomorrow.beginning_of_day + 3.hours).perform_later

class ScheduleJob < ApplicationJob
  queue_with_priority 1
  def perform
    puts "Job de alta ScheduleJob"
  end
end

