class Question < ActiveRecord::Base
  include PublicActivity::Common

  is_impressionable
  acts_as_votable
  acts_as_taggable

  validates_presence_of :title, :body

  attr_accessible :user_id, :title, :body, :active, :tag_list

  belongs_to :user
  has_many :solutions

  scope :active, -> { where(active: true).order('questions.created_at DESC') }
  scope :by_user, -> (user) { where('questions.user_id = ?', user.id) }

  def rating
    self.upvotes.length - self.downvotes.length
  end

end
