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
    new_level_progress = 100 - ((self['level'] * 100) - self['xp'])
    self.update(:level_progress => new_level_progress)
    if self['level_progress'] > 99
      new_level = self['level'] + 1
      self.update(:level => new_level)
      self.update_level
    end
  end

  ## Increments the number of quizzes completed, and checks for earned badges.
  def increment_quizzes
    new_quizzes_completed = self['quizzes_completed'] + 1
    self.update(:quizzes_completed => new_quizzes_completed)
    if self['quizzes_completed'] == 1
      badge = Badge.first(:name => 'Completed 1 Quiz')
    elsif self['quizzes_completed'] == 5
      badge = Badge.first(:name => 'Completed 5 Quizzes')
    elsif self['quizzes_completed'] == 10
      badge = Badge.first(:name => 'Completed 10 Quizzes')
    end
    if badge
      self.badges << badge
      self.save
    end
  end

  ## Increments the number of comments left, and checks for earned badges.
  def increment_comments
    new_comments_left = (self['comments_left'] + 1)
    self.update(:comments_left => new_comments_left)
    if self['comments_left'] == 1
      badge = Badge.first(:name => 'Left 1 Comment')
    elsif self['comments_left'] == 5
      badge = Badge.first(:name => 'Left 5 Comments')
    elsif self['comments_left'] == 10
      badge = Badge.first(:name => 'Left 10 Comments')
    end
    if badge
      self.badges << badge
      self.save
    end
  end

  def earn_xp(xp_earned)
    new_xp = (self['xp'] + xp_earned)
    self.update(:xp => new_xp)
    self.update_level
  end
end
