class User
  include DataMapper::Resource

  property :id, Serial
  property :name, String, required: true, length: 150
  property :email, String, required: true, length: 150
  property :image, String, required: true, length: 150

  # Gamification Records
  property :xp, Integer, :default => 0
  property :level, Integer, :default => 1
  property :level_progress, Integer, :default => 0
  property :quizzes_completed, Integer, :default => 0
  property :comments_left, Integer, :default => 0
  has n, :badges, :through => Resource

  ## An instance method to perform required calculations for leveling up.
  def update_level
    self.update(:level_progress => (:level * 100 - :xp))
    if :level_progress > 100
      self.update(:level => (:level + 1))
      self.update_level
    end
  end

  ## Increments the number of quizzes completed, and checks for earned badges.
  def increment_quizzes
    self.update(:quizzes_completed => (:quizzes_completed + 1))
    if :quizzes_completed == 1
      badge = Badge.get(:name => 'Completed 1 Quiz')
    elsif :quizzes_completed == 5
      badge = Badge.get(:name => 'Completed 5 Quizzes')
    elsif :quizzes_completed == 10
      badge = Badge.get(:name => 'Completed 10 Quizzes')
    end
    if badge
      :badges << badge
    end
  end

  ## Increments the number of comments left, and checks for earned badges.
  def increment_comments
    self.update(:comments_left => (:comments_left + 1))
    if :comments_left == 1
      badge = Badge.get(:name => 'Left 1 Comment')
    elsif :comments_left == 5
      badge = Badge.get(:name => 'Left 5 Comments')
    elsif :comments_left == 10
      badge = Badge.get(:name => 'Left 10 Comments')
    end
    if badge
      :badges << badge
    end
  end

  def earn_xp(xp_earned)
    self.update(:xp => (:xp + xp_earned))
    self.update_level
  end
end

