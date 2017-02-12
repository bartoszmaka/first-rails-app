require 'rails_helper'

RSpec.describe ArticleTag, type: :model do
  before(:each) do
    @article = create(:article)
    @tag = create(:tag)
  end

  # it 'should have valid factory' do
  #   puts Tag.count
  #   puts Article.count
  #   puts Comment.count
  #   puts @tag.name
  #   tag2 = build(:tag)
  #   puts tag2.name
  #   expect(@article.valid?).to be true
  #   expect(@tag.valid?).to be true
  #   expect(tag2.valid?).to be true
  # end

  it 'should allow article to have many tags' do
    @article << @tag
    @article << create(:tag)
    expect(@article.tags.count).to be 2
  end

  it 'should allow tag to be used in many articles' do
    other_article = create(:article)
    @article << @tag
    other_article << @tag
    expect(@article.tags).to eq(other_article.tags)
  end
end
