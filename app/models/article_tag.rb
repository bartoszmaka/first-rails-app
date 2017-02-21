class ArticleTag < ApplicationRecord
  belongs_to :article
  belongs_to :tag, counter_cache: :articles_count
  validates_uniqueness_of :tag_id, scope: :article_id
end
