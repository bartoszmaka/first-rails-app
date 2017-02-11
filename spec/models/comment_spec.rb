require 'rails_helper'

RSpec.describe Comment, type: :model do
  before(:each) do
    @comment = build(:comment)
  end

  it 'should belong to user' do
    @comment.user = nil
    expect(@comment.valid?).to be false
  end

  it 'should belong to article' do
    @comment.article = nil
    expect(@comment.valid?).to be false
  end
end
