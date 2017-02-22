require 'rails_helper'

RSpec.describe Tag, type: :model do
  let(:tag) { create(:tag) }

  describe 'tag' do
    subject { tag }
    it { should have_many(:articles) }
    it { should validate_uniqueness_of(:name).case_insensitive }
    it { should validate_length_of(:name).is_at_least(1) }
    it { should validate_presence_of(:name) }
    it { should_not allow_value(nil).for(:name) }
    it { should_not allow_value('inv@lid').for(:name) }
    it { should_not allow_value('with whitespace').for(:name) }
  end

  describe 'tag articles_count counter_cache' do
    let!(:article) { create(:article) }
    let(:other_article) { create(:article) }
    let(:old_articles_count) { tag.articles_count }
    before do
      article.tags << tag
      old_articles_count
    end
    subject { tag.articles_count }

    it 'increases by 1 after creating article with tag' do
      other_article.tags << tag
      expect(tag.articles_count).to eq(old_articles_count + 1)
    end
    it 'decreases by 1 after deleting article with tag' do
      article.destroy
      expect(tag.articles_count).to eq(old_articles_count - 1)
    end
  end
end
