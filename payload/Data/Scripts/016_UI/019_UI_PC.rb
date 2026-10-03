#===============================================================================
#
#===============================================================================
class TrainerPC
  def shouldShow?
    return true
  end

  def name
    return _INTL("PC de {1}",$Trainer.name)
  end

  def access
    pbMessage(_INTL("\\se[PC access]Acessou o PC de {1}.",$Trainer.name))
    pbTrainerPCMenu
  end
end

#===============================================================================
#
#===============================================================================
class StorageSystemPC
  def shouldShow?
    return true
  end

  def name
    return _INTL("Armazenamento Pokémon")
    #if $Trainer.seen_storage_creator
    #  return "{1}'s PC",pbGetStorageCreator
    #else
    #  return "Someone's PC"
    #end
  end

  def access
    pbMessage(_INTL("\\se[PC access]O Sistema de Armazenamento Pokémon foi aberto."))
    command = 0
    loop do
      command = pbShowCommandsWithHelp(nil,
         [_INTL("Organizar / Fundir"),
         _INTL("Retirar Pokémon"),
         _INTL("Depositar Pokémon"),
         _INTL("Até mais!")],
         [_INTL("Organize os Pokémon das Boxes e da sua equipe."),
         _INTL("Mova Pokémon guardados nas Boxes para sua equipe."),
         _INTL("Guarde Pokémon da sua equipe nas Boxes."),
         _INTL("Voltar ao menu anterior.")],-1,command
      )
      if command>=0 && command<3
        if command==1   # Withdraw
          if $PokemonStorage.party_full?
            pbMessage(_INTL("Sua equipe está cheia!"))
            next
          end
        elsif command==2   # Deposit
          count=0
          for p in $PokemonStorage.party
            count += 1 if p && !p.egg? && p.hp>0
          end
          if count<=1
            pbMessage(_INTL("Não dá para depositar o último Pokémon!"))
            next
          end
        end
        pbFadeOutIn {
          scene = PokemonStorageScene.new
          screen = PokemonStorageScreen.new(scene,$PokemonStorage)
          screen.pbStartScreen(command)
        }
      else
        break
      end
    end
  end
end

#===============================================================================
#
#===============================================================================
module PokemonPCList
  @@pclist = []

  def self.registerPC(pc)
    @@pclist.push(pc)
  end

  def self.getCommandList
    commands = []
    for pc in @@pclist
      commands.push(pc.name) if pc.shouldShow?
    end
    commands.push(_INTL("Desligar"))
    return commands
  end

  def self.callCommand(cmd)
    return false if cmd<0 || cmd>=@@pclist.length
    i = 0
    for pc in @@pclist
      next if !pc.shouldShow?
      if i==cmd
        pc.access
        return true
      end
      i += 1
    end
    return false
  end
end

#===============================================================================
# PC menus
#===============================================================================
def pbPCItemStorage
  command = 0
  loop do
    command = pbShowCommandsWithHelp(nil,
       [_INTL("Retirar item"),
       _INTL("Depositar item"),
       _INTL("Descartar item"),
       _INTL("Sair")],
       [_INTL("Retire itens do PC."),
       _INTL("Guarde itens no PC."),
       _INTL("Jogue fora itens guardados no PC."),
       _INTL("Voltar ao menu anterior.")],-1,command
    )
    case command
    when 0   # Withdraw Item
      if !$PokemonGlobal.pcItemStorage
        $PokemonGlobal.pcItemStorage = PCItemStorage.new
      end
      if $PokemonGlobal.pcItemStorage.empty?
        pbMessage(_INTL("Não há itens."))
      else
        pbFadeOutIn {
          scene = WithdrawItemScene.new
          screen = PokemonBagScreen.new(scene,$PokemonBag)
          screen.pbWithdrawItemScreen
        }
      end
    when 1   # Deposit Item
      pbFadeOutIn {
        scene = PokemonBag_Scene.new
        screen = PokemonBagScreen.new(scene,$PokemonBag)
        screen.pbDepositItemScreen
      }
    when 2   # Toss Item
      if !$PokemonGlobal.pcItemStorage
        $PokemonGlobal.pcItemStorage = PCItemStorage.new
      end
      if $PokemonGlobal.pcItemStorage.empty?
        pbMessage(_INTL("Não há itens."))
      else
        pbFadeOutIn {
          scene = TossItemScene.new
          screen = PokemonBagScreen.new(scene,$PokemonBag)
          screen.pbTossItemScreen
        }
      end
    else
      break
    end
  end
end

def pbPCMailbox
  if !$PokemonGlobal.mailbox || $PokemonGlobal.mailbox.length==0
    pbMessage(_INTL("Não há Mail aqui."))
  else
    loop do
      command = 0
      commands=[]
      for mail in $PokemonGlobal.mailbox
        commands.push(mail.sender)
      end
      commands.push(_INTL("Cancelar"))
      command = pbShowCommands(nil,commands,-1,command)
      if command>=0 && command<$PokemonGlobal.mailbox.length
        mailIndex = command
        commandMail = pbMessage(_INTL("O que você quer fazer com a Mail de {1}?",
           $PokemonGlobal.mailbox[mailIndex].sender),[
           _INTL("Ler"),
           _INTL("Mover para a Bag"),
           _INTL("Dar"),
           _INTL("Cancelar")
           ],-1)
        case commandMail
        when 0   # Read
          pbFadeOutIn {
            pbDisplayMail($PokemonGlobal.mailbox[mailIndex])
          }
        when 1   # Move to Bag
          if pbConfirmMessage(_INTL("A mensagem será perdida. Tudo bem?"))
            if $PokemonBag.pbStoreItem($PokemonGlobal.mailbox[mailIndex].item)
              pbMessage(_INTL("A Mail voltou para a Bag com a mensagem apagada."))
              $PokemonGlobal.mailbox.delete_at(mailIndex)
            else
              pbMessage(_INTL("A Bag está cheia."))
            end
          end
        when 2   # Give
          pbFadeOutIn {
            sscene = PokemonParty_Scene.new
            sscreen = PokemonPartyScreen.new(sscene,$Trainer.party)
            sscreen.pbPokemonGiveMailScreen(mailIndex)
          }
        end
      else
        break
      end
    end
  end
end

def pbTrainerPCMenu
  command = 0
  loop do
    command = pbMessage(_INTL("O que você quer fazer?"),[
       _INTL("Armazenamento de itens"),
       _INTL("Mailbox"),
       _INTL("Desligar")
       ],-1,nil,command)
    case command
    when 0 then pbPCItemStorage
    when 1 then pbPCMailbox
    else        break
    end
  end
end

def pbTrainerPC
  pbMessage(_INTL("\\se[PC open]{1} ligou o PC.",$Trainer.name))
  pbTrainerPCMenu
  pbSEPlay("PC close")
end

def checkPorygonEncounter
  porygon_chance = 200
  if $PokemonGlobal.stepcount % porygon_chance == 0
    pbSEPlay("Paralyze3")
    pbWait(12)
    pbMessage(_INTL("Hã? O PC deu uma falha por um instante enquanto ligava."))
    pbMessage(_INTL("Será que algo entrou no PC?"))
    pbWait(8)
    pbAddPokemonSilent(:PORYGON,1)
    $PokemonGlobal.stepcount += 1
  end
    # code here
end

def pbPokeCenterPC
  pbMessage(_INTL("\\se[PC open]{1} ligou o PC.",$Trainer.name))
  checkPorygonEncounter()
  command = 0
  loop do
    commands = PokemonPCList.getCommandList
    command = pbMessage(_INTL("Qual PC deve ser acessado?"),commands,
       commands.length,nil,command)
    break if !PokemonPCList.callCommand(command)
  end
  pbSEPlay("PC close")
  if $game_temp.transfer_box_autosave
    Game.save()
    $game_temp.transfer_box_autosave=false
  end
end

def pbGetStorageCreator
  creator = Settings.storage_creator_name
  creator = _INTL("Bill") if nil_or_empty?(creator)
  return creator
end

#===============================================================================
#
#===============================================================================
PokemonPCList.registerPC(StorageSystemPC.new)
PokemonPCList.registerPC(TrainerPC.new)
