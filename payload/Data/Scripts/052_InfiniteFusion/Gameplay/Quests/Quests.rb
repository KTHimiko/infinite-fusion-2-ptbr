
MainQuestColor = :GREEN
HotelQuestColor = :GOLD

class Quest
  attr_accessor :id
  attr_accessor :name
  attr_accessor :desc
  attr_accessor :npc
  attr_accessor :sprite
  attr_accessor :location
  attr_accessor :color
  attr_accessor :time
  attr_accessor :completed
  attr_accessor :type
  attr_accessor :location_map_id

  def name
    return _INTL(@name)
  end

  def desc
    return _INTL(@desc)
  end

  def location
    return _INTL(@location)
  end

  def initialize(id, name, desc, sprite, location, color = :WHITE, time = Time.now, completed = false, map_id=nil)
    self.id = id
    self.name = name
    self.desc = desc
    self.npc = npc
    self.sprite = sprite
    self.location = location
    self.color = pbColor(color)
    self.time = time
    self.completed = completed
    self.location_map_id = map_id
  end
end

def default_color
  return pbColor(get_quest_color(@type))
end

def get_quest_color(quest_type)
  case quest_type
  when :MAIN_QUEST
    return MainQuestColor
  when :HOTEL_QUEST
    return HotelQuestColor
  when :FIELD_QUEST
    return FieldQuestColor
  when :LEGENDARY_QUEST
    return LegendaryQuestColor
  when :ROCKET_QUEST
    return TRQuestColor
  when :MAGMA_QUEST
    return MagmaQuestColor
  when :AQUA_QUEST
    return AquaQuestColor
  else
    return :WHITE
  end
end

def define_quest(quest_id,quest_type,quest_name,quest_description,quest_location,npc_sprite,map_id=nil)
  text_color = get_quest_color(quest_type)
  new_quest = Quest.new(quest_id, quest_name, quest_description, npc_sprite, quest_location, text_color,Time.now,false,map_id)
  new_quest.type= quest_type
  QUESTS[quest_id] = new_quest
end

QUESTS = {
    #Pokemart
    "pokemart_johto" => Quest.new("pokemart_johto", _INTL("Pokémon de Johto"), _INTL("Um viajante no PokéMart quer que você mostre a ele um Pokémon nativo da região de Johto."), "traveler_johto", _INTL("Cerulean City"), HotelQuestColor),
    "pokemart_hoenn" => Quest.new("pokemart_hoenn", _INTL("Pokémon de Hoenn"), _INTL("Um viajante no PokéMart quer que você mostre a ele um Pokémon nativo da região de Hoenn."), "traveler_hoenn", _INTL("Vermillion City"), HotelQuestColor),
    "pokemart_sinnoh" => Quest.new("pokemart_sinnoh", _INTL("Pokémon de Sinnoh"), _INTL("Um viajante no Department Center quer que você mostre a ele um Pokémon nativo da região de Sinnoh."), "traveler_sinnoh", _INTL("Celadon City"), HotelQuestColor),
    "pokemart_unova" => Quest.new( "pokemart_unova", _INTL("Pokémon de Unova"), _INTL("Um viajante no PokéMart quer que você mostre a ele um Pokémon nativo da região de Unova."), "traveler_unova", _INTL("Fuchsia City"), HotelQuestColor),
    "pokemart_kalos" => Quest.new("pokemart_kalos", _INTL("Pokémon de Kalos"), _INTL("Um viajante no PokéMart quer que você mostre a ele um Pokémon nativo da região de Kalos."), "traveler_kalos", _INTL("Saffron City"), HotelQuestColor),
    "pokemart_alola" => Quest.new("pokemart_alola", _INTL("Pokémon de Alola"), _INTL("Um viajante no PokéMart quer que você mostre a ele um Pokémon nativo da região de Alola."), "traveler_alola", _INTL("Cinnabar Island"), HotelQuestColor),


    #Pewter hotel
    "pewter_1" => Quest.new("pewter_1", _INTL("Coleta de cogumelos"), _INTL("Uma senhora em Pewter City quer que você traga 3 TinyMushroom de Viridian Forest para fazer um ensopado."), "BW (74)", _INTL("Pewter City"), HotelQuestColor),
    "pewter_2" =>Quest.new("pewter_2", _INTL("Remédio perdido"), _INTL("Um Youngster em Pewter City precisa da sua ajuda para encontrar um Revive perdido. Ele perdeu o item ao se sentar em algum banco de Pewter City."), "BW (19)", _INTL("Pewter City"), HotelQuestColor),
    "pewter_3" =>Quest.new("pewter_3", _INTL("Evolução Bug "), _INTL("Um Bug Catcher em Pewter City quer que você mostre a ele um Pokémon Bug totalmente evoluído."), "BWBugCatcher_male", _INTL("Pewter City"), HotelQuestColor),
    "pewter_field_1" => Quest.new("pewter_field_1", _INTL("Jardim de néctar"), _INTL("Um senhor quer que você traga flores de cores diferentes para o jardim da cidade."),  "BW (039)", _INTL("Pewter City"), FieldQuestColor),
    "pewter_field_2" => Quest.new("pewter_field_2", _INTL("Eu escolho você!"), _INTL("Um Pikachu no PokéMart perdeu seu Pokémon League Hat oficial. Encontre um e entregue ao Pikachu!"),  "YOUNGSTER_LeagueHat", _INTL("Pewter City"), FieldQuestColor),
    "pewter_field_3" => Quest.new("pewter_field_3", _INTL("Âmbar pré-histórico!"), _INTL("Encontre um cientista em Viridian Forest para procurar âmbar pré-histórico."),  "BW (82)", _INTL("Pewter City"), FieldQuestColor),

    #Cerulean hotel
    "cerulean_1" => Quest.new("cerulean_1", _INTL("Cupido em ação"), _INTL("Um garoto em Cerulean City quer que você leve uma carta de amor para uma Pokémon Breeder chamada Maude. Ela provavelmente está em alguma das rotas perto de Cerulean City."), "BW (18)", _INTL("Cerulean City"), HotelQuestColor),
    "cerulean_2" => Quest.new("cerulean_2", _INTL("Especialistas de Tipo"), _INTL("Derrote todos os Type Experts espalhados pela região de Kanto ({1}/{2})",pbGet(VAR_TYPE_EXPERTS_BEATEN),TOTAL_NB_TYPE_EXPERTS), "expert-normal", _INTL("Cerulean City"), HotelQuestColor),

    #Route 24
    "cerulean_field_1" => Quest.new("cerulean_field_1", _INTL("Pesquisa de campo (Parte 1)"), _INTL("O assistente do Professor Oak quer que você capture um Abra."),  "BW (82)", _INTL("Route 24"), FieldQuestColor),
    "cerulean_field_2" => Quest.new("cerulean_field_2", _INTL("Pesquisa de campo (Parte 2)"), _INTL("O assistente do Professor Oak quer que você encontre todos os Pokémon da Route 24."),  "BW (82)", _INTL("Route 24"), FieldQuestColor),
    "cerulean_field_3" => Quest.new("cerulean_field_3", _INTL("Pesquisa de campo (Parte 3)"), _INTL("O assistente do Professor Oak quer que você capture um Buneary usando o Pokéradar."),  "BW (82)", _INTL("Route 24"), FieldQuestColor),

    #Vermillion City
    "vermillion_2" => Quest.new("vermillion_2", _INTL("Pescando uma sola"), _INTL("Um pescador quer que você pesque uma bota velha. Fisgue uma com a Old Rod em qualquer corpo d'água."), "BW (71)", _INTL("Cerulean City"), HotelQuestColor),
    "vermillion_1" => Quest.new("vermillion_1", _INTL("Tipos incomuns 1"), _INTL("Uma mulher no hotel quer que você mostre a ela um Pokémon tipo Water/Fire."), "BW (58)", _INTL("Vermillion City"), HotelQuestColor),
    "vermillion_3" => Quest.new("vermillion_3", _INTL("Coquetel de frutos do mar "), _INTL("Pegue algumas pernas de Krabby no vapor na cozinha do S.S. Anne e leve-as de volta ao hotel antes que esfriem."), "BW (36)", _INTL("Vermillion City"), HotelQuestColor),
    "vermillion_field_1" => Quest.new("vermillion_field_1", _INTL("Materiais de construção "), _INTL("Pegue algumas wooden planks em Viridian City e alguns Bricks em Pewter City."),  "BW (36)", _INTL("Vermillion City"), FieldQuestColor),
    "vermillion_field_2" => Quest.new("vermillion_field_2", _INTL("Garçom sobre as águas"), _INTL("O garçom do S.S. Anne quer que você anote os pedidos do restaurante enquanto ele vai buscar um bolo reserva."),  "BW (53)", _INTL("S.S. Anne"), FieldQuestColor),

    #Celadon City
    "celadon_1" => Quest.new("celadon_1", _INTL("Sol ou Lua"), _INTL("Mostre o Pokémon em que Eevee evolui ao ser exposto a uma Moon Stone ou Sun Stone para ajudar a cientista em sua pesquisa."), "BW (82)", _INTL("Celadon City"), HotelQuestColor),
    "celadon_2" => Quest.new("celadon_2", _INTL("Por quem os sinos dobram"), _INTL("Toque o sino de Lavender Town na hora certa para revelar seu segredo."), "BW (40)", _INTL("Lavender Town"), HotelQuestColor),
    "celadon_3" => Quest.new("celadon_3", _INTL("Ovo cozido"), _INTL("Uma mulher quer que você dê a ela um ovo para fazer uma omelete."), "BW (24)", _INTL("Celadon City"), HotelQuestColor),
    "celadon_field_1" => Quest.new("celadon_field_1", _INTL("Um passeio com Eevee!"), _INTL("Passeie com Eevee por um tempo até ele ficar cansado."),  "BW (37)", _INTL("Celadon City"), FieldQuestColor),

    #Fuchsia City
    "fuchsia_1" => Quest.new("fuchsia_1", _INTL("Corrida de bicicleta!"), _INTL("Encontre a Cyclist no fim da Route 17 e bata o tempo dela subindo a Cycling Road!"), "BW032", _INTL("Cycling Road"), HotelQuestColor),
    "fuchsia_2" => Quest.new("fuchsia_2", _INTL("Pokémon perdido!"), _INTL("Encontre o treinador da Chansey perdida!"), "113", _INTL("Fuchsia City"), HotelQuestColor),
    "fuchsia_3" => Quest.new("fuchsia_3", _INTL("Limpando a Cycling Road"), _INTL("Livre-se de todos os Pokémon que estão sujando a Cycling Road."), "BW (77)", _INTL("Fuchsia City"), HotelQuestColor),
    "fuchsia_4" => Quest.new("fuchsia_4", _INTL("Pokémon mordedor"), _INTL("Um pescador quer saber qual é o Pokémon de dentes afiados que o mordeu no lago da Safari Zone."), "BW (71)", _INTL("Fuchsia City"), HotelQuestColor),

    #Crimson City
    "crimson_1" => Quest.new("crimson_1", _INTL("Resgate dos Shellder"), _INTL("Coloque todos os Shellder encalhados de volta na água na rota para Crimson City."), "BW (48)", _INTL("Crimson City"), HotelQuestColor),
    "crimson_2" => Quest.new("crimson_2", _INTL("Batalha da quarta rodada"), _INTL("Derrote Jeanette e seu Bellsprout de nível alto em uma Pokémon Battle."), "BW024", _INTL("Crimson City"), HotelQuestColor),
    "crimson_3" => Quest.new("crimson_3", _INTL("Tipos incomuns 2"), _INTL("Uma mulher no hotel quer que você mostre a ela um Pokémon tipo Normal/Ghost."), "BW (58)", _INTL("Crimson City"), HotelQuestColor),
    "crimson_4" => Quest.new("crimson_4", _INTL("O topo da cachoeira"), _INTL("Alguém quer que você investigue o topo de uma cachoeira perto de Crimson City."), "BW (28)", _INTL("Crimson City"), HotelQuestColor),

    #Saffron City
    "saffron_1" => Quest.new("saffron_1", _INTL("Filhotes perdidos"), _INTL("Encontre todos os Growlithe desaparecidos nas rotas ao redor de Saffron City."), "BW (73)", _INTL("Saffron City"), HotelQuestColor),
    "saffron_2" => Quest.new("saffron_2", _INTL("Pokémon invisível"), _INTL("Encontre um Pokémon invisível na parte leste de Saffron City."), "BW (57)", _INTL("Saffron City"), HotelQuestColor),
    "saffron_3" => Quest.new("saffron_3", _INTL("Osso duro de roer!"), _INTL("Encontre um Rare Bone usando Rock Smash."), "BW (72)", _INTL("Saffron City"), HotelQuestColor),
    "saffron_field_1" => Quest.new("saffron_field_1", _INTL("Rainha da dança!"), _INTL("Dance com a Copycat Girl!"),  "BW (24)", _INTL("Saffron City (nightclub)"), FieldQuestColor),

    #Cinnabar Island
    "cinnabar_1" => Quest.new("cinnabar_1", _INTL("O Pokémon transformação"), _INTL("O cientista quer que você encontre Quick Powder, que às vezes pode ser encontrado com Ditto selvagens no porão da mansão."), "BW (82)", _INTL("Cinnabar Island"), HotelQuestColor),
    "cinnabar_2" => Quest.new("cinnabar_2", _INTL("Diamantes e pérolas"), _INTL("Encontre um Diamond Necklace para salvar o casamento do homem."), "BW (71)", _INTL("Cinnabar Island"), HotelQuestColor),
    "cinnabar_3" => Quest.new("cinnabar_3", _INTL("Artefato roubado"), _INTL("Recupere um vaso roubado de um ladrão na Pokémon Mansion."), "BW (21)", _INTL("Cinnabar Island"), HotelQuestColor),

    #Goldenrod City
    "goldenrod_1" => Quest.new( "goldenrod_1", _INTL("Lembrança da Safari!"), _INTL("Traga uma lembrança da Safari Zone de Fuchsia City."), "BW (28)", _INTL("Goldenrod City"), HotelQuestColor),
    "goldenrod_2" => Quest.new("goldenrod_2", _INTL("A floresta amaldiçoada"), _INTL("Uma criança quer que você encontre um tronco flutuante em Ilex Forest. Do que será que ela está falando?"), "BW109", _INTL("Goldenrod City"), HotelQuestColor),

    "goldenrod_police_1" => Quest.new("goldenrod_police_1", _INTL("Trabalho policial disfarçado!"), _INTL("Procure a polícia em Goldenrod City para ajudá-los em uma operação policial importante."),  "BW (80)", _INTL("Goldenrod City"), FieldQuestColor),
    "pinkan_police" => Quest.new("pinkan_police", _INTL("Pinkan Island!"), _INTL("A Team Rocket está planejando um assalto em Pinkan Island. Você uniu forças com a polícia para detê-los!"),  "BW (80)", _INTL("Goldenrod City"), FieldQuestColor),

    #Violet City
    "violet_1" => Quest.new("violet_1", _INTL("Desarme as pinhas!"), _INTL("Livre-se de todos os Pineco na Route 31 e na Route 30."), "BW (64)", _INTL("Violet City"), HotelQuestColor),
    "violet_2" => Quest.new("violet_2", _INTL("Encontre a SlowpokeTail!"), _INTL("Encontre uma SlowpokeTail em algumas flores, em algum lugar por Violet City!"), "BW (19)", _INTL("Violet City"), HotelQuestColor),

    #Blackthorn City
    "blackthorn_1" => Quest.new( "blackthorn_1", _INTL("Evolução Dragon"), _INTL("Uma Dragon Tamer em Blackthorn City quer que você mostre a ela um Pokémon Dragon totalmente evoluído."), "BW014", _INTL("Blackthorn City"), HotelQuestColor),
    "blackthorn_2" => Quest.new("blackthorn_2", _INTL("Tesouro afundado!"), _INTL("Encontre uma memorabilia antiga em um navio afundado perto de Cinnabar Island."), "BW (28)", _INTL("Blackthorn City"), HotelQuestColor),
    "blackthorn_3" => Quest.new("blackthorn_3", _INTL("A maior carpa"), _INTL("Um pescador quer que você pesque um Magikarp de nível excepcionalmente alto em Dragon's Den."), "BW (71)", _INTL("Blackthorn City"), HotelQuestColor),

    #Ecruteak City
    "ecruteak_1" => Quest.new("ecruteak_1", _INTL("Evolução Ghost"), _INTL("Uma garota em Ecruteak City quer que você mostre a ela um Pokémon Ghost totalmente evoluído."), "BW014", _INTL("Ecruteak City"), HotelQuestColor),

    #Kin Island
    "kin_1" => Quest.new("kin_1", _INTL("Banana Slamma!"), _INTL("Colete 30 bananas."), "BW059", _INTL("Kin Island"), HotelQuestColor),
    "kin_2" => Quest.new("kin_2", _INTL("Meteoro caído"), _INTL("Investigue uma cratera perto de Bond Bridge."), "BW009", _INTL("Kin Island"), HotelQuestColor),
    "kin_field_1" => Quest.new("kin_field_1", _INTL("O peixe mais raro"), _INTL("Um pescador quer que você mostre a ele um Feebas. Pelo visto, eles podem ser pescados pelas Sevii Islands quando chove."),  "BW056", _INTL("Kin Island"), FieldQuestColor),

    "legendary_deoxys_1" => Quest.new("legendary_deoxys_1", _INTL("Primeiro contato"), _INTL("Encontre as peças desaparecidas de uma nave alienígena caída."), "BW (92)", _INTL("Bond Bridge"), LegendaryQuestColor),
    "legendary_deoxys_2" => Quest.new("legendary_deoxys_2", _INTL("Primeiro contato (Parte 2)"), _INTL("Peça ao marinheiro no porto de Cinnabar Island para levar você até a ilha inexplorada onde a nave pode estar."), "BW (92)", _INTL("Bond Bridge"), LegendaryQuestColor),

    #Necrozma quest
    "legendary_necrozma_1" => Quest.new("legendary_necrozma_1", _INTL("Prismas misteriosos"), _INTL("Você encontrou um pedestal com um prisma misterioso. Parece haver espaço para mais prismas."), "BW_Sabrina", _INTL("Pokémon Tower"), LegendaryQuestColor),
    "legendary_necrozma_2" => Quest.new("legendary_necrozma_2", _INTL("A longa noite (Parte 1)"), _INTL("Uma escuridão misteriosa envolveu parte da região. Encontre Sabrina do lado de fora do portão oeste de Saffron City para investigar."), "BW_Sabrina", _INTL("Lavender Town"), LegendaryQuestColor),
    "legendary_necrozma_3" => Quest.new("legendary_necrozma_1", _INTL("A longa noite (Parte 2)"), _INTL("A escuridão misteriosa se expandiu. Encontre Sabrina no topo do Dept. Store de Celadon City para descobrir a origem da escuridão."), "BW_Sabrina", _INTL("Route 7"), LegendaryQuestColor),
    "legendary_necrozma_4" => Quest.new("legendary_necrozma_4", _INTL("A longa noite (Parte 3)"), _INTL("Fuchsia City parece não ter sido afetada pela escuridão. Investigue para ver se consegue descobrir mais informações."), "BW_Sabrina", _INTL("Celadon City"), LegendaryQuestColor),
    "legendary_necrozma_5" => Quest.new("legendary_necrozma_5", _INTL("A longa noite (Parte 4)"), _INTL("A escuridão misteriosa se expandiu de novo e plantas estranhas apareceram. Siga as plantas para ver aonde elas levam."), "BW_koga", _INTL("Fuchsia City"), LegendaryQuestColor),
    "legendary_necrozma_6" => Quest.new("legendary_necrozma_6", _INTL("A longa noite (Parte 5)"), _INTL("Você encontrou uma fruta estranha que parece estar ligada à escuridão misteriosa. Procure o Professor Oak para analisá-la."), "BW029", _INTL("Safari Zone"), LegendaryQuestColor),
    "legendary_necrozma_7" => Quest.new("legendary_necrozma_7", _INTL("A longa noite (Parte 6)"), _INTL("A planta estranha que você encontrou parece brilhar na escuridão misteriosa que agora cobre toda a região. Tente seguir o brilho para encontrar a origem da perturbação."), "BW-oak", _INTL("Pallet Town"), LegendaryQuestColor),


    "legendary_meloetta_1" => Quest.new("legendary_meloetta_1", _INTL("Uma banda lendária (Parte 1)"), _INTL("O vocalista de uma banda em Saffron City quer que você ajude a recrutar um baterista. Eles acham que ouviram uma bateria por Crimson City..."), "BW107", _INTL("Saffron City"), LegendaryQuestColor),
    "legendary_meloetta_2" => Quest.new("legendary_meloetta_2", _INTL("Uma banda lendária (Parte 2)"), _INTL("O baterista de uma Pokéband lendária quer que você encontre os antigos integrantes. O empresário da banda falou sobre dois ex-guitarristas..."), "band_drummer", _INTL("Saffron City"), LegendaryQuestColor),
    "legendary_meloetta_3" => Quest.new("legendary_meloetta_3", _INTL("Uma banda lendária (Parte 3)"), _INTL("O baterista de uma Pokéband lendária quer que você encontre os antigos integrantes. Há rumores sobre uma música estranha ouvida pela região."), "band_drummer", _INTL("Saffron City"), LegendaryQuestColor),
    "legendary_meloetta_4" => Quest.new("legendary_meloetta_4", _INTL("Uma banda lendária (Parte 4)"), _INTL("Você reuniu a banda inteira! Venha assistir ao show no sábado à noite."), "BW117", _INTL("Saffron City"), LegendaryQuestColor),

    "legendary_cresselia_1" => Quest.new("legendary_cresselia_1", _INTL("Mysterious Lunar feathers"), _INTL("A mysterious entity asked you to collect Lunar Feathers for them. It said that they will come at night to tell you where to look. Whoever that may be..."), "lunarFeather", _INTL("Lavender Town"), LegendaryQuestColor),
    #removed
    #11 => Quest.new(11, "Powering the Lighthouse", "Catch some Voltorb to power up the lighthouse", QuestBranchHotels, "BW (43)", "Vermillion City", HotelQuestColor),
}

###################
# HOENN QUESTS   ##
# ################

## MAIN QUESTS
define_quest("main_dad",:MAIN_QUEST,_INTL("Visit Dad!"), _INTL("Go visit your Dad at his Gym in Petalburg Town!"),_INTL("Petalburg City"),"NPC_Hoenn_Leader_Norman",MAP_PETALBURG)
define_quest("main_wally",:MAIN_QUEST,_INTL("Catching Tutoring"), _INTL("Catch a wild Pokémon for Wally."),_INTL("Petalburg City"),"NPC_Hoenn_Wally",MAP_PETALBURG)

define_quest("main_gym_1",:MAIN_QUEST,_INTL("The Pokémon Gym Challenge"), _INTL("Challenge Roxanne in Rustboro City to obtain your first Gym Badge."),_INTL("Rustboro City"),"NPC_Hoenn_Leader_Roxanne",MAP_RUSTBORO)
define_quest("main_gym_2",:MAIN_QUEST,_INTL("The Pokémon Gym Challenge"), _INTL("Challenge Brawly in Dewford Town to obtain your second Gym Badge."),_INTL("Dewford Town"),"NPC_Hoenn_Leader_Brawly",MAP_DEWFORD)
define_quest("main_gym_3",:MAIN_QUEST,_INTL("The Pokémon Gym Challenge"), _INTL("Challenge Wattson in Mauville City to obtain your third Gym Badge."),_INTL("Mauville City"),"NPC_Hoenn_Leader_Wattson",MAP_MAUVILLE)
define_quest("main_gym_4",:MAIN_QUEST,_INTL("The Pokémon Gym Challenge"), _INTL("Challenge Flannery in Lavaridge Town to obtain your fourth Gym Badge."),_INTL("Lavaridge Town"),"NPC_Hoenn_Leader_Flannery",MAP_LAVARIDGE)
define_quest("main_gym_5",:MAIN_QUEST,_INTL("The Pokémon Gym Challenge"), _INTL("Challenge Norman in Petalburg City to obtain your fifth Gym Badge."),_INTL("Petalburg Town"),"NPC_Hoenn_Leader_Norman",MAP_PETALBURG)
define_quest("main_gym_6",:MAIN_QUEST,_INTL("The Pokémon Gym Challenge"), _INTL("Challenge Winona in Fortree City to obtain your sixth Gym Badge."),_INTL("Fortree City"),"NPC_Hoenn_Leader_Winona",MAP_FORTREE)
define_quest("main_gym_7",:MAIN_QUEST,_INTL("The Pokémon Gym Challenge"), _INTL("Challenge Tate & Liza in Mossdeep City to obtain your seventh Gym Badge."),_INTL("Mossdeep City"),"NPC_Hoenn_Leader_TateLiza",MAP_MOSSDEEP)
define_quest("main_gym_8",:MAIN_QUEST,_INTL("The Pokémon Gym Challenge"), _INTL("Challenge Wallace in Sootopolis City to obtain your final Gym Badge."),_INTL("Sootopolis City"),"NPC_Hoenn_Leader_Wallace",MAP_SOOTOPOLIS)

define_quest("main_league",:MAIN_QUEST,_INTL("Pokémon League Challenge"), _INTL("Collect all 8 Gym Badges and take part in the Pokémon League!"),_INTL("Hoenn"),"NPC_Hoenn_GymMan",MAP_LEAGUE)

define_quest("main_stolen_parts",:MAIN_QUEST,_INTL("Stolen Package"), _INTL("Recover a package stolen by Team Magma!"),_INTL("Rustboro City"),"NPC_Hoenn_MrStone")
define_quest("main_steven_letter",:MAIN_QUEST,_INTL("Steven's Letter"), _INTL("Deliver a letter from the Devon Corp. president to Steven in Granite Cave. "),_INTL("Granite Cave"),"NPC_Hoenn_MrStone",MAP_DEWFORD)
define_quest("main_devon_parts",:MAIN_QUEST,_INTL("Devon Parts Delivery"), _INTL("Deliver the Devon Parts to the Shipyard in Slateport City."),_INTL("Slateport City"),"NPC_Hoenn_MrStone",MAP_SLATEPORT)

#SIDE QUESTS
define_quest("template",:FIELD_QUEST,_INTL("Template Quest"), _INTL("Don't forget to change the quest ID if you copy paste this!"),_INTL("Unknown"),"000")

#route 102
define_quest("route_102_rematch",:FIELD_QUEST,_INTL("Revanche de Trainers"), _INTL("Uma Lass que batalhou com você quer mudar o time e pedir revanche!"),_INTL("Route 102"),"NPC_Hoenn_Lass")

#Petalburg Town
define_quest("petalburg_berry",:FIELD_QUEST,_INTL("Berry Contest"), _INTL("Take part in the berry-growing contest in Petalburg Town!"),_INTL("Petalburg Town"),"NPC_Hoenn_Breeder_F")


    #Route 116
define_quest("route116_glasses",:FIELD_QUEST,_INTL("Óculos perdidos"), _INTL("Um Trainer perdeu os óculos. Ajude-o a encontrá-los!"),_INTL("Route 116"),"NPC_Hoenn_Collector_NoGlasses")

#Route 104 (South)
define_quest("route104_rivalWeather",:FIELD_QUEST,_INTL("Observação do clima"), _INTL("Ajude seu rival com trabalho de campo e encontre um Pokémon que só aparece quando está ventando!"),_INTL("Route 104"),"rival")

#Petalburg woods
define_quest("petalburgwoods_spores",:FIELD_QUEST,_INTL("Colheita de esporos"), _INTL("Um cientista encarregou você de coletar 4 amostras de esporos dos cogumelos grandes encontrados na floresta!"),_INTL("Petalburg Woods"),"NPC_Hoenn_Scientist")

#Route 104 (North)
define_quest("route104_oricorio",:FIELD_QUEST,_INTL("Grama florida especial"), _INTL("Encontre um Oricorio na grama florida atrás da floricultura."),_INTL("Route 104"),"NPC_Hoenn_AromaLady")
define_quest("route104_oricorio_forms",:FIELD_QUEST,_INTL("Flores de néctar"), _INTL("Encontre todos os 4 tipos de flores de néctar para transformar Oricorio."),_INTL("Route 104"),"NPC_Hoenn_AromaLady")
define_quest("route104_allergic",:FIELD_QUEST,_INTL("The Allergic Rich Boy"), _INTL("An allergy-ridden rich boy is looking for a flowery Pokémon to give to his girlfriend."),_INTL("Route 104"),"NPC_Hoenn_RichBoy")

#Route 115
define_quest("route115_secretBase",:FIELD_QUEST,_INTL("Sua própria Secret Base!"), _INTL("Fale com Aarune perto da secret base dele para aprender a criar a sua."),_INTL("Route 115"),"NPC_Hoenn_AromaLady")

#Rustboro
define_quest("rustboro_whismur",:FIELD_QUEST,_INTL("Aumentador de volume!"), _INTL("Encontre um Wingull para fundir com um Whismur e deixá-lo mais alto."),_INTL("Rustboro City"),"NPC_schoolgirl")
define_quest("rustboro_shiny",:FIELD_QUEST,_INTL("A Green Marill?"), _INTL("A child claims they've seen a green Marill by the pond on Route 104. Go investigate!"),_INTL("Rustboro City"),"NPC_preschooler_m")
define_quest("rustboro_trash",:FIELD_QUEST,_INTL("Clean Up the Beach!"), _INTL("Help the ranger clean-up the beach behind the Devon Corp. building."),_INTL("Rustboro City"),"NPC_Hoenn_Ranger_M")
define_quest("rustboro_fusion",:FIELD_QUEST,_INTL("Wild Fusion Study"), _INTL("Help a scientist gather data by getting wild Pokémon to fuse before a battle 3 different times."),_INTL("Rustboro City"),"NPC_scientist_m")

#Dewford
define_quest("dewford_fishing",:FIELD_QUEST,_INTL("The Angler's Rite of Passage"), _INTL("It's tradition to fish a Skrelp near Dewford Town as a rite of passage. Find one and show it to the fisherman!"),_INTL("Dewford Town"),"NPC_Hoenn_Fisherman")

#Slateport
define_quest("slateport_team_aqua",:AQUA_QUEST,_INTL("Join Team Aqua!"), _INTL("Archie invited you to join Team Aqua. Go meet them at their camp on Slateport Beach if you so choose."),_INTL("Slateport City"),"NPC_Hoenn_Aqua_Archie",MAP_AQUA_CAMP)
define_quest("slateport_team_magma",:MAGMA_QUEST,_INTL("Join Team Magma!"), _INTL("Maxie invited you to join Team Magma. Go meet them at their camp, North of Slateport if you so choose."),_INTL("Slateport City"),"NPC_Hoenn_Magma_Maxie",MAP_MAGMA_CAMP)


# Route 109
define_quest("route109_tanning",:FIELD_QUEST,_INTL("Soaking in the sun"), _INTL("Sit in a beach chair until your suntan is on point!"),_INTL("Route 109"),"NPC_Hoenn_Triathlete_F")
define_quest("route109_seahouse",:FIELD_QUEST,_INTL("Hot Battles at the Seashore House"), _INTL("Defeat all of the trainers in the Seashore House!"),_INTL("Route 109"),"NPC_Hoenn_Fisherman")
define_quest("route109_beachball",:FIELD_QUEST,_INTL("Find a New Beach Ball!"), _INTL("Replace the popped beach ball of the kids playing on the beach"),_INTL("Route 109"),"NPC_Hoenn_Tuber_M")

#Team Magma - Route 103
define_quest("magma_camp_attack",:MAGMA_QUEST,_INTL("Under Attack!"), _INTL("Defend the Team Magma Camp against Team Aqua!"),_INTL("Magma Camp"),"NPC_Hoenn_Magma_Exec_M")
define_quest("magma_slugma_eggs",:MAGMA_QUEST,_INTL("Egg Hunt!"), _INTL("Collect Slugma Eggs with Tabitha."),_INTL("Cliffside Sanctuary"),"NPC_Hoenn_Magma_Exec_M")
define_quest("magma_help_grunts",:MAGMA_QUEST,_INTL("Grunt Work!"), _INTL("Help 3 grunts in the Team Magma Camp, then report back to Tabitha!"),_INTL("Magma Camp"),"NPC_Hoenn_Magma_Exec_M")
define_quest("magma_numel",:MAGMA_QUEST,_INTL("Anti-Water Training!"), _INTL("Fuse Numel to make it resistant Water-type attacks."),_INTL("Magma Camp"),"NPC_Hoenn_Magma_Grunt_M")
define_quest("magma_graffiti",:MAGMA_QUEST,_INTL("Painting the Town Red"), _INTL("Team Aqua painted their logo on various walls in Slateport City. Cover them up with the Team Magma logo instead!"),_INTL("Magma Camp"),"NPC_Hoenn_Magma_Grunt_F")
define_quest("magma_song",:MAGMA_QUEST,_INTL("The Magma Theme Song"), _INTL("Help compose lyrics to the official Team Magma theme song!"),_INTL("Magma Camp"),"NPC_Hoenn_Magma_Grunt_F")

#Team Aqua - Route 108
define_quest("aqua_camp_attack",:AQUA_QUEST,_INTL("Under Attack!"), _INTL("Defend the Team Aqua Camp against Team Magma!"),_INTL("Aqua Camp"),"NPC_Hoenn_Aqua_Exec_F")
define_quest("aqua_wailmer_eggs",:AQUA_QUEST,_INTL("Egg Hunt!"), _INTL("Collect Wailmer Eggs for Shelly."),_INTL("Route 108"),"NPC_Hoenn_Aqua_Exec_F")
define_quest("aqua_help_grunts",:AQUA_QUEST,_INTL("Grunt Work!"), _INTL("Help 3 grunts in the Team Aqua Camp, then report back to Shelly!"),_INTL("Aqua Camp"),"NPC_Hoenn_Aqua_Exec_F")
define_quest("aqua_carvanha",:AQUA_QUEST,_INTL("Just Add Water!"), _INTL("You were given two Zubats and a Geodude. Fuse all three of them into Water-type Pokémon."),_INTL("Aqua Camp"),"NPC_Hoenn_Aqua_Grunt_F")
define_quest("aqua_graffiti",:AQUA_QUEST,_INTL("Painting the Town Blue"), _INTL("Team Magma painted their logo on various walls in Slateport City. Cover them up with the Team Aqua logo instead!"),_INTL("Aqua Camp"),"NPC_Hoenn_Aqua_Grunt_M")
define_quest("aqua_song",:AQUA_QUEST,_INTL("The Aqua Theme Song"), _INTL("Help compose lyrics to the official Team Aqua theme song!"),_INTL("Aqua Camp"),"NPC_Hoenn_Aqua_Grunt_F")

#Route 110
define_quest("route110_bike",:FIELD_QUEST,_INTL("Cycling Road Time Trial"), _INTL("Go through the Cycling Road as fast as possible. You'll be penalized if you hit the walls!"),_INTL("Route 110"),"NPC_Hoenn_Triathlete_M_bike")


#Mauville
define_quest("mauville_quests_1",:FIELD_QUEST,_INTL("Associate Producer! - Episode 1"), _INTL("You've been hired as an associate producer on a TV show! Complete 2 quests to help write the second season of the show."),_INTL("Mauville TV"),"NPC_Hoenn_Collector")
define_quest("mauville_quests_2",:FIELD_QUEST,_INTL("Associate Producer! - Episode 2"), _INTL("You've been hired as an associate producer on a TV show! Complete 5 quests to help write the second season of the show."),_INTL("Mauville TV"),"NPC_Hoenn_Collector")
define_quest("mauville_quests_3",:FIELD_QUEST,_INTL("Associate Producer! - Episode 3"), _INTL("You've been hired as an associate producer on a TV show! Complete 10 quests to help write the second season of the show."),_INTL("Mauville TV"),"NPC_Hoenn_Collector")
define_quest("mauville_quests_4",:FIELD_QUEST,_INTL("Associate Producer! - Episode 4"), _INTL("You've been hired as an associate producer on a TV show! Complete 15 quests to help write the second season of the show."),_INTL("Mauville TV"),"NPC_Hoenn_Collector")
define_quest("mauville_quests_5",:FIELD_QUEST,_INTL("Associate Producer! - Episode 5"), _INTL("You've been hired as an associate producer on a TV show! Complete 20 quests to help write the second season of the show."),_INTL("Mauville TV"),"NPC_Hoenn_Collector")
define_quest("mauville_quests_6",:FIELD_QUEST,_INTL("Associate Producer! - Episode 6"), _INTL("You've been hired as an associate producer on a TV show! Complete 25 quests to help write the second season of the show."),_INTL("Mauville TV"),"NPC_Hoenn_Collector")
define_quest("mauville_quests_7",:FIELD_QUEST,_INTL("Associate Producer! - Episode 7"), _INTL("You've been hired as an associate producer on a TV show! Complete 30 quests to help write the second season of the show."),_INTL("Mauville TV"),"NPC_Hoenn_Collector")

define_quest("mauville_magma",:MAGMA_QUEST,_INTL("The Element of Surprise!"), _INTL("Catch a Tynamo in the waters near New Mauville to catch Team Aqua by surprise."),_INTL("Mauville City"),"NPC_Hoenn_Magma_Grunt_M")
define_quest("mauville_aqua",:AQUA_QUEST,_INTL("The Element of Surprise!"), _INTL("Catch a Tynamo in the waters near New Mauville to catch Team Magma by surprise."),_INTL("Mauville City"),"NPC_Hoenn_Aqua_Grunt_M")

#Route 111 (South)
define_quest("route111_winstrate",:FIELD_QUEST,_INTL("The Winstrate Family"), _INTL("Defeat all 4 members of the Winstrate family in back-to-back battles."),_INTL("Route 111"),"NPC_Hoenn_Pokefan_M")

#Verdanturf
define_quest("verdanturf_shroomish",:FIELD_QUEST,_INTL("A Lost Shroomish"), _INTL("A girl lost her Shroomish and needs your help to find it."),_INTL("Verdanturf Town"),"NPC_Hoenn_Schoolgirl")
define_quest("verdanturf_nurse",:FIELD_QUEST,_INTL("The Bored Nurse"), _INTL("The Pokémon Center's nurse challenged you to a battle. Meet her in the meadow behind the Pokémon Center."),_INTL("Verdanturf Town"),"NPC_nurse")

#Rusturf Tunnel
define_quest("rusturf_trumpet",:FIELD_QUEST,_INTL("Uproar in B Flat"), _INTL("A trumpet player is cornered in Rusturf Tunnel. Find a way to help him!"),_INTL("Rusturf Tunnel"),"NPC_Hoenn_trumpet_playing")
define_quest("evergrande_trumpet",:FIELD_QUEST,_INTL("The Trumpet Festival!"), _INTL("Find the 4 Trumpet Brothers and join the Trumpet Festival in Evergrande City."),_INTL("Evergrande City"),"NPC_Hoenn_trumpet_playing",MAP_EVERGRANDE)

#Route 112
#Route 111 (North)
#Route 113
define_quest("route113_sootgrass",:FIELD_QUEST,_INTL("Clear Out the Soot!"), _INTL("Get rid of the soot on every single patch of grass on Route 113."),_INTL("Route 113"),"NPC_oldman3")
