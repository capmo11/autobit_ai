class CoinDto
  
  attr_accessor :initValue,:highValue,:lowValue,:lastValue,:macdHistogramValue,:macdBlueValue,:macdRedValue,:beforeBlueValue,:beforeRedValue,:nowBlueValue,:nowRedValue,:beforeIchimokuValue,:nowIchimokuValue,:conversionLineValue,:macdSignal,:turnMacdSignal
  
  def initValue
    @initValue
  end
  def highValue
    @highValue
  end
  def lowValue
     @lowValue
  end   
  def lastValue
     @lastValue
  end
  def macdHistogramValue
     @macdHistogramValue
  end
  def macdBlueValue
     @macdBlueValue
  end
  def macdRedValue
     @macdRedValue
  end
  def beforeIchimokuValue
     @beforeIchimokuValue
  end
  def nowIchimokuValue
     @nowIchimokuValue
  end
  def conversionLineValue
     @conversionLineValue
  end
  def macdSignal
     @macdSignal
  end
  def turnMacdSignal
     @turnMacdSignal
  end
  

  def initValue=(initValue)
     @initValue = initValue
  end
  def highValue=(highValue)
    @highValue= highValue
  end
  def lowValue=(lowValue)
     @lowValue= lowValue
  end   
  def lastValue=(lastValue)
     @lastValue= lastValue
  end
  def macdHistogramValue=(macdHistogramValue)
     @macdHistogramValue= macdHistogramValue
  end
  def macdBlueValue=(macdBlueValue)
     @macdBlueValue= macdBlueValue
  end
  def macdRedValue=(macdRedValue)
     @macdRedValue= macdRedValue
  end
  def beforeIchimokuValue=(beforeIchimokuValue)
     @beforeIchimokuValue= beforeIchimokuValue
  end
  def nowIchimokuValue=(nowIchimokuValue)
     @nowIchimokuValue= nowIchimokuValue
  end
  def conversionLineValue=(conversionLineValue)
     @conversionLineValue= conversionLineValue
  end
  def macdSignal=(macdSignal)
      @macdSignal= macdSignal
  end
  def turnMacdSignal=(turnMacdSignal)
      @turnMacdSignal= turnMacdSignal
  end
  
  
  
  
  
  
          
  
end