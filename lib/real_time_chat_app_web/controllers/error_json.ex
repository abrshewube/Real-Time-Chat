defmodule RealTimeChatAppWeb.ErrorHTML do
  use RealTimeChatAppWeb, :html

  def render("404.html", _assigns) do
    "Page not found"
  end

  def render("500.html", _assigns) do
    "Internal server error"
  end
end

defmodule RealTimeChatAppWeb.ErrorJSON do
  def render("404.json", _assigns) do
    %{errors: %{detail: "Not found"}}
  end

  def render("500.json", _assigns) do
    %{errors: %{detail: "Internal server error"}}
  end
end
