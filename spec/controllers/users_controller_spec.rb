require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe 'GET #index' do
    let(:call_request) { get :index }
    let(:user) { create(:user) }

    context 'when user is authorised' do
      before do
        sign_in user
        call_request
      end
      it { is_expected.to render_template :index }
      it { is_expected.to respond_with :ok }
    end

    context 'when user is not authorised' do
      before { call_request }

      it { is_expected.to respond_with :found }
      it { is_expected.to redirect_to new_user_session_path }
    end
  end

  describe 'GET #show' do
    let!(:user) { create(:user) }
    let(:call_request) { get :show, params: { id: user.id } }

    before { call_request }

    it 'exposes user' do
      expect(assigns(:user)).to eq user
    end
    it { is_expected.to render_template :show }
    it { is_expected.to respond_with :ok }
  end
end
