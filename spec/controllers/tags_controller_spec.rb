require 'rails_helper'

describe TagsController, type: :controller do
  describe 'GET #index' do
    let(:tag) { create(:tag) }
    let(:call_request) { get :index }

    before { call_request }

    it 'exposes tags' do
      expect(assigns(:tags)).to eq [tag]
    end
  end

  describe 'GET #show' do
    let(:tag) { create(:tag) }
    let(:article) { create(:article, tags: [tag]) }
    let(:call_request) { get :show, params: { id: tag.id } }

    before { call_request }

    it 'exposes tag' do
      expect(assigns(:tag)).to eq tag
    end

    it 'exposes tag articles' do
      expect(assigns(:tag).articles).to eq [article]
    end
  end
end
