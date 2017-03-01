require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe 'GET #show' do
    let!(:user) { create(:user) }
    let(:call_request) { get :show, params: { id: user.id } }
    before { call_request }
    it 'exposes user' do
      expect(assigns(:user)).to eq user
    end
    it { is_expected.to render_with_layout :application }
    it { is_expected.to render_template :show }
    it { is_expected.to respond_with :ok }
  end

  describe 'GET #new' do
    let(:call_request) { get :new }
    before { call_request }
    it 'exposes new user' do
      expect(assigns(:user)).to be_a User
    end
    it { is_expected.to render_with_layout :application }
    it { is_expected.to render_template :new }
    it { is_expected.to respond_with :ok }
  end

  describe 'POST #create' do
    let(:call_request) { post :create, params: { user: attributes } }
    context 'when attributes are valid' do
      let(:attributes) { attributes_for(:user) }
      it 'creates new user' do
        expect { call_request }.to change(User, :count).by(1)
      end
      it { expect(call_request).to redirect_to user_path(User.last) }
      it { expect(call_request.status).to eq 302 }
    end

    context 'when attributes are invalid' do
      let(:attributes) { attributes_for(:user, email: '') }
      it 'does not create new user' do
        expect { call_request }.to change(User, :count).by(0)
      end
      it { expect(call_request).to redirect_to new_user_path }
      it { expect(call_request.status).to eq 302 }
    end
  end
end
