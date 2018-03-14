require 'rubygems'
require 'watir'
require 'time'
require 'timeout'
require 'net/https'
require 'uri'
require 'Win32API'
#require 'auto_click'
#require 'win32/sound'
require 'open3'
#include Win32
#require_relative './CoinDto.rb'
Selenium::WebDriver::Chrome.driver_path = File.join(File.absolute_path('./', "C:/Ruby24-x64/bin/chromedriver.exe"))    

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
  attr_accessor :server, :loginId, :loginPw, :watir , :bandloop_Cnt , :exceptionCnt , :data , :targetingCoin , :beforeArray  , :nowArray , :beforeTranValue , :nowTranValue  
  


  def initialize(loginId,loginPw)
    
    #puts "Current Time : " + time1.inspect
    @loginId = loginId
    @loginPw = loginPw
    #@server = 'https://kr.tradingview.com/'
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
      
      
    puts "initialize setting!"
    #puts '[' +"#{@bandList_Array}".length.to_s   + ']' 
  end

  
  
  def telegramLogin
       begin
       #474059759:AAFM24fbUFVyEhFN6bCszocGgdUqWyJqbxA  => token  id => 323422607
       # https://api.telegram.org/bot474059759:AAFM24fbUFVyEhFN6bCszocGgdUqWyJqbxA/sendmessage?chat_id=323422607&text=good =>나한테 문자보내기
       # http://www.convertstring.com/ko/EncodeDecode/UrlEncode 인코딩 주소  hihi %0d%0a Thanks %0d%0a ok   || %0d%0a 코드가 엔터코드
       @watir.execute_script(' window.open("https://web.telegram.org/#/login")')
       sleep(1)
       @watir.windows.last.use
       @watir.window(:title => "Telegram Web").use do
       @watir.text_field(:name=>'phone_number').value = "01020813240"
       @watir.a(:class ,'login_head_submit_btn').click
       @watir.button(:class ,'btn btn-md btn-md-primary').click
       sleep(30)
       
       @watir.goto "https://web.telegram.org/#/im?p=u329474625_7322225066492776527"
       end 
       sleep(5)
       
       #@watir.div(:class ,'composer_rich_textarea').send_keys [:control, '사랑해']
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
        sleep(1) 
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
      
      #class
      #right right_padding_none click up 상향
      #right right_padding_none click down 하향
      #ico-rate-down 하향화살표 ico-rate-down2 폭락화살표  
    
    
      
      
     #countValue = 0  
     #@targetingCoin = ""
     #   
     #
     #@watir.execute_script(' window.open("https://www.bithumb.com")')
     #sleep(1.5)
     #@watir.window(:title => "빗썸 - 대한민국 1등 암호화폐 거래소").use
     #
     ## 팝업 다 삭제
     #@watir.execute_script('fnLayerClose("layerBanner_hack")')
     #sleep(0.2)
     #@watir.execute_script('fnLayerClose("layerBanner_security")')
     #sleep(0.2)
     #@watir.execute_script('fnLayerClose("layerBanner_free")')
     #sleep(0.2)
     #@watir.execute_script('fnLayerClose("layerBanner_security")')
     #sleep(0.2)
     #
     #      
     #sleep(1.5)
     #@watir.select_list(:id => 'selectRealTick').option(:index, 3).select
     #sleep(2)
     #@watir.span(:id=>'assetRealBTC2KRW' ).click
     #
     #
     #btcValue = @watir.span(:id=>'assetRealBTC2KRW' ).text.gsub(/[^\d]/, '').to_i 
     #ethValue = @watir.span(:id=>'assetRealETH2KRW' ).text.gsub(/[^\d]/, '').to_i 
     #dashValue = @watir.span(:id=>'assetRealDASH2KRW').text.gsub(/[^\d]/, '').to_i 
     #ltcValue = @watir.span(:id=>'assetRealLTC2KRW' ).text.gsub(/[^\d]/, '').to_i 
     #etcValue = @watir.span(:id=>'assetRealETC2KRW' ).text.gsub(/[^\d]/, '').to_i 
     #xrpValue = @watir.span(:id=>'assetRealXRP2KRW' ).text.gsub(/[^\d]/, '').to_i 
     #bchValue = @watir.span(:id=>'assetRealBCH2KRW' ).text.gsub(/[^\d]/, '').to_i 
     #xmrValue = @watir.span(:id=>'assetRealXMR2KRW' ).text.gsub(/[^\d]/, '').to_i 
     #zecValue = @watir.span(:id=>'assetRealZEC2KRW' ).text.gsub(/[^\d]/, '').to_i 
     #qtumValue = @watir.span(:id=>'assetRealQTUM2KRW').text.gsub(/[^\d]/, '').to_i
     #btgValue = @watir.span(:id=>'assetRealBTG2KRW').text.gsub(/[^\d]/, '').to_i  
     #
     #
     #
     ##상향인지 하향인지 확인하기
     #puts 'up down count ...'
     #puts @watir.spans(:class => 'ico-rate-up' ).length
     #puts @watir.spans(:class => 'ico-rate-up2' ).length
     #puts @watir.spans(:class => 'ico-rate-down' ).length
     #puts @watir.spans(:class => 'ico-rate-down2' ).length
     #    
     #
     #
     ##if(@watir.spans(:class => 'ico-rate-down2' ).length == 8)
     ##  uri = URI('https://api.telegram.org/bot474059759:AAFM24fbUFVyEhFN6bCszocGgdUqWyJqbxA/sendmessage?chat_id=323422607&text=DownSingal▼ = ' + @watir.spans(:class => 'ico-rate-down' ).length.to_s + '      ')
     ##  Net::HTTP.get(uri)
     ##end 
     ##if(@watir.spans(:class => 'ico-rate-down2' ).length == 8)
     ##  uri = URI('https://api.telegram.org/bot474059759:AAFM24fbUFVyEhFN6bCszocGgdUqWyJqbxA/sendmessage?chat_id=323422607&text=DownSingal  = ' + @watir.spans(:class => 'ico-rate-down' ).length.to_s + '      ')
     ##  Net::HTTP.get(uri)
     ##end
     #    
     #
     #
     #@nowTranValue = { "BTC"=> btcValue , "ETH" =>  ethValue , "DASH" => dashValue , "LTC" =>ltcValue ,"ETC"  =>etcValue,"XRP" =>xrpValue,"BCH" => bchValue,"XMR" =>xmrValue ,"ZEC"  =>zecValue, "QTUM"  =>qtumValue,"BTG"=> btgValue}
     #@beforeTranValue = @nowTranValue  
     #  
     #arrayRank = {}
     #countValue = 0    
     #@nowTranValue.sort_by {|k,v| v}.reverse.each do |key, value|
     #   countValue = countValue+1
     #   arrayRank[key] = countValue
     #end
     #
     ##@beforeArray.delete_if {|key, value| value < 5 } # 4위 이하는 삭제 !! 3위까지 들어옴!  
     #
     #@nowArray  = arrayRank.delete_if {|key, value| value > 5 }
     #
     #result = {}
     #@beforeArray.each {|k, v| result[k] =  @nowArray[k] if  @nowArray[k] != v }
     #
     #result2 = result.sort_by{ |x| x.last }.to_h
     # 
     #puts listValue
     #puts @beforeArray
     #puts @nowArray 
     #
     #@beforeArray = @nowArray   
     #  
     #if( !result2.empty? )
     #      Sound.beep(1000,500) # play a beep 600 hertz for 200 milliseconds
     #      Sound.beep(1000,700) # play a beep 600 hertz for 200 milliseconds
     #      Sound.beep(1000,900) # play a beep 600 hertz for 200 milliseconds
     #      Sound.beep(2000,900) # play a beep 600 hertz for 200 milliseconds
     #      
     # 
     #      puts '***************Change Rank...****************'
     #        result2.each do |key, value|
     #        puts '***************Key ...****************'
     #        puts key
     #        puts '***************Value...****************'
     #        puts value
     #         
     #          
     #        #@watir.execute_script('window.open("https://miraclepushserver.firebaseapp.com/?signal='+key+'")')
     #        #@watir.windows.last.close
     #        #sleep(1)
     #        #@watir.windows.first.use
     #        #sleep(2)
     #          
     #        
     #        break
     #        end
     #      puts '***************Change Rank...****************'
     #else
     #  puts 'Rank holding...'
     #  sleep(1)
     #end
     #
     #
     #
     #
     #@watir.window(:title => "빗썸 - 대한민국 1등 가상화폐 거래소").close
     #sleep(1)
     #@watir.windows.first.use
     #
      
      
      
      @watir.text_field(:class =>'symbol-edit').value = "BTCKRW"     
      @watir.send_keys :enter
      chartPageLoading
      # BTCKRW 비트코인  
      # POLONIEX:BCHUSD 비트코인캐시
      # XRPKRW 리플/원  
      # LTCUSD 라이트코인/달러 
      # BCHUSD 비트코인캐쉬 
      # ETHKRW 이더리움 
      # ETCKRW 이더리움클래식
      # @watir.send_keys :enter
      # chartPageLoading
      # @watir.span(:class ,'submenu interval-dialog-button apply-common-tooltip').click
      # @watir.send_keys '1M' # '1D'
      # @watir.send_keys :enter
      # chartPageLoading
       @watir.span(:class ,'submenu interval-dialog-button apply-common-tooltip').click
       @watir.send_keys '5' # '1D' ## 기간 설정
       @watir.send_keys :enter
      chartPageLoading
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

          
          # krchart load Data ... 
          # -14000.5374[1] macd histogram X
          # -37768.7063[2] macd 파란선 파란선이 위에있어야 매수
          # -23768.1688[3] macd 빨간선 파란선이 밑에있으면 매도
          # 16302000.0[4]  시
          # 16401000.0[5]  고
          # 16302000.0[6]  저
          # 16338000.0[7]  종
          # 16430250.0000[8] 볼린저밴드
          # 16579773.4095[9] 볼린저밴드
          # 16280726.5905[10] 볼린저밴드
          # 16390750.0000[11]  일목균형표
          # 16425000.0000[12]  일목균형표
          # 16338000.0000[13]  일목균형표
          # 16380250.0000[14]  일목균형표
          # 16418250.0000[15]  일목균형표
          # 3[16]
          # 7[17]
          # 16340600.0000[18] 5일선
          # 16363900.0000[19] 10일선
          # 16430250.0000[20] 20일선
          # 16437366.6667[21] 60일선
          # 41.0106[22] rsi


          ##초기값 셋팅
          bandList_Array = @watir.spans(:class => 'pane-legend-item-value pane-legend-line' ).collect(&:text)
                  puts 'bandList_Array List Count [ '+bandList_Array.length.to_s + ']'
                  count = 0 
                  
                  bandList_Array.each do |textValue|
                    count = count + 1
                    puts textValue+'['+count.to_s+']'
                  end
                  
                  bandList_Array.each do |textValue|
                    count = count + 1
                  
                    if count ==  1
                    # puts '1 macdHistogramValue = [' + textValue + ']'+'count'+count.to_s
                      macdHistogramValue = textValue.to_f
                    end
                    #빨간 > 파란 -> #빨간 < 파란 이 되는 시점이 매수
                    if count ==  2
                      nowBlueValue = textValue.to_f
                    #   puts '2 macdBlueValue = [' + textValue + ']'+'count'+count.to_s
                    end
  
                    if count ==  3 
                      nowRedValue = textValue.to_f
                      puts '3 macdRedValue = [' + textValue + ']'+'count'+count.to_s
                    end
  
                    if count ==  4 #시가
                      initValue =  textValue.to_f
                    # puts '4 initValue = [' + textValue + ']'+'count'+count.to_s
                    end
  
                    if count ==  5 #고가
                      highValue =  textValue.to_f
                    # puts '5 highValue = [' + textValue + ']'+'count'+count.to_s
                    end
                    if count ==  6 #저가
                      lowValue =  textValue.to_f
                    # puts '6 lowValue = [' + textValue + ']'+'count'+count.to_s
                    end
                    if count ==  7 #종가
                      lastValue =  textValue.to_f
                    # puts '7 lastValue = [' + textValue + ']'+'count'+count.to_s
                    end
                    if count ==  10
                      conversionLineValue = textValue.to_f
                    # puts '10 Conversion Line = [' + textValue + ']'+'count'+count.to_s
                  end

                  
          end # bandlist array End
          
          if macdBlueValue < macdRedValue
            macdSignal = 0 # 하락 
          else
            macdSignal = 1 # 상승 
          end
          
        
          
          puts  'PriceData => initValue['+ initValue.to_s+']'+' highValue['+ highValue.to_s+']'+' lowValue['+ lowValue.to_s+']'+' lastValue['+ lastValue.to_s+']'+' Conversion Line['+conversionLineValue.to_s+']'
          puts  'Signal Data => macdHistogramValue['+ macdHistogramValue.to_s+']'+' nowBlueValue['+ nowBlueValue.to_s+']'+' nowRedValue['+ nowRedValue.to_s+']'+' beforeBlueValue['+beforeBlueValue.to_s+']'+' beforeRedValue['+beforeRedValue.to_s+']'+' turnMacdSignal['+turnMacdSignal.to_s+']'      
          
            
    
        
          while true
            timeValue = @watir.span(:class , 'chart-controls-clock').text
          
            timeMinute = timeValue[3..4] #분 
            timeSecond = timeValue[6..7] #초
            
              
            if timeSecond == "00"
              mouse_move(mouseXpoint,mouseYpoint)
              left_click
              sleep(1)
            end
            
            
           #if  ( (timeSecond == "00" && timeMinute == "00") ||  (timeSecond == "00" && timeMinute == "30")  )
           #if  ( (timeSecond == "00" && timeMinute == "15") ||  (timeSecond == "00" && timeMinute == "30") ||  (timeSecond == "00" && timeMinute == "45")  ||  (timeSecond == "00" && timeMinute == "00")   )
           #if   timeSecond == "00"
            
           if  ( (timeSecond == "00" && timeMinute == "05") ||  (timeSecond == "00" && timeMinute == "10") ||  (timeSecond == "00" && timeMinute == "15")  ||  (timeSecond == "00" && timeMinute == "20")  ||  (timeSecond == "00" && timeMinute == "25")  ||  (timeSecond == "00" && timeMinute == "30")  ||  (timeSecond == "00" && timeMinute == "35")   ||  (timeSecond == "00" && timeMinute == "40")  ||  (timeSecond == "00" && timeMinute == "45")  ||  (timeSecond == "00" && timeMinute == "50")  ||  (timeSecond == "00" && timeMinute == "55")     )
            
             
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
                   #  puts '1 macdHistogramValue = [' + textValue + ']'+'count'+count.to_s
                    macdHistogramValue = textValue.to_f
                  end

                  #빨간 > 파란 -> #빨간 < 파란 이 되는 시점이 매수
                  if count ==  2
                    beforeBlueValue = nowBlueValue
                  #   puts '2 macdBlueValue = [' + textValue + ']'+'count'+count.to_s
                     nowBlueValue = textValue.to_f
                  end

                  if count ==  3
                    beforeRedValue = nowRedValue
                  # puts '3 macdRedValue = [' + textValue + ']'+'count'+count.to_s
                    nowRedValue = textValue.to_f
                  end

                  if count ==  7
                    lastValue = textValue.to_f
                  # puts '7 lastValue = [' + textValue + ']'+'count'+count.to_s
                  end

                  if count ==  10
                    conversionLineValue = textValue.to_f
                  # puts '10 Conversion Line = [' + textValue + ']'+'count'+count.to_s
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
              
              puts  'PriceData => initValue['+ initValue.to_s+']'+' highValue['+ highValue.to_s+']'+' lowValue['+ lowValue.to_s+']'+' lastValue['+ lastValue.to_s+']'+' Conversion Line['+conversionLineValue.to_s+']'
              puts  'Signal Data => macdHistogramValue['+ macdHistogramValue.to_s+']'+' nowBlueValue['+ nowBlueValue.to_s+']'+' nowRedValue['+ nowRedValue.to_s+']'+' beforeBlueValue['+beforeBlueValue.to_s+']'+' beforeRedValue['+beforeRedValue.to_s+']'+' turnMacdSignal['+turnMacdSignal.to_s+']'      
                   
              
              
              
              
              #
              #bollanger band 위면 매수 2
              #imok 시그날 위면 매수 1
            
              if  (  turnMacdSignal == 1  && (  conversionLineValue.to_f  <  lastValue.to_f  )    )
                puts 'Buy Sign!!!!!!!!!!'
                  turnMacdSignal  = -1
                  
                  #@watir.execute_script('window.open("https://miraclepushserver.firebaseapp.com/?signal=buyBTCKRW&initValue='+initValue.to_s+'&highValue='+highValue.to_s+'&lowValue='+lowValue.to_s+'&lastValue='+lastValue.to_s+'&conversionLine='+conversionLineValue.to_s+'&nowBlueValue='+nowBlueValue.to_s+'&nowRedValue='+nowRedValue.to_s+'")')
                                    #                                                                                                             1                                       2                                                    3                                                          4                                                       5                                                                  6                                                                                        7                                                                      8
                  
                  uri = URI('https://api.telegram.org/bot474059759:AAFM24fbUFVyEhFN6bCszocGgdUqWyJqbxA/sendmessage?chat_id=323422607&text=Buy%0d%0a'+lastValue.to_s+'%0d%0aok')
                  Net::HTTP.get(uri)
                  
                  stdout, stdeerr, status = Open3.capture3("java -cp C:/eclipse-workspace/ApiClient/bin;C:/eclipse-workspace/ApiClient/lib/jackson-all-1.9.11.jar;C:/eclipse-workspace/ApiClient/lib/guava-18.0.jar;C:/eclipse-workspace/ApiClient/lib/commons-codec-1.10.jar javaApi.Main buy BTC")
                  
                  puts 'Command BitSum Api'
                  puts stdout
                  puts status
                                           
                  #@watir.windows.last.close
                  #sleep(1)
                  #@watir.windows.first.use
                  #sleep(2)
                  mouse_move(mouseXpoint,mouseYpoint)
                  left_click
                  
                  time1 = Time.new
                puts "Current Time S : " + time1.inspect
              end
                if  ( turnMacdSignal == 0  && (  conversionLineValue.to_f  >  lastValue.to_f  )  )
             
                  puts 'Sell Sign!!!!!!!!!!'
                  turnMacdSignal  = -1
                    #@watir.execute_script('window.open("https://miraclepushserver.firebaseapp.com/?signal=sellBTCKRW&initValue='+initValue.to_s+'&highValue='+highValue.to_s+'&lowValue='+lowValue.to_s+'&lastValue='+lastValue.to_s+'&conversionLine='+conversionLineValue.to_s+'&nowBlueValue='+nowBlueValue.to_s+'&nowRedValue='+nowRedValue.to_s+'")')
                    uri = URI('https://api.telegram.org/bot474059759:AAFM24fbUFVyEhFN6bCszocGgdUqWyJqbxA/sendmessage?chat_id=323422607&text=Sell%0d%0a'+lastValue.to_s+'%0d%0aok')
                    Net::HTTP.get(uri)
                    
                    stdout, stdeerr, status = Open3.capture3("java -cp C:/eclipse-workspace/ApiClient/bin;C:/eclipse-workspace/ApiClient/lib/jackson-all-1.9.11.jar;C:/eclipse-workspace/ApiClient/lib/guava-18.0.jar;C:/eclipse-workspace/ApiClient/lib/commons-codec-1.10.jar javaApi.Main sell BTC")
                  
                    puts 'Command BitSum Api'
                    puts stdout
                    puts status
                                                  
                    #@watir.windows.last.close
                    #sleep(1)
                    #@watir.windows.first.use
                    #sleep(2)
                    mouse_move(mouseXpoint,mouseYpoint)
                    left_click
                    
                    time1 = Time.new
                  puts "Current Time S : " + time1.inspect
                  end
            end
            sleep(0.5)
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
