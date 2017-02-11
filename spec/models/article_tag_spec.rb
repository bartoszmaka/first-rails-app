require 'rails_helper'

RSpec.describe ArticleTag, type: :model do
  before(:each) do
    @user = User.create(
      name: 'Example User',
      email: 'exampleemail@example.com',
      password: 'password',
      password_confirmation: 'password'
    )
    @tag = Tag.new(name: 'testingArticleTag')
    @article = Article.new(
      title: 'Testing',
      content: 'foobar',
      user: @user
    )
  end

  pending "add some examples to (or delete) #{__FILE__}"
end
