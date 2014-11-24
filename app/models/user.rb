class User < ActiveRecord::Base

  has_many :friendships
  has_many :friends, ->{ where( "friendships.status" => "confirmed") }, :through => :friendships

  has_many :inverse_friendships, :class_name => "Friendship", :foreign_key => "friend_id"
  has_many :inverse_friends, ->{ where( "friendships.status" => "confirmed") }, :through => :inverse_friendships, :source => "user"

  has_many :photos

  before_validation :setup_token, :on => :create

  def all_friends
    (friends + inverse_friends).uniq
  end

  def find_friendship(user)
    friendships.where( :friend => user ).first ||
    user.friendships.where( :friend => self ).first
  end

  def is_friend?(user)
    all_friends.include?(user)
  end

  def pending_friendship?(user)
    self.friendships.pending.where( :friend => user ).exists?
  end

  def inverse_pending_friendship?(user)
    user.friendships.pending.where( :friend => self ).exists?
  end

  def ignored_friendship?(user)
    self.friendships.ignored.where( :friend => user ).exists?
  end

  def inverse_ignored_friendship?(user)
    user.friendships.ignored.where( :friend => self ).exists?
  end

  def self.from_omniauth(auth_hash)
    user = where( :fb_uid => auth_hash[:uid] ).first_or_initialize
    user.name = auth_hash[:info][:name]
    user.email = auth_hash[:info][:email]

    if auth_hash[:credentials]
      user.fb_token = auth_hash[:credentials][:token]
      user.fb_expires_at = Time.at(auth_hash[:credentials][:expires_at])
    end

    user.save!
    user
  end

  def self.verify_facebook_token(access_token)
    conn = Faraday.new(:url => 'https://graph.facebook.com/me')
    response = conn.get "/me", { :access_token => access_token }
    data = JSON.parse(response.body)

    if response.status == 200
      data
    else
      Rails.logger.warn(data)
      nil
    end
  end

  def setup_token(options={})
    self.token = Digest::SHA1.hexdigest("--#{SecureRandom.hex}--#{Time.now.to_s}--#{self.id.to_s}")[0,32]
  end

  def fb_posts
    conn = Faraday.new(:url => 'https://graph.facebook.com')
    response = conn.get "/#{self.fb_uid}/posts", { :access_token => self.fb_token }
    JSON.parse(response.body)
  end

  def fb_photos
    conn = Faraday.new(:url => 'https://graph.facebook.com')
    response = conn.get "/#{self.fb_uid}/photos", { :access_token => self.fb_token }
    JSON.parse(response.body)
  end

  def fb_posts_location
    conn = Faraday.new(:url => 'https://graph.facebook.com')
    response = conn.get "/#{self.fb_uid}/posts", { :access_token => self.fb_token, :with => "location" }
    JSON.parse(response.body)
  end

  def fb_post!(message)
    conn = Faraday.new(:url => 'https://graph.facebook.com')
    response = conn.post "/me/feed", { :message => message, :access_token => self.fb_token }
    JSON.parse(response.body)
  end

end
