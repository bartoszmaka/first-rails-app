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

  it 'denies to create invalid article' do
    @article.title = ''
    @article.content = ''
    expect(@article.save).to be false
  end

  it 'accepts to create valid article' do
    expect(@article.valid?).to be true
  end

  it 'validates title presence' do
    @article.title = nil
    expect(@article.valid?).to be false
  end

  it 'validates content presence' do
    @article.content = nil
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

  it 'validates content minimum length' do
    @article.content = 'a'
    expect(@article.valid?).to be false
  end
end
