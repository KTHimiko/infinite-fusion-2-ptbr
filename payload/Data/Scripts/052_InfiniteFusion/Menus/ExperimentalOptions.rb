
module OptionTypes
  WILD_POKE = 0
  TRAINER_POKE = 1
end

class ExperimentalOptionsScene < PokemonOption_Scene
  def initialize
    super
    @openTrainerOptions = false
    @openWildOptions = false
    @openGymOptions = false
    @openItemOptions = false
    $game_switches[SWITCH_RANDOMIZED_AT_LEAST_ONCE] = true
  end

  def getDefaultDescription
    return _INTL("Configure o Randomizer")
  end

  def pbStartScene(inloadscreen = false)
    super
    @changedColor = true
    @sprites["title"] = Window_UnformattedTextPokemon.newWithSize(
      _INTL("Opções experimentais"), 0, 0, Graphics.width, 64, @viewport)
    @sprites["textbox"].text = getDefaultDescription
    pbFadeInAndShow(@sprites) { pbUpdate }
  end

  def pbGetOptions(inloadscreen = false)
    options = []

    if Settings::KANTO
      options << EnumOption.new(_INTL("Expert mode (beta)"), [_INTL("On"), _INTL("Off")],
                                proc {
                                  $game_switches[SWITCH_EXPERT_MODE] ? 0 : 1
                                },
                                proc { |value|
                                  $game_switches[SWITCH_EXPERT_MODE] = value == 0
                                }, _INTL("Muda todas as equipes de trainers para deixá-las o mais desafiadoras possível!")
      )
    end

    options << EnumOption.new(_INTL("No levels mode"), [_INTL("On"), _INTL("Off")],
                     proc {
                       $game_switches[SWITCH_NO_LEVELS_MODE] ? 0 : 1
                     },
                     proc { |value|
                       $game_switches[SWITCH_NO_LEVELS_MODE] = value == 0
                     }, _INTL("Todos os Pokémon usam seus atributos base, independentemente dos levels.")
      )
    options << EnumOption.new(_INTL("Reversed mode"), [_INTL("On"), _INTL("Off")],
                     proc {
                       $game_switches[SWITCH_REVERSED_MODE] ? 0 : 1
                     },
                     proc { |value|
                       $game_switches[SWITCH_REVERSED_MODE] = value == 0
                     }, _INTL("Inverte as fusões de todos os trainers do jogo.")
      )
    return options
  end


end
