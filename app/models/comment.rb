class Comment
  include DataMapper::Resource

  property :id, Serial
  property :timestamp, DateTime, required: true
  property :text, Text, required: true

  property :item_slug, Text, required: true
  belongs_to :user, 'User'
end
