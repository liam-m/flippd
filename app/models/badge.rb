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
      [1, 5, 10].each do |required_value|
        badge_name = required_value == 1 ? 'Completed 1 Quiz' : "Completed #{required_value} Quizzes"
        Badge.create(:name => badge_name,
                     :image => 'badge.png',
                     :requirement => "quizzes_complete",
                     :required_value => required_value)

        badge_name = required_value == 1 ? 'Left 1 Comment' : "Left #{required_value} Comments"
        Badge.create(:name => badge_name,
                     :image => 'badge.png',
                     :requirement => "comments_left",
                     :required_value => required_value)
      end
    end
  end
end
