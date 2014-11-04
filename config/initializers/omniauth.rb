Rails.application.config.middleware.use OmniAuth::Builder do
  config = YAML.load(File.read("#{Rails.root}/config/facebook.yml"))[Rails.env]

  provider :facebook, config["app_id"], config["secret"],
           :scope => 'email, user_photos, read_friendlists, read_stream, publish_actions'
           # https://developers.facebook.com/docs/facebook-login/permissions/v2.2

end