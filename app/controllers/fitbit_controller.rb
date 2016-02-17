require "base64"

class FitbitController < ApplicationController
  before_action :initialize_token
  
  def index
  end

  def show
    render json: @token.get_today_step
  end
  
  private
  def initialize_token
    @token = Token.find(1)
  end
end
