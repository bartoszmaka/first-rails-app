require 'rails_helper'

describe TagsController, type: :controller do
  describe 'GET #index' do
    let!(:tag) { create(:tag) }
    let(:call_request) { get :index }

    before { call_request }

    it { expect(controller.tags).to eq [tag] }
    it { expect(call_request).to render_template :index }
    it { expect(call_request.status).to eq 200 }
  end

  describe 'GET #show' do
    let!(:tag) { create(:tag) }
    let!(:article) { create(:article, tags: [tag]) }
    let(:call_request) { get :show, params: { id: tag.id } }

    before { call_request }

    it { expect(controller.taggling).to eq tag }
    it { expect(controller.articles).to eq [article] }
    it { expect(call_request).to render_template :show }
    it { expect(call_request.status).to eq 200 }
  end
end
