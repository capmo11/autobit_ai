require 'rubygems'
require 'watir'
require 'time'
require 'timeout'

#서비스 이용정지 
#https://auth.band.us/get_user_account_status?next_url=http://band.us&signature=8P8Lt9CtplcyKDMaZNhy6eM%2Fn34M0K8np6BTNFBWTac%3D&token=45b4c355284549daf2a0513aaa0c9e298e21a2bf&user_no=10156050
class NaverTest
  
  #TODO 크롬 , 인터넷IE 로직도 추가
  #initialize :: param setting
  attr_accessor :server, :loginId, :loginPw, :watir , :bandloop_Cnt , :exceptionCnt
  
  def initialize(loginId,loginPw)
    time1 = Time.new
    puts "Current Time : " + time1.inspect
    @loginId = loginId
    @loginPw = loginPw
    @server = 'http://www.naver.com'
    @watir = Watir::Browser.new :firefox #chrome 
    @watir.goto "#{@server}"
    @bandloop_Cnt = 0
    @exceptionCnt = 0
    #@watir.window.resize_to(600, 700)
    puts "initialize setting!"
    #puts '[' +"#{@bandList_Array}".length.to_s   + ']' 
  end

  #httpRespons Method
  def httpResponsCheck
    begin
      uri = URI(@watir.url)
      res = Net::HTTP.get_response(uri)
      return res.code
    rescue Exception => e
      puts 'httpResponsCheck Exception'
      exceptionCnt++
      if(exceptionCnt < 5 )
        puts self.httpResponsCheck
      else
        self.loginDo
      end
      
    end
      
  end
  
  #Naver login logic 
  def loginDo
    begin
      puts "Naver login logic Start"
      @watir.text_field(:id=>'id').value = "#{@loginId}"
      @watir.text_field(:id=>'pw').value = "#{@loginPw}"
      @watir.span(:class ,'btn_login').click
      uri = URI(@watir.url)
      res = Net::HTTP.get_response(uri)
      #puts res.code 
      if  httpResponsCheck == '200'
        puts "Naver login Success"
        self.loginBandDo
      else
        self.loginDo
      end
    rescue Exception => e
      puts "loginDo Fail"
      self.loginDo
    ensure
    end
  end

  #Naver Band Login logic 
  def loginBandDo
    begin
      puts "Band Login logic Start"

      @watir.goto "https://auth.band.us/login_page?next_url=http%3A%2F%2Fband.us%2F"
      @watir.a(:class ,'uBtn -icoType -naver').click
      
      if httpResponsCheck == '200'
        puts "Band Login logic Success"
        self.bandListDo
      else
        self.loginBandDo
      end
    rescue Exception => e
      puts "loginBandDo Fail"
      self.loginBandDo
    end
  end

  #Naver BandList Login logic 
  def bandListDo
    begin
      puts "bandlist"
      if httpResponsCheck != '200'
        self.bandListDo
      else
        sleep(5)
        bandList_Array = @watir.ps(:class => /uriText/ ).collect(&:text)
        #bandList_Array = @watir.spans(:class => /uriText/ ).collect(&:text)
        
        #네이버 밴드 리스트 중복 제거 
        puts bandList_Array.length.to_s   
        bandList_Array.sort
        bandList_Array.delete('밴드 만들기')
        bandList_Array.delete('밴드 가이드')
        bandList_Array.delete('베가 컨플릭트 한국 채널(VCKC)')
        bandList_Array.delete('[VCFB] 베가컨플릭트 자유게시판')

        puts 'bandList_Array List Count [ '+bandList_Array.length.to_s + ']'
        puts 'bandList_Array List Chk Start '
        bandList_Array.each do |textValue|
          puts 'bandList_Array List Chk = [' + textValue + ']'
        end
        puts 'bandList_Array List Chk End'
        if bandList_Array.length == 0
          puts 'bandListDo list loding .. Waiting...'
          sleep(5)
          self.bandListDo
        else
          
          puts 'bandListDd Success Next bandWriteTask... '
          self.bandWriteTask(bandList_Array)
        end
      end

      rescue Exception => e
      puts "bandListDo Fail"
      self.bandListDo
    end
  end

  def bandWriteTask(bandList_Array) 
    begin
      time1 = Time.new
      for i in 0..4
        puts "Current Time S : " + time1.inspect
        loopingCnt = 0
        writeButtonExistCnt = 0 
        puts 'bandWriteTask start'
        puts '[' +bandList_Array.length.to_s  + ']' 
        bandList_Array.each do |textValue|
    
          puts 'Band skinName = [' + textValue + ']' + ' Loop Cnt = [' + loopingCnt.to_s + ']'
          #puts 'Band CntValue S = [' + link_BandName.length.to_s + ']'
          sleep(3)
          #네이버 밴드 리스트
          #@watir.span(:text ,textValue).click
          @watir.p(:text ,textValue).click
          uri = URI(@watir.url)
          puts uri
            
          if( uri == 'http://band.us/')
            puts 'out looping'
          else
              #글씨기 버튼누르기
            while true
              sleep(1)
              writeButtonExistCnt = writeButtonExistCnt + 1
              puts writeButtonExistCnt
              #puts '_btnOpenWriteLayer exists? ' 
              break if  @watir.button(:class ,'cPostWriteEventWrapper _btnOpenWriteLayer').exists? == true  or writeButtonExistCnt > 5
            end
          
            #글쓰기 버튼이 없으면 루프를 빠져나온다.
            if writeButtonExistCnt > 5
              puts 'writeButtonExistCnt loop'
              writeButtonExistCnt = 0
              loopingCnt = loopingCnt + 1
              @watir.goto "http://band.us/#!/"
              next  
            end
            @watir.button(:class ,'cPostWriteEventWrapper _btnOpenWriteLayer').click

            
            #네이버 밴드 join 후 글쓰기 창이 있는지?
            #contentEditor _richEditor skin11 cke_editable cke_editable_inline cke_contents_ltr placeholder
            while true
              sleep(1) 
              #puts 'contentEditor exists? ' 
              break if @watir.div(:class ,'contentEditor').exists? == true
            end
            @watir.div(:class ,'contentEditor').click
            sleep(1)


          
            @watir.div(:class ,'contentEditor').send_keys [:control, 'v']
            #@watir.div(:class ,'contentEditor').send_keys '안녕?!'
            sleep(1)
            
#            uButton -sizeM _btnSubmitPost -confirm
          
            @watir.button(class: ['uButton', '-sizeM', '_btnSubmitPost', '-confirm']).click  
            while true
              
              #puts '_btnSubmitPost -active exists? ' 
              #break if @watir.button(:class ,'uButton -point _btnSubmitPost -active').exists? == false
              break if @watir.button(class: ['uButton', '-sizeM', '_btnSubmitPost', '-confirm']).exists? == false
            end
            #link_Band.delete(textValue)
            @watir.goto "http://band.us/#!/"
            #puts 'Band CntValue E = [' + link_Band.length.to_s + ']'
            loopingCnt = loopingCnt + 1
           

          end

          
        end
        puts '10 Minute.. Counting'
        
        for i in 0..120
          sleep(30)
          puts '5 second.. Counting.. End Counting 120 ['+i.to_s+']'
        
          #puts "Current Time E : " + time1.inspect
        end

        
      end
    rescue Exception => e
      puts "bandWriteTask Fail => ["+loopingCnt.to_s+']'
    end
    
  end

end

doTask = NaverTest.new('capmo1','Dnjzm1324!') 
doTask.loginDo

#doTask = NaverTest.new('finance_jh@naver.com','dnjzm1324!') 
#doTask.loginDo

#doTask = NaverTest.new('kzero0708@naver.com','shikishiki@78')
#doTask.loginDo