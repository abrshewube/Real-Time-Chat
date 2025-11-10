defmodule RealTimeChatAppWeb.CoreComponents do
  @moduledoc """
  Provides core UI components.
  """
  use Phoenix.Component
  import Phoenix.LiveView.JS

  def flash_group(assigns) do
    ~H"""
    <div id="flash-group" class="flash-group" phx-click={hide(to: "#flash-group")} phx-key="escape" phx-key-code="Escape">
      <%= for {kind, message} <- @flash do %>
        <div
          id={"flash-#{kind}"}
          class={"rounded-lg p-4 mb-4 #{flash_class(kind)}"}
          role="alert"
          phx-click={hide(to: "#flash-#{kind}")}
        >
          <div class="flex items-center justify-between">
            <p class="font-medium"><%= message %></p>
            <button
              type="button"
              class="ml-4 text-white hover:text-gray-200"
              phx-click={hide(to: "#flash-#{kind}")}
            >
              ×
            </button>
          </div>
        </div>
      <% end %>
    </div>
    """
  end

  defp flash_class(:info), do: "bg-blue-100 text-blue-800 border border-blue-200"
  defp flash_class(:error), do: "bg-red-100 text-red-800 border border-red-200"
  defp flash_class(_), do: "bg-gray-100 text-gray-800 border border-gray-200"
end
