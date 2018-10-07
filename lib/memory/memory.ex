defmodule Memory.Game do
  use Agent

  @doc """
  Starts the memory game agent, ready to spin up new games
  """
  def start_link _args do
    Agent.start_link fn -> Map.new end, name: __MODULE__
  end

  @doc """
  Gets the game state for a single game. If the game isn't started, it will be
  created with an initial state
  """
  def get_game_state id do
    Agent.get_and_update __MODULE__, fn lobby ->
      unless Map.has_key? lobby, id do
        state = initial_state()
        { state, Map.put(lobby, id, state) }
      else
        { Map.get(lobby, id), lobby }
      end
    end
  end

  def reset_game id do
    Agent.get_and_update __MODULE__, &Tuple.append({ initial_state }, Map.put(&1, id, initial_state))
    # TODO: make sure the timeout is cancelled before resetting
  end

  @doc """
  Updates the state for the game associated with the given id, and returns it.
  """
  def tile_clicked id, tile do
    Agent.get_and_update __MODULE__, fn lobby -> 
      state = lobby[id]
      if state[:frozen] do
        { state, lobby }
      end
      n_clicks = state[:num_clicks] + 1
      state = Map.replace state, :num_clicks, n_clicks
      unless state[:first_selected] do
        new_state = first_tile_clicked state, tile
        { new_state, Map.put(lobby, id, new_state) }
      else
        new_state = second_tile_clicked id, state, tile
        { new_state, Map.put(lobby, id, new_state) }
      end
    end
  end

  def unfreeze id do
    Agent.get_and_update __MODULE__, fn lobby ->
      state = lobby[id]
      unfrozen_state = Map.merge(state, %{ :frozen => false, :first_selected => nil, :second_selected => nil, state[:first_selected] => false, state[:second_selected] => false })
      { unfrozen_state, Map.put(lobby, id, unfrozen_state) }
    end
  end

  defp first_tile_clicked state, tile do
    Map.merge state, %{:first_selected => tile, tile => true}
  end

  defp second_tile_clicked id, state, tile do
    inv = get_inverse String.split_at(tile, 1)
    if state[inv] do
      Map.merge state, %{ :first_selected => nil, tile => true}
    else
      first_selected = state[:first_selected]
      Map.merge state, %{:frozen => true, :second_selected => tile, tile => true }
    end
  end

  defp get_inverse {letter, "1"} do letter <> "2" end
  defp get_inverse {letter, "2"} do letter <> "1" end

  defp tiles do 
    letters = ["H", "G", "F", "E", "D", "C", "B", "A"]
    Enum.reduce letters, [], &([ "#{&1}1" | ["#{&1}2" | &2]])
  end

  defp tiles_random do Enum.take_random tiles, length(tiles) end
  defp tiles_map do Enum.reduce tiles, Map.new, &Map.put(&2, &1, false) end

  defp initial_state do
    base_state = %{
      :num_clicks => 0,
      :frozen => false,
      :tiles_random_order => tiles_random,
      :frozen => false,
      :first_selected => nil,
      :second_selected => nil,
    }
    Map.merge base_state, tiles_map
  end
end
