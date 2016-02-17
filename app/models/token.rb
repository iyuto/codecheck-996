class Token < ActiveRecord::Base
	after_initialize :set_token
	
	# def get_summary
	# 	# 概要を取得
	# 	begin
	# 		response = @access_token.get("https://api.fitbit.com/1/user/-/activities/date/" + Time.now.strftime("%Y-%m-%d") + ".json")
  #     data = JSON.parse(response.body)
  #     return data
  #   rescue
  #     return $!
  #   end
	# end
	
	# Fitbitバンドの情報
	def get_devices_info
		begin
			response = @access_token.get("https://api.fitbit.com/1/user/-/devices.json")
      data = JSON.parse(response.body)
      return data
    rescue
      return $!
    end
	end
	
	# 歩数データ
	def get_today_step
    begin
      response = @access_token.get("https://api.fitbit.com/1/user/-/activities/steps/date/today/1d/15min.json")
      data = JSON.parse(response.body)
      return data
    rescue
      return $!
    end
	end
	
	# 睡眠データ
	def get_today_sleep
    begin
			response = @access_token.get("https://api.fitbit.com/1/user/-/sleep/date/today.json")
      data = JSON.parse(response.body)
      return data
    rescue
      return $!
    end
	end
	
	private
	## Fitbit APIのアクセストークンを設定
	def set_token
		# Fitbit APIのクライアントキーを環境変数から取得
		client_id = ENV["FITBIT_CLIENT_ID"]
    client_key = ENV["FITBIT_CLIENT_KEY"]
    client_secret = ENV["FITBIT_CLIENT_SECRET"]
		
    # OAuth2のクライアントを設定
    client = OAuth2::Client.new(client_id, client_secret, site: "https://api.fitbit.com", token_url: "https://api.fitbit.com/oauth2/token", raise_errors: false)
    bearer_token = "#{client_id}:#{client_secret}"
    encoded_bearer_token = Base64.strict_encode64(bearer_token)
    
		# APIのアクセストークンを設定
    @access_token = OAuth2::AccessToken.new(client, self.access_token, {refresh_token: self.refresh_token, expires_at: self.expire_time})
    
    # トークンの有効期限が切れていた場合
    if @access_token.expired?
      @access_token = @access_token.refresh!(:headers => {'Authorization' => "Basic #{encoded_bearer_token}"})
    
      # DBを更新
      self.update(access_token: @access_token.token, refresh_token: @access_token.refresh_token, expire_time: @access_token.expires_at)
    
      puts "token has been refreshed."
    end
	end
end
