require 'rails_helper'

RSpec.describe Article, type: :model do
  before(:each) do
    @article = build(:article)
  end

  it 'sample should be valid' do
    expect(@article.valid?).to be true
  end

  it 'should belong to user' do
    @article.user = nil
    expect(@article.valid?).to be false
  end

  context 'when creating or deleting comment' do
    before(:each) do
      @comment = create(:comment, article: @article)
      @old_comments_count = @article.comments_count
    end

    it 'should update comments_count after creating new comment' do
      create(:comment, article: @article)
      expect(@article.comments_count).to eq(@old_comments_count + 1)
    end

    it 'should update comments_count after deleting comment' do
      @comment.destroy
      expect(@article.comments_count).to eq(@old_comments_count - 1)
    end
  end

  it 'content cant be blank' do
    @article.content = ''
    expect(@article.save).to be false
  end

  it 'validates content presence' do
    @article.content = nil
    expect(@article.valid?).to be false
  end

  it 'validates content minimum length' do
    @article.content = 'a'
    expect(@article.valid?).to be false
  end

  it 'title cant be blank' do
    @article.title = ''
    expect(@article.save).to be false
  end

  it 'validates title presence' do
    @article.title = nil
    expect(@article.valid?).to be false
  end

  it 'validates title minimum length' do
    @article.title = 'a'
    expect(@article.valid?).to be false
  end

  it 'validates title maximum length' do
    long_title = 'a' * 1400
    @article.title = long_title
    expect(@article.valid?).to be false
  end
end
