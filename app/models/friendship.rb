class Friendship < ActiveRecord::Base

  belongs_to :user
  belongs_to :friend, :class_name => "User", :foreign_key => "friend_id"

  scope :pending, -> { where(:status => "pending") }
  scope :confirmed, -> { where(:status => "confirmed") }
  scope :ignored, -> { where(:status => "ignored") }

end
