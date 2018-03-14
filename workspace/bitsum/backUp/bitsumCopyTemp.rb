require 'rubygems'
require 'watir'
require 'time'
require 'timeout'
require 'net/https'
require 'uri'
require 'Win32API'
require 'auto_click'


#https://rubygems.org/gems/auto_click/versions/0.2.0 마우스오토클릭  gem install auto_click -v 0.2.0
#chart-controls-clock time 가져오기 span  <span class="chart-controls-clock">17:00:38</span>
# 네이버 로그인 진짜로 하는것처럼 로직 변경해야함.
# nclks('log.login',this,event)
# 네이버 이메일로 로그인
#서비스 이용정지 
#https://auth.band.us/get_user_account_status?next_url=http://band.us&signature=8P8Lt9CtplcyKDMaZNhy6eM%2Fn34M0K8np6BTNFBWTac%3D&token=45b4c355284549daf2a0513aaa0c9e298e21a2bf&user_no=10156050
class NaverTest
  
  #TODO 크롬 , 인터넷IE 로직도 추가
  #initialize :: param setting
  attr_accessor :server, :loginId, :loginPw, :watir , :bandloop_Cnt , :exceptionCnt , :data , :targetingCoin
  


  def initialize(loginId,loginPw)
    
    #puts "Current Time : " + time1.inspect
    @loginId = loginId
    @loginPw = loginPw
    #@server = 'https://kr.tradingview.com/'
    @server = 'https://kr.tradingview.com/'
    
    @watir = Watir::Browser.new :firefox   #: chrome
    @watir.goto "#{@server}"
    @bandloop_Cnt = 0
    @exceptionCnt = 0
    #@watir.window.resize_to(600, 700)
    @watir.window.maximize
    sleep(2)
    
    puts "initialize setting!"
    #puts '[' +"#{@bandList_Array}".length.to_s   + ']' 
  end

  def kakaoLogin
      begin
      @watir.execute_script(' window.open("https://miraclepushserver.firebaseapp.com")')
      sleep(1)
      @watir.windows.last.use
      @watir.window(:title => "Kakao Web Login").use do
          @watir.text_field(:name=>'email').value = "capmo11@nate.com"
          @watir.text_field(:name=>'password').value = "Dnjzm1324!"
          @watir.a(:id ,'btn_login').click
      end 
      @watir.windows.first.use
      puts "kakaoLogin Success"
      return "kakaoLogin Success"
      rescue 
      puts "kakaoLogin Fail"
      return "kakaoLogin Fail"
      end
  end
  
  def telegramLogin
       begin
      
       @watir.execute_script(' window.open("https://web.telegram.org/#/login")')
       sleep(1)
       @watir.windows.last.use
       @watir.window(:title => "Telegram Web").use do
       @watir.text_field(:name=>'phone_number').value = "01020813240"
       @watir.a(:class ,'login_head_submit_btn').click
       @watir.button(:class ,'btn btn-md btn-md-primary').click
       sleep(30)
       
       @watir.goto "https://web.telegram.org/#/im?p=u468788851_5906293482892282881"
       end 
       sleep(5)
       
       #@watir.div(:class ,'composer_rich_textarea').send_keys [:control, '사랑해']
       @watir.send_keys '사랑해 ' # '1D'
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
      @watir.a(:class ,'tv-header__link tv-header__link--signin js-header__signin').click
      @watir.text_field(:name=>'username').value = "#{@loginId}"
      @watir.text_field(:name=>'password').value = "#{@loginPw}"
      #@watir.span(:class ,'tv-button__loader').click
      @watir.button(:class ,'tv-button tv-button--no-border-radius tv-button--size_large tv-button--primary_ghost tv-button--loader').click
      sleep(2)
      @watir.a(:href,'/chart/').click
      sleep(5)  
      
      puts "krChartLogin Success"
      return "krChartLogin Success"
      rescue 
      puts "krChartLogin Fail"
      return "krChartLogin Fail"
      end
  end

  #httpRespons Method
  def httpResponsCheck
    begin
      uri = URI(@watir.url)
      res = Net::HTTP.get_response(uri)
      return res.code
    rescue Exception => e
      puts 'httpResponsCheck Exception'
      sleep(3)
      exceptionCnt++
      if(exceptionCnt < 5 )
        puts self.httpResponsCheck
      else
        #self.loginDo
      end
      
    end
      
  end
  
  
  def chartPageLoading
    begin
      while true
        sleep(0.5) 
        puts 'chartPageLoading...'
        break if @watir.span(:class , 'chart-controls-clock').exists? == true
      end
    rescue 
         puts "refleshIsFail..."
         self.refleshIsOK
    end   
  end  
  
  
    
  def refleshIsOK
    begin
      
      
     
      puts '***** [ Targeting ... Search...!! Volumn Top Best.. ] *****'
      jsonValue =""
      uri = URI('https://api.bithumb.com/public/ticker/ALL')
      params = { :limit => 10, :page => 3 }
      uri.query = URI.encode_www_form(params)
      
      res = Net::HTTP.get_response(uri)
      puts res.body if res.is_a?(Net::HTTPSuccess)
      jsonValue = res.body
      puts jsonValue
      data_hash =  JSON.parse(jsonValue)
      puts JSON.parse(jsonValue).keys
      
      if  data_hash['status'] == "0000"
             volumn_hash = {"BTC" => data_hash['data']['BTC']['volume_1day'].to_f * data_hash['data']['BTC'].to_f} 
             volumn_hash["ETH"] = data_hash['data']['ETH']['volume_1day'].to_f * data_hash['data']['ETH'].to_f 
             volumn_hash["DASH"] =  data_hash['data']['DASH']['volume_1day'].to_f * data_hash['data']['DASH'].to_f    
             volumn_hash["LTC"] =data_hash['data']['LTC']['volume_1day'].to_f * data_hash['data']['LTC'].to_f    
             volumn_hash["ETC"] =data_hash['data']['ETC']['volume_1day'].to_f * data_hash['data']['ETC'].to_f    
             volumn_hash["XRP"] =data_hash['data']['XRP']['volume_1day'].to_f * data_hash['data']['XRP'].to_f    
             volumn_hash["BCH"] =data_hash['data']['BCH']['volume_1day'].to_f * data_hash['data']['BCH'].to_f    
             volumn_hash["XMR"] =data_hash['data']['XMR']['volume_1day'].to_f * data_hash['data']['XMR'].to_f   
             volumn_hash["ZEC"] =data_hash['data']['ZEC']['volume_1day'].to_f * data_hash['data']['ZEC'].to_f  
             volumn_hash["QTUM"] =data_hash['data']['QTUM']['volume_1day'].to_f * data_hash['data']['QTUM'].to_f  
             
             puts volumn_hash.sort.to_h 
                       
            
             puts   'name' + volumn_hash.sort[0][0].to_s
             puts   'value' +  volumn_hash.sort[0][1].to_s
input-3lfOzLDc-
             if volumn_hash.sort[0][0].to_s == "BTC"
                 @watir.text_field(:class =>'symbol-edit').value = "BTCKRW"
               elsif volumn_hash.sort[0][0].to_s == "ETH"
                 @watir.text_field(:class =>'symbol-edit').value = "ETHKRW"
               elsif volumn_hash.sort[0][0].to_s == "DASH"
                 @watir.text_field(:class =>'symbol-edit').value = "DASHUSD"
               elsif volumn_hash.sort[0][0].to_s == "LTC"
                 @watir.text_field(:class =>'symbol-edit').value = "LTCUSD"
               elsif volumn_hash.sort[0][0].to_s == "ETC"
                 @watir.text_field(:class =>'symbol-edit').value = "ETCUSD"
               elsif volumn_hash.sort[0][0].to_s == "XRP"
                 @watir.text_field(:class =>'symbol-edit').value = "XRPKRW"
               elsif volumn_hash.sort[0][0].to_s == "BCH"
                 @watir.text_field(:class =>'symbol-edit').value = "POLONIEX:BCHUSD"
               elsif volumn_hash.sort[0][0].to_s == "XMR"
                 @watir.text_field(:class =>'symbol-edit').value = "XMRUSD"
               elsif volumn_hash.sort[0][0].to_s == "ZEC"
                 @watir.text_field(:class =>'symbol-edit').value = "ZECUSD"
               elsif volumn_hash.sort[0][0].to_s == "QTUM"
                 @watir.text_field(:class =>'symbol-edit').value = "QTUMUSD"
             end
      
      else
        @watir.text_field(:class =>'symbol-edit').value = "POLONIEX:BCHUSD"
      end
       
      # BTCKRW 비트코인  
      # XRPKRW 리플/원  
      # LTCUSD 라이트코인/달러 
      # BCHUSD 비트코인캐쉬 
      # ETHKRW 이더리움 
      # ETCKRW 이더리움클래식
      @watir.send_keys :enter
      chartPageLoading
      @watir.span(:class ,'submenu interval-dialog-button apply-common-tooltip').click
      @watir.send_keys '1M' # '1D'
      @watir.send_keys :enter
      chartPageLoading
      @watir.span(:class ,'submenu interval-dialog-button apply-common-tooltip').click
      @watir.send_keys '30' # '1D' ## 기간 설정
      @watir.send_keys :enter
      chartPageLoading
      sleep(1)
      #@watir.divs(:class => /widgetbar-iconplace apply-common-tooltip common-tooltip-vertical/, :index => 2).click   
      sleep(1)
      
      puts "refleshIsOK...."
      return "refleshIsOK"
    rescue 
      #errorCnt =  errorCnt  + 1
      puts "refleshIsFail..."
      self.refleshIsOK
    end   
  end
    
    

  #Naver login logic 
  def loginDo
    begin
    


      if  kakaoLogin == 'kakaoLogin Success' 
          sleep(5)
          krChartLogin
          sleep(5)
          #@watir.refresh
          sleep(3)
          
         

          
          mouseXpoint = cursor_position[0]
          mouseYpoint = cursor_position[1]
          
          
          puts '***mouse position : s ***'
          puts cursor_position #cursor_position[0] x point cursor_position[1] y point
          puts mouseXpoint
          puts mouseYpoint
          puts '***mouse position : e ***'
          refleshIsOK
          
          initValue = 0 #시가
          highValue = 0 #고가
          lowValue = 0  #저가
          lastValue = 0  # 종가

          macdHistogramValue = 0 # Histogram ( 빨간 )
          macdBlueValue = 0 # macd 파란   # 파란 > 빨간    =>   상승장
          macdRedValue  = 0 # macd 빨간   # 파란 < 빨간    =>   하락장
          
          beforeBlueValue =  0  # 전봉 macd Blue 값
          beforeRedValue =  0 # 전봉 macd Red 값
          nowBlueValue = 0 # 현재봉 macd Blue 값
          nowRedValue = 0 # 현재봉 macd Blue 값
          
          beforeIchimokuValue = 0 # 전봉 전환점값
          nowIchimokuValue = 0 # 현재봉 전환점값

          conversionLineValue = 0  #일목균형표 추세전환선
          macdSignal = 0 # 1 macd 상승추세 , 0 하락추세 기점
          turnMacdSignal =  -1 # 1 macd 상승 , 0 하락 기점

          #   Value = [10.5708]count1 Histogram ( 빨간 )
          #   Value = [35.0074]count2 Macd (파란)
          #   Value = [24.4366]count3 Signal ( 주황 )
          #   Value = [5983.77]count4 시가
          #   Value = [5990.91]count5 고가
          #   Value = [5957.21]count6 저가
          #   Value = [5990.91]count7 종가
          #   Value = [191]count8 볼륨 20
          #   Value = [164]count9 볼륨 MA
          #   Value = [5908.2650]count10   (imok) 
          #   Value = [5847.0300]count11 Base Line (imok)
          #   Value = [5990.9100]count12 Lagging Span (imok)
          #   Value = [5884.1425]count13 Lead 1 (imok)
          #   Value = [5938.0000]count14 Lead 2 (imok)
          #   Value = [5846.7475]count15 볼린저 Basis
          #   Value = [5968.4822]count16 볼린저 Upper
          #   Value = [5725.0128]count17 볼린저 Lower

          ##초기값 셋팅
          bandList_Array = @watir.spans(:class => 'pane-legend-item-value pane-legend-line' ).collect(&:text)
                  puts 'bandList_Array List Count [ '+bandList_Array.length.to_s + ']'
                  count = 0 
                  bandList_Array.each do |textValue|
                  count = count + 1
                
                  if count ==  1
                    puts '1 macdHistogramValue = [' + textValue + ']'+'count'+count.to_s
                    macdHistogramValue = textValue.to_f
                  end
                  #빨간 > 파란 -> #빨간 < 파란 이 되는 시점이 매수
                  if count ==  2
                    nowBlueValue = textValue.to_f
                     puts '2 macdBlueValue = [' + textValue + ']'+'count'+count.to_s
                  end

                  if count ==  3 
                    nowRedValue = textValue.to_f
                    puts '3 macdRedValue = [' + textValue + ']'+'count'+count.to_s
                  end

                  if count ==  4 #시가
                    initValue =  textValue.to_f
                    puts '4 initValue = [' + textValue + ']'+'count'+count.to_s
                  end

                  if count ==  5 #고가
                    highValue =  textValue.to_f
                    puts '5 highValue = [' + textValue + ']'+'count'+count.to_s
                  end
                  if count ==  6 #저가
                    lowValue =  textValue.to_f
                    puts '6 lowValue = [' + textValue + ']'+'count'+count.to_s
                  end
                  if count ==  7 #종가
                    lastValue =  textValue.to_f
                    puts '7 lastValue = [' + textValue + ']'+'count'+count.to_s
                  end
                  if count ==  10
                    conversionLineValue = textValue.to_f
                    puts '10 Conversion Line = [' + textValue + ']'+'count'+count.to_s
                  end

                  
          end # bandlist array End
          
          if macdBlueValue < macdRedValue
            macdSignal = 0 # 하락 
          else
            macdSignal = 1 # 상승 
          end
          
        
          
          puts  'initValue['+ initValue.to_s+']'
          puts  'highValue['+ highValue.to_s+']'
          puts  'lowValue['+ lowValue.to_s+']'
          puts  'lastValue['+ lastValue.to_s+']'
          puts  'Conversion Line['+conversionLineValue.to_s+']'
          puts  'macdHistogramValue['+ macdHistogramValue.to_s+']'
          puts  'nowBlueValue['+ nowBlueValue.to_s+']'
          puts  'nowRedValue['+ nowRedValue.to_s+']'
          puts  'beforeBlueValue['+beforeBlueValue.to_s+']'
          puts  'beforeRedValue['+beforeRedValue.to_s+']'
          puts  'turnMacdSignal['+turnMacdSignal.to_s+']' 
          
          
            
    
        
          while true
            timeValue = @watir.span(:class , 'chart-controls-clock').text
          
            timeMinute = timeValue[3..4] #분 
            timeSecond = timeValue[6..7] #초
            
              
            if timeSecond == "00"
              mouse_move(mouseXpoint,mouseYpoint)
              left_click
              sleep(1)
            end 
            
            #if  ( (timeSecond == "00" && timeMinute == "15") ||  (timeSecond == "00" && timeMinute == "30") ||  (timeSecond == "00" && timeMinute == "45")  ||  (timeSecond == "00" && timeMinute == "00")   )
            if  ( (timeSecond == "00" && timeMinute == "00") ||  (timeSecond == "00" && timeMinute == "30")  )
            #if   timeSecond == "00" 
              time1 = Time.new
              puts "Current Time Stamp Counting....  :: " + time1.inspect
              
              mouse_move(mouseXpoint,mouseYpoint)
              left_click
              
              #TODO 여기부터 다시 해야함 . 3분봉 셋팅하는부분 
              # macd가 상향인지 하향인지 ? 크로스될때
              #2번째 전환점보다 종가가 클때
              #3번째 전 봉이 전환점보다 컸는지?
              
              refleshIsOK
              
               
              bandList_Array = @watir.spans(:class => 'pane-legend-item-value pane-legend-line' ).collect(&:text)
                  puts 'bandList_Array List Count [ '+bandList_Array.length.to_s + ']'
                  count = 0 
                  bandList_Array.each do |textValue|
                  count = count + 1
                
                  if count ==  1
                    puts '1 macdHistogramValue = [' + textValue + ']'+'count'+count.to_s
                    macdHistogramValue = textValue.to_f
                  end

                  #빨간 > 파란 -> #빨간 < 파란 이 되는 시점이 매수
                  if count ==  2
                    beforeBlueValue = nowBlueValue
                     puts '2 macdBlueValue = [' + textValue + ']'+'count'+count.to_s
                     nowBlueValue = textValue.to_f
                  end

                  if count ==  3
                    beforeRedValue = nowRedValue
                    puts '3 macdRedValue = [' + textValue + ']'+'count'+count.to_s
                    nowRedValue = textValue.to_f
                  end

                  if count ==  7
                    lastValue = textValue.to_f
                    puts '7 lastValue = [' + textValue + ']'+'count'+count.to_s
                  end

                  if count ==  10
                    conversionLineValue = textValue.to_f
                    puts '10 Conversion Line = [' + textValue + ']'+'count'+count.to_s
                  end
                  
              end # bandlist array End
              
          


              #매수매도 신호 : ${msg}
              #시가 : ${initValue}
              #고가 : ${highValue}
              #저가 : ${lowValue}
              #종가 : ${lastValue}
              #ConversionLine  : ${conversionLine  }
              #Histogram : ${histogram }
              #Macd : ${macd }
              #Macd Signal : ${macdSignal}
              
              #바이 시그날
              #양봉 2번 나왔을때
              #양봉 2번다 전환점 이상가격이였을때
              #

            

              if  ( ( beforeBlueValue.to_f < beforeRedValue.to_f ) && ( nowBlueValue.to_f > nowRedValue.to_f )   ) 
                turnMacdSignal = 1 #상승전환
              elsif  ( ( beforeBlueValue.to_f > beforeRedValue.to_f  ) && ( nowBlueValue.to_f < nowRedValue.to_f ) ) 
                turnMacdSignal = 0 #하락전환
              end
              
    
              if macdBlueValue < macdRedValue
                macdSignal = 0 # 하락 
              else
                macdSignal = 1 # 상승 
              end
              puts  'initValue['+ initValue.to_s+']'
              puts  'highValue['+ highValue.to_s+']'
              puts  'lowValue['+ lowValue.to_s+']'
              puts  'lastValue['+ lastValue.to_s+']'
              puts  'Conversion Line['+conversionLineValue.to_s+']'
              puts  'macdHistogramValue['+ macdHistogramValue.to_s+']'
              puts  'nowBlueValue['+ nowBlueValue.to_s+']'
              puts  'nowRedValue['+ nowRedValue.to_s+']'
              puts  'beforeBlueValue['+beforeBlueValue.to_s+']'
              puts  'beforeRedValue['+beforeRedValue.to_s+']'
              puts  'turnMacdSignal['+turnMacdSignal.to_s+']' 
              
              
              
              
              
              #
              #bollanger band 위면 매수 2
              #imok 시그날 위면 매수 1
            
              if  (  turnMacdSignal == 1  && (  conversionLineValue.to_f  <  lastValue.to_f  )    )
                puts 'Buy Sign!!!!!!!!!!'
                  turnMacdSignal  = -1
                  @watir.execute_script('window.open("https://miraclepushserver.firebaseapp.com/?signal=buyBTCKRW&initValue='+initValue.to_s+'&highValue='+highValue.to_s+'&lowValue='+lowValue.to_s+'&lastValue='+lastValue.to_s+'&conversionLine='+conversionLineValue.to_s+'&nowBlueValue='+nowBlueValue.to_s+'&nowRedValue='+nowRedValue.to_s+'")')
                  #                                                                                                             1                                       2                                                    3                                                          4                                                       5                                                                  6                                                                                        7                                                                      8                         
                  @watir.windows.last.close
                  sleep(1)
                  @watir.windows.first.use
                  sleep(2)
                  mouse_move(mouseXpoint,mouseYpoint)
                  left_click
                  
                  time1 = Time.new
                puts "Current Time S : " + time1.inspect
              end
              if  ( turnMacdSignal == 0  && (  conversionLineValue.to_f  >  lastValue.to_f  )  )
                turnMacdSignal  = -1
                puts 'Sell Sign!!!!!!!!!!'
                  @watir.execute_script('window.open("https://miraclepushserver.firebaseapp.com/?signal=sellBTCKRW&initValue='+initValue.to_s+'&highValue='+highValue.to_s+'&lowValue='+lowValue.to_s+'&lastValue='+lastValue.to_s+'&conversionLine='+conversionLineValue.to_s+'&nowBlueValue='+nowBlueValue.to_s+'&nowRedValue='+nowRedValue.to_s+'")')
                  @watir.windows.last.close
                  sleep(1)
                  @watir.windows.first.use
                  sleep(2)
                  mouse_move(mouseXpoint,mouseYpoint)
                  left_click
                  
                  time1 = Time.new
                puts "Current Time S : " + time1.inspect
              end
            end
            sleep(0.5)
          end
      else
        # 카카오로그인 성공 못할시
        
      end
      
    rescue Exception => e
      puts "loginDo Fail"
      self.loginDo  
    ensure
    end
  end

  


end



doTask = NaverTest.new('capmo1@naver.com','Dnjzm1324!') 
doTask.loginDo

#doTask = NaverTest.new('cityrabbit25@naver.com','jh450045') 
#doTask.loginDo


#doTask = NaverTest.new('kzero0708@naver.com','shikishiki@78')
#doTask.loginDo





# 새로운 브라우저창 컨트롤
#browser.window(:title => "annoying popup").use do
#  browser.button(:id => "close").click
#end
