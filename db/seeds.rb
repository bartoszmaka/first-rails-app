puts 'Users, Tags and Archivements'
10.times do
  FactoryGirl.create(:user)
  3.times do
    FactoryGirl.create(:tag)
    FactoryGirl.create(:archivement)
  end
end

puts 'Articles and UserArchivements'
User.find_each do |user|
  a = Archivement.order('RANDOM()').limit(rand(1..4))
  user.archivements << a
  rand(1..11).times do
    FactoryGirl.create(:article, user: user)
  end
end

puts 'ArticleTags and Comments'
Article.find_each do |article|
  t = Tag.order('RANDOM()').limit(rand(1..4))
  article.tags << t
  rand(1..11).times do
    user = User.order('RANDOM()').limit(1).first
    FactoryGirl.create(:comment, user: user, article: article)
  end
end

puts 'Votes'
User.find_each do |user|
  print '.'
  Article.order('RANDOM()').limit((Article.count * 0.7).round).each do |article|
    vote = Vote.new(user: user, votable: article)
    rand(1..3).odd? ? vote.upvote : vote.downvote
    vote.save
  end
  Comment.order('RANDOM()').limit((Comment.count * 0.6).round).each do |comment|
    vote = Vote.new(user: user, votable: comment)
    rand(1..5).odd? ? vote.upvote : vote.downvote
    vote.save
  end
end

puts "\nAvatars"
User.find_each do |user|
  if rand(1..5).odd?
    user.update_attributes(avatar: FFaker::Avatar.image)
    print '#'
  else
    print '.'
  end
end
puts "\ndone"
