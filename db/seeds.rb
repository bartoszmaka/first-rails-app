# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# generate 10 users
10.times do
  User.create(
    name: FFaker::Internet.user_name,
    email: FFaker::Internet.safe_email,
    password: '123456',
    password_confirmation: '123456'
  )
end

# generate up to 11 articles for each user
User.all.each do |user|
  rand(0..11).times do
    user.articles.create(title: FFaker::CheesyLingo.title, content: FFaker::Lorem.paragraph)
  end
end

# generate up to 30 tags
30.times do
  Tag.create(name: FFaker::CheesyLingo.word)
end

# generate 3..11 comments for each article
Article.all.each do |article|
  rand(3..11).times do
    article.comments.create(content: FFaker::CheesyLingo.paragraph)
  end

  # pin 1 to 4 tags to each article
  tags = Tag.all.sample(rand(1..4)).uniq
  tags.each do |tag|
    ArticleTag.create(article_id: article.id, tag_id: tag.id)
  end
end
