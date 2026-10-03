class PokemonStorage
  def wallpaperLottery
    cmd_play = _INTL("Jogar!")
    cmd_info = _INTL("Info")
    cmd_cancel = _INTL("Cancelar")
    commands = [cmd_play, cmd_info, cmd_cancel]

    $Trainer.quest_points = initialize_quest_points unless $Trainer.quest_points
    choice = pbMessage(_INTL("\\qpWould you like to play the Wallpaper Lottery? (Costs \\C[1]1 Quest point\\C[0])"), commands, 2)

    case commands[choice]
    when cmd_play
      if $Trainer.quest_points <= 0
        pbMessage(_INTL("Você não tem nenhum \\C[1]ponto de quest\\C[0]. Conclua quests para conseguir mais!"))
        return
      end

      locked_wallpapers = []
      for i in BASICWALLPAPERQTY..allWallpapers.length - 1
        locked_wallpapers << i unless isAvailableWallpaper?(i)
      end
      if locked_wallpapers.empty?
        pbMessage(_INTL("Não há mais wallpapers para desbloquear!"))
        return
      end

      unlocked_index = locked_wallpapers.sample
      $Trainer.quest_points -= 1

      $game_system.bgm_memorize
      $game_system.bgm_stop

      pbWait(8)
      pbSEPlay("BW_exp")
      pbWait(90)
      $game_system.bgm_restore
      obtain_wallpaper(unlocked_index)
    when cmd_info
      pbMessage(_INTL("A Wallpaper Lottery permite desbloquear \\C[1]novos wallpapers\\C[0] para o fundo das Boxes do PC."))
      pbMessage(_INTL("Participar da loteria custa \\C[1]1 ponto de quest\\C[0]. Você obtém um ponto de quest por quest concluída."))

    end
  end

  def obtain_wallpaper(wallpaper_id)
    wallpaper_name = allWallpapers[wallpaper_id]
    pbUnlockWallpaper(wallpaper_id)
    path = "Graphics/Pictures/Storage/Wallpapers/box_#{wallpaper_id}"
    pictureViewport = showPicture(path, 50, -45)
    musical_effect = "Key item get"
    pbMessage(_INTL("\\qp\\me[{1}]Novo wallpaper obtido: \\c[1]{2}\\c[0]!", musical_effect, wallpaper_name))
    pictureViewport.dispose if pictureViewport
  end
end

class WallpaperLotteryPC
  def shouldShow?
    if Settings::KANTO
      return player_has_quest_journal?
    end
    if Settings::HOENN
      return $game_switches[SWITCH_UNLOCKED_WALLPAPER_LOTTERY]
    end
  end

  def name
    return _INTL("Wallpaper Lottery")
  end

  def access
    pbMessage(_INTL("\\se[PC access]Wallpaper Lottery acessada."))
    $PokemonStorage.wallpaperLottery
  end
end

#===============================================================================
#
#===============================================================================
PokemonPCList.registerPC(WallpaperLotteryPC.new)