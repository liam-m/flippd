class Badge
  include DataMapper::Resource

  property :id, Serial
  property :name, String, required: true, length: 150
  property :image, String, required: true, length: 150
  property :requirement, String, required: true, length: 150
  property :required_value, Integer, required: true

  has n, :users, :through => Resource

  ## This would ideally be replaced with a JSON import.
  def Badge.populate
    if Badge.count == 0
      Badge.create(:name => 'Completed 1 Quiz',
                   :image => "badge.png",
                   :requirement => "quizzes_complete",
                   :required_value => 1)
      Badge.create(:name => "Completed 5 Quizzes",
                   :image => "badge.png",
                   :requirement => "quizzes_complete",
                   :required_value => 5)
      Badge.create(:name => "Completed 10 Quizzes",
                   :image => "badge.png",
                   :requirement => "quizzes_complete",
                   :required_value => 10)
      Badge.create(:name => "Left 1 Comment",
                   :image => "badge.png",
                   :requirement => "comments_left",
                   :required_value => 1)
      Badge.create(:name => "Left 5 Comments",
                   :image => "badge.png",
                   :requirement => "comments_left",
                   :required_value => 5)
      Badge.create(:name => "Left 10 Comments",
                   :image => "badge.png",
                   :requirement => "comments_left",
                   :required_value => 10)
    end
  end
end
