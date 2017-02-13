require 'rails_helper'

RSpec.describe ArticleTag, type: :model do
  before(:each) do
    @article = create(:article)
    @tag = create(:tag)
  end

  it 'should have valid factory' do
    expect(@article.valid?).to be true
    expect(@tag.valid?).to be true
  end

  it 'should allow article to have many tags' do
    @article.tags << @tag
    @article.tags << create(:tag)
    expect(@article.tags.count).to be 2
  end

  it 'should allow tag to be used in many articles' do
    other_article = create(:article)
    @article.tags << @tag
    other_article.tags << @tag
    expect(@article.tags).to eq(other_article.tags)
  end
end
