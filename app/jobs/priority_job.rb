# Valores de Prioridade no SolidQueue
# O sistema de prioridade funciona da seguinte maneira:

# 0 → Maior prioridade (executado primeiro)
# 1-4 → Alta prioridade
# 5 → Prioridade média (padrão se não especificado)
# 6-9 → Baixa prioridade
# 10+ → Menor prioridade (executado por último)

# MyJob.set(priority: 2).perform_later

class HighPriorityJob < ApplicationJob
  queue_with_priority 1
  def perform
    puts "Job de alta prioridade"
  end
end

class LowPriorityJob < ApplicationJob
  queue_with_priority 10
  def perform
    puts "Job de baixa prioridade"
  end
end