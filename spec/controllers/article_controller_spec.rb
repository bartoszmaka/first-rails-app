require 'rails_helper'

RSpec.describe ArticlesController, type: :controller do
  describe 'GET #index' do
    it 'renders index template' do
      get :index
      expect(response).to render_template('index')
    end
  end
end
