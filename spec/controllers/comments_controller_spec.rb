require 'rails_helper'

describe CommentsController, type: :controller do
  let(:user) { create(:user) }
  let(:article) { create(:article) }
  describe 'GET #new' do
    let(:params) { { article_id: article.id } }
    let(:call_request) { get :new, params: params, session: session }
    before { call_request }
    context 'when user is authorised' do
      let(:session) { { user_id: user.id } }
      it { is_expected.to respond_with :ok }
      it { is_expected.to render_template :new }
      it { is_expected.to render_with_layout :application }
      it 'assigns empty comment' do
        expect(assigns(:comment).attributes).to eq article.comments.new.attributes
      end
    end

    context 'when user is not authorised' do
      let(:session) { { user_id: nil } }
      it { is_expected.to respond_with :found }
      it { is_expected.to redirect_to denied_path }
    end
  end

  describe 'POST #create' do
    let(:call_request) { post :create, params: params, session: session }
    context 'when user is authorised' do
      let(:session) { { user_id: user.id } }
      context 'when attributes are valid' do
        let(:params) { { article_id: article.id, comment: attributes_for(:comment) } }
        it { expect(call_request.status).to eq 302 }
        it { expect(call_request).to redirect_to article_path(article.id) }
        it 'creates a comment' do
          expect { call_request }.to change(Comment, :count).by(1)
        end
      end

      context 'when attributes are not valid' do
        let(:params) { { article_id: article.id, comment: attributes_for(:comment, content: '') } }
        it { expect(call_request.status).to eq 200 }
        it { expect(call_request).to render_with_layout :application }
        it { expect(call_request).to render_template :new }
        it 'does not create a comment' do
          expect { call_request }.to change(Comment, :count).by(0)
        end
      end
    end

    context 'when user is not authorised' do
      let(:session) { { user_id: nil } }
      let(:params) { { article_id: article.id, comment: attributes_for(:comment) } }
      it { expect(call_request.status).to eq 302 }
      it { expect(call_request).to redirect_to denied_path }
    end
  end

  describe 'GET #edit' do
    let(:comment) { create(:comment, user: user, article: article) }
    let(:params) { { id: comment.id, article_id: article.id } }
    let(:call_request) { get :edit, params: params, session: session }
    before { call_request }
    context 'when user is authorised' do
      context 'when user owns resource' do
        let(:session) { { user_id: user.id } }
        # it 'asserts article' do
        #   expect(assert(:comment)).to eq(comment)
        # end
        it { is_expected.to respond_with :ok }
        it { is_expected.to render_with_layout :application }
        it { is_expected.to render_template :edit }
      end

      context 'when user does not own resource' do
        let(:other_user) { create(:user) }
        let(:session) { { user_id: other_user.id } }
        it { is_expected.to respond_with :found }
        it { is_expected.to redirect_to article_path(article.id) }
      end
    end

    context 'when user is not authorised' do
      let(:session) { { user_id: nil } }
      it { is_expected.to respond_with :found }
      it { is_expected.to redirect_to denied_path }
    end
  end

  describe 'PUT #update' do
    let!(:comment) { create(:comment, user: user, article: article) }
    let(:call_request) { put :update, params: params, session: session }
    let(:params) { { id: comment.id, article_id: article.id, comment: attributes } }
    before { call_request }
    context 'when user is authorised' do
      let(:session) { { user_id: user.id } }
      context 'when attributes are valid' do
        let(:attributes) { attributes_for(:comment) }
        it 'expects to change comment content' do
          expect(Comment.find(comment.id).content).not_to eq comment.content
        end
        it { is_expected.to respond_with :found }
        it { is_expected.to redirect_to article_path(article.id) }
      end

      context 'when attributes are not valid' do
        let(:attributes) { attributes_for(:comment, content: '') }
        it 'expects to leave content as it is' do
          expect(Comment.find(comment.id).content).to eq comment.content
        end
        it { is_expected.to respond_with :ok }
        it { is_expected.to render_template :edit }
        it { is_expected.to render_with_layout :application }
      end
    end

    context 'when user is not authorised' do
      let(:attributes) { attributes_for(:comment) }
      let(:session) { { user_id: nil } }
      it 'expects to leave content as it is' do
        expect(Comment.find(comment.id).content).to eq comment.content
      end
      it { is_expected.to respond_with :found }
      it { is_expected.to redirect_to denied_path }
    end
  end

  describe 'PATCH #update' do
    let!(:comment) { create(:comment, user: user, article: article) }
    let(:call_request) { patch :update, params: params, session: session }
    let(:params) { { id: comment.id, article_id: article.id, comment: attributes } }
    before { call_request }
    context 'when user is authorised' do
      let(:session) { { user_id: user.id } }
      context 'when attributes are valid' do
        let(:attributes) { { content: 'my new valid content' } }
        it 'expects to change comment content' do
          expect(Comment.find(comment.id).content).not_to eq comment.content
        end
        it { is_expected.to respond_with :found }
        it { is_expected.to redirect_to article_path(article.id) }
      end

      context 'when attributes are not valid' do
        let(:attributes) { { content: '' } }
        it 'expects to leave content as it is' do
          expect(Comment.find(comment.id).content).to eq comment.content
        end
        it { is_expected.to respond_with :ok }
        it { is_expected.to render_template :edit }
        it { is_expected.to render_with_layout :application }
      end
    end

    context 'when user is not authorised' do
      let(:session) { { user_id: nil } }
      let(:attributes) { { content: 'my new valid content' } }
      it 'expects to leave content as it is' do
        expect(Comment.find(comment.id).content).to eq comment.content
      end
      it { is_expected.to respond_with :found }
      it { is_expected.to redirect_to denied_path }
    end
  end

  describe 'DELETE #destroy' do
    let!(:comment) { create(:comment, user: user, article: article) }
    let(:params) { { id: comment.id, article_id: article.id } }
    let(:call_request) { delete :destroy, params: params, session: session }
    context 'when user is authorised' do
      let(:session) { { user_id: user.id } }
      context 'when user owns resource' do
        it 'deletes comment' do
          expect { call_request }.to change(Comment, :count).by(-1)
        end
        it { expect(call_request.status).to eq 302 }
        it { expect(call_request).to redirect_to article_path(article.id) }
      end

      context 'when user does not own resource' do
        let(:other_user) { create(:user) }
        let(:session) { { user_id: other_user.id } }
        it { expect(call_request.status).to eq 302 }
        it { expect(call_request).to redirect_to article_path(article.id) }
      end
    end

    context 'when user is not authorised' do
      let(:session) { { user_id: nil } }
      it { expect(call_request.status).to eq 302 }
      it { expect(call_request).to redirect_to denied_path }
    end
  end
end
