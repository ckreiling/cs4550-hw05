defmodule MemoryWeb.Channel do
  use Phoenix.Channel

  import Memory.Game

  def join "games:" <> id, _message, socket do
    { :ok, Memory.Game.get_game_state(id), socket }
  end

  def handle_in "reset_game", _params, socket do
    "games:" <> id = socket.topic
    broadcast! socket, "new_game_state", Memory.Game.reset_game(id)
    { :noreply, socket }
  end

  def handle_in "tile_clicked", %{"tile" => tile}, socket do
    "games:" <> id = socket.topic
    new_state = Memory.Game.tile_clicked(id, tile)
    broadcast! socket, "new_game_state", new_state
    if new_state[:frozen] do
      Process.sleep(3000)
      new_state = Memory.Game.unfreeze id
      broadcast! socket, "new_game_state", new_state
    end
    { :noreply, socket }
  end
end