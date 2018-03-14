require 'rubygems'
require 'watir'
require 'time'
require 'timeout'
require 'net/https'
require 'uri'
require 'Win32API'
require "selenium-webdriver"
#require 'auto_click'
#require 'win32/sound'
require 'open3'
require 'telegram/bot'
require_relative  'KrChartDTO.rb'
#include Win32
#require_relative './CoinDto.rb'
Selenium::WebDriver::Chrome.driver_path = File.join(File.absolute_path('./', "C:/Ruby24-x64/bin/chromedriver.exe"))    

class AutoBit_AI_Signal
  
  attr_accessor :server, :loginId, :loginPw, :watir , :bandloop_Cnt , :exceptionCnt , :data , :targetingCoin , :beforeArray  , :nowArray , :beforeTranValue , :nowTranValue  
  attr_accessor :krChartDTO_3Minute , :krChartDTO_30Minute ,:krChartDTO_1Hour ,:krChartDTO_4hour , :krChartDTO_8hour , :krChartDTO_before_3Minute ,:krChartDTO_before_30Minute ,:krChartDTO_before_1Hour ,:krChartDTO_before_4hour , :krChartDTO_before_8hour
  attr_accessor :interVal_1 , :interVal_2 , :interVal_3 , :interVal_4
  attr_accessor :turnSignal  , :turnSignal_MA

  def initialize(loginId,loginPw)
    
    #puts "Current Time : " + time1.inspect
    @loginId = loginId
    @loginPw = loginPw
    @server = 'https://kr.tradingview.com/'
    @watir = Watir::Browser.new :chrome   #:firefox
    @watir.goto "#{@server}"
    @bandloop_Cnt = 0
    @exceptionCnt = 0
    
    #@watir.window.resize_to(600, 700)
    @watir.window.maximize
    sleep(2)
    @beforeArray = {} 
    @nowArray = {}
    @beforeTranValue = {}
    @nowTranValue = {}
    @krChartDTO_before_3Minute = KrChartDTO.new
    @krChartDTO_3Minute = KrChartDTO.new
    @krChartDTO_before_30Minute = KrChartDTO.new
    @krChartDTO_30Minute = KrChartDTO.new
    @krChartDTO_before_1Hour = KrChartDTO.new
    @krChartDTO_1Hour = KrChartDTO.new
    @krChartDTO_before_4hour = KrChartDTO.new
    @krChartDTO_4hour = KrChartDTO.new
    @interVal_1 = 30# 1분   -> 3분
    @interVal_2 = 60 # 3분   -> 30분
    @interVal_3 = 240 # 30분 -> 1시간 
    @interVal_4 = 480 # 60분  -> 4시간 
    @interVal_5 = 720 # 60분  -> 4시간
    @turnSignal = -1     # sell 0 buy 1
    @turnSignal_MA = -1 # 이평선 정배열 역배열 문자쏴주기
    
    
      
    puts "initialize setting!"
    #puts '[' +"#{@bandList_Array}".length.to_s   + ']' 
  end

  
    #TOKEN = 'your bot token'
    #id = 'your chat id group or individual'
    #bot = Telegram::Bot::Client.new(TOKEN)
    #bot.api.send_message(chat_id: id, text: "hello world")
    #
    #to send a message without use Telegram::Bot::Client.run(token) do |bot|
    #bot.api.send_message(chat_id: user.chat_id, text: 'Hello, world')
    #end
    
    # telegram api token ->  474059759:AAFM24fbUFVyEhFN6bCszocGgdUqWyJqbxA
    # "https://api.telegram.org/botXXX:YYYY/sendMessage" -d "chat_id=-zzzzzzzzzz&text=my sample text"
    #{"ok":true,"result":[{"update_id":888815941,
    #"message":{"message_id":59,"from":{"id":323422607,"is_bot":false,"first_name":"\uc7ac\ud604","last_name":"\uc591","language_code":"ko"},"chat":{"id":323422607,"first_name":"\uc7ac\ud604","last_name":"\uc591","type":"private"},"date":1519368425,"text":"/start","entities":[{"offset":0,"length":6,"type":"bot_command"}]}}]}
    # https://api.telegram.org/bot474059759:AAFM24fbUFVyEhFN6bCszocGgdUqWyJqbxA/sendmessage?chat_id=323422607&text=good
    # {"ok":true,"result":{"message_id":3,"chat":{"id":-1001364815243,"title":"AutoBit_AI_Signal","username":"AutoBit_AISignal","type":"channel"},"date":1519370562,"text":"good"}}
    # My Auto Token Id : 474059759:AAFM24fbUFVyEhFN6bCszocGgdUqWyJqbxA
  
  def telegramLogin
       begin
       #474059759:AAFM24fbUFVyEhFN6bCszocGgdUqWyJqbxA  => token  id => 323422607
       # https://api.telegram.org/bot474059759:AAFM24fbUFVyEhFN6bCszocGgdUqWyJqbxA/sendmessage?chat_id=323422607&text=good =>나한테 문자보내기
       # http://www.convertstring.com/ko/EncodeDecode/UrlEncode 인코딩 주소  hihi %0d%0a Thanks %0d%0a ok   || %0d%0a 코드가 엔터코드
       @watir.execute_script('window.open("https://web.telegram.org/#/login")')
       sleep(1)
       @watir.windows.last.use
       @watir.window(:title => "Telegram Web").use do
         sleep(10)
       @watir.text_field(:name=>'phone_number').value = "01020813240"
       sleep(1)
       @watir.a(:class ,%w(login_head_submit_btn)).click
       @watir.button(:class ,%w(btn btn-md btn-md-primary)).click
       sleep(30)
       
       @watir.goto "https://web.telegram.org/#/im?p=u468788851_5906293482892282881"
       end 
       sleep(3)
       
       @watir.div(:class ,'composer_rich_textarea').send_keys [:control, '사랑해']
       @watir.send_keys 'Test Message Auto Api' # '1D'
       @watir.send_keys :enter
       
       @watir.windows.first.use
       
       puts "telegramLogin Success"
       return "telegramLogin Success"
       rescue 
       puts "telegramLogin Fail"
       return "telegramLogin Fail"
       end
   end
  
  

  def krChartLogin
      begin
       puts 'krChartLogin Start'
      @watir.a(:class ,%w(tv-header__link tv-header__link--signin js-header__signin)).click
      @watir.text_field(:name=>'username').value = "#{@loginId}"
      @watir.text_field(:name=>'password').value = "#{@loginPw}"
      #@watir.span(:class ,'tv-button__loader').click
      @watir.button(:class ,%w(tv-button tv-button--no-border-radius tv-button--size_large tv-button--primary_ghost tv-button--loader)).click
      sleep(3)
      @watir.element(:href => '/chart/').hover
      sleep(1)
      @watir.a(:href ,  '/chart/a2YIRud0/').click
       sleep(5)
      puts "krChartLogin Success"
      return "krChartLogin Success"
      rescue 
      puts "krChartLogin Fail"
      return "krChartLogin Fail"
      end
  end


  def chartPageLoading
      begin
        while true
          sleep(1) 
          puts 'chartPageLoading...'
          break if @watir.span(:class , 'chart-controls-clock').exists? == true
        end
        
      rescue 
           puts "chartPageLoading Loading Fail..."
           self.chartPageLoading
      end   
    end  
  
    
  def getChartTimeStamp
       begin
         # puts '현재시간 :'+time.hour().to_s+':'+time.min().to_s+':'+time.sec().to_s
         
         
         
         timeSecond = Time.now.strftime("%S").to_s
         timeMinute = Time.now.strftime("%M").to_s
         timeHour = Time.now.strftime("%H").to_s
         
         if ( timeSecond == "40" )
              @watir.refresh
         end
         
          
          if( (timeSecond == "58" && timeMinute == "59" && timeHour == "23" ) ||  (timeSecond == "58" && timeMinute == "59" && timeHour == "07" ) ||  (timeSecond == "58" && timeMinute == "59" && timeHour == "15" )  )
               return "8hourEnd"
          elsif( (timeSecond == "58" && timeMinute == "59" && timeHour == "23" ) ||  (timeSecond == "58" && timeMinute == "59" && timeHour == "03" ) ||  (timeSecond == "58" && timeMinute == "59" && timeHour == "07" ) ||  (timeSecond == "58" && timeMinute == "59" && timeHour == "11" ) ||  (timeSecond == "58" && timeMinute == "59" && timeHour == "15" ) ||  (timeSecond == "58" && timeMinute == "59" && timeHour == "19" )  )
               return "4hourEnd"  
           elsif( timeSecond == "58"  && timeMinute == "59"   )
               return "1hourEnd" 
          elsif( (timeSecond == "58" && timeMinute == "59") ||  (timeSecond == "58" && timeMinute == "29")  )
            return "30minuteEnd"
          elsif( (timeSecond == "58" && timeMinute == "15") ||  (timeSecond == "58" && timeMinute == "29") ||  (timeSecond == "58" && timeMinute == "44")  ||  (timeSecond == "58" && timeMinute == "59")  ) 
            return "15minuteEnd"
          elsif  ( (timeSecond == "58" && timeMinute == "02") ||  (timeSecond == "58" && timeMinute == "05") ||  (timeSecond == "58" && timeMinute == "08")  ||  (timeSecond == "58" && timeMinute == "11")  ||  (timeSecond == "58" && timeMinute == "14")  ||  (timeSecond == "58" && timeMinute == "17")  ||  (timeSecond == "58" && timeMinute == "20")   ||  (timeSecond == "58" && timeMinute == "23")  ||  (timeSecond == "58" && timeMinute == "26")  ||  (timeSecond == "58" && timeMinute == "29")  ||  (timeSecond == "58" && timeMinute == "32") ||  (timeSecond == "58" && timeMinute == "35") ||  (timeSecond == "58" && timeMinute == "38") ||  (timeSecond == "58" && timeMinute == "41") ||  (timeSecond == "58" && timeMinute == "44") ||  (timeSecond == "58" && timeMinute == "47") ||  (timeSecond == "58" && timeMinute == "50") ||  (timeSecond == "58" && timeMinute == "53") ||  (timeSecond == "58" && timeMinute == "56")  ||  (timeSecond == "58" && timeMinute == "59")      )
            return "3minuteEnd"
          elsif  ( timeSecond == "58"  )
            return "1minuteEnd"
           else
            return "StandByTime"    
          end 
       rescue 
            puts "getChartTimeStamp Loading Fail..."
            self.getChartTimeStamp
       end   
     end  
  
    
  def refleshIsOK
    begin
                 
      puts "refleshIsOK...."
      return "refleshIsOK"
    rescue 
      #errorCnt =  errorCnt  + 1
      puts "refleshIsFail..."
      self.refleshIsOK
    end   
  end
    
 def movingAverageStatus(indexValue)
    ##작성중
    begin
      puts 'movingAverageStatus Start'
       sleep(5)
       krChartDTO = KrChartDTO.new
       krChartDTO = krChartDataGetting(indexValue)
       
       
       
       
       nowMovingAverageValue = { "MA5"=>  krChartDTO.get_movingAverage_5().to_f  , "MA20" =>  krChartDTO.get_movingAverage_20().to_f  , "MA60" => krChartDTO.get_movingAverage_60().to_f  , "MA120" =>krChartDTO.get_movingAverage_120().to_f  ,"MA240"  =>  krChartDTO.get_movingAverage_240().to_f  }
       nMvAvgSrtVal = {}  ## nowMovingAverageSortASCValue 
           
       movingAvergaeRank = {}
       countValue = 0    
       nowMovingAverageValue.sort_by {|k,v| v}.reverse.each do |key, value|
             countValue = countValue + 1
             movingAvergaeRank[key] = countValue
             nMvAvgSrtVal[key] = value.to_s
       end
       
       puts 'nowMovingAverageValue'
       puts nowMovingAverageValue
       puts 'movingAvergaeRank...'  
       puts  movingAvergaeRank
       puts 'nMvAvgSrtVal'
       puts nMvAvgSrtVal
       
        puts  movingAvergaeRank["MA5"] == 1 && movingAvergaeRank["MA20"] == 2 && movingAvergaeRank["MA60"] == 3 && movingAvergaeRank["MA120"] == 4  && movingAvergaeRank["MA240"] == 5 #정배열
        puts  movingAvergaeRank["MA5"] == 5 && movingAvergaeRank["MA20"] == 4 && movingAvergaeRank["MA60"] == 3 && movingAvergaeRank["MA120"] == 2  && movingAvergaeRank["MA240"] == 1 #역배열
     
        text = ""
        nowMovingAverageValue.sort_by {|k,v| v}.reverse.each do |key, value|
                text+= key +' : $ '+ value.to_s + '%0d%0a'
        end
        
        puts text
         
         if  (    movingAvergaeRank["MA5"] == 5 && movingAvergaeRank["MA20"] == 4 && movingAvergaeRank["MA60"] == 3 && movingAvergaeRank["MA120"] == 2  && movingAvergaeRank["MA240"] == 1  ) 
             # 역배열상태   0
                if   ( @turnSignal_MA  != 0)     
                        uri = URI('https://api.telegram.org/bot474059759:AAFM24fbUFVyEhFN6bCszocGgdUqWyJqbxA/sendmessage?chat_id=-1001364815243&text=(BITFINEX '+indexValue.to_s+'Minute  MovingAverage Status)%0d%0aBest Down Signal!! Sad%0d%0a'+text.to_s+'')
                        Net::HTTP.get(uri)
                end
                @turnSignal_MA = 0
                puts 'BEST_DOWN'
                return "BEST_DOWN"
           elsif (  movingAvergaeRank["MA5"] == 1 && movingAvergaeRank["MA20"] == 2 && movingAvergaeRank["MA60"] == 3 && movingAvergaeRank["MA120"] == 4  && movingAvergaeRank["MA240"] == 5  )
              #정배열 상태   1
                 if   ( @turnSignal_MA  != 1)
                       uri = URI('https://api.telegram.org/bot474059759:AAFM24fbUFVyEhFN6bCszocGgdUqWyJqbxA/sendmessage?chat_id=-1001364815243&text=(BITFINEX '+indexValue.to_s+'Minute MovingAverage Status)%0d%0aBest Up Signal!! Happy%0d%0a'+text.to_s+'')
                       Net::HTTP.get(uri)
                 end      
                @turnSignal_MA =  1
                 puts 'BEST_UP'
                 return "BEST_UP"
                 
           else
              if  (indexValue == 480 )
                      # 현황 브리핑 
                       uri = URI('https://api.telegram.org/bot474059759:AAFM24fbUFVyEhFN6bCszocGgdUqWyJqbxA/sendmessage?chat_id=-1001364815243&text=(BITFINEX 8hour MovingAverage Status)%0d%0a'+text.to_s+'')
                       Net::HTTP.get(uri) 
                       puts 'NA'
                       return "NA"
               end
        end    
       
         
         
        rescue
            puts "MovingAverageStatus Fail..."
            self.movingAverageStatus
    end
   
 end   
  
 def krChartDataGettingInit
   begin
      
       
      @watir.divs(:class ,%w(js-button-text text-1sK7vbvh-))[0].click  # 3분 차트
      chartPageLoading
      sleep(3)
      chartData_Array = @watir.spans(:class => %w(pane-legend-item-value pane-legend-line) ).collect(&:text)
      # 데이터 확인용 #  
       count = 0
       chartData_Array.each do |textValue|
           count = count + 1
          puts textValue+'['+count.to_s+']'
       end
      #End 
        #  :krChartDTO_before_3Minute ,:krChartDTO_before_30Minute ,:krChartDTO_before_1Hour ,:krChartDTO_before_4hour
       
      @krChartDTO_before_3Minute.set_initValue(chartData_Array[0])
      @krChartDTO_before_3Minute.set_highValue(chartData_Array[1]);
      @krChartDTO_before_3Minute.set_lowValue(chartData_Array[2]);
      @krChartDTO_before_3Minute.set_lastValue(chartData_Array[3]);
      @krChartDTO_before_3Minute.set_bollangerCenterValue(chartData_Array[11]);
      @krChartDTO_before_3Minute.set_bollangerHightValue(chartData_Array[12]);
      @krChartDTO_before_3Minute.set_movingAverage_5(chartData_Array[6]);
      @krChartDTO_before_3Minute.set_movingAverage_20(chartData_Array[7]);
      @krChartDTO_before_3Minute.set_movingAverage_60(chartData_Array[8]);
      @krChartDTO_before_3Minute.set_movingAverage_120(chartData_Array[9]);
      @krChartDTO_before_3Minute.set_movingAverage_240(chartData_Array[10]);
      @krChartDTO_before_3Minute.set_stoch_5K3Day_BlueValue(chartData_Array[14]);
      @krChartDTO_before_3Minute.set_stoch_5K3Day_RedValue(chartData_Array[15]);
      @krChartDTO_before_3Minute.set_stoch_12K3Day_BlueValue(chartData_Array[16]);
      @krChartDTO_before_3Minute.set_stoch_12K3Day_RedValue(chartData_Array[17]);
      @krChartDTO_before_3Minute.set_stoch_12K9Day_BlueValue(chartData_Array[18]);
      @krChartDTO_before_3Minute.set_stoch_12K9Day_RedValue(chartData_Array[19]);
      @krChartDTO_before_3Minute.set_stoch_20K12Day_BlueValue(chartData_Array[20]);
      @krChartDTO_before_3Minute.set_stoch_20K12Day_RedValue(chartData_Array[21]);
      
      
      @watir.divs(:class ,%w(js-button-text text-1sK7vbvh-))[1].click  # 30분 차트
      chartPageLoading
      sleep(3)
      chartData_Array = @watir.spans(:class => %w(pane-legend-item-value pane-legend-line) ).collect(&:text)
      # 데이터 확인용 #  
       count = 0
       chartData_Array.each do |textValue|
           count = count + 1
          puts textValue+'['+count.to_s+']'
       end
       
     @krChartDTO_before_30Minute.set_initValue(chartData_Array[0])
     @krChartDTO_before_30Minute.set_highValue(chartData_Array[1]);
     @krChartDTO_before_30Minute.set_lowValue(chartData_Array[2]);
     @krChartDTO_before_30Minute.set_lastValue(chartData_Array[3]);
     @krChartDTO_before_30Minute.set_bollangerCenterValue(chartData_Array[11]);
     @krChartDTO_before_30Minute .set_bollangerHightValue(chartData_Array[12]);
     @krChartDTO_before_30Minute.set_movingAverage_5(chartData_Array[6]);
     @krChartDTO_before_30Minute.set_movingAverage_20(chartData_Array[7]);
     @krChartDTO_before_30Minute.set_movingAverage_60(chartData_Array[8]);
     @krChartDTO_before_30Minute.set_movingAverage_120(chartData_Array[9]);
     @krChartDTO_before_30Minute.set_movingAverage_240(chartData_Array[10]);
     @krChartDTO_before_30Minute.set_stoch_5K3Day_BlueValue(chartData_Array[14]);
     @krChartDTO_before_30Minute.set_stoch_5K3Day_RedValue(chartData_Array[15]);
     @krChartDTO_before_30Minute.set_stoch_12K3Day_BlueValue(chartData_Array[16]);
     @krChartDTO_before_30Minute.set_stoch_12K3Day_RedValue(chartData_Array[17]);
     @krChartDTO_before_30Minute.set_stoch_12K9Day_BlueValue(chartData_Array[18]);
     @krChartDTO_before_30Minute.set_stoch_12K9Day_RedValue(chartData_Array[19]);
     @krChartDTO_before_30Minute.set_stoch_20K12Day_BlueValue(chartData_Array[20]);
     @krChartDTO_before_30Minute.set_stoch_20K12Day_RedValue(chartData_Array[21]);
     
     @watir.divs(:class ,%w(js-button-text text-1sK7vbvh-))[2].click  # 1시간 차트
      chartPageLoading
      sleep(3)
      chartData_Array = @watir.spans(:class => %w(pane-legend-item-value pane-legend-line) ).collect(&:text)
      # 데이터 확인용 #  
       count = 0
       chartData_Array.each do |textValue|
           count = count + 1
          puts textValue+'['+count.to_s+']'
       end
     @krChartDTO_before_1Hour.set_initValue(chartData_Array[0])
     @krChartDTO_before_1Hour.set_highValue(chartData_Array[1]);
     @krChartDTO_before_1Hour.set_lowValue(chartData_Array[2]);
     @krChartDTO_before_1Hour.set_lastValue(chartData_Array[3]);
     @krChartDTO_before_1Hour.set_bollangerCenterValue(chartData_Array[11]);
     @krChartDTO_before_1Hour.set_bollangerHightValue(chartData_Array[12]);
     @krChartDTO_before_1Hour.set_movingAverage_5(chartData_Array[6]);
     @krChartDTO_before_1Hour.set_movingAverage_20(chartData_Array[7]);
     @krChartDTO_before_1Hour.set_movingAverage_60(chartData_Array[8]);
     @krChartDTO_before_1Hour.set_movingAverage_120(chartData_Array[9]);
     @krChartDTO_before_1Hour.set_movingAverage_240(chartData_Array[10]);
     @krChartDTO_before_1Hour.set_stoch_5K3Day_BlueValue(chartData_Array[14]);
     @krChartDTO_before_1Hour.set_stoch_5K3Day_RedValue(chartData_Array[15]);
     @krChartDTO_before_1Hour.set_stoch_12K3Day_BlueValue(chartData_Array[16]);
     @krChartDTO_before_1Hour.set_stoch_12K3Day_RedValue(chartData_Array[17]);
     @krChartDTO_before_1Hour.set_stoch_12K9Day_BlueValue(chartData_Array[18]);
     @krChartDTO_before_1Hour.set_stoch_12K9Day_RedValue(chartData_Array[19]);
     @krChartDTO_before_1Hour.set_stoch_20K12Day_BlueValue(chartData_Array[20]);
     @krChartDTO_before_1Hour.set_stoch_20K12Day_RedValue(chartData_Array[21]);
      
     
     @watir.divs(:class ,%w(js-button-text text-1sK7vbvh-))[3].click  # 4시간 차트
      chartPageLoading
      sleep(3)
      chartData_Array = @watir.spans(:class => %w(pane-legend-item-value pane-legend-line) ).collect(&:text)
      # 데이터 확인용 #  
       count = 0
       chartData_Array.each do |textValue|
           count = count + 1
          puts textValue+'['+count.to_s+']'
       end
     @krChartDTO_before_4Hour.set_initValue(chartData_Array[0])
     @krChartDTO_before_4Hour.set_highValue(chartData_Array[1]);
     @krChartDTO_before_4Hour.set_lowValue(chartData_Array[2]);
     @krChartDTO_before_4Hour.set_lastValue(chartData_Array[3]);
     @krChartDTO_before_4Hour.set_bollangerCenterValue(chartData_Array[11]);
     @krChartDTO_before_4Hour.set_bollangerHightValue(chartData_Array[12]);
     @krChartDTO_before_4Hour.set_movingAverage_5(chartData_Array[6]);
     @krChartDTO_before_4Hour.set_movingAverage_20(chartData_Array[7]);
     @krChartDTO_before_4Hour.set_movingAverage_60(chartData_Array[8]);
     @krChartDTO_before_4Hour.set_movingAverage_120(chartData_Array[9]);
     @krChartDTO_before_4Hour.set_movingAverage_240(chartData_Array[10]);
     @krChartDTO_before_4Hour.set_stoch_5K3Day_RedValue(chartData_Array[14]);
     @krChartDTO_before_4Hour.set_stoch_5K3Day_BlueValue(chartData_Array[15]);
     @krChartDTO_before_4Hour.set_stoch_12K3Day_RedValue(chartData_Array[16]);
     @krChartDTO_before_4Hour.set_stoch_12K3Day_BlueValue(chartData_Array[17]);
     @krChartDTO_before_4Hour.set_stoch_12K9Day_RedValue(chartData_Array[18]);
     @krChartDTO_before_4Hour.set_stoch_12K9Day_BlueValue(chartData_Array[19]);
     @krChartDTO_before_4Hour.set_stoch_20K12Day_RedValue(chartData_Array[20]);
     @krChartDTO_before_4Hour.set_stoch_20K12Day_BlueValue(chartData_Array[21]);
     
     
     
    @watir.divs(:class ,%w(js-button-text text-1sK7vbvh-))[4].click  # 8시간 차트
     chartPageLoading
     sleep(3)
     chartData_Array = @watir.spans(:class => %w(pane-legend-item-value pane-legend-line) ).collect(&:text)
     # 데이터 확인용 #  
      count = 0
      chartData_Array.each do |textValue|
          count = count + 1
         puts textValue+'['+count.to_s+']'
      end
    @krChartDTO_before_8Hour.set_initValue(chartData_Array[0])
    @krChartDTO_before_8Hour.set_highValue(chartData_Array[1]);
    @krChartDTO_before_8Hour.set_lowValue(chartData_Array[2]);
    @krChartDTO_before_8Hour.set_lastValue(chartData_Array[3]);
    @krChartDTO_before_8Hour.set_bollangerCenterValue(chartData_Array[11]);
    @krChartDTO_before_8Hour.set_bollangerHightValue(chartData_Array[12]);
    @krChartDTO_before_8Hour.set_movingAverage_5(chartData_Array[6]);
    @krChartDTO_before_8Hour.set_movingAverage_20(chartData_Array[7]);
    @krChartDTO_before_8Hour.set_movingAverage_60(chartData_Array[8]);
    @krChartDTO_before_8Hour.set_movingAverage_120(chartData_Array[9]);
    @krChartDTO_before_8Hour.set_movingAverage_240(chartData_Array[10]);
    @krChartDTO_before_8Hour.set_stoch_5K3Day_RedValue(chartData_Array[14]);
    @krChartDTO_before_8Hour.set_stoch_5K3Day_BlueValue(chartData_Array[15]);
    @krChartDTO_before_8Hour.set_stoch_12K3Day_RedValue(chartData_Array[16]);
    @krChartDTO_before_8Hour.set_stoch_12K3Day_BlueValue(chartData_Array[17]);
    @krChartDTO_before_8Hour.set_stoch_12K9Day_RedValue(chartData_Array[18]);
    @krChartDTO_before_8Hour.set_stoch_12K9Day_BlueValue(chartData_Array[19]);
    @krChartDTO_before_8Hour.set_stoch_20K12Day_RedValue(chartData_Array[20]);
    @krChartDTO_before_8Hour.set_stoch_20K12Day_BlueValue(chartData_Array[21]);
      
     
      
      
      
   rescue 
     
   end
 end  
    
  
  
 def krChartDataGetting(intervalMinute)
   begin
      puts 'intervaleMinute['+intervalMinute.to_s+']'
      if(intervalMinute == @interVal_1 )
        @watir.divs(:class ,%w(js-button-text text-1sK7vbvh-))[0].click  #  1번째 즐겨찾기  차트
      elsif(intervalMinute ==  @interVal_2 )
        @watir.divs(:class ,%w(js-button-text text-1sK7vbvh-))[1].click  # 2번째 즐겨찾기 차트
      elsif(intervalMinute ==  @interVal_3 )
        @watir.divs(:class ,%w(js-button-text text-1sK7vbvh-))[2].click  # 3번째 즐겨찾기 차트
      elsif(intervalMinute ==  @interVal_4 )
        @watir.divs(:class ,%w(js-button-text text-1sK7vbvh-))[3].click  # 4번째 즐겨찾기 차트
      elsif(intervalMinute ==  @interVal_5 )
        @watir.divs(:class ,%w(js-button-text text-1sK7vbvh-))[4].click  # 5번째 즐겨찾기 차트 
      else
        @watir.divs(:class ,%w(js-button-text text-1sK7vbvh-))[0].click  # 기본디폴트   처음 인터발로 설정
      end
      chartPageLoading  
      sleep(1)
      krChartDTO = KrChartDTO.new
      sleep(1)
      ##초기값 셋팅\
      puts '*********************************************************************************************'
      chartData_Array = @watir.spans(:class => %w(pane-legend-item-value pane-legend-line) ).collect(&:text)
      puts 'chartData_Array List Count [ '+chartData_Array.length.to_s+ ']'
      
      # 데이터 확인용 #  
      count = -1
      chartData_Array.each do |textValue|
          count = count + 1
         puts textValue+'['+count.to_s+']'
      end
      
      krChartDTO.set_initValue(chartData_Array[0])
      krChartDTO.set_highValue(chartData_Array[1]);
      krChartDTO.set_lowValue(chartData_Array[2]);
      krChartDTO.set_lastValue(chartData_Array[3]);
      krChartDTO.set_bollangerCenterValue(chartData_Array[11]);
      krChartDTO.set_bollangerHightValue(chartData_Array[12]);
      krChartDTO.set_movingAverage_5(chartData_Array[6]);
      krChartDTO.set_movingAverage_20(chartData_Array[7]);
      krChartDTO.set_movingAverage_60(chartData_Array[8]);
      krChartDTO.set_movingAverage_120(chartData_Array[9]);
      krChartDTO.set_movingAverage_240(chartData_Array[10]);
      krChartDTO.set_stoch_5K3Day_BlueValue(chartData_Array[14]);
      krChartDTO.set_stoch_5K3Day_RedValue(chartData_Array[15]);
      krChartDTO.set_stoch_12K3Day_BlueValue(chartData_Array[16]);
      krChartDTO.set_stoch_12K3Day_RedValue(chartData_Array[17]);
      krChartDTO.set_stoch_12K9Day_BlueValue(chartData_Array[18]);
      krChartDTO.set_stoch_12K9Day_RedValue(chartData_Array[19]);
      krChartDTO.set_stoch_20K12Day_BlueValue(chartData_Array[20]);
      krChartDTO.set_stoch_20K12Day_RedValue(chartData_Array[21]);
      
      return krChartDTO
     
   rescue "krChartDataGetting..."
    
   end
 end 
 
 
     
 def buyOrSell_Signal_CalCulate(interValMinute )
   begin
        
        ##단타픽
        if (  interValMinute == @interVal_1 ||    interValMinute == @interVal_2  )
              buy_stoch12k3_Signal3min_Boolean =  @krChartDTO_3Minute.get_stoch_12K3Day_RedValue().to_f <  @krChartDTO_3Minute.get_stoch_12K3Day_BlueValue().to_f
              buy_stoch12k3_Signal3min_30Down_Boolean =  @krChartDTO_3Minute.get_stoch_12K3Day_BlueValue().to_f < 30.to_f
              buy_stoch12k9_Signal3min_Boolean =  @krChartDTO_3Minute.get_stoch_12K9Day_RedValue().to_f <   @krChartDTO_3Minute.get_stoch_12K9Day_BlueValue().to_f
              buy_stoch12k9_Signal3min_30Down_Boolean =  @krChartDTO_3Minute.get_stoch_12K3Day_BlueValue().to_f < 30.to_f
              buy_stoch12k3_Signal30min_Boolean = @krChartDTO_30Minute.get_stoch_12K3Day_RedValue().to_f < @krChartDTO_30Minute.get_stoch_12K3Day_BlueValue().to_f
              buy_stoch12k3_Signal30min_30Down_Boolean = @krChartDTO_30Minute.get_stoch_12K3Day_BlueValue().to_f < 30.to_f
              buy_stoch12k9_Signal30min_Boolean = @krChartDTO_30Minute.get_stoch_12K9Day_RedValue().to_f < @krChartDTO_30Minute.get_stoch_12K9Day_BlueValue().to_f
              buy_stoch12k9_Signal30min_30Down_Boolean = @krChartDTO_30Minute.get_stoch_12K3Day_BlueValue().to_f < 30.to_f
              ## 전체적인 상승 턴 어라운드   
              buy_stoch20k12_SignalTurnSignal_Boolean = (  @krChartDTO_before_30Minute.get_stoch_before_20K12Day_RedValue().to_f  <   @krChartDTO_30Minute.get_stoch_20K12Day_BlueValue().to_f  ) &&    @krChartDTO_30Minute.get_stoch_20K12Day_BlueValue().to_f  < 30.to_f
              
              
              sell_stoch12k3_Signal3min_Boolean =  @krChartDTO_3Minute.get_stoch_12K3Day_RedValue().to_f >  @krChartDTO_3Minute.get_stoch_12K3Day_BlueValue().to_f
              sell_stoch12k3_Signal3min_Up_Boolean =  @krChartDTO_3Minute.get_stoch_12K3Day_BlueValue().to_f   > 75.to_f
              sell_stoch12k9_Signal3min_Boolean =  @krChartDTO_3Minute.get_stoch_12K9Day_RedValue().to_f >   @krChartDTO_3Minute.get_stoch_12K9Day_BlueValue().to_f
              sell_stoch12k9_Signal3min_Up_Boolean =  @krChartDTO_3Minute.get_stoch_12K3Day_BlueValue().to_f >  75.to_f
              sell_stoch12k3_Signal30min_Boolean = @krChartDTO_30Minute.get_stoch_12K3Day_RedValue().to_f > @krChartDTO_30Minute.get_stoch_12K3Day_BlueValue().to_f
              sell_stoch12k3_Signal30min_Up_Boolean = @krChartDTO_30Minute.get_stoch_12K3Day_BlueValue().to_f > 75.to_f
              sell_stoch12k9_Signal30min_Boolean = @krChartDTO_30Minute.get_stoch_12K9Day_RedValue().to_f > @krChartDTO_30Minute.get_stoch_12K9Day_BlueValue().to_f
              sell_stoch12k9_Signal30min_Up_Boolean = @krChartDTO_30Minute.get_stoch_12K3Day_BlueValue().to_f   >  75.to_f
              ## 전체적인 하락  턴 어라운드   
              sell_stoch20k12_SignalTurnSignal_Boolean =  (  @krChartDTO_before_30Minute.get_stoch_before_20K12Day_RedValue().to_f  >   @krChartDTO_30Minute.get_stoch_20K12Day_BlueValue().to_f  ) &&    @krChartDTO_30Minute.get_stoch_20K12Day_BlueValue().to_f   > 75.to_f
              ## 전체적인 하락  턴 어라운드 완벽한 열배열일땐 5 3 3  시그널 참조     
              sell_stoch5k3_SignalTurnSignal_Boolean =  @krChartDTO_before_3Minute.get_stoch_5K3Day_BlueValue().to_f  >   @krChartDTO_3Minute.get_stoch_5K3Day_BlueValue().to_f
          
             
               puts 'stoch12k3_Signal3min_Boolean'
               puts  buy_stoch12k3_Signal3min_Boolean
               puts 'stoch12k3_Signal3min_30Down_Boolean'
               puts  buy_stoch12k3_Signal3min_30Down_Boolean
               puts 'stoch12k9_Signal3min_Boolean'
               puts  buy_stoch12k9_Signal3min_Boolean
               puts 'stoch12k9_Signal3min_30Down_Boolean'
               puts  buy_stoch12k9_Signal3min_30Down_Boolean
               puts 'stoch12k3_Signal30min_Boolean'
               puts  buy_stoch12k3_Signal30min_Boolean
               puts 'stoch12k3_Signal30min_30Down_Boolean'
               puts  buy_stoch12k3_Signal30min_30Down_Boolean
               puts 'stoch12k9_Signal30min_Boolean'
               puts  buy_stoch12k9_Signal30min_Boolean
               puts 'stoch12k9_Signal30min_30Down_Boolean'
               puts  buy_stoch12k9_Signal30min_30Down_Boolean
               puts 'buy_stoch20k12_SignalTurnSignal_Boolean _Boolean '
               puts  buy_stoch20k12_SignalTurnSignal_Boolean
                 
              puts 'sell_stoch12k3_Signal3min_Boolean'
              puts  sell_stoch12k3_Signal3min_Boolean
              puts 'stoch12k3_Signal3min_30Up_Boolean'
              puts  sell_stoch12k3_Signal3min_Up_Boolean
              puts 'stoch12k9_Signal3min_Boolean'
              puts  sell_stoch12k9_Signal3min_Boolean
              puts 'stoch12k9_Signal3min_30Up_Boolean'
              puts  sell_stoch12k9_Signal3min_Up_Boolean
              puts 'stoch12k3_Signal30min_Boolean'
              puts  sell_stoch12k3_Signal30min_Boolean
              puts 'stoch12k3_Signal30min_30Up_Boolean'
              puts  sell_stoch12k3_Signal30min_Up_Boolean
              puts 'stoch12k9_Signal30min_Boolean'
              puts  sell_stoch12k9_Signal30min_Boolean
              puts 'stoch12k9_Signal30min_30Up_Boolean'
              puts  sell_stoch12k9_Signal30min_Up_Boolean
              puts 'sell_stoch20k12_SignalTurnSignal_Boolean _Boolean '
              puts  sell_stoch20k12_SignalTurnSignal_Boolean
               
               
              if (  buy_stoch12k3_Signal3min_Boolean == true  && buy_stoch12k3_Signal3min_30Down_Boolean == true &&  buy_stoch12k3_Signal30min_Boolean  == true &&buy_stoch12k3_Signal30min_30Down_Boolean == true  &&  buy_stoch20k12_SignalTurnSignal_Boolean  == true  )
                        puts 'buy'
                             if( @turnSignal  != 1 )
                                 uri = URI('https://api.telegram.org/bot474059759:AAFM24fbUFVyEhFN6bCszocGgdUqWyJqbxA/sendmessage?chat_id=-1001364815243&text=3MinuteBtc_Buy%0d%0aBuyValue=$'+@krChartDTO_3Minute.get_lastValue+'%0d%0aFirst_TargetSell=$'+@krChartDTO_30Minute.get_bollangerCenterValue()+'%0d%0aSecond_TargetSell=$'+@krChartDTO_30Minute.get_bollangerHightValue()+'')
                                 Net::HTTP.get(uri)
                             end
                             #BuyValue=$불
                             #TargetSell=$불
                             @turnSignal = 1
              elsif(  movingAverageStatus(@interVal_1) == "BEST_DOWN"  && ( @krChartDTO_3Minute.get_stoch_5K3Day_BlueValue() > 80.to_f   ||  sell_stoch5k3_SignalTurnSignal_Boolean )    )                   
                          #elsif( ( @krChartDTO_30Minute.get_stoch_12K3Day_RedValue().to_i > @krChartDTO_30Minute.get_stoch_12K3Day_BlueValue().to_i ) && ( @krChartDTO_30Minute.get_stoch_12K9Day_RedValue().to_i < @krChartDTO_30Minute.get_stoch_12K9Day_BlueValue().to_i ) || @krChartDTO_30Minute.get_stoch_12K3Day_BlueValue().to_i > 80  )
                            puts '3MinuteBtc_Full_Speed_Sell'
                            if ( @turnSignal !=0 )
                                uri = URI('https://api.telegram.org/bot474059759:AAFM24fbUFVyEhFN6bCszocGgdUqWyJqbxA/sendmessage?chat_id=-1001364815243&text=3MinuteBtc_Full_Speed_Sell%0d%0aSellValue=$'+@krChartDTO_3Minute.get_lastValue+'')
                                Net::HTTP.get(uri)
                            end
                           @turnSignal = 0
              elsif(  ( sell_stoch12k3_Signal3min_Boolean && sell_stoch12k3_Signal3min_Up_Boolean )  ||  ( sell_stoch12k9_Signal3min_Boolean && sell_stoch12k9_Signal3min_Up_Boolean )    ||  sell_stoch20k12_SignalTurnSignal_Boolean  )   
                        #elsif( ( @krChartDTO_30Minute.get_stoch_12K3Day_RedValue().to_i > @krChartDTO_30Minute.get_stoch_12K3Day_BlueValue().to_i ) && ( @krChartDTO_30Minute.get_stoch_12K9Day_RedValue().to_i < @krChartDTO_30Minute.get_stoch_12K9Day_BlueValue().to_i ) || @krChartDTO_30Minute.get_stoch_12K3Day_BlueValue().to_i > 80  )
                         puts '3MinuteBtc_First_Sell_half'
                         if ( @turnSignal !=0 )
                             uri = URI('https://api.telegram.org/bot474059759:AAFM24fbUFVyEhFN6bCszocGgdUqWyJqbxA/sendmessage?chat_id=-1001364815243&text=3MinuteBtc_First_Sell_half%0d%0aSellValue=$'+@krChartDTO_3Minute.get_lastValue+'')
                             Net::HTTP.get(uri)
                         end
                        @turnSignal = 0
              elsif(  ( sell_stoch12k3_Signal30min_Boolean && sell_stoch12k3_Signal30min_Up_Boolean ) || ( sell_stoch12k9_Signal30min_Boolean && sell_stoch12k9_Signal30min_Up_Boolean  ) || sell_stoch20k12_SignalTurnSignal_Boolean   )   
                     #elsif( ( @krChartDTO_30Minute.get_stoch_12K3Day_RedValue().to_i > @krChartDTO_30Minute.get_stoch_12K3Day_BlueValue().to_i ) && ( @krChartDTO_30Minute.get_stoch_12K9Day_RedValue().to_i < @krChartDTO_30Minute.get_stoch_12K9Day_BlueValue().to_i ) || @krChartDTO_30Minute.get_stoch_12K3Day_BlueValue().to_i > 80  )
                      puts '3MinuteBtc_Second_Sell_Full'
                      if ( @turnSignal !=0 )
                          uri = URI('https://api.telegram.org/bot474059759:AAFM24fbUFVyEhFN6bCszocGgdUqWyJqbxA/sendmessage?chat_id=-1001364815243&text=3MinuteBtc_Second_Sell_Full%0d%0aSellValue=$'+@krChartDTO_3Minute.get_lastValue+'')
                          Net::HTTP.get(uri)
                      end
                     @turnSignal = 0          
              else 
               #  uri = URI('https://api.telegram.org/bot474059759:AAFM24fbUFVyEhFN6bCszocGgdUqWyJqbxA/sendmessage?chat_id=-1001364815243&text=3MinuteBtc_StandBy')
                # Net::HTTP.get(uri)
                 puts 'StandBy Pick'
             end 
        else
            #    if ( ( krChartDTO.get_stoch_12K3Day_RedValue().to_i < krChartDTO.get_stoch_12K3Day_BlueValue().to_i ) && krChartDTO.get_stoch_12K3Day_BlueValue().to_i < 30 && ( krChartDTO.get_stoch_12K9Day_RedValue().to_i < krChartDTO.get_stoch_12K9Day_BlueValue().to_i ) && krChartDTO.get_stoch_12K9Day_BlueValue().to_i < 30 )
            #       uri = URI('https://api.telegram.org/bot474059759:AAFM24fbUFVyEhFN6bCszocGgdUqWyJqbxA/sendmessage?chat_id=-1001364815243&text=3MinuteBtc_Buy')
            #       Net::HTTP.get(uri)
            #   elsif( ( krChartDTO.get_stoch_12K3Day_RedValue().to_i > krChartDTO.get_stoch_12K3Day_BlueValue().to_i ) && ( krChartDTO.get_stoch_12K9Day_RedValue().to_i < krChartDTO.get_stoch_12K9Day_BlueValue().to_i ) || krChartDTO.get_stoch_12K3Day_BlueValue().to_i > 80  )
            #       uri = URI('https://api.telegram.org/bot474059759:AAFM24fbUFVyEhFN6bCszocGgdUqWyJqbxA/sendmessage?chat_id=-1001364815243&text=3MinuteBtc_Sell')
            #       Net::HTTP.get(uri)
            #   else 
            #      uri = URI('https://api.telegram.org/bot474059759:AAFM24fbUFVyEhFN6bCszocGgdUqWyJqbxA/sendmessage?chat_id=-1001364815243&text=3MinuteBtc_StandBy')
            #      Net::HTTP.get(uri)
            #   end
        end       
     
       if ( interValMinute == 1 )
              puts 'Data Now Instance -> Data Before Instance 3min Transfer... Start!!'
              @krChartDTO_before_3Minute =    @krChartDTO_3Minute
       elsif( interValMinute == 3 )
              puts 'Data Now Instance -> Data Before Instance 3min , 30min Transfer... Start!!'
              @krChartDTO_before_3Minute =    @krChartDTO_3Minute
              @krChartDTO_before_30Minute =    @krChartDTO_30Minute
       elsif( interValMinute == 60 )
              puts 'Data Now Instance -> Data Before Instance 3min , 30min , 60min Transfer... Start!!'
              @krChartDTO_before_3Minute =    @krChartDTO_3Minute
              @krChartDTO_before_30Minute =    @krChartDTO_30Minute
              @krChartDTO_before_1Hour =    @krChartDTO_1Hour
       elsif ( interValMinute == 240 )
              puts 'Data Now Instance -> Data Before Instance 3min , 30min , 60min , 240min  Transfer... Start!!'
               @krChartDTO_before_3Minute =    @krChartDTO_3Minute
               @krChartDTO_before_30Minute =    @krChartDTO_30Minute
               @krChartDTO_before_1Hour =    @krChartDTO_1Hour
               @krChartDTO_before_4hour =    @krChartDTO_4hour
       end 
       puts 'Data Now Instance -> Data Before Instance Transfer... End!!'
      
   rescue 
     "krChartDataGetting..."
   end
 end

  #Naver login logic 
  def loginDo
    begin
      
      krChartLogin # 차트 로그인
      krChartDataGettingInit # 차트 init 셋팅값 설정
      
      
      
     #while true
     #          puts '3minute  DataGetting Start'
     #          @krChartDTO_3Minute = krChartDataGetting(@interVal_1)
     #           puts '3minute  buyOrSell_Signal_CalCulate Start'
     #           
     #           buyOrSell_Signal_CalCulate(@interVal_1 )
     #           sleep ( 10 )
     #end
      
     # initKrChartDataSetting  ##TODO 만들어야함
      while true
        
        standByTime = ""
        timeStamp =  getChartTimeStamp
        
        if timeStamp != "StandByTime" 
           if ( timeStamp  == "1minuteEnd" )
                      puts '3minute  DataGetting Start'
                     @krChartDTO_3Minute = krChartDataGetting(@interVal_1)
                      puts '3minute  buyOrSell_Signal_CalCulate Start'
                      
                      buyOrSell_Signal_CalCulate(@interVal_1 )
             elsif (timeStamp  == "3minuteEnd")
                      puts '3minute  and 30minute -> DataGetting Start'
                     @krChartDTO_3Minute = krChartDataGetting(@interVal_1)
                     @krChartDTO_30Minute = krChartDataGetting(@interVal_2)
                      puts '30minute  buyOrSell_Signal_CalCulate Start'
                      
                      buyOrSell_Signal_CalCulate(@interVal_2)
             elsif (timeStamp  == "1hourEnd")
                     puts '3minute  30minute 1Hour -> DataGetting Start'
                     @krChartDTO_3Minute = krChartDataGetting(@interVal_1)
                     @krChartDTO_30Minute = krChartDataGetting(@interVal_2)
                     @krChartDTO_1Hour =  krChartDataGetting(@interVal_3)
                     
                     puts '1Hour  buyOrSell_Signal_CalCulate Start'
                     buyOrSell_Signal_CalCulate( @interVal_3)
             elsif (timeStamp  == "4hourEnd")
                      puts '3minute  30minute 1Hour 4Hour -> DataGetting Start'
                      @krChartDTO_3Minute = krChartDataGetting(@interVal_1)
                      @krChartDTO_30Minute  = krChartDataGetting(@interVal_2)
                      @krChartDTO_1Hour =  krChartDataGetting(@interVal_3)
                      @krChartDTO_4Hour =  krChartDataGetting(@interVal_4)
                       puts '4Hour  buyOrSell_Signal_CalCulate Start'
                       buyOrSell_Signal_CalCulate( @interVal_4)
             elsif (timeStamp  == "8hourEnd")          
                      puts '3minute  30minute 1Hour 4Hour  and Status -> DataGetting Start'
                      movingAverageStatus(480)
             else 
           end
        end    
     
        
        
        
      end
      
    rescue Exception => e
      puts "loginDo Fail"
      self.loginDo  
    ensure
    end
  end

  #> require './Phone'  #! import class
  #> myphone = Phone.new  #! instantiate class Phone
  #> myphone.model = "iPhone5"  #! set model name
  #> myphone.model  #! get model name
   


end

doTask = AutoBit_AI_Signal.new('capmo1@naver.com','Dnjzm1324!') 
doTask.loginDo

# 새로운 브라우저창 컨트롤
#browser.window(:title => "annoying popup").use do
#  browser.button(:id => "close").click
#end


 ## 차트 로딩 데이터 
   #9826.4[1] 시가
   #9827.0[2] 고가
   #9583.1[3] 저가
   #9758.5[4] 종가
   #14.382K[5] 현재볼륨
   #20.303K[6] 이평선 볼륨
   #10127.3906[7] 5일선
   #10699.0977[8] 20일선
   #9230.7604[9] 60일선
   #10193.9611[10] 120일선
   #12694.8513[11] 240일선
   #[12] 볼린저밴드 중단
   #[13] 볼린저밴드 상단
   #[14] 볼린저밴드 하단
   #11.8492[15] 5 3 3 k 파란선      # 파란선이 빨간선 위에 있을때가 상승추세 
   #15.7167[16] 5 3 3 D 빨간선      # 파란선이 빨간선 아래 있으면 하락추세
   #8.0652[17] 12 3 3 k 파란선
   #14.4781[18] 12 3 3 D 빨간선
   #35.0721[19] 12 9 9 k 파란선
   #64.6244[20] 12 9 9 D 빨간선
   #58.9619[21] 20 12 12 k 파란선
   #80.7940[22] 20 12 12 D 빨간선