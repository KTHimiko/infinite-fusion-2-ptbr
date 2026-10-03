#
# Rewards given by hotel questman after a certain nb. of completed quests
#
QUEST_REWARDS = Settings::KANTO ? [
  # Kanto quest rewards
  QuestReward.new(1, :HM08, 1, _INTL("Este HM vai permitir iluminar cavernas escuras e deve ajudar você a avançar na sua jornada!")),
  QuestReward.new(5, :AMULETCOIN, 1, _INTL("Este item permite ganhar o dobro de dinheiro em uma batalha se o Pokémon que estiver segurando ele participar!")),
  QuestReward.new(10, :LANTERN, 1, _INTL("Isto vai permitir iluminar cavernas sem precisar usar um HM! Prático, não é?")),
  QuestReward.new(15, :LINKINGCORD, 3, _INTL("Este cabo estranho ativa a evolução de Pokémon que normalmente evoluem por troca. Sei que você vai usar bem!")),
  QuestReward.new(20, :SLEEPINGBAG, 1, _INTL("Este item prático vai permitir que você durma onde quiser. Você nem vai precisar mais de hotéis!")),
  QuestReward.new(30, :MISTSTONE, 1, _INTL("Esta pedra rara pode evoluir qualquer Pokémon, independentemente do nível ou método de evolução. Use com sabedoria!"), true),
  QuestReward.new(50, :GSBALL, 1, _INTL("Dizem que esta bola misteriosa é a chave para invocar o protetor de Ilex Forest. É uma relíquia preciosa.")),
  QuestReward.new(60, :MASTERBALL, 1, _INTL("Esta bola rara pode capturar qualquer Pokémon. Não desperdice!"), true),
] : [
  # Hoenn quest rewards
  QuestReward.new(2, :AMULETCOIN, 1, _INTL("This doubles the money you get in Pokémon battles. Maybe it'll help finance the show!")),
  QuestReward.new(5, :INCUBATOR, 1, _INTL("The note that came with it said that it allows you to hatch an egg instantly!")),
  QuestReward.new(10, :ITEMFINDER, 1, _INTL("There's a note with it. If there's a hidden item anywhere near you, that little thing will react to tell you.")),
  QuestReward.new(15, :INCUBATOR, 3, _INTL("Looks like they sent even more of these incubators for hatching Eggs. There must be a high-profile Pokémon breeder that's a fan of the show!")),
  QuestReward.new(20, :SLEEPINGBAG, 1, _INTL("There's a note with it. This deluxe sleeping bag will allow you to sleep anywhere you want. It's so comfortable that you can sleep in it for hours!")),
  QuestReward.new(25, :LINKINGCORD, 1, _INTL("Apparently, this strange cable triggers the evolution of Pokémon that typically evolve via trade. I know you'll put it to good use!")),
  QuestReward.new(50, :MISTSTONE, 1, _INTL("This rare stone can evolve any Pokémon, regardless of their level or evolution method. Use it wisely!"), true),
  QuestReward.new(60, :GSBALL, 1, _INTL("This mysterious ball is rumored to be the key to call upon the protector of Ilex Forest.  It's a precious relic.")),
  QuestReward.new(70, :MASTERBALL, 1, _INTL("This rare ball can catch any Pokémon. Don't waste it!"), true),
]
