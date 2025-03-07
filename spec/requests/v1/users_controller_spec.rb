# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe V1::UsersController, type: :request do
  #
  #
  #
  # Documentation for the user listing endpoint
  #
  path '/v1/users' do
    get('list users') do
      tags 'users'
      produces 'application/json'
      consumes 'application/json'

      response(200, 'successful') do
        run_test!
      end
    end
  end


  path '/v1/users/batch_inactivate' do
    patch('activate users in batch') do
      tags 'users'
      produces 'application/json'
      consumes 'application/json'

      # Define parameters for Swagger documentation
      parameter(name: :kind, in: :query, required: true,
      schema: {
        type: :string,
        enum:  %w[promoter supervisor administrator]
      })

      response(200, 'successful') do
        run_test!
      end
    end
  end
end
