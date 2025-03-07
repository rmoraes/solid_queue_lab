class InactivateUsersJob < ApplicationJob
  queue_as :default

  def perform(kind)
    users = User.where(kind:)

    users.update_all(status: :inactive)
  end
end
