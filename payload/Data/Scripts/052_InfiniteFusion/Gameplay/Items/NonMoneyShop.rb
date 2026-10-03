class VariableCurrencyMartAdapter < PokemonMartAdapter
  def initialize(currency)
    @currency_variable = currency
  end
  def getMoney
    return pbGet(@currency_variable).to_i
  end

  def getMoneyString
    return pbGet(@currency_variable).to_s
  end

  def setMoney(value)
    pbSet(@currency_variable,value)
  end
end


def pbVariablePokemonMart(stock,currencyVariable,currency_name="Points",speech=nil,cantsell=true)
  for i in 0...stock.length
    stock[i] = GameData::Item.get(stock[i]).id
    stock[i] = nil if GameData::Item.get(stock[i]).is_important? && $PokemonBag.pbHasItem?(stock[i])
  end
  stock.compact!
  commands = []
  cmdBuy  = -1
  cmdSell = -1
  cmdQuit = -1
  commands[cmdBuy = commands.length]  = _INTL("Comprar")
  #commands[cmdSell = commands.length] = _INTL("Sell") if !cantsell
  commands[cmdQuit = commands.length] = _INTL("Sair")
  cmd = pbMessage(
    speech ? speech : _INTL("Bem-vindo! Como posso ajudar?"),
    commands,cmdQuit+1)
  loop do
    if cmdBuy>=0 && cmd==cmdBuy
      adapter = VariableCurrencyMartAdapter.new(currencyVariable)
      scene = PokemonMart_Scene.new(currency_name)
      screen = PokemonMartScreen.new(scene,stock,adapter)
      screen.pbBuyScreen
    elsif cmdSell>=0 && cmd==cmdSell    #NOT IMPLEMENTED
      scene = PokemonMart_Scene.new(currency_name)
      screen = PokemonMartScreen.new(scene,stock,adapter)
      screen.pbSellScreen
    else
      pbMessage(_INTL("Volte sempre!"))
      break
    end
    cmd = pbMessage(_INTL("Posso ajudar com mais alguma coisa?"),
                    commands,cmdQuit+1)
  end
  $game_temp.clear_mart_prices
end