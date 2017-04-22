require 'rails_helper'

describe CommentsController, type: :controller do
  let(:user) { create(:user) }
  let(:article) { create(:article) }

  describe 'GET #new' do
    let(:params) { { article_id: article.id } }
    let(:call_request) { get :new, params: params }

    context 'when user is authorised' do
      before do
        sign_in user
        call_request
      end

      it { is_expected.to respond_with :ok }
      it { is_expected.to render_template :new }
      it { expect(controller.comment.attributes).to eq article.comments.new.attributes }
    end

    context 'when user is banned' do
      before do
        request.env['HTTP_REFERER'] = article_path(article)
        sign_in user
        user.ban
        call_request
      end

      it { is_expected.to respond_with :found }
      it { is_expected.to redirect_to article_path(article) }
    end

    context 'when user is not authorised' do
      before { call_request }

      it { is_expected.to respond_with :found }
      it { is_expected.to redirect_to new_user_session_path }
    end
  end

  describe 'POST #create' do
    let(:call_request) { post :create, params: params }

    context 'when user is authorised' do
      before { sign_in user }

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
        it { expect(call_request.status).to eq 302 }
        it { expect(call_request).to redirect_to article }
        it 'does not create a comment' do
          expect { call_request }.to change(Comment, :count).by(0)
        end
      end

      context 'when user is banned' do
        let(:params) { { article_id: article.id, comment: attributes_for(:comment) } }
        before do
          request.env['HTTP_REFERER'] = article_path(article)
          sign_in user
          user.ban
        end
        it 'does not create a new article' do
          expect { call_request }.to change(Article, :count).by(0)
        end
        it { expect(call_request.status).to eq 302 }
        it { expect(call_request).to redirect_to article_path(article) }
      end
    end

    context 'when user is not authorised' do
      let(:params) { { article_id: article.id, comment: attributes_for(:comment) } }
      it { expect(call_request.status).to eq 302 }
      it { expect(call_request).to redirect_to new_user_session_path }
    end
  end

  describe 'GET #edit' do
    let(:comment) { create(:comment, user: user, article: article) }
    let(:params) { { id: comment.id, article_id: article.id } }
    let(:call_request) { get :edit, params: params }
    context 'when user is authorised' do
      before do
        sign_in user
        call_request
      end
      context 'when user owns resource' do
        it { expect(controller.comment.attributes).to eq Comment.last.attributes }
        it { is_expected.to respond_with :ok }
        it { is_expected.to render_template :edit }
      end

      context 'when user does not own resource' do
        let(:comment) { create(:comment, article: article) }
        it { is_expected.to respond_with :found }
        it { is_expected.to redirect_to article_path(article.id) }
      end
    end

    context 'when user is banned' do
      before do
        request.env['HTTP_REFERER'] = article_path(article)
        sign_in user
        user.ban
        call_request
      end

      it { is_expected.to respond_with :found }
      it { is_expected.to redirect_to article_path(article) }
    end

    context 'when user is not authorised' do
      before { call_request }

      it { is_expected.to respond_with :found }
      it { is_expected.to redirect_to new_user_session_path }
    end
  end

  describe 'PUT #update' do
    let!(:comment) { create(:comment, user: user, article: article) }
    let(:call_request) { put :update, params: params }
    let(:attributes) { attributes_for(:comment) }
    let(:params) { { id: comment.id, article_id: article.id, comment: attributes } }

    context 'when user is authorised' do
      before do
        sign_in user
        call_request
      end

      context 'when attributes are valid' do
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
      end
    end

    context 'when user is banned' do
      before do
        request.env['HTTP_REFERER'] = article_path(article)
        sign_in user
        user.ban
        call_request
      end
      it 'expects to leave comment title as it is' do
        expect(Comment.find(comment.id).content).to eq comment.content
      end
      it { is_expected.to respond_with :found }
      it { is_expected.to redirect_to article_path(article) }
    end

    context 'when user is not authorised' do
      before { call_request }
      let(:attributes) { attributes_for(:comment) }
      it 'expects to leave content as it is' do
        expect(Comment.find(comment.id).content).to eq comment.content
      end
      it { is_expected.to respond_with :found }
      it { is_expected.to redirect_to new_user_session_path }
    end
  end

  describe 'PATCH #update' do
    let!(:comment) { create(:comment, user: user, article: article) }
    let(:call_request) { patch :update, params: params }
    let(:attributes) { { content: 'my new valid content' } }
    let(:params) { { id: comment.id, article_id: article.id, comment: attributes } }
    context 'when user is authorised' do
      before do
        sign_in user
        call_request
      end
      context 'when attributes are valid' do
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
      end
    end

    context 'when user is banned' do
      before do
        request.env['HTTP_REFERER'] = article_path(article)
        sign_in user
        user.ban
        call_request
      end
      it 'expects to leave comment title as it is' do
        expect(Comment.find(comment.id).content).to eq comment.content
      end
      it { is_expected.to respond_with :found }
      it { is_expected.to redirect_to article_path(article) }
    end

    context 'when user is not authorised' do
      before { call_request }
      let(:attributes) { { content: 'my new valid content' } }
      it 'expects to leave content as it is' do
        expect(Comment.find(comment.id).content).to eq comment.content
      end
      it { is_expected.to respond_with :found }
      it { is_expected.to redirect_to new_user_session_path }
    end
  end

  describe 'DELETE #destroy' do
    let!(:comment) { create(:comment, user: user, article: article) }
    let(:params) { { id: comment.id, article_id: article.id } }
    let(:call_request) { delete :destroy, params: params }
    context 'when user is authorised' do
      before { sign_in user }
      context 'when user owns resource' do
        it 'deletes comment' do
          expect { call_request }.to change(Comment, :count).by(-1)
        end
        it { expect(call_request.status).to eq 302 }
        it { expect(call_request).to redirect_to article_path(article.id) }
      end

      context 'when user does not own resource' do
        let(:other_user) { create(:user) }
        it { expect(call_request.status).to eq 302 }
        it { expect(call_request).to redirect_to article_path(article.id) }
      end
    end

    context 'when user is banned' do
      before do
        request.env['HTTP_REFERER'] = article_path(article)
        sign_in user
        user.ban
      end
      it 'does not delete article' do
        expect { call_request }.to change(Comment, :count).by(0)
      end
      it { expect(call_request.status).to eq 302 }
      it { expect(call_request).to redirect_to article_path(article) }
    end

    context 'when user is not authorised' do
      it { expect(call_request.status).to eq 302 }
      it { expect(call_request).to redirect_to new_user_session_path }
    end
  end
end
