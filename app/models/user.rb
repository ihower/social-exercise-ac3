class User < ActiveRecord::Base

  def self.from_omniauth(auth_hash)
    user = where( :fb_uid => auth_hash[:uid] ).first_or_initialize
    user.name = auth_hash[:info][:name]
    user.email = auth_hash[:info][:email]
    user.fb_token = auth_hash[:credentials][:token]
    user.fb_expires_at = Time.at(auth_hash[:credentials][:expires_at])
    user.save!
    user
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
