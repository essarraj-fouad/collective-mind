class Friendship < ActiveRecord::Base
  include PublicActivity::Common

  belongs_to :user
  belongs_to :friend, class_name: 'User', foreign_key: :friend_id

  attr_accessible :friend_id
end
