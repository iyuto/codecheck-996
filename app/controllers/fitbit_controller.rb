require "base64"

class FitbitController < ApplicationController
  before_action :authorize_fitbit
  
  def index
  end

  def show
    ##歩数データ
    #1日の歩数をFitbitAPIから取得
    begin
      response = @access_token.get("https://api.fitbit.com/1/user/-/activities/steps/date/today/1d/15min.json")
      data = JSON.parse(response.body)
      render json: data
    rescue
      render text: $!
    end
  end
  
  private
  def authorize_fitbit
    client_id = ENV["FITBIT_CLIENT_ID"]
    client_key = ENV["FITBIT_CLIENT_KEY"]
    client_secret = ENV["FITBIT_CLIENT_SECRET"]
    token = Token.find(1)
    
    #Fitbit API OAuth2
    client = OAuth2::Client.new(client_id, client_secret, site: "https://api.fitbit.com", token_url: "https://api.fitbit.com/oauth2/token", raise_errors: false)
    bearer_token = "#{client_id}:#{client_secret}"
    encoded_bearer_token = Base64.strict_encode64(bearer_token)
    
    @access_token = OAuth2::AccessToken.new(client, token.access_token, {refresh_token: token.refresh_token, expires_at: token.expire_time})
    
    # トークンの有効期限が切れていた場合
    if @access_token.expired?
      @access_token = @access_token.refresh!(:headers => {'Authorization' => "Basic #{encoded_bearer_token}"})
      
      # DBを更新
      token = Token.find(1)
      token.update(access_token: @access_token.token, refresh_token: @access_token.refresh_token, expire_time: @access_token.expires_at)
      
      puts "token has been refreshed."
    end
  end
end
