require 'rails_helper'

RSpec.describe ApplicationController, type: :request do

  describe 'GET /api/v1/messages/9999999' do
    it 'RecordNotFound error processing', autodoc: true do
      get '/api/v1/messages/9999999', nil
      expect(response).to have_http_status(404)
      message = JSON.parse(response.body)['errors'].first['message']
      expect(message).to match(/^Couldn't find /)
    end
  end

  describe 'GET /api/v1/hogehoge' do
    it 'RoutingError error processing', autodoc: true do
      get '/api/v1/hogehoge', nil
      expect(response).to have_http_status(404)
      message = JSON.parse(response.body)['errors'].first['message']
      expect(message).to match(/^Error/)
    end
  end

  describe 'ArgumentError' do
    it 'Exception error processing', autodoc: true do
      allow_any_instance_of(Api::MessagesController).to receive(
        :index
      ).and_raise(ActiveRecord::RecordInvalid)
      get '/api/v1/messages', nil
      expect(response).to have_http_status(500)
    end
  end
end
