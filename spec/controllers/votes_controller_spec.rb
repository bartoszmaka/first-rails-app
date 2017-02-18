require 'rails_helper'

describe VotesController, type: :controller do
  let(:user) { create(:user) }
  let(:article) { create(:article, user: user) }
  let(:comment) { create(:comment, user: user, article: article) }
  let(:session) { { user_id: user.id } }
  let(:params) { { votable_id: article.id, votable_type: article.class.name } }
  before { request.env['HTTP_REFERER'] = article_path(article.id) }
  describe 'POST #create' do
    let(:call_request) { post :create, params: params, session: session }
    it 'expects to create new vote' do
      expect { call_request }.to change(Vote, :count).by(1)
    end
  end

  describe 'DELETE #destroy' do
    let!(:vote) { create(:vote, votable: article, user: user, positive: true) }
    let(:call_request) { delete :destroy, params: params, session: session }
    it 'expects to delete vote' do
      expect { call_request }.to change(Vote, :count).by(-1)
    end
  end

  describe 'PATCH #update' do
    let!(:vote) { create(:vote, votable: article, user: user, positive: true) }
    let(:call_request) { patch :update, params: params, session: session }
    it 'changes vote value' do
      call_request
      expect(Vote.find(vote.id).positive).to eq false
    end
  end

  describe 'PUT #update' do
    let!(:vote) { create(:vote, votable: article, user: user, positive: true) }
    let(:call_request) { put :update, params: params, session: session }
    it 'changes vote value' do
      call_request
      expect(Vote.find(vote.id).positive).to eq false
    end
  end
end
