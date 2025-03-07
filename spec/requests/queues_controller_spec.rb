# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe QueuesController, type: :request do
  #
  #
  #
  # Documentation for the queues listing endpoint
  #
  path '/queues' do
    get('list queues') do
      tags 'users'
      produces 'application/json'
      consumes 'application/json'

      response(200, 'successful') do
        run_test!
      end
    end
  end
end
