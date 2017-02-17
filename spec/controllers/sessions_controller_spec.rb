require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  describe 'GET #new' do
    let(:call_request) { get :new }
    before { call_request }
    it { is_expected.to render_with_layout :application }
    it { is_expected.to render_template :new }
    it { is_expected.to respond_with :ok }
  end

  describe 'POST #create' do
    let!(:user) { User.create(attributes) }
    let(:attributes) { attributes_for(:user) }
    before { call_request }
    context 'with valid email, password combination' do
      let(:call_request) { post :create, params: { session: attributes } }
      it { is_expected.to redirect_to user_path(user.id) }
      it { is_expected.to respond_with :found }
    end
    context 'with invalid email, password combination' do
      let(:wrong_attributes) { attributes_for(:user, password: 'wrong441') }
      let(:call_request) { post :create, params: { session: wrong_attributes } }
      it { is_expected.to redirect_to '/login' }
      it { is_expected.to respond_with :found }
    end
  end

  describe 'DELETE #destroy' do
    let!(:user) { create(:user) }
    let(:call_request) { delete :destroy, session: { user_id: user.id } }
    before { call_request }
    it { is_expected.to redirect_to '/login' }
    it { is_expected.to respond_with :found }
  end
end
