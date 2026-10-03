class PokemonStorageScreen
  attr_accessor :fusionMode
  #
  # Fusion stuff
  #

  def pbFuseFromPC(selected, heldpoke)
    @scene.pbSetCursorMode("default")
    box = selected[0]
    index = selected[1]
    poke_body = @storage[box, index]
    poke_head = heldpoke
    if heldpoke
      if dexNum(heldpoke.species) > NB_POKEMON
        pbDisplay(_INTL("{1} já está fundido!", heldpoke.name))
        return
      end
      if (heldpoke.egg?)
        pbDisplay(_INTL("É impossível fundir um Egg!"))
        return
      end
    end

    splicerItem = selectSplicer()
    if splicerItem == nil
      cancelFusion()
      return
    end

    if !heldpoke
      @fusionMode = true
      @fusionItem = splicerItem
      @scene.setFusing(true, @fusionItem)
      pbHold(selected)
      pbDisplay(_INTL("Escolha um Pokémon para fundir com ele."))
      @scene.sprites["box"].disableFusions()

      return
    end
    if !poke_body
      pbDisplay(_INTL("Escolha um Pokémon para fundir com ele."))
      @fusionMode = true
      @fusionItem = splicerItem
      @scene.setFusing(true, @fusionItem)
      return
    end
  end

  def deleteHeldPokemon(heldpoke, selected)
    @scene.pbReleaseInstant(selected, heldpoke)
    @heldpkmn = nil
  end

  def deleteSelectedPokemon(heldpoke, selected)
    pbSwap(selected)
    deleteHeldPokemon(heldpoke, selected)
  end

  def cancelFusion
    pbSEPlay("GUI storage put down")
    @splicerItem = nil
    @scene.setFusing(false)
    @fusionMode = false
    @scene.sprites["box"].enableFusions()
  end

  def canDeleteItem(item)
    return item == :SUPERSPLICERS || item == :DNASPLICERS
  end

  def isSuperSplicer?(item)
    return item == :SUPERSPLICERS || item == :INFINITESPLICERS2
  end

  def pbFusionCommands(selected)
    heldpoke = pbHeldPokemon
    pokemon = @storage[selected[0], selected[1]]

    if !pokemon
      command = pbShowCommands(_INTL("Escolha uma ação"), [_INTL("Continuar fundindo"), _INTL("Parar de fundir")])
      case command
      when 1 # stop
        cancelFusion
      end
    else
      commands = [
        _INTL("Fundir"),
        _INTL("Trocar")
      ]
      commands.push(_INTL("Parar de fundir"))
      commands.push(_INTL("Cancelar"))

      if !heldpoke
        pbPlace(selected)
        @fusionMode = false
        @scene.setFusing(false)
        return
      end
      command = pbShowCommands(_INTL("Escolha uma ação"), commands)
      case command
      when 0 # Fuse
        if !pokemon
          pbDisplay(_INTL("Nenhum Pokémon selecionado!"))
          return
        else
          if dexNum(pokemon.species) > NB_POKEMON
            pbDisplay(_INTL("Este Pokémon já está fundido!"))
            return
          end
        end
        isSuperSplicer = isSuperSplicer?(@fusionItem)

        selectedHead, selected_sprite = selectFusion(pokemon, heldpoke, isSuperSplicer)
        if selectedHead == nil
          pbDisplay(_INTL("Isso não terá efeito."))
          return false
        end
        if selectedHead == -1 # cancelled out
          return false
        end

        selectedBase = selectedHead == pokemon ? heldpoke : pokemon
        firstOptionSelected = selectedBase == pokemon

        if (Kernel.pbConfirmMessage(_INTL("Fundir os dois Pokémon?")))
          playingBGM = $game_system.getPlayingBGM
          pbFuse(selectedHead, selectedBase, @fusionItem, selected_sprite)
          if canDeleteItem(@fusionItem)
            $PokemonBag.pbDeleteItem(@fusionItem)
          end
          if firstOptionSelected
            deleteSelectedPokemon(heldpoke, selected)
          else
            deleteHeldPokemon(heldpoke, selected)
          end

          @scene.setFusing(false)
          @fusionMode = false
          @scene.sprites["box"].enableFusions()
          pbBGMPlay(playingBGM)
          return
        else
          # print "fusion cancelled"
          # @fusionMode = false
        end
      when 1 # swap
        if pokemon
          if dexNum(pokemon.species) <= NB_POKEMON
            pbSwap(selected)
          else
            pbDisplay(_INTL("Este Pokémon já está fundido!"))
          end
        else
          pbDisplay(_INTL("Escolha um Pokémon!"))
        end
      when 2 # cancel
        cancelFusion()
        return
      end
    end
  end

  def reverseFromPC(selected)
    box = selected[0]
    index = selected[1]
    pokemon = @storage[box, index]

    if !pokemon.isFusion?
      scene.pbDisplay(_INTL("Isso não terá efeito."))
      return
    end
    if Kernel.pbConfirmMessage(_INTL("Should {1} be reversed?", pokemon.name))
      reverseFusion(pokemon)
      $PokemonBag.pbDeleteItem(:DNAREVERSER) if $PokemonBag.pbQuantity(:INFINITEREVERSERS) <= 0
    end
    @scene.pbHardRefresh
  end

  def pbUnfuseFromPC(selected)
    box = selected[0]
    index = selected[1]
    pokemon = @storage[box, index]

    if pbConfirm(_INTL("Desfundir {1}?", pokemon.name))
      item = selectSplicer()
      return if item == nil
      isSuperSplicer = isSuperSplicer?(item)
      if pbUnfuse(pokemon, @scene, nil, selected)
        if canDeleteItem(item)
          $PokemonBag.pbDeleteItem(item)
        end
      end
      @scene.pbHardRefresh
    end
  end
end
