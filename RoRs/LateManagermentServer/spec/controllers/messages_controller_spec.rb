require 'rails_helper'

RSpec.describe MessagesController, type: :controller do
  describe 'GET #index', autodoc: true do
    context 'without parameters' do
      it 'responds successfully with an HTTP 200 status code' do
        get :index
        expect(response).to be_success
        expect(response).to have_http_status(200)
      end

      it 'renders the index template' do
        get :index
        expect(response).to render_template('index')
      end

      it 'loads all of the services into @services' do
        message1 = create(:message)
        message2 = create(:message)
        get :index
        expect(assigns(:messages)).to match_array([message1, message2])
      end
    end
  end
end
