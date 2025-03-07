class QueuesController < ApplicationController
  def index
    @queues = SolidQueue::Job.all
  end
end
