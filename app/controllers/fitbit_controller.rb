require "base64"

class FitbitController < ApplicationController
  before_action :initialize_token
  
  def index
  end

  def show
    data = @token.get_today_step
    category = data["activities-steps-intraday"]["dataset"].map {|item| item["time"][0,5] }
    current_quantity = data["activities-steps-intraday"]["dataset"].map {|item| item["value"]}
    steps = data["activities-steps-intraday"]["dataset"].map {|item| {y: item["value"], name: item["time"][0,5]}}
    
    # チャート生成
    @graph = LazyHighCharts::HighChart.new('graph') do |f|
      f.title(text: "歩数")
      f.xAxis(categories: category, labels: {enabled: false})
      f.yAxis(title: {text: nil}, labels: {enabled: false})
      f.series(name: "歩", data: current_quantity, type: "column")
      f.legend(enabled: false)
    end
  end
  
  private
  def initialize_token
    @token = Token.find(1)
  end
end
