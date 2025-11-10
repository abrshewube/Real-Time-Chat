# Real-Time Chat App 💬

A real-time chat application built with Phoenix LiveView, demonstrating Phoenix Channels, Presence, WebSockets, and PubSub.

## ✨ Features

- ✅ User authentication with secure password hashing
- ✅ Real-time messaging using Phoenix Channels
- ✅ Online/offline user presence tracking with Phoenix Presence
- ✅ Chat history stored in PostgreSQL
- ✅ Beautiful, modern UI with LiveView updates
- ✅ Typing indicators
- ✅ Responsive design

## 🚀 Quick Start

### Prerequisites
- Elixir 1.14+ and Erlang/OTP
- PostgreSQL (running)
- Node.js 16+

### Installation Steps

1. **Install Elixir dependencies:**
```bash
mix deps.get
```

2. **Install Node.js dependencies:**
```bash
cd assets && npm install && cd ..
```

3. **Create and setup database:**
```bash
mix ecto.create
mix ecto.migrate
mix run priv/repo/seeds.exs
```

4. **Start the server:**
```bash
mix phx.server
```

5. **Open your browser:**
Visit `http://localhost:4000`

**📖 For detailed setup instructions, see [INSTALL.md](INSTALL.md)**

## 👥 Test Users

The seed file creates three test users:

| Email | Password | Username |
|-------|----------|----------|
| alice@example.com | password123 | alice |
| bob@example.com | password123 | bob |
| charlie@example.com | password123 | charlie |

## Architecture

- **Authentication**: Custom auth system with bcrypt password hashing
- **Real-time Updates**: Phoenix PubSub for LiveView integration
- **Presence**: Phoenix Presence for tracking online users
- **Channels**: Phoenix Channels for WebSocket communication
- **Database**: PostgreSQL with Ecto
- **UI**: Tailwind CSS with Phoenix LiveView

## Project Structure

- `lib/real_time_chat_app/accounts/` - User authentication and management
- `lib/real_time_chat_app/chat/` - Chat message handling
- `lib/real_time_chat_app_web/live/` - LiveView components
- `lib/real_time_chat_app_web/channels/` - Phoenix Channels
- `priv/repo/migrations/` - Database migrations

## Learn More

- [Phoenix Framework](https://www.phoenixframework.org/)
- [Phoenix LiveView](https://hexdocs.pm/phoenix_live_view/)
- [Phoenix Channels](https://hexdocs.pm/phoenix/Phoenix.Channel.html)
- [Phoenix Presence](https://hexdocs.pm/phoenix/Phoenix.Presence.html)

