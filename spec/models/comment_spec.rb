require 'rails_helper'

RSpec.describe Comment, type: :model do
  before(:each) do
    @user = User.new(
      name: 'Example User',
      email: 'exampleemail@example.com',
      password: 'password',
      password_confirmation: 'password'
    )
    @article = Article.create(
      title: 'Testing',
      content: 'foobar',
      user: @user
    )
    @comment = Comment.new(
      content: 'sample comment',
      article: @article,
      user: @user
    )

    it 'should belong to user' do
      @comment.user = nil
      expect(@comment.valid?).to be false
    end

    it 'should belong to article' do
      @comment.article = nil
      expect(@comment.valid?).to be false
    end
  end
end
