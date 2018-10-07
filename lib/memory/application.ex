defmodule Memory.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised. These modules' start_link
    # function will be called.
    children = [
      # Start the endpoint when the application starts
      MemoryWeb.Endpoint,
      # Start the memory game process when the app starts
      Memory.Game
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Memory.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    MemoryWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
