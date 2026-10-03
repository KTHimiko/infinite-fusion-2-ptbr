class PokemonStorageScreen
  # --- Define sortable criteria ---
  def sortable_criteria
    [
      {
        key: :dex,
        label: _INTL("Por número da Pokédex"),
        value_proc: ->(p) { p.id_number || 0 },
        friendly: [_INTL("Menor para maior número da Pokédex"), _INTL("Maior para menor número da Pokédex")]
      },
      {
        key: :head_dex,
        label: _INTL("Por número da Pokédex da cabeça"),
        value_proc: ->(p) { p.head_id || 0 },
        friendly: [_INTL("Menor para maior número da Pokédex"), _INTL("Maior para menor número da Pokédex")]
      },
      {
        key: :body_dex,
        label: _INTL("Por número da Pokédex do corpo"),
        value_proc: ->(p) { p.body_id || 0 },
        friendly: [_INTL("Menor para maior número da Pokédex"), _INTL("Maior para menor número da Pokédex")]
      },
      {
        key: :alpha_species,
        label: _INTL("Por nome da espécie"),
        value_proc: ->(p) { (p.species.to_s || "").downcase },
        friendly: [_INTL("A to Z"), _INTL("Z to A")]
      },
      {
        key: :alpha,
        label: _INTL("Por apelido"),
        value_proc: ->(p) { (p.name || "").downcase },
        friendly: [_INTL("A to Z"), _INTL("Z to A")]
      },
      {
        key: :level,
        label: _INTL("By base stats"),
        value_proc: ->(p) { p.bst || 0 },
        friendly: [_INTL("A to Z"), _INTL("Z to A")]
      },
      {
        key: :level,
        label: _INTL("Por level"),
        value_proc: ->(p) { p.level || 0 },
        friendly: [_INTL("Menor para maior level"), _INTL("Maior para menor level")]
      },
      {
        key: :type,
        label: _INTL("Por tipo"),
        value_proc: ->(p) {
          # Grab both types (fallbacks in case one is nil)
          t1 = p.type1 || :NORMAL
          t2 = p.type2 || ""
          [
            GameData::Type.get(t1).name,
            GameData::Type.get(t2).name
          ]
        },
        friendly: [_INTL("A a Z por tipo"), _INTL("Z a A por tipo")]
      },
      {
        key: :date,
        label: _INTL("Por data de captura"),
        value_proc: ->(p) { p.timeReceived || Time.at(0) },
        friendly: [_INTL("Mais antigo para mais recente"), _INTL("Mais recente para mais antigo")]
      },
      {
        key: :invert,
        label: _INTL("Reverse"),
        value_proc: ->(p) { reverse },
        friendly: [_INTL("Inverter a ordem")]
      },
      {
        key: :random,
        label: _INTL("Embaralhar"),
        value_proc: ->(p) { rand },
        friendly: [_INTL("Randomizar a ordem")]
      },

    ]
  end

  # --- Ask which criterion to sort by ---
  def pbAskSortCriterion
    commands = sortable_criteria.map { |c| c[:label] } + [_INTL("Cancelar")]
    cmd = pbShowCommands(_INTL("Como ordenar os Pokémon selecionados?"), commands)
    return nil if cmd == commands.length - 1
    return nil if cmd <= -1
    return cmd
  end

  # --- Ask for order using friendly text ---
  def pbAskSortOrder(criterion_index)
    crit = sortable_criteria[criterion_index]
    orders = crit[:friendly] + [_INTL("Cancelar")]
    ord = pbShowCommands(_INTL("Qual ordem?"), orders)
    return nil if ord <= -1
    return nil if ord == orders.length - 1
    return ord == 1 # true if descending
  end

  # --- Sort the array according to criterion and order ---
  def sort_pokemon_array!(arr, criterion_index, descending)
    crit = sortable_criteria[criterion_index]
    if crit[:key] == :invert
      arr.reverse!
      return
    end
    arr.sort_by! { |p| crit[:value_proc].call(p) }
    arr.reverse! if descending
  end

  # --- Main method stays mostly unchanged ---
  def pbSortMulti(box)
    selected = getMultiSelection(box, nil)
    return if selected.empty?

    pokes = selected.map { |idx| @storage[box, idx] }.compact
    return if pokes.empty?

    criterion = pbAskSortCriterion
    return if criterion.nil?

    descending = pbAskSortOrder(criterion)
    return if descending.nil?

    sort_pokemon_array!(pokes, criterion, descending)

    # Clear selected slots
    selected.each { |idx| @storage[box, idx] = nil }

    # Refill the rectangle row-by-row
    rect = getSelectionRect(box, nil)
    i = 0
    if rect
      for y in rect.y...(rect.y + rect.height)
        for x in rect.x...(rect.x + rect.width)
          break if i >= pokes.length
          idx = getBoxIndex(box, x, y)
          @storage[box, idx] = pokes[i]
          i += 1
        end
      end
    else
      selected.each do |idx|
        break if i >= pokes.length
        @storage[box, idx] = pokes[i]
        i += 1
      end
    end

    pbSEPlay("GUI party switch")
    @scene.pbHardRefresh
  end


end