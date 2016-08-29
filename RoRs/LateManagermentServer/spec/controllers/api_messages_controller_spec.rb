require 'rails_helper'

RSpec.describe Api::MessagesController, type: :request do

  describe 'GET /api/v1/messages', autodoc: true do
    it 'Message list, default is 50 messages' do
      insert_times = 5
      insert_times.times { create(:message) }
      get '/api/v1/messages', nil
      expect(response).to be_success
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body).size).to be > 0
    end
  end

  describe 'GET /api/v1/messages/message_id', autodoc: true do
    it 'return message json data of @Message assigned' do
      message = create(:message)
      message_id = message[:id]
      get "/api/v1/messages/#{message_id}", nil
      expect(JSON.parse(response.body)['id']).to eq(message_id)
    end
  end

  describe 'POST /api/v1/messages', autodoc: true do
    context 'with valid attributes' do
      it 'phone number not found, description has not phone number' do
        new_message = attributes_for(:message)
        post '/api/v1/messages', { params: new_message }
        expect(response).to be_success
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)['user_id']).to eq 1000000001
      end

      it 'phone number not found, description has phone number' do
        new_message = attributes_for(:message, description: '+84123456789 - test')
        post '/api/v1/messages', { params: new_message }
        expect(response).to be_success
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)['user_id']).to eq 1000000001
      end

      it 'has phone number, phone number has not +84' do
        new_message = attributes_for(:message, description: '0123456789 - test')
        post '/api/v1/messages', { params: new_message }
        expect(response).to be_success
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)['user_id']).to eq 1000000001
      end

      it 'match phone number of user present in system' do
        user = create(:user)
        new_message = attributes_for(:message, phone_number: '+84111222333')
        post '/api/v1/messages', { params: new_message }
        expect(response).to be_success
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)['user_id']).to eq user.id
      end
    end

    context 'with invalid attributes' do
      it 'does not save the new message and get 400 error code' do
        post '/api/v1/messages', { params: attributes_for(:message, phone_number: nil) }
        expect(response).to have_http_status(400)
        expect(JSON.parse(response.body)['success']).to eq false
      end
    end
  end
end
