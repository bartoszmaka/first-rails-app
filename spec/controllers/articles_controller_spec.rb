require 'rails_helper'

describe ArticlesController, type: :controller do
  describe 'GET #index' do
    let!(:article) { create(:article) }
    let!(:article2) { create(:article, title: 'test') }
    before { call_request }

    context 'when params :search is not passed' do
      let(:call_request) { get :index }

      it { expect(controller.articles).to eq [article, article2] }
      it { is_expected.to render_template :index }
      it { is_expected.to respond_with :ok }
    end
  end

  describe 'GET #show' do
    let(:article) { create(:article) }
    let(:call_request) { get :show, params: { id: article } }
    before { call_request }

    it { expect(controller.article).to eq article }
    it { is_expected.to render_template :show }
    it { is_expected.to respond_with :ok }
  end

  describe 'GET #new' do
    let(:user) { create(:user) }
    let(:call_request) { get :new }

    context 'when user is authenticated' do
      before do
        sign_in user
        call_request
      end

      it { expect(controller.article.attributes).to eq Article.new.attributes }
      it { is_expected.to render_with_layout :application }
      it { is_expected.to render_template :new }
      it { is_expected.to respond_with :ok }
    end

    context 'when user is banned' do
      before do
        request.env['HTTP_REFERER'] = articles_path
        sign_in user
        user.ban
        call_request
      end

      it { is_expected.to respond_with :found }
      it { is_expected.to redirect_to articles_path }
    end

    context 'when user is not authenticated' do
      before { call_request }
      it { is_expected.to respond_with :found }
      it { is_expected.to redirect_to new_user_session_path }
    end
  end

  describe 'GET #edit' do
    let(:user) { create(:user) }
    let(:article) { create(:article, user: user) }
    let(:call_request) { get :edit, params: { id: article.id } }

    context 'when user is authenticated' do
      before do
        sign_in user
        call_request
      end

      it { expect(controller.article.attributes).to eq Article.last.attributes }
      it { is_expected.to render_with_layout :application }
      it { is_expected.to render_template :edit }
      it { is_expected.to respond_with :ok }
    end

    context 'when user does not own resource' do
      let(:article) { create(:article) }

      before do
        sign_in user
        call_request
      end

      it { is_expected.to respond_with :found }
      it { is_expected.to redirect_to articles_path }
    end

    context 'when user is banned' do
      before do
        request.env['HTTP_REFERER'] = articles_path
        sign_in user
        user.ban
        call_request
      end

      it { is_expected.to respond_with :found }
      it { is_expected.to redirect_to articles_path }
    end

    context 'when user is not authenticated' do
      before { call_request }
      it { is_expected.to respond_with :found }
      it { is_expected.to redirect_to new_user_session_path }
    end
  end

  describe 'POST #create' do
    let(:attributes) { attributes_for(:article) }
    let(:user) { create(:user) }
    let(:call_request) { post :create, params: { article: attributes } }

    context 'when user is authenticated' do
      before { sign_in user }

      context 'when attributes are valid' do
        it 'creates a new article' do
          expect { call_request }.to change(Article, :count).by(1)
        end
        it { expect(call_request).to redirect_to article_path(id: Article.last) }
        it { expect(call_request.status).to eq 302 }
      end

      context 'when attributes are invalid' do
        let(:attributes) { attributes_for(:article, title: '') }
        it 'does not create a new article' do
          expect { call_request }.to change(Article, :count).by(0)
        end
        it { expect(call_request).to render_with_layout :application }
        it { expect(call_request).to render_template :new }
        it { expect(call_request.status).to eq 200 }
      end

      context 'when user is banned' do
        before do
          request.env['HTTP_REFERER'] = articles_path
          sign_in user
          user.ban
        end
        it 'does not create a new article' do
          expect { call_request }.to change(Article, :count).by(0)
        end
        it { expect(call_request.status).to eq 302 }
        it { expect(call_request).to redirect_to articles_path }
      end
    end

    context 'when user is not authenicated' do
      it 'does not create article' do
        expect { call_request }.to change(Article, :count).by(0)
      end
      it { expect(call_request.status).to eq 302 }
      it { expect(call_request).to redirect_to new_user_session_path }
    end
  end

  describe 'DELETE #destroy' do
    let!(:user) { create(:user) }
    let!(:article) { create(:article, user: user) }
    let(:call_request) { delete :destroy, params: { id: article.id } }

    context 'when user is authenticated' do
      context 'when user owns resource' do
        before { sign_in user }

        it 'deletes article' do
          expect { call_request }.to change(Article, :count).by(-1)
        end
        it { expect(call_request.status).to eq 302 }
        it { expect(call_request).to redirect_to articles_path }
      end

      context 'when user does not own resource' do
        let(:other_user) { create(:user) }
        let(:call_request) { delete :destroy, params: { id: article.id } }

        before { sign_in other_user }
        it 'does not delete article' do
          expect { call_request }.to change(Article, :count).by(0)
        end

        it { expect(call_request.status).to eq 302 }
        it { expect(call_request).to redirect_to articles_path }
      end

      context 'when user is an admin' do
        let(:user) { create(:admin) }
        let(:call_request) { delete :destroy, params: { id: article.id } }

        before { sign_in user }

        it 'deletes article' do
          expect { call_request }.to change(Article, :count).by(-1)
        end
        it { expect(call_request.status).to eq 302 }
        it { expect(call_request).to redirect_to articles_path }
      end

      context 'when user is banned' do
        let(:user) { create(:user) }
        let(:call_request) { delete :destroy, params: { id: article.id } }

        before do
          request.env['HTTP_REFERER'] = articles_path
          sign_in user
          user.ban
        end

        it 'does not delete article' do
          expect { call_request }.to change(Article, :count).by(0)
        end
        it { expect(call_request.status).to eq 302 }
        it { expect(call_request).to redirect_to articles_path }
      end
    end

    context 'when user is not authenticated' do
      let(:call_request) { delete :destroy, params: { id: article.id } }

      it 'does not delete article' do
        expect { call_request }.to change(Article, :count).by(0)
      end
      it { expect(call_request.status).to eq 302 }
      it { expect(call_request).to redirect_to new_user_session_path }
    end
  end

  describe 'PATCH #update' do
    let(:user) { create(:user) }
    let(:article) { create(:article, user: user) }
    let(:new_title) { 'my new valid title' }
    let(:params) { { id: article.id, article: { title: new_title } } }
    let(:call_request) { patch :update, params: params }

    context 'when user is authenticated' do
      before do
        user.add_role('admin')
        sign_in user
        call_request
      end

      context 'when changed resource is valid' do
        it 'expects to change article title' do
          call_request
          expect(Article.find(article.id).title).to eq new_title
        end
        it { is_expected.to respond_with :found }
        it { is_expected.to redirect_to article_path(article.id) }
      end

      context 'when changed resource is not valid' do
        let(:params) { { id: article.id, article: { title: '' } } }
        it 'expects to leave article title as it is' do
          expect(Article.find(article.id).title).to eq article.title
        end
        it { is_expected.to respond_with :ok }
        it { is_expected.to render_template :edit }
        it { is_expected.to render_with_layout :application }
      end
    end

    context 'when user is banned' do
      before do
        request.env['HTTP_REFERER'] = articles_path
        sign_in user
        user.ban
      end
      it 'expects to leave article title as it is' do
        expect(Article.find(article.id).title).to eq article.title
      end
      it { expect(call_request.status).to eq 302 }
      it { expect(call_request).to redirect_to articles_path }
    end

    context 'when user is not authenticated' do
      before { call_request }
      it 'expects to leave article title as it is' do
        expect(Article.find(article.id).title).to eq article.title
      end
      it { is_expected.to respond_with :found }
      it { is_expected.to redirect_to new_user_session_path }
    end
  end

  describe 'PUT #update' do
    let!(:user) { create(:user) }
    let!(:article) { create(:article, user: user) }
    let(:new_attributes) { attributes_for(:article) }
    let(:params) { { id: article.id, article: new_attributes } }
    let(:call_request) { put :update, params: params }
    context 'when user is authenticated' do
      before do
        sign_in user
        call_request
      end
      context 'when changed resource is valid' do
        it 'expects to change article title' do
          expect(Article.find(article.id).title).not_to eq article.title
        end
        it { is_expected.to respond_with :found }
        it { is_expected.to redirect_to article_path(article.id) }
      end

      context 'when changed resource is not valid' do
        let(:new_attributes) { attributes_for(:article, title: '') }
        let(:call_request) { put :update, params: params }
        it 'expects to leave article title as it is' do
          expect(Article.find(article.id).title).to eq article.title
        end
        it { is_expected.to respond_with :ok }
        it { is_expected.to render_template :edit }
        it { is_expected.to render_with_layout :application }
      end
    end
    context 'when user is not authenticated' do
      let(:call_request) { put :update, params: params }
      before { call_request }
      it 'expects to leave article title as it is' do
        expect(Article.find(article.id).title).to eq article.title
      end
      it { is_expected.to respond_with :found }
      it { is_expected.to redirect_to new_user_session_path }
    end
  end
end
