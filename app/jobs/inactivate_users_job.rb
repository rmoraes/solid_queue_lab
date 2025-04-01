class InactivateUsersJob < ApplicationJob
  queue_as :default

  def perform(params)
    users = User.where(kind: params[:kind])

    users.update_all(status: :inactive)
  end
end
