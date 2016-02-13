class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session
  
  # 必須パラメータが空の場合の例外処理
  rescue_from ActionController::ParameterMissing do
    render :nothing => true, :status => 400
  end
end
