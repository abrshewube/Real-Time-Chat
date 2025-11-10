defmodule RealTimeChatApp.Application do
  @moduledoc false
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      RealTimeChatAppWeb.Telemetry,
      RealTimeChatApp.Repo,
      {Phoenix.PubSub, name: RealTimeChatApp.PubSub},
      RealTimeChatAppWeb.Presence,
      RealTimeChatAppWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: RealTimeChatApp.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @impl true
  def config_change(changed, _new, removed) do
    RealTimeChatAppWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
