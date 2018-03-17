class SessionsController < ApplicationController
  def create
    @response = Faraday.post("https://github.com/login/oauth/access_token?client_id=ced91a734f069690a7c1&client_secret=aba39568b8f899206737e9e02f098453137eb230&code=#{params["code"]}")
    token = @response.body.split(/\W+/)[1]

    oauth_response = Faraday.get("https://api.github.com/user?access_token=#{token}")
    auth = JSON.parse(oauth_response.body)

    user = User.find_or_create_by(uid: auth["id"])
    user.username = auth["login"]
    user.uid = auth["id"]
    user.token = token
    user.save

    session[:user_id] = user.id
    redirect_to dashboard_index_path
  end
end
