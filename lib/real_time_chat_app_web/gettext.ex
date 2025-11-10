defmodule RealTimeChatAppWeb.Gettext do
  @moduledoc """
  A module providing Internationalization with a gettext-based API.

  By using [Gettext](https://hexdocs.pm/gettext),
  your module gains a set of macros for translations, for example:

      import RealTimeChatAppWeb.Gettext

      # Simple translation
      gettext("Hello world")

      # Plural translation
      ngettext("Hello world", "Hello worlds", count)

      # Domain-based translation
      dgettext("errors", "Page not found")

  See the [Gettext Docs](https://hexdocs.pm/gettext) for detailed usage.
  """
  use Gettext.Backend, otp_app: :real_time_chat_app
end
