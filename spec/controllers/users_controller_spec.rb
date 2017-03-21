require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe 'GET #index' do
    let(:call_request) { get :index }
    before { call_request }
    it { is_expected.to render_with_layout :application }
    it { is_expected.to render_template :index }
    it { is_expected.to respond_with :ok }
  end

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

  # describe 'GET #edit' do
  #   let(:user) { create(:user) }
  #   let(:params) { { id: user.id } }
  #   let(:session) { { user_id: user.id } }
  #   let(:call_request) { get :edit, params: params, session: session }
  #   before { call_request }
  #   it { is_expected.to render_with_layout :application }
  #   it { is_expected.to render_template :edit }
  #   it { is_expected.to respond_with :ok }
  # end

#   describe 'GET #new' do
#     let(:call_request) { get :new }
#     before { call_request }
#     it 'exposes new user' do
#       expect(assigns(:user)).to be_a User
#     end
#     it { is_expected.to render_with_layout :application }
#     it { is_expected.to render_template :new }
#     it { is_expected.to respond_with :ok }
#   end

#   describe 'POST #create' do
#     let(:call_request) { post :create, params: { user: attributes } }
#     context 'when attributes are valid' do
#       let(:attributes) { attributes_for(:user) }
#       it 'creates new user' do
#         expect { call_request }.to change(User, :count).by(1)
#       end
#       it { expect(call_request).to redirect_to user_path(User.last) }
#       it { expect(call_request.status).to eq 302 }
#     end

#     context 'when attributes are invalid' do
#       let(:attributes) { attributes_for(:user, email: '') }
#       it 'does not create new user' do
#         expect { call_request }.to change(User, :count).by(0)
#       end
#       it { expect(call_request).to render_template 'new' }
#       it { expect(call_request.status).to eq 200 }
#     end
#   end

#   describe 'PATCH #update' do
#     let!(:user) { create(:user) }
#     let(:session) { { user_id: user.id } }
#     let(:call_request) { patch :update, params: params, session: session }
#     before { call_request }
#     context 'when password is passed' do
#       context 'when attributes are valid' do
#         let(:params) do
#           { id: user.id, user: { name: 'mynewtestname',
#                                  old_password: '123123',
#                                  password: 'qweqwe',
#                                  password_confirmation: 'qweqwe' } }
#         end
#         it { expect(call_request).to redirect_to user_path(user.id) }
#         it { expect(call_request.status).to eq 302 }
#       end

#       context 'when attributes are invalid' do
#         let(:params) do
#           { id: user.id, user: { name: 'mynewtestname',
#                                  old_password: '123123',
#                                  password: 'qweqwe',
#                                  password_confirmation: 'asdasd' } }
#         end
#         it { expect(call_request).to render_with_layout :application }
#         it { expect(call_request).to render_template :edit }
#         it { expect(call_request.status).to eq 200 }
#       end
#     end

#     context 'when password is not passed' do
#       context 'when attributes are valid' do
#         let(:params) { { id: user.id, user: { name: 'mynewtestname' } } }
#         it { expect(call_request).to redirect_to user_path(user.id) }
#         it { expect(call_request.status).to eq 302 }
#       end

#       context 'when attributes are invalid' do
#         let(:params) { { id: user.id, user: { name: ('test' * 20).to_str } } }
#         it { expect(call_request).to render_with_layout :application }
#         it { expect(call_request).to render_template :edit }
#         it { expect(call_request.status).to eq 200 }
#       end
#     end
#   end
end
