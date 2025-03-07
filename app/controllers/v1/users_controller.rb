# frozen_string_literal: true

class V1::UsersController < ApplicationController
  # GET /v1/users
  def index
    @users = User.all
  end

  # GET /v1/users/batch_inactivate
  def batch_inactivate
    InactivateUsersJob.perform_later(params[:kind])

    head :ok
  end
end
