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

class AutoBit_AI_Signal_Danta
  
  attr_accessor :server, :loginId, :loginPw, :watir , :bandloop_Cnt , :exceptionCnt , :data , :targetingCoin , :beforeArray  , :nowArray , :beforeTranValue , :nowTranValue  
  attr_accessor :krChartDTO_1Index , :krChartDTO_2Index ,:krChartDTO_3Index ,:krChartDTO_4Index , :krChartDTO_5Index   
  attr_accessor :krChartDTO_before_1Index ,:krChartDTO_before_2Index ,:krChartDTO_before_3Index ,:krChartDTO_before_4Index , :krChartDTO_before_5Index
  attr_accessor :interVal_1 , :interVal_2 , :interVal_3 , :interVal_4 , :interVal_5
  attr_accessor :turnSignal  , :turnSignal_MA
  attr_accessor :signalScore , :finalSignalScore #7점 이상이면 매수 \
  attr_accessor :telegramChatId
  attr_accessor :profit , :positionValue

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
    @krChartDTO_before_1Index = KrChartDTO.new
    @krChartDTO_1Index = KrChartDTO.new
    @krChartDTO_before_2Index = KrChartDTO.new
    @krChartDTO_2Index = KrChartDTO.new
    @krChartDTO_before_3Index = KrChartDTO.new
    @krChartDTO_3Index = KrChartDTO.new
    @krChartDTO_before_4Index = KrChartDTO.new
    @krChartDTO_4Index = KrChartDTO.new
    @krChartDTO_before_5Index = KrChartDTO.new
    @krChartDTO_5Index = KrChartDTO.new
    @interVal_1 = 3# 1분   -> 30분
    @interVal_2 = 15# 3분   -> 1시간
    @interVal_3 = 60 # 30분 -> 4시간 
    @interVal_4 = 960 # 60분  -> 12시간 
    @interVal_5 = 1440 #하루
    @interVal_6 = 10080 #일주일
    @turnSignal = -1     # sell 0 buy 1
    @turnSignal_MA = -1 # 이평선 정배열 역배열 문자쏴주기
    @signalScore = 0 
    @finalSignalScore = 0
    @telegramChatId  = -1001364815243  # real Id  : -1001189596297     ,    test Id  ::  -1001364815243
    @profit = 0
    @positionValue = 0
    
    krChartLogin # 차트 로그인
    puts "initialize setting end!"
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
    # {"ok":true,"result":{"message_id":3,"chat":{"id":'+@telegramChatId.to_s+',"title":"AutoBit_AI_Signal","username":"AutoBit_AISignal","type":"channel"},"date":1519370562,"text":"good"}}
    # My Auto Token Id : 474059759:AAFM24fbUFVyEhFN6bCszocGgdUqWyJqbxA
  
   # 한글을 보낼려면 parse url을 해줘야한다.
   # uri = URI.parse( URI.encode('https://api.telegram.org/bot474059759:AAFM24fbUFVyEhFN6bCszocGgdUqWyJqbxA/sendmessage?chat_id='+@telegramChatId.to_s+'&text=방가&#45397%0d%0a') )
   # Net::HTTP.get(uri)
  

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
      rescue   Exception => e
      puts e.message 
      puts "krChartLogin Fail"
      return "krChartLogin Fail"
      end
  end


  def chartPageLoading
      begin
        while true
          sleep(3) 
          puts 'chartPageLoading...Start'
          break if @watir.span(:class , 'chart-controls-clock').exists? == true
        end
        puts 'chartPageLoading..End.'
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
           if( (timeSecond == "58" && timeMinute == "02") ||  (timeSecond == "58" && timeMinute == "05") ||  (timeSecond == "58" && timeMinute == "08")  ||  (timeSecond == "58" && timeMinute == "11")  ||  (timeSecond == "58" && timeMinute == "14")  ||  (timeSecond == "58" && timeMinute == "17")  ||  (timeSecond == "58" && timeMinute == "20")   ||  (timeSecond == "58" && timeMinute == "23")  ||  (timeSecond == "58" && timeMinute == "26")  ||  (timeSecond == "58" && timeMinute == "29")  ||  (timeSecond == "58" && timeMinute == "32") ||  (timeSecond == "58" && timeMinute == "35") ||  (timeSecond == "58" && timeMinute == "38") ||  (timeSecond == "58" && timeMinute == "41") ||  (timeSecond == "58" && timeMinute == "44") ||  (timeSecond == "58" && timeMinute == "47") ||  (timeSecond == "58" && timeMinute == "50") ||  (timeSecond == "58" && timeMinute == "53") ||  (timeSecond == "58" && timeMinute == "56")  ||  (timeSecond == "58" && timeMinute == "59")     )
             return "3MIN"
           else
             return "N/A"   
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
  
  ## 숫자에 콤마 찍어주는 정규식   
  def  insert_comma(string)
        result = string.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse
        return  result 
 end
  
  
    
 def movingAverageStatus(indexValue)
    ##작성중
    begin
      puts 'movingAverageStatus Start'
       sleep(5)
       krChartDTO = KrChartDTO.new
       krChartDTO = krChartDataGetting(indexValue)
       
       
       
       
       nowMovingAverageValue = { "5일선"=>  krChartDTO.get_movingAverage_5().to_f  , "20일선" =>  krChartDTO.get_movingAverage_20().to_f  , "60일선" => krChartDTO.get_movingAverage_60().to_f  , "120일선" =>krChartDTO.get_movingAverage_120().to_f  ,"240일선"  =>  krChartDTO.get_movingAverage_240().to_f  }
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
       
        puts  movingAvergaeRank["5일선"] == 1 && movingAvergaeRank["20일선"] == 2 && movingAvergaeRank["60일선"] == 3 && movingAvergaeRank["120일선"] == 4  && movingAvergaeRank["240일선"] == 5 #정배열
        puts  movingAvergaeRank["5일선"] == 5 && movingAvergaeRank["20일선"] == 4 && movingAvergaeRank["60일선"] == 3 && movingAvergaeRank["120일선"] == 2  && movingAvergaeRank["240일선"] == 1 #역배열
     
        text = ""
        nowMovingAverageValue.sort_by {|k,v| v}.reverse.each do |key, value|
                text+= key +' : ￦'+ insert_comma(value.to_i.to_s) + '
'
        end
        
        if  (    movingAvergaeRank["MA5"] == 5 && movingAvergaeRank["MA20"] == 4 && movingAvergaeRank["MA60"] == 3 && movingAvergaeRank["MA120"] == 2  && movingAvergaeRank["MA240"] == 1  ) 
             # 역배열상태   0
                telegramSMS('Bithumb'+indexValue.to_s+'분 역배열 시그널 :(   [단위(원)]
'+text.to_s)
                puts 'BEST_DOWN'
                return "BEST_DOWN"
           elsif (  movingAvergaeRank["MA5"] == 1 && movingAvergaeRank["MA20"] == 2 && movingAvergaeRank["MA60"] == 3 && movingAvergaeRank["MA120"] == 4  && movingAvergaeRank["MA240"] == 5  )
              #정배열 상태   1
                telegramSMS('Bithumb'+indexValue.to_s+'분 정배열 시그널 :)   [단위(원)]
'+text.to_s)
                 puts 'BEST_UP'
                 return "BEST_UP"
                 
           else
                       puts 'NA'
                       return "NA"
        end    
       
         
         
        rescue
            puts "MovingAverageStatus Fail..."
            self.movingAverageStatus
    end
   
 end   
  
 def krChartDataChkReg(chartData_Array,interValMinute)
   begin  
            puts 'krChartDataChkReg Start...'
           dataReg =  chartData_Array
           count = 0 
            while true
                   regCnt = 0
                   regCnt =    dataReg[0].to_s.gsub(/\d/, "") .gsub(".","").length +  dataReg[1].to_s.gsub(/\d/, "") .gsub(".","").length +  dataReg[2].to_s.gsub(/\d/, "") .gsub(".","").length +  dataReg[3].to_s.gsub(/\d/, "") .gsub(".","").length
                   regCnt+=  dataReg[11].to_s.gsub(/\d/, "") .gsub(".","").length +  dataReg[12].to_s.gsub(/\d/, "") .gsub(".","").length +  dataReg[6].to_s.gsub(/\d/, "") .gsub(".","").length +  dataReg[7].to_s.gsub(/\d/, "") .gsub(".","").length
                   regCnt+=  dataReg[8].to_s.gsub(/\d/, "") .gsub(".","").length +  dataReg[9].to_s.gsub(/\d/, "") .gsub(".","").length +  dataReg[10].to_s.gsub(/\d/, "") .gsub(".","").length +  dataReg[14].to_s.gsub(/\d/, "") .gsub(".","").length
                   regCnt+=  dataReg[15].to_s.gsub(/\d/, "") .gsub(".","").length +  dataReg[16].to_s.gsub(/\d/, "") .gsub(".","").length +  dataReg[17].to_s.gsub(/\d/, "") .gsub(".","").length +  dataReg[18].to_s.gsub(/\d/, "") .gsub(".","").length
                   regCnt+=  dataReg[19].to_s.gsub(/\d/, "") .gsub(".","").length +  dataReg[20].to_s.gsub(/\d/, "") .gsub(".","").length +  dataReg[21].to_s.gsub(/\d/, "") .gsub(".","").length 
                   puts 'RegCnt::=>'+ regCnt.to_s+'Count=>'+count.to_s
                   count = count+1
                   if(  regCnt > 0  )
                          @watir.refresh
                          sleep(10)
                                  if(interValMinute == @interVal_1 )
                                   @watir.divs(:class ,%w(js-button-text text-1sK7vbvh-))[0].click  #  1번째 즐겨찾기  차트
                                 elsif(interValMinute ==  @interVal_2 )
                                   @watir.divs(:class ,%w(js-button-text text-1sK7vbvh-))[1].click  # 2번째 즐겨찾기 차트
                                 elsif(interValMinute ==  @interVal_3 )
                                   @watir.divs(:class ,%w(js-button-text text-1sK7vbvh-))[2].click  # 3번째 즐겨찾기 차트
                                 elsif(interValMinute ==  @interVal_4 )
                                   @watir.divs(:class ,%w(js-button-text text-1sK7vbvh-))[3].click  # 4번째 즐겨찾기 차트
                                 elsif(interValMinute ==  @interVal_5 )
                                   @watir.divs(:class ,%w(js-button-text text-1sK7vbvh-))[4].click  # 5번째 즐겨찾기 차트 
                                 else
                                   @watir.divs(:class ,%w(js-button-text text-1sK7vbvh-))[0].click  # 기본디폴트   처음 인터발로 설정
                                 end
                                dataReg = @watir.spans(:class => %w(pane-legend-item-value pane-legend-line) ).collect(&:text)
                                sleep(3)
                   end
                   
                   if(count > 30)
                     self.loginDo
                   end  
                   
                   break if   regCnt == 0
           end
           
            puts 'krChartDataChkReg End...'
   rescue Exception  => e
              puts "krChartDataChkReg...Fail"
              puts e.message 
              krChartDataChkReg(dataReg,interValMinute)
   end
 end  
 
 
 def krChartDataGettingInit
   begin
      
     #  uri = URI('https://api.telegram.org/bot474059759:AAFM24fbUFVyEhFN6bCszocGgdUqWyJqbxA/sendmessage?chat_id='+@telegramChatId.to_s+'&text=************************************%0d%0aTelegram Server initialization... Start..')
     #  Net::HTTP.get(uri)  
     
     @watir.text_field(:class =>'input-3lfOzLDc-').value = "BTCKRW"
     sleep(1)
     @watir.send_keys :enter
     sleep(1)
     
      @watir.divs(:class ,%w(js-button-text text-1sK7vbvh-))[0].click  # 30분 차트
      chartPageLoading
      sleep(5)
      chartData_Array = @watir.spans(:class => %w(pane-legend-item-value pane-legend-line) ).collect(&:text)
      # 데이터 확인용 #  
       count = 0
       chartData_Array.each do |textValue|
           count = count + 1
          puts textValue+'['+count.to_s+']'
       end
      #End 
        #  :krChartDTO_before_1Index ,:krChartDTO_before_2Index ,:krChartDTO_before_3Index ,:krChartDTO_before_4Index
        sleep(1)
       
       krChartDataChkReg(chartData_Array  ,  @interVal_1)
      @krChartDTO_1Index.set_initValue(chartData_Array[0])
      @krChartDTO_1Index.set_highValue(chartData_Array[1]);
      @krChartDTO_1Index.set_lowValue(chartData_Array[2]);
      @krChartDTO_1Index.set_lastValue(chartData_Array[3]);
      @krChartDTO_1Index.set_bollangerCenterValue(chartData_Array[11]);
      @krChartDTO_1Index.set_bollangerHightValue(chartData_Array[12]);
      @krChartDTO_1Index.set_bollangerLowValue(chartData_Array[13]);
      @krChartDTO_1Index.set_movingAverage_5(chartData_Array[6]);
      @krChartDTO_1Index.set_movingAverage_20(chartData_Array[7]);
      @krChartDTO_1Index.set_movingAverage_60(chartData_Array[8]);
      @krChartDTO_1Index.set_movingAverage_120(chartData_Array[9]);
      @krChartDTO_1Index.set_movingAverage_240(chartData_Array[10]);
      @krChartDTO_1Index.set_stoch_5K3Day_BlueValue(chartData_Array[14]);
      @krChartDTO_1Index.set_stoch_5K3Day_RedValue(chartData_Array[15]);
      @krChartDTO_1Index.set_stoch_12K3Day_BlueValue(chartData_Array[16]);
      @krChartDTO_1Index.set_stoch_12K3Day_RedValue(chartData_Array[17]);
      @krChartDTO_1Index.set_stoch_12K9Day_BlueValue(chartData_Array[18]);
      @krChartDTO_1Index.set_stoch_12K9Day_RedValue(chartData_Array[19]);
      @krChartDTO_1Index.set_stoch_20K12Day_BlueValue(chartData_Array[20]);
      @krChartDTO_1Index.set_stoch_20K12Day_RedValue(chartData_Array[21]);
      buyOrSell_Signal_CalCulate( @krChartDTO_before_1Index  , @krChartDTO_1Index  , @interVal_1 , 0)
      sleep(3)
      
      
      
      @watir.divs(:class ,%w(js-button-text text-1sK7vbvh-))[1].click  # 1시간 차트
      chartPageLoading
      sleep(5)
      chartData_Array = @watir.spans(:class => %w(pane-legend-item-value pane-legend-line) ).collect(&:text)
      # 데이터 확인용 #  
       count = 0
       chartData_Array.each do |textValue|
           count = count + 1
          puts textValue+'['+count.to_s+']'
       end
     sleep(1)
     krChartDataChkReg(chartData_Array ,  @interVal_2)
     @krChartDTO_2Index.set_initValue(chartData_Array[0])
     @krChartDTO_2Index.set_highValue(chartData_Array[1]);
     @krChartDTO_2Index.set_lowValue(chartData_Array[2]);
     @krChartDTO_2Index.set_lastValue(chartData_Array[3]);
     @krChartDTO_2Index.set_bollangerCenterValue(chartData_Array[11]);
     @krChartDTO_2Index .set_bollangerHightValue(chartData_Array[12]);
     @krChartDTO_2Index.set_bollangerLowValue(chartData_Array[13]);
     @krChartDTO_2Index.set_movingAverage_5(chartData_Array[6]);
     @krChartDTO_2Index.set_movingAverage_20(chartData_Array[7]);
     @krChartDTO_2Index.set_movingAverage_60(chartData_Array[8]);
     @krChartDTO_2Index.set_movingAverage_120(chartData_Array[9]);
     @krChartDTO_2Index.set_movingAverage_240(chartData_Array[10]);
     @krChartDTO_2Index.set_stoch_5K3Day_BlueValue(chartData_Array[14]);
     @krChartDTO_2Index.set_stoch_5K3Day_RedValue(chartData_Array[15]);
     @krChartDTO_2Index.set_stoch_12K3Day_BlueValue(chartData_Array[16]);
     @krChartDTO_2Index.set_stoch_12K3Day_RedValue(chartData_Array[17]);
     @krChartDTO_2Index.set_stoch_12K9Day_BlueValue(chartData_Array[18]);
     @krChartDTO_2Index.set_stoch_12K9Day_RedValue(chartData_Array[19]);
     @krChartDTO_2Index.set_stoch_20K12Day_BlueValue(chartData_Array[20]);
     @krChartDTO_2Index.set_stoch_20K12Day_RedValue(chartData_Array[21]);
     buyOrSell_Signal_CalCulate( @krChartDTO_before_2Index  , @krChartDTO_2Index  , @interVal_2, 0)
     sleep(3)
     
     @watir.divs(:class ,%w(js-button-text text-1sK7vbvh-))[2].click  # 4시간 차트
      chartPageLoading
      sleep(5)
      chartData_Array = @watir.spans(:class => %w(pane-legend-item-value pane-legend-line) ).collect(&:text)
      # 데이터 확인용 #  
       count = 0
       chartData_Array.each do |textValue|
           count = count + 1
          puts textValue+'['+count.to_s+']'
       end
     sleep(1)
      krChartDataChkReg(chartData_Array,  @interVal_3)
     @krChartDTO_3Index.set_initValue(chartData_Array[0])
     @krChartDTO_3Index.set_highValue(chartData_Array[1]);
     @krChartDTO_3Index.set_lowValue(chartData_Array[2]);
     @krChartDTO_3Index.set_lastValue(chartData_Array[3]);
     @krChartDTO_3Index.set_bollangerCenterValue(chartData_Array[11]);
     @krChartDTO_3Index.set_bollangerHightValue(chartData_Array[12]);
     @krChartDTO_3Index.set_bollangerLowValue(chartData_Array[13]);
     @krChartDTO_3Index.set_movingAverage_5(chartData_Array[6]);
     @krChartDTO_3Index.set_movingAverage_20(chartData_Array[7]);
     @krChartDTO_3Index.set_movingAverage_60(chartData_Array[8]);
     @krChartDTO_3Index.set_movingAverage_120(chartData_Array[9]);
     @krChartDTO_3Index.set_movingAverage_240(chartData_Array[10]);
     @krChartDTO_3Index.set_stoch_5K3Day_BlueValue(chartData_Array[14]);
     @krChartDTO_3Index.set_stoch_5K3Day_RedValue(chartData_Array[15]);
     @krChartDTO_3Index.set_stoch_12K3Day_BlueValue(chartData_Array[16]);
     @krChartDTO_3Index.set_stoch_12K3Day_RedValue(chartData_Array[17]);
     @krChartDTO_3Index.set_stoch_12K9Day_BlueValue(chartData_Array[18]);
     @krChartDTO_3Index.set_stoch_12K9Day_RedValue(chartData_Array[19]);
     @krChartDTO_3Index.set_stoch_20K12Day_BlueValue(chartData_Array[20]);
     @krChartDTO_3Index.set_stoch_20K12Day_RedValue(chartData_Array[21]);
     buyOrSell_Signal_CalCulate( @krChartDTO_before_3Index  , @krChartDTO_3Index  , @interVal_3, 0)
     sleep(3)
     
     @watir.divs(:class ,%w(js-button-text text-1sK7vbvh-))[3].click  # 8시간 차트
      chartPageLoading
      sleep(5)
      chartData_Array = @watir.spans(:class => %w(pane-legend-item-value pane-legend-line) ).collect(&:text)
      # 데이터 확인용 #  
       count = 0
       chartData_Array.each do |textValue|
           count = count + 1
          puts textValue+'['+count.to_s+']'
       end
      sleep(1)
      krChartDataChkReg(chartData_Array,  @interVal_4)
     @krChartDTO_4Index.set_initValue(chartData_Array[0])
     @krChartDTO_4Index.set_highValue(chartData_Array[1]);
     @krChartDTO_4Index.set_lowValue(chartData_Array[2]);
     @krChartDTO_4Index.set_lastValue(chartData_Array[3]);
     @krChartDTO_4Index.set_bollangerCenterValue(chartData_Array[11]);
     @krChartDTO_4Index.set_bollangerHightValue(chartData_Array[12]);
     @krChartDTO_4Index.set_bollangerLowValue(chartData_Array[13]);
     @krChartDTO_4Index.set_movingAverage_5(chartData_Array[6]);
     @krChartDTO_4Index.set_movingAverage_20(chartData_Array[7]);
     @krChartDTO_4Index.set_movingAverage_60(chartData_Array[8]);
     @krChartDTO_4Index.set_movingAverage_120(chartData_Array[9]);
     @krChartDTO_4Index.set_movingAverage_240(chartData_Array[10]);
     @krChartDTO_4Index.set_stoch_5K3Day_BlueValue(chartData_Array[14]);
     @krChartDTO_4Index.set_stoch_5K3Day_RedValue(chartData_Array[15]);
     @krChartDTO_4Index.set_stoch_12K3Day_BlueValue(chartData_Array[16]);
     @krChartDTO_4Index.set_stoch_12K3Day_RedValue(chartData_Array[17]);
     @krChartDTO_4Index.set_stoch_12K9Day_BlueValue(chartData_Array[18]);
     @krChartDTO_4Index.set_stoch_12K9Day_RedValue(chartData_Array[19]);
     @krChartDTO_4Index.set_stoch_20K12Day_BlueValue(chartData_Array[20]);
     @krChartDTO_4Index.set_stoch_20K12Day_RedValue(chartData_Array[21]);
     buyOrSell_Signal_CalCulate( @krChartDTO_before_4Index  , @krChartDTO_4Index  , @interVal_4, 0)
     sleep(3)
     
    @watir.divs(:class ,%w(js-button-text text-1sK7vbvh-))[4].click  # 1하루 차트
     chartPageLoading
     sleep(5)
     chartData_Array = @watir.spans(:class => %w(pane-legend-item-value pane-legend-line) ).collect(&:text)
     # 데이터 확인용 #  
      count = 0
      chartData_Array.each do |textValue|
          count = count + 1
         puts textValue+'['+count.to_s+']'
      end
     sleep(1)
     krChartDataChkReg(chartData_Array,  @interVal_5)
    @krChartDTO_5Index.set_initValue(chartData_Array[0])
    @krChartDTO_5Index.set_highValue(chartData_Array[1]);
    @krChartDTO_5Index.set_lowValue(chartData_Array[2]);
    @krChartDTO_5Index.set_lastValue(chartData_Array[3]);
    @krChartDTO_5Index.set_bollangerCenterValue(chartData_Array[11]);
    @krChartDTO_5Index.set_bollangerHightValue(chartData_Array[12]);
    @krChartDTO_5Index.set_bollangerLowValue(chartData_Array[13]);
    @krChartDTO_5Index.set_movingAverage_5(chartData_Array[6]);
    @krChartDTO_5Index.set_movingAverage_20(chartData_Array[7]);
    @krChartDTO_5Index.set_movingAverage_60(chartData_Array[8]);
    @krChartDTO_5Index.set_movingAverage_120(chartData_Array[9]);
    @krChartDTO_5Index.set_movingAverage_240(chartData_Array[10]);
    @krChartDTO_5Index.set_stoch_5K3Day_BlueValue(chartData_Array[14]);
    @krChartDTO_5Index.set_stoch_5K3Day_RedValue(chartData_Array[15]);
    @krChartDTO_5Index.set_stoch_12K3Day_BlueValue(chartData_Array[16]);
    @krChartDTO_5Index.set_stoch_12K3Day_RedValue(chartData_Array[17]);
    @krChartDTO_5Index.set_stoch_12K9Day_BlueValue(chartData_Array[18]);
    @krChartDTO_5Index.set_stoch_12K9Day_RedValue(chartData_Array[19]);
    @krChartDTO_5Index.set_stoch_20K12Day_BlueValue(chartData_Array[20]);
    @krChartDTO_5Index.set_stoch_20K12Day_RedValue(chartData_Array[21]);
    buyOrSell_Signal_CalCulate( @krChartDTO_before_5Index  , @krChartDTO_5Index  , @interVal_5, 0)
    sleep(3)
    # 
    
    #uri = URI('https://api.telegram.org/bot474059759:AAFM24fbUFVyEhFN6bCszocGgdUqWyJqbxA/sendmessage?chat_id='+@telegramChatId.to_s+'&text=Telegram Server initialization... End ..%0d%0a************************************')
    #Net::HTTP.get(uri)  

      
   rescue 
     
   end
 end  
    
  
  
 def krChartDataGetting(intervalMinute)
   begin
      puts ' intervaleMinute['+intervalMinute.to_s+']'
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
      puts '***************************************Start****************************************************'
      chartData_Array = @watir.spans(:class => %w(pane-legend-item-value pane-legend-line) ).collect(&:text)
      puts 'chartData_Array List Count [ '+chartData_Array.length.to_s+ ']'
      
      # 데이터 확인용 #  
      count = -1
      chartData_Array.each do |textValue|
          count = count + 1
         puts textValue+'['+count.to_s+']'
      end
      
      krChartDataChkReg(chartData_Array , intervalMinute )
      krChartDTO.set_initValue(chartData_Array[0])
      krChartDTO.set_highValue(chartData_Array[1]);
      krChartDTO.set_lowValue(chartData_Array[2]);
      krChartDTO.set_lastValue(chartData_Array[3]);
      krChartDTO.set_bollangerCenterValue(chartData_Array[11]);
      krChartDTO.set_bollangerHightValue(chartData_Array[12]);
      krChartDTO.set_bollangerLowValue(chartData_Array[13]);
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
     
   rescue Exception  => e
   puts "krChartDataGetting...Fail"
   puts e.message 
   self.krChartDataGetting(intervalMinute)
   end
 end 
 
 def telegramSMS(text)
    begin
        uri = URI.parse( URI.encode('https://api.telegram.org/bot474059759:AAFM24fbUFVyEhFN6bCszocGgdUqWyJqbxA/sendmessage?chat_id='+@telegramChatId.to_s+'&text=
'+text+'') )
        Net::HTTP.get(uri)
    rescue Exception => e
      puts "telegramSMS...Fail"
      puts e.message 
    end
   
 end
     
 def buyOrSell_Signal_CalCulate(krChartDTO_Before_Obj , krChartDTO_Obj , interValMinute , smsBoolean )
   begin
         #  smsBoolean  0   안보내기 1 보내기    
         # 시그널스코어 초기화        
         @signalScore = 0 
                  
     
     
        ##단타픽
             # 스코어가 총 7점 이상이되야 매수 사인 나가고 7점 이하면 매도임.
          
             # 상승장에서는 5일선이 20일선이 위에에 있으면  상승장
             # 상승장에서는 5일선이 20일선이 아래에 있으면  하락장
             # 스코어 점수 계산법 
             # 양봉일때             1점
             #  5-3-3 상승     1점     
             #  12-3-3 상승   2점
             # 12 -6-6 상승   3점
             # 20-5-5 상승    4점  4점은 저번 타임보다 수치가 높아도 4점 부여  하지만 저번타임보다 낮으면 4점 추가 X 
             # 총 7점 이상되야 매수 , 7점 이하면 매도  하지만 상승장에서는 수치 무의미, 
             
          
             #무조건 매도   
             #::12-6-6  80이상 20-5-5 80이상 2가지 조건 만족하면 풀매도. 
             #:: 최고가 대비 종가가 -1% 이상 빠진 캔들  윗꼬리 음봉 역시 풀매도
             #:: 완벽한 역배열이면  관망.
          
             #무조건매수
             
             
             
              #5일선과 20일선 위에 있는지 아래 있는지 추세 ㅋㅋ   true 상승 false 하락
              movingAverageChse =  krChartDTO_Obj.get_movingAverage_5().to_f >  krChartDTO_Obj.get_movingAverage_20().to_f
              puts 'stochChSe'
              puts movingAverageChse
              
              #캔들이 5일선 밑에 있는지 위에 있는지 알아야함  하향선인지 상향선인지 알아봐야함
              stochDanGiChuSe =  krChartDTO_Obj.get_movingAverage_5().to_f  <= krChartDTO_Obj.get_lastValue().to_f
              
             # 양봉인지 음봉인지? 양봉이면 1점 , 음봉이면 -1  true면 양봉 false면 음봉
              candleType =  krChartDTO_Obj.get_initValue().to_f < krChartDTO_Obj.get_lastValue().to_f
              
              
              
              
              if(candleType == true  )
                  puts '양봉인지 음봉인지'
                  @signalScore = @signalScore + 1    # 양봉이면 +1점 
                  puts @signalScore
              end
          
             puts '데이터계산'
          
              # 30분봉 데이터  Score Index Boolean = SIB
              stoch533 =  krChartDTO_Obj.get_stoch_5K3Day_RedValue().to_f        <  krChartDTO_Obj.get_stoch_5K3Day_BlueValue().to_f   
              stoch1233 = krChartDTO_Obj.get_stoch_12K3Day_RedValue().to_f     <  krChartDTO_Obj.get_stoch_12K3Day_BlueValue().to_f
              stoch1299 =  krChartDTO_Obj.get_stoch_12K9Day_RedValue().to_f     <  krChartDTO_Obj.get_stoch_12K9Day_BlueValue().to_f
              stoch201212 = krChartDTO_Obj.get_stoch_20K12Day_RedValue().to_f  <  krChartDTO_Obj.get_stoch_20K12Day_BlueValue().to_f
              stoch201212_ChSe = false
              
              
              
              ## 엄청난 과매수인지 체크한다.
              stoch533_Overbought = krChartDTO_Obj.get_stoch_5K3Day_BlueValue().to_f    >  80.0
              stoch1233_Overbought = krChartDTO_Obj.get_stoch_12K3Day_BlueValue().to_f  > 80.0
              stoch1299_Overbought = krChartDTO_Obj.get_stoch_12K9Day_BlueValue().to_f  > 80.0
              stoch201212_Overbought = krChartDTO_Obj.get_stoch_20K12Day_BlueValue().to_f >  80.0 
              
              # stoch533_OverSell = krChartDTO_Obj.get_stoch_5K3Day_BlueValue().to_f    <  10.0
              stoch1233_OverSell  = krChartDTO_Obj.get_stoch_12K3Day_BlueValue().to_f  < 10.0 &&   ( krChartDTO_Before_Obj.get_stoch_12K3Day_BlueValue().to_f  <  krChartDTO_Obj.get_stoch_12K3Day_BlueValue().to_f )
              #stoch1299_OverSell = krChartDTO_Obj.get_stoch_12K9Day_BlueValue().to_f  < 10.0 
              stoch201212_OverSell = krChartDTO_Obj.get_stoch_20K12Day_BlueValue().to_f <  10.0 && (  krChartDTO_Before_Obj.get_stoch_20K12Day_BlueValue().to_f  <  krChartDTO_Obj.get_stoch_20K12Day_BlueValue().to_f )
              
              if ( krChartDTO_Before_Obj.get_stoch_20K12Day_BlueValue().to_f  != 0.0)
                  stoch201212_ChSe = krChartDTO_Before_Obj.get_stoch_20K12Day_BlueValue().to_f  <  krChartDTO_Obj.get_stoch_20K12Day_BlueValue().to_f
              end
              
              if ( stoch533 == true ) 
                    @signalScore = @signalScore + 1
                    puts @signalScore
              end
              if ( stoch1233== true  ) 
                    @signalScore = @signalScore + 2
                    puts @signalScore
              end
              if ( stoch1299== true  ) 
                    @signalScore = @signalScore + 3
                    puts @signalScore
              end
              if ( stoch201212 == true  ||  stoch201212_ChSe == true ) 
                    @signalScore = @signalScore + 4
                    puts @signalScore
              end
              
              puts '@signalScore'
              puts @signalScore
              
              
                  if (  @signalScore >= 7 )
                              # 5일선이 20일선 위에 있는 경우와 아래에 있는 경우 목표가가 틀리다.
                              if ( movingAverageChse  == true )
                                    puts 'buy SMS'
                                    text = interValMinute.to_s+'분 시그널 매수!(단위:원)
매수가 : '+insert_comma(krChartDTO_Obj.get_lastValue().to_i.to_s)+'
매도가  : '+insert_comma(krChartDTO_Obj.get_bollangerHightValue().to_i.to_s)+'
손절가  : '+insert_comma(krChartDTO_Obj.get_movingAverage_20().to_i.to_s)  
                                          if(smsBoolean == 1  )
                                          telegramSMS(text)
                                          end
                              else
                                    text = interValMinute.to_s+'분 시그널 매수!(단위:원)
매수가='+insert_comma(krChartDTO_Obj.get_lowValue().to_i.to_s)+'
1차 매도가  : '+insert_comma(krChartDTO_Obj.get_movingAverage_20().to_i.to_s)+'
2차매도가  : '+insert_comma(krChartDTO_Obj.get_bollangerHightValue().to_i.to_s)+'
손절가 : '+insert_comma(krChartDTO_Obj.get_bollangerLowValue().to_i.to_s)
                                          if(smsBoolean == 1  )
                                          telegramSMS(text)
                                          end
                              end
                             
                              return 1
                    elsif(@signalScore < 7   )
                             
                           
                              
                          if (  stoch533_Overbought || stoch1233_Overbought || stoch1299_Overbought ||  stoch201212_Overbought  )
                                  if ( movingAverageChse  == true )
                                            text = interValMinute.to_s+'분 시그널 매도! (단위:원)
과매수구간 익절추천!현재 시장가로 50프로 매도
나머지 물량은 : '+insert_comma(krChartDTO_Obj.get_movingAverage_5().to_i.to_s)+'무너지면 매도'  
                                          if(smsBoolean == 1  )
                                          telegramSMS(text)
                                          end
                                  else
                                            text = interValMinute.to_s+'분 시그널 매도! (단위:원)
과매수구간 익절추천!  현재 시장가로 50프로 매도'+'
나머지 물량은: '+insert_comma(krChartDTO_Obj.get_movingAverage_5().to_i.to_s)+'무너지면 매도'  
                                          if(smsBoolean == 1  )
                                          telegramSMS(text)
                                          end
                                  end
                         elsif (stoch1233_OverSell && stoch201212_OverSell  )
                                 if ( movingAverageChse  == true )    
                                           text = interValMinute.to_s+'분 시그널 매수! (단위:원)
과매도구간 초단타로 반등먹기!
매수가 : '+insert_comma(krChartDTO_Obj.get_lastValue().to_i.to_s)+'
매도가  : '+insert_comma(krChartDTO_Obj.get_movingAverage_5().to_i.to_s)+'
손절가  : '+insert_comma(krChartDTO_Obj.get_bollangerLowValue().to_i.to_s)  
                                          if(smsBoolean == 1  )
                                          telegramSMS(text)
                                          end
                               else
                                           text = interValMinute.to_s+'분 시그널 매수! (단위:원)
과매도구간 초단타로 반등먹기!매수가='+insert_comma(krChartDTO_Obj.get_lastValue().to_i.to_s)+'
1차 매도가 : '+insert_comma(krChartDTO_Obj.get_movingAverage_5().to_i.to_s)+'
2차 매도가 : '+insert_comma(krChartDTO_Obj.get_bollangerCenterValue().to_i.to_s)+'
3차매도가 : '+insert_comma(krChartDTO_Obj.get_bollangerHightValue().to_i.to_s)+'
손절가 : '+insert_comma(krChartDTO_Obj.get_bollangerLowValue().to_i.to_s)  
                                        if(smsBoolean == 1  )
                                        telegramSMS(text)
                                        end
                                 end
                         else
                            if ( movingAverageChse  == true )
                            text = interValMinute.to_s+'분 시그널 매도! (단위:원)
추세 하락으로 전환.. 매도추천
현재 가격 : '+insert_comma(krChartDTO_Obj.get_lastValue().to_i.to_s)+' 
1차 지지라인 : '+insert_comma(krChartDTO_Obj.get_movingAverage_5().to_i.to_s)+'
2차 지지라인 : '+insert_comma(krChartDTO_Obj.get_bollangerCenterValue().to_i.to_s)
                                       if(smsBoolean == 1  )
                                       telegramSMS(text)
                                       end
                            else
                            text = interValMinute.to_s+'분 시그널 매도! (단위:원)
추세 하락으로 전환.. 매도추천 
지지라인 : '+insert_comma(krChartDTO_Obj.get_bollangerLowValue().to_i.to_s)
                                      if(smsBoolean == 1  )
                                      telegramSMS(text)
                                      end
                              
                            end    
                                    
                         end
                          return 0
                          
                          
                   else
                        puts 'StandBy SMS'
                        uri = URI('https://api.telegram.org/bot474059759:AAFM24fbUFVyEhFN6bCszocGgdUqWyJqbxA/sendmessage?chat_id='+@telegramChatId.to_s+'&text='+interValMinute.to_s+'MinuteBtc_StandBy Position')
                        Net::HTTP.get(uri)
                   end
                   
           
            #    if ( ( krChartDTO.get_stoch_12K3Day_RedValue().to_i < krChartDTO.get_stoch_12K3Day_BlueValue().to_i ) && krChartDTO.get_stoch_12K3Day_BlueValue().to_i < 30 && ( krChartDTO.get_stoch_12K9Day_RedValue().to_i < krChartDTO.get_stoch_12K9Day_BlueValue().to_i ) && krChartDTO.get_stoch_12K9Day_BlueValue().to_i < 30 )
            #       uri = URI('https://api.telegram.org/bot474059759:AAFM24fbUFVyEhFN6bCszocGgdUqWyJqbxA/sendmessage?chat_id='+@telegramChatId.to_s+'&text=1IndexBtc_Buy')
            #       Net::HTTP.get(uri)
            #   elsif( ( krChartDTO.get_stoch_12K3Day_RedValue().to_i > krChartDTO.get_stoch_12K3Day_BlueValue().to_i ) && ( krChartDTO.get_stoch_12K9Day_RedValue().to_i < krChartDTO.get_stoch_12K9Day_BlueValue().to_i ) || krChartDTO.get_stoch_12K3Day_BlueValue().to_i > 80  )
            #       uri = URI('https://api.telegram.org/bot474059759:AAFM24fbUFVyEhFN6bCszocGgdUqWyJqbxA/sendmessage?chat_id='+@telegramChatId.to_s+'&text=1IndexBtc_Sell')
            #       Net::HTTP.get(uri)
            #   else 
            #      uri = URI('https://api.telegram.org/bot474059759:AAFM24fbUFVyEhFN6bCszocGgdUqWyJqbxA/sendmessage?chat_id='+@telegramChatId.to_s+'&text=1IndexBtc_StandBy')
            #      Net::HTTP.get(uri)
            #   end
     
       if ( interValMinute ==  @interVal_1 )
              puts 'Data Now Instance -> Data Before Instance interVal_1 Transfer... Start!!'
              @krChartDTO_before_1Index =    @krChartDTO_1Index
       elsif( interValMinute == @interVal_2  )
              puts 'Data Now Instance -> Data Before Instance interVal_1 , interVal_2 Transfer... Start!!'
              @krChartDTO_before_1Index =    @krChartDTO_1Index
              @krChartDTO_before_2Index =    @krChartDTO_2Index
       elsif( interValMinute == @interVal_3  )
              puts 'Data Now Instance -> Data Before Instance interVal_1 , interVal_2 , interVal_3 Transfer... Start!!'
              @krChartDTO_before_1Index =    @krChartDTO_1Index
              @krChartDTO_before_2Index =    @krChartDTO_2Index
              @krChartDTO_before_3Index =    @krChartDTO_3Index
       elsif ( interValMinute == @interVal_4  )
              puts 'Data Now Instance -> Data Before Instance interVal_1 , interVal_2 , interVal_3 , interVal_4  Transfer... Start!!'
               @krChartDTO_before_1Index =    @krChartDTO_1Index
               @krChartDTO_before_2Index =    @krChartDTO_2Index
               @krChartDTO_before_3Index =    @krChartDTO_3Index
               @krChartDTO_before_4Index =    @krChartDTO_4Index
       elsif ( interValMinute == @interVal_5  )
                puts 'Data Now Instance -> Data Before Instance interVal_1 , interVal_2 , interVal_3 , interVal_4 , interVal_5   Transfer... Start!!'
                @krChartDTO_before_1Index =    @krChartDTO_1Index
                @krChartDTO_before_2Index =    @krChartDTO_2Index
                @krChartDTO_before_3Index =    @krChartDTO_3Index
                @krChartDTO_before_4Index =    @krChartDTO_4Index        
                @krChartDTO_before_5Index =    @krChartDTO_5Index        
       end 
       puts 'Data Now Instance -> Data Before Instance Transfer... End!!'
      
       if ( signalScore >= 7 )
         return 1
       else
         return 0
       end    
       
     rescue Exception => e
          puts "buyOrSell_Signal_CalCulate Fail"
          puts e.message 
          uri = URI('https://api.telegram.org/bot474059759:AAFM24fbUFVyEhFN6bCszocGgdUqWyJqbxA/sendmessage?chat_id='+@telegramChatId.to_s+'&text=Error::%0d%0a'+e.message.to_s+'')
          Net::HTTP.get(uri)
          self.loginDo  
      ensure
      end
 end

 
 def scoreResultText(score)
          begin
            text=""
            if(score == 1)
              text = "매수시그널"
            else
              text = "매도시그널"
            end    
          rescue Exception =>e
             puts "scoreResultText Fail"
             puts e.message 
          end
 end    
 
 def totalScoreResultText(score)
          begin
            text=""
            if(score>= 10)
              text = "매수시그널"
            else
              text = "매도시그널"
            end    
          rescue Exception =>e
             puts "scoreResultText Fail"
             puts e.message 
          end
 end  
 
 
  #Naver login logic 
  def loginDo
    begin
      
      
      
      krChartDataGettingInit # 차트 init 셋팅값 설정
      
     #while true
     #          puts '1Index  DataGetting Start'
     #          @krChartDTO_1Index = krChartDataGetting(@interVal_1)
     #           puts '1Index  buyOrSell_Signal_CalCulate Start'
     #           
     #           buyOrSell_Signal_CalCulate(@interVal_1 )
     #           sleep ( 10 )
     #end
      
     # initKrChartDataSetting  ##TODO 만들어야함
      
  
      
                init = 0
                while true
                          standByTime = ""
                          timeStamp =  getChartTimeStamp
                          if(init == 0 || getChartTimeStamp =="3MIN" )
                                        puts '1Index  2Index 3Index 4Index 5Index  and Status -> DataGetting Start'
                                       @krChartDTO_1Index = krChartDataGetting(@interVal_1)
                                       @krChartDTO_2Index = krChartDataGetting(@interVal_2)
                                       puts '5Index  buyOrSell_Signal_CalCulate Start'
                                       movingAverageStatus(@interVal_1)
                                       movingAverageStatus(@interVal_2)
                                      result1 =  buyOrSell_Signal_CalCulate(@krChartDTO_before_1Index ,@krChartDTO_1Index, @interVal_1, 1 )
                                      result2 =  buyOrSell_Signal_CalCulate(@krChartDTO_before_2Index ,@krChartDTO_2Index, @interVal_2, 1 )
                                      
                                if (init ==0 )
                                    @positionValue =  @krChartDTO_1Index.get_lastValue().to_i
                                    @turnSignal == 1
                                end
                                                                  
                            
                            if (result1+result2 >= 2 &&  @turnSignal == 1 )
                                 text ='AutoBit Signal매수 *****'+@krChartDTO_1Index.get_lastValue()
                                  telegramSMS(text)
                                  puts '매수가격'
                                  @positionValue =  @krChartDTO_1Index.get_lastValue().to_i
                                  puts @positionValue
                                  @turnSignal = 0
                            else
                                   if(init!=0)
                                          text ='AutoBit Signal매도 *****'+@krChartDTO_1Index.get_lastValue().to_s
                                          telegramSMS(text)
                                          puts '매도가격'
                                          if(@positionValue!=0)
                                              profitValue   =   @krChartDTO_1Index.get_lastValue().to_i  - @positionValue
                                              puts 'profitValue'
                                              puts profitValue 
                                              @profit = @profit +  profitValue
                                          puts @profit
                                          end
                                    end
                                    if (@profit != 0)
                                        telegramSMS("Now profit:"+profitValue.to_s+"||  총이익금액 : "+@profit.to_s)
                                    end
                                    @turnSignal = 1
                            end  
                                
                            
                            init+=init+1
                            end
                end    
      end
      
    rescue Exception => e
      puts "loginDo Fail"
      puts e.message 
      uri = URI('https://api.telegram.org/bot474059759:AAFM24fbUFVyEhFN6bCszocGgdUqWyJqbxA/sendmessage?chat_id='+@telegramChatId.to_s+'&text=Error::%0d%0a'+e.message.to_s+'')
      Net::HTTP.get(uri)
      self.loginDo  
    ensure
    end
  end

  #> require './Phone'  #! import class
  #> myphone = Phone.new  #! instantiate class Phone
  #> myphone.model = "iPhone5"  #! set model name
  #> myphone.model  #! get model name
   



doTask = AutoBit_AI_Signal_Danta.new('capmo1@naver.com','Dnjzm1324!') 
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
