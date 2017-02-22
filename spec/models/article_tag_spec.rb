require 'rails_helper'

RSpec.describe ArticleTag, type: :model do
  let(:article_tag) { create(:article_tag) }
  describe 'article_tag' do
    subject { article_tag }
    it { should belong_to(:article) }
    it { should belong_to(:tag) }
    it { should validate_uniqueness_of(:tag_id).scoped_to(:article_id).case_insensitive }
  end
end
