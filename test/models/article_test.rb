require 'test_helper'

class ArticleTest < ActiveSupport::TestCase
  def setup
    @article = Article.new(title: 'test title', content: 'test content')
  end

  test 'should be valid' do
    assert @article.valid?
  end

  test 'comments_count should increment after creating comment' do
    @article.save
    comments_before = @article.comments_count
    @article.comments.create(author: 'tester', content: 'testing content')
    comments_after = @article.comments_count
    assert comments_after == comments_before + 1
  end

  test 'comments_count should decrement adter deleting comment' do
    @article.save
    @comment = @article.comments.new(author: 'tester', content: 'testing content')
    @comment.save
    comments_before = @article.comments_count
    @comment.destroy
    comments_after = @article.comments_count
    assert comments_after == comments_before - 1
  end
end
