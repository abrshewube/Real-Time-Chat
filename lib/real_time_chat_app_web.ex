defmodule RealTimeChatAppWeb do
  use PyrauiWeb, :html

  @moduledoc """
  The entrypoint for defining your web interface, such
  as controllers, views, components and so on.

  This can be used in your application as:

      use RealTimeChatAppWeb, :controller
      use RealTimeChatAppWeb, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below. Instead, define any helper function in modules
  and import those modules here.
  """

  def router do
    quote do
      use Phoenix.Router

      import Plug.Conn
      import Phoenix.Controller
      import Phoenix.LiveView.Router
    end
  end

  def static_paths, do: ~w(assets fonts images favicon.ico robots.txt)

  def channel do
    quote do
      use Phoenix.Channel
      use Gettext, backend: RealTimeChatAppWeb.Gettext
    end
  end

  def controller do
    quote do
      use Phoenix.Controller, namespace: RealTimeChatAppWeb

      import Plug.Conn
      use Gettext, backend: RealTimeChatAppWeb.Gettext
      alias RealTimeChatAppWeb.Router.Helpers, as: Routes
      import Phoenix.LiveView.Controller
    end
  end

  def live_view do
    quote do
      use Phoenix.LiveView,
        layout: {RealTimeChatAppWeb.Layouts, :app}

      import RealTimeChatAppWeb.CoreComponents
      import Pyraui.Components.Button
      import Pyraui.Components.Card
      use Gettext, backend: RealTimeChatAppWeb.Gettext

      alias RealTimeChatAppWeb.Router.Helpers, as: Routes
    end
  end

  def live_component do
    quote do
      use Phoenix.LiveComponent

      import RealTimeChatAppWeb.CoreComponents
      import Pyraui.Components.Button
      import Pyraui.Components.Card
      use Gettext, backend: RealTimeChatAppWeb.Gettext

      alias RealTimeChatAppWeb.Router.Helpers, as: Routes
    end
  end

  def html do
    quote do
      use Phoenix.Component

      # Import convenience functions from controllers
      import Phoenix.Controller,
        only: [get_csrf_token: 0, view_module: 1, view_template: 1]

      # Include general helpers for rendering HTML
      import RealTimeChatAppWeb.CoreComponents
      import Pyraui.Components.Button
      import Pyraui.Components.Card
      use Gettext, backend: RealTimeChatAppWeb.Gettext

      alias RealTimeChatAppWeb.Router.Helpers, as: Routes
    end
  end

  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
