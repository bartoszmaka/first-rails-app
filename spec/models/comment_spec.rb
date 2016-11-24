require 'rails_helper'

RSpec.describe Comment, type: :model do
  before(:each) do
    @article = Article.new
    @article.title = 'long enough title to be accepted'
    @article.content = 'some long enough content'
    @comment = @article.comment.new
    @comment.author = 'tester'
    @comment.content = 'some long enough content'
  end
end
