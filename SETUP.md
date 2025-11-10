# Real-Time Chat App - Complete Setup Guide

## 🚀 Quick Start

1. **Install dependencies:**
   ```bash
   mix deps.get
   cd assets && npm install && cd ..
   ```

2. **Set up the database:**
   ```bash
   mix ecto.create
   mix ecto.migrate
   mix run priv/repo/seeds.exs
   ```

3. **Start the server:**
   ```bash
   mix phx.server
   ```

4. **Open your browser:**
   Visit `http://localhost:4000` and start chatting!

## 📝 Test Users

The seed file creates three test users for easy testing:
- **Alice**: `alice@example.com` / `password123`
- **Bob**: `bob@example.com` / `password123`
- **Charlie**: `charlie@example.com` / `password123`

## 🏗️ Architecture Overview

This app demonstrates several Phoenix concepts:

### Authentication Flow
- Users register/login through `HomeLive` (LiveView)
- Session is stored in cookies via `Auth` plug
- Protected routes use `UserAuth` on_mount hook

### Real-Time Updates
- **LiveView**: Uses PubSub for server-to-client updates
- **Channels**: Uses WebSocket channels for client-to-client communication
- **Presence**: Tracks online users automatically

### Data Flow
1. User sends message → `ChatLive.handle_event`
2. Message saved to database → `Chat.create_message`
3. Message broadcast via PubSub → All subscribers receive update
4. UI updates automatically → LiveView re-renders

## 🎨 Features

- ✅ **User Authentication**: Secure registration and login
- ✅ **Real-Time Messaging**: Instant message delivery via PubSub
- ✅ **Online Presence**: See who's online in real-time
- ✅ **Typing Indicators**: Know when someone is typing
- ✅ **Message History**: Last 50 messages loaded on join
- ✅ **Beautiful UI**: Modern design with Tailwind CSS
- ✅ **Responsive**: Works on desktop and mobile

## 🔧 Key Files

- `lib/real_time_chat_app_web/live/chat_live.ex` - Main chat interface
- `lib/real_time_chat_app_web/channels/room_channel.ex` - WebSocket channel handler
- `lib/real_time_chat_app/accounts.ex` - User authentication logic
- `lib/real_time_chat_app/chat.ex` - Message handling logic
- `assets/js/app.js` - Client-side JavaScript hooks

## 🐛 Troubleshooting

**Database connection issues:**
- Make sure PostgreSQL is running
- Check credentials in `config/dev.exs`

**Assets not loading:**
- Run `cd assets && npm install`
- Check that `mix phx.server` is running (watches assets)

**Messages not appearing:**
- Check browser console for errors
- Verify WebSocket connection in Network tab
- Make sure PubSub is running (check `application.ex`)

## 📚 Learn More

- [Phoenix LiveView Guide](https://hexdocs.pm/phoenix_live_view/)
- [Phoenix Channels](https://hexdocs.pm/phoenix/Phoenix.Channel.html)
- [Phoenix Presence](https://hexdocs.pm/phoenix/Phoenix.Presence.html)

