require 'rails_helper'

describe ArticlesController, type: :controller do
  describe 'GET #index' do
    context 'when params :search is not passed' do
      let(:article) { create(:article) }
      let(:article2) { create(:article, title: 'test') }
      let(:call_request) { get :index }
      before { call_request }

      it 'exposes articles' do
        expect(assigns(:articles)).to eq [article, article2]
      end

      it { is_expected.to render_with_layout :application }
      it { is_expected.to render_template :index }
      it { is_expected.to respond_with :ok }
    end
  end

  context 'when params :search passed' do
    let(:article) { create(:article) }
    let(:article2) { create(:article, title: 'test') }
    let(:call_request) { get :index, params: { search: 'test' } }
    before { call_request }
    it { is_expected.to render_with_layout :application }
    it { is_expected.to render_template :index }
    it { is_expected.to respond_with :ok }
    it 'exposes articles with title matching pattern' do
      expect(assigns(:articles)).to eq [article2]
    end
  end

  describe 'GET #show' do
    let(:article) { create(:article) }
    let(:call_request) { get :show, params: { id: article } }

    before { call_request }
    it 'exposes article' do
      expect(assigns(:article)).to eq article
    end

    it { is_expected.to render_with_layout :application }
    it { is_expected.to render_template :show }
    it { is_expected.to respond_with :ok }
  end

  describe 'GET #new' do
    context 'when user is authenticated' do
      let(:user) { create(:user) }
      let(:call_request) { get :new, session: { user_id: user.id } }
      it { expect(call_request.status).to eq 200 }
      it { expect(call_request).to render_template :new }
      it 'assigns new article' do
        call_request
        expect(assigns(:article).attributes).to eq Article.new.attributes
      end
    end

    context 'when user is not authenticated' do
      let(:call_request) { get :new, session: { user_id: nil } }
      it { expect(call_request.status).to eq 302 }
      it { expect(call_request).to redirect_to denied_path }
    end
  end

  describe 'GET #edit' do
    let!(:user) { create(:user) }
    let!(:article) { create(:article, user: user) }
    before { call_request }
    context 'when user is authenticated' do
      context 'when user owns resource' do
        let(:call_request) { get :edit, params: { id: article.id }, session: { user_id: user.id } }
        it { is_expected.to render_with_layout :application }
        it { is_expected.to render_template :edit }
        it { is_expected.to respond_with :ok }
        it 'assigns edited article' do
          expect(assigns(:article)).to eq(Article.find(article.id))
        end
      end

      context 'when user does not own resource' do
        let(:other_user) { create(:user) }
        let(:call_request) { get :edit, params: { id: article.id }, session: { user_id: other_user.id } }
        it { is_expected.to respond_with :found }
        it { is_expected.to redirect_to articles_path }
      end
    end

    context 'when user id not authenticated' do
      let(:call_request) { get :edit, params: { id: article.id }, session: { user_id: nil } }
      it { is_expected.to respond_with :found }
      it { is_expected.to redirect_to denied_path }
    end
  end

  describe 'POST #create' do
    let(:attributes) { attributes_for(:article) }
    let(:user) { create(:user) }

    context 'when user is authenticated' do
      let(:call_request) { post :create, params: { article: attributes }, session: { user_id: user.id } }

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
    end

    context 'when user is not authenicated' do
      let(:call_request) { post :create, params: { article: attributes }, session: { user_id: nil } }
      it 'does not create article' do
        expect { call_request }.to change(Article, :count).by(0)
      end
      it { expect(call_request.status).to eq 302 }
      it { expect(call_request).to redirect_to denied_path }
    end
  end

  describe 'DELETE #destroy' do
    let!(:user) { create(:user) }
    let!(:article) { create(:article, user: user) }

    context 'when user is authenticated' do
      let(:call_request) { delete :destroy, params: { id: article.id }, session: { user_id: user.id } }
      context 'when user owns resource' do
        it 'deletes article' do
          expect { call_request }.to change(Article, :count).by(-1)
        end
        it { expect(call_request.status).to eq 302 }
        it { expect(call_request).to redirect_to articles_path }
      end

      context 'when user does not own resource' do
        let(:other_user) { create(:user) }
        let(:call_request) { delete :destroy, params: { id: article.id }, session: { user_id: other_user.id } }
        it 'does not delete article' do
          expect { call_request }.to change(Article, :count).by(0)
        end
        it { expect(call_request.status).to eq 302 }
        it { expect(call_request).to redirect_to articles_path }
      end

      context 'when user is an admin' do
        let(:user) { create(:admin) }
        let(:call_request) { delete :destroy, params: { id: article.id }, session: { user_id: user.id } }
        it 'deletes article' do
          expect { call_request }.to change(Article, :count).by(-1)
        end
        it { expect(call_request.status).to eq 302 }
        it { expect(call_request).to redirect_to articles_path }
      end
    end

    context 'when user is not authenticated' do
      let(:call_request) { delete :destroy, params: { id: article.id }, session: { user_id: nil } }

      it 'does not delete article' do
        expect { call_request }.to change(Article, :count).by(0)
      end
      it { expect(call_request.status).to eq 302 }
      it { expect(call_request).to redirect_to denied_path }
    end
  end

  describe 'PATCH #update' do
    let(:user) { create(:user) }
    let(:article) { create(:article, user: user) }
    let(:params) { { id: article.id, article: { title: 'my new valid title' } } }
    before { call_request }
    context 'when user is authenticated' do
      context 'when changed resource is valid' do
        let(:call_request) { patch :update, params: params, session: { user_id: user.id } }
        it 'expects to change article title' do
          expect(Article.find(article.id).title).not_to eq article.title
        end
        it { is_expected.to respond_with :found }
        it { is_expected.to redirect_to article_path(article.id) }
      end

      context 'when changed resource is not valid' do
        let(:params) { { id: article.id, article: { title: '' } } }
        let(:call_request) { patch :update, params: params, session: { user_id: user.id } }
        it 'expects to leave article title as it is' do
          expect(Article.find(article.id).title).to eq article.title
        end
        it { is_expected.to respond_with :ok }
        it { is_expected.to render_template :edit }
        it { is_expected.to render_with_layout :application }
      end
    end
    context 'when user is not authenticated' do
      let(:call_request) { patch :update, params: params, session: { user_id: nil } }
      it 'expects to leave article title as it is' do
        call_request
        expect(Article.find(article.id).title).to eq article.title
      end
      it { is_expected.to respond_with :found }
      it { is_expected.to redirect_to denied_path }
    end
  end

  describe 'PUT #update' do
    let(:user) { create(:user) }
    let(:article) { create(:article, user: user) }
    let(:new_attributes) { attributes_for(:article) }
    let(:params) { { id: article.id, article: new_attributes } }
    before { call_request }
    context 'when user is authenticated' do
      context 'when changed resource is valid' do
        let(:call_request) { put :update, params: params, session: { user_id: user.id } }
        it 'expects to change article title' do
          expect(Article.find(article.id).title).not_to eq article.title
        end
        it { is_expected.to respond_with :found }
        it { is_expected.to redirect_to article_path(article.id) }
      end

      context 'when changed resource is not valid' do
        let(:new_attributes) { attributes_for(:article, title: '') }
        let(:call_request) { put :update, params: params, session: { user_id: user.id } }
        it 'expects to leave article title as it is' do
          expect(Article.find(article.id).title).to eq article.title
        end
        it { is_expected.to respond_with :ok }
        it { is_expected.to render_template :edit }
        it { is_expected.to render_with_layout :application }
      end
    end
    context 'when user is not authenticated' do
      let(:call_request) { put :update, params: params, session: { user_id: nil } }
      it 'expects to leave article title as it is' do
        call_request
        expect(Article.find(article.id).title).to eq article.title
      end
      it { is_expected.to respond_with :found }
      it { is_expected.to redirect_to denied_path }
    end
  end
end
