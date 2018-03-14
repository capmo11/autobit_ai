class KrChartDTO
  # 
  # initValue = 0 #시가
  # highValue = 0 #고가
  # lowValue = 0  #저가
  # lastValue = 0  # 종가
  # 
  # macdHistogramValue = 0 # Histogram ( 빨간 )
  # macdBlueValue = 0 # macd 파란   # 파란 > 빨간    =>   상승장
  # macdRedValue  = 0 # macd 빨간   # 파란 < 빨간    =>   하락장
  # 
  # beforeBlueValue =  0  # 전봉 macd Blue 값
  # beforeRedValue =  0 # 전봉 macd Red 값
  # nowBlueValue = 0 # 현재봉 macd Blue 값
  # nowRedValue = 0 # 현재봉 macd Blue 값
  # 
  # beforeIchimokuValue = 0 # 전봉 전환점값
  # nowIchimokuValue = 0 # 현재봉 전환점값
  # 
  # conversionLineValue = 0  #일목균형표 추세전환선
  # macdSignal = 0 # 1 macd 상승추세 , 0 하락추세 기점
  # turnMacdSignal =  -1 # 1 macd 상승 , 0 하락 기점  attr_accessor           :stochRedValue_3 , :stochBlueValue_3
 
   attr_accessor :initValue , :highValue , :lowValue ,  :lastValue , :bollangerCenterValue   , :bollangerHightValue , :bollangerLowValue
   attr_accessor :movingAverage_5 ,  :movingAverage_20 , :movingAverage_60 , :movingAverage_120 , :movingAverage_240   
   attr_accessor :stoch_5K3Day_RedValue , :stoch_5K3Day_BlueValue  , :stoch_12K3Day_RedValue , :stoch_12K3Day_BlueValue  , :stoch_12K9Day_RedValue , :stoch_12K9Day_BlueValue  , :stoch_20K12Day_RedValue , :stoch_20K12Day_BlueValue
   attr_accessor :stoch_before_5K3Day_RedValue , :stoch_before_5K3Day_BlueValue  , :stoch_before_12K3Day_RedValue , :stoch_before_12K3Day_BlueValue  , :stoch_before_12K9Day_RedValue , :stoch_before_12K9Day_BlueValue  , :stoch_before_20K12Day_RedValue , :stoch_before_20K12Day_BlueValue
   attr_accessor :deadCloss , :goldCloss
   attr_accessor :tradingSignal , :stoch_12k3DayTurnSignal , :stoch_12k9DayTurnSignal  # turnSignal  1이 상승  -1이 하락
   
    
  def set_tradingSignal ( tradingSignal )
         @tradingSignal = tradingSignal
    end
    def get_tradingSignal
         @tradingSignal
  end
      
  def set_stoch_12k3DayTurnSignal ( stoch_12k3DayTurnSignal )
         @stoch_12k3DayTurnSignal = stoch_12k3DayTurnSignal
    end
    def get_stoch_12k3DayTurnSignal
         @stoch_12k3DayTurnSignal
  end
  
  def set_stoch_12k9DayTurnSignal ( stoch_12k9DayTurnSignal )
         @stoch_12k9DayTurnSignal = stoch_12k9DayTurnSignal
    end
    def get_stoch_12k9DayTurnSignal
         @stoch_12k9DayTurnSignal
  end
  
   
   def set_initValue ( initValue )
          @initValue = initValue
     end
     def get_initValue
          @initValue
   end
   
   def set_highValue ( highValue )
          @highValue = highValue
     end
     def get_highValue
          @highValue
   end
   
   def set_lowValue ( lowValue )
          @lowValue = lowValue
     end
     def get_lowValue
          @lowValue
   end
   
   def set_lastValue ( lastValue )
          @lastValue = lastValue
     end
     def get_lastValue
          @lastValue
   end
   
   def set_bollangerCenterValue ( bollangerCenterValue )
          @bollangerCenterValue = bollangerCenterValue
     end
     def get_bollangerCenterValue
          @bollangerCenterValue
   end
   
  def set_bollangerHightValue ( bollangerHightValue )
           @bollangerHightValue = bollangerHightValue
      end
      def get_bollangerHightValue
           @bollangerHightValue
    end
    
      def set_bollangerLowValue ( bollangerLowValue )
            @bollangerLowValue = bollangerLowValue
       end
       def get_bollangerLowValue
            @bollangerLowValue
     end
     
   
   
   # 이평선 변수  시작    attr_accessor :movingAverage_5 ,  :movingAverage_20 , :movingAverage_60 , :movingAverage_120 , :movingAverage_240 
   def set_movingAverage_5 ( movingAverage_5 )
          @movingAverage_5 = movingAverage_5
     end
     def get_movingAverage_5
          @movingAverage_5
   end
     
   def set_movingAverage_20 ( movingAverage_20 )
        @movingAverage_20 = movingAverage_20
   end
   def get_movingAverage_20
        @movingAverage_20
   end
   
   def set_movingAverage_60 ( movingAverage_60 )
        @movingAverage_60 = movingAverage_60
   end
   def get_movingAverage_60
        @movingAverage_60
   end
   
   def set_movingAverage_120 ( movingAverage_120 )
        @movingAverage_120 = movingAverage_120
   end
   def get_movingAverage_120
        @movingAverage_120
   end
   
   def set_movingAverage_240 ( movingAverage_240 )
        @movingAverage_240 = movingAverage_240
   end
   def get_movingAverage_240
        @movingAverage_240
   end
   
  #스톡캐스틱 변수 시작 attr_accessor :stoch_5K3Day_RedValue , :stoch_5K3Day_BlueValue  , :stoch_10K6Day_RedValue , :stoch_10K6Day_BlueValue  , :stoch_20K12Day_RedValue , :stoch_20K12Day_BlueValue

   def set_stoch_5K3Day_RedValue ( stoch_5K3Day_RedValue )
        @stoch_5K3Day_RedValue = stoch_5K3Day_RedValue
   end
   def get_stoch_5K3Day_RedValue
        @stoch_5K3Day_RedValue
   end   
   
   def set_stoch_5K3Day_BlueValue ( stoch_5K3Day_BlueValue )
         @stoch_5K3Day_BlueValue = stoch_5K3Day_BlueValue
    end
    def get_stoch_5K3Day_BlueValue
         @stoch_5K3Day_BlueValue
    end 
   
   
   
   def set_stoch_12K3Day_RedValue ( stoch_12K3Day_RedValue )
        @stoch_12K3Day_RedValue = stoch_12K3Day_RedValue
   end
   def get_stoch_12K3Day_RedValue
        @stoch_12K3Day_RedValue
   end   
   
   def set_stoch_12K3Day_BlueValue ( stoch_12K3Day_BlueValue )
        @stoch_12K3Day_BlueValue = stoch_12K3Day_BlueValue
   end
   
   def get_stoch_12K3Day_BlueValue
        @stoch_12K3Day_BlueValue
   end   
   
   
  def set_stoch_12K9Day_RedValue ( stoch_12K9Day_RedValue )
         @stoch_12K9Day_RedValue = stoch_12K9Day_RedValue
    end
    def get_stoch_12K9Day_RedValue
         @stoch_12K9Day_RedValue
    end   
   
    def set_stoch_12K9Day_BlueValue ( stoch_12K9Day_BlueValue )
         @stoch_12K9Day_BlueValue = stoch_12K9Day_BlueValue
    end
    
    def get_stoch_12K9Day_BlueValue
         @stoch_12K9Day_BlueValue
    end   
    
    
   
   
   
   
   def set_stoch_20K12Day_RedValue ( stoch_20K12Day_RedValue )
        @stoch_20K12Day_RedValue = stoch_20K12Day_RedValue
   end
   def get_stoch_20K12Day_RedValue
        @stoch_20K12Day_RedValue
   end   
      
   def set_stoch_20K12Day_BlueValue ( stoch_20K12Day_BlueValue )
        @stoch_20K12Day_BlueValue = stoch_20K12Day_BlueValue
   end
   def get_stoch_20K12Day_BlueValue
        @stoch_20K12Day_BlueValue
   end   
   
   
   ############################### Before ############################## 
   

  def set_before_stoch_5K3Day_RedValue ( stoch_before_5K3Day_RedValue )
       @stoch_before_5K3Day_RedValue = stoch_before_5K3Day_RedValue
  end
  def get_before_stoch_5K3Day_RedValue
       @stoch_before_5K3Day_RedValue
  end   
  
  def set_before_stoch_5K3Day_BlueValue ( stoch_before_5K3Day_BlueValue )
        @stoch_before_5K3Day_BlueValue = stoch_before_5K3Day_BlueValue
   end
   def get_before_stoch_5K3Day_BlueValue
        @stoch_before_5K3Day_BlueValue
   end 
  
  
  
  def set_stoch_before_12K3Day_RedValue ( stoch_before_12K3Day_RedValue )
       @stoch_before_12K3Day_RedValue = stoch_before_12K3Day_RedValue
  end
  def get_stoch_before_12K3Day_RedValue
       @stoch_before_12K3Day_RedValue
  end   
  
  def set_stoch_before_12K3Day_BlueValue ( stoch_before_12K3Day_BlueValue )
       @stoch_before_12K3Day_BlueValue = stoch_before_12K3Day_BlueValue
  end
  
 def set_stoch_before_12K9Day_RedValue ( stoch_before_12K9Day_RedValue )
        @stoch_before_10K9Day_RedValue = stoch_before_12K9Day_RedValue
   end
   def get_stoch_before_19K3Day_RedValue
        @stoch_before_12K9Day_RedValue
   end   
   
   def set_stoch_before_12K9Day_BlueValue ( stoch_before_12K9Day_BlueValue )
        @stoch_before_12K9Day_BlueValue = stoch_before_12K9Day_BlueValue
   end
   
   def get_stoch_before_12K9Day_BlueValue
        @stoch_before_12K9Day_BlueValue
   end   
  
  
  
  
  def set_stoch_before_20K12Day_RedValue ( stoch_before_20K12Day_RedValue )
       @stoch_before_20K12Day_RedValue = stoch_before_20K12Day_RedValue
  end
  def get_stoch_before_20K12Day_RedValue
       @stoch_before_20K12Day_RedValue
  end   
     
  def set_stoch_before_20K12Day_BlueValue ( stoch_before_20K12Day_BlueValue )
       @stoch_before_20K12Day_BlueValue = stoch_before_20K12Day_BlueValue
  end
  def get_stoch_before_20K12Day_BlueValue
       @stoch_before_20K12Day_BlueValue
  end   
   
   
   
   
   
   
   
  #> require './Phone'  #! import class
  #> myphone = Phone.new  #! instantiate class Phone
  #> myphone.model = "iPhone5"  #! set model name
  #> myphone.model  #! get model name
   
end