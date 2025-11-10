defmodule RealTimeChatApp.Repo do
  use Ecto.Repo,
    otp_app: :real_time_chat_app,
    adapter: Ecto.Adapters.Postgres
end

