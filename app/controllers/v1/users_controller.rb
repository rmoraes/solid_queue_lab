# frozen_string_literal: true

class V1::UsersController < ApplicationController
  # GET /v1/users
  def index
    @users = User.all
  end
end
