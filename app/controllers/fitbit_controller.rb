require "base64"

class FitbitController < ApplicationController
  before_action :initialize_token
  
  def index
    
  end

  def show
    # Fitbitバンドのデバイス情報をAPIから取得
    api_device = @token.get_devices_info[0]
    
    p Time.parse(api_device["lastSyncTime"])
    
    # 歩数データをDBから取得
    db_step = Fitbit.find_by(name: "step")
    
    # 最後のアクセスからFitbitのデータが更新されているか
    if (db_step.last_update <=> api_device["lastSyncTime"]) != 0 then
      # APIから歩数を取得
      api_step = @token.get_today_step
      
      # DBを更新
      db_step.update(name: "step", data: api_step, last_update: Time.parse(api_device["lastSyncTime"]))
      
    else
      p "Fitbit hasn't synced since last time you access"
    end
    
    # DBから取ってきたテキストをハッシュに変換
    data = eval(db_step.data)
        
    # チャート用にJSONをパース
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
