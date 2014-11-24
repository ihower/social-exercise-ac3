require 'rails_helper'

RSpec.describe "API_V1::Auth", :type => :request do

  example "valid facebook login and logout" do

    expect(User).to receive(:verify_facebook_token).with("abc").and_return( { "id" => 123, "name" => "ihower", "email" => "ihower@gmail.com"} )

    post "/api/v1/login", :access_token => "abc"

    expect(response).to have_http_status(200)

    user = User.last
    expect(response.body).to eq(
      {
        :message => "Ok",
        :auth_token => user.token,
        :user_id => user.id
      }.to_json
    )


    post "/api/v1/logout"
    expect(response).to have_http_status(401)

    post "/api/v1/logout", :auth_token => user.token
    expect(response).to have_http_status(200)
    expect(User.last.token).not_to eq(user.token)
  end

  example "invalid facebook token login" do
    expect(User).to receive(:verify_facebook_token).with("abc").and_return(nil)

    post "/api/v1/login", :access_token => "abc"

    expect(response).to have_http_status(401)
    expect(response.body).to eq(
      { :message => "Failed" }.to_json
    )
  end

end