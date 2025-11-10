# 🚀 Installation & Setup Guide

## Prerequisites

Make sure you have these installed:
- **Elixir** (1.14+) - [Install Guide](https://elixir-lang.org/install.html)
- **Erlang/OTP** (usually comes with Elixir)
- **PostgreSQL** - [Install Guide](https://www.postgresql.org/download/)
- **Node.js** (16+) - [Install Guide](https://nodejs.org/)
- **Mix** (comes with Elixir)

## Step-by-Step Setup

### 1. Install Elixir Dependencies

Open your terminal in the project directory and run:

```bash
mix deps.get
```

This downloads all Elixir packages (Phoenix, Ecto, etc.) defined in `mix.exs`.

### 2. Install Node.js Dependencies

```bash
cd assets
npm install
cd ..
```

This installs JavaScript packages (Phoenix LiveView client, Tailwind, etc.).

### 3. Configure Database

Make sure PostgreSQL is running on your system.

Edit `config/dev.exs` if your PostgreSQL credentials are different:
```elixir
username: "postgres",  # Change if needed
password: "postgres",  # Change if needed
hostname: "localhost",
```

### 4. Create and Setup Database

```bash
# Create the database
mix ecto.create

# Run migrations (creates users and messages tables)
mix ecto.migrate

# Seed the database (creates test users)
mix run priv/repo/seeds.exs
```

### 5. Generate Secret Key (if needed)

For production, generate a secret key:
```bash
mix phx.gen.secret
```
Then add it to your environment variables.

### 6. Start the Server

```bash
mix phx.server
```

You should see output like:
```
[info] Running RealTimeChatAppWeb.Endpoint with cowboy 2.9.0 at 127.0.0.1:4000 (http)
[info] Access RealTimeChatAppWeb.Endpoint at http://localhost:4000
```

### 7. Open in Browser

Visit: **http://localhost:4000**

## 🧪 Test Users

The seed file creates these test accounts:

| Email | Password | Username |
|-------|----------|----------|
| alice@example.com | password123 | alice |
| bob@example.com | password123 | bob |
| charlie@example.com | password123 | charlie |

## 🐛 Troubleshooting

### Database Connection Error

**Error:** `could not connect to server`

**Solution:**
1. Make sure PostgreSQL is running:
   ```bash
   # Windows (PowerShell)
   Get-Service postgresql*
   
   # Mac/Linux
   sudo service postgresql status
   ```

2. Start PostgreSQL if it's not running:
   ```bash
   # Windows
   net start postgresql-x64-14  # (version may vary)
   
   # Mac (Homebrew)
   brew services start postgresql
   
   # Linux
   sudo systemctl start postgresql
   ```

3. Check credentials in `config/dev.exs`

### Port Already in Use

**Error:** `address already in use: :4000`

**Solution:**
```bash
# Find and kill the process using port 4000
# Windows
netstat -ano | findstr :4000
taskkill /PID <PID> /F

# Mac/Linux
lsof -ti:4000 | xargs kill -9
```

Or change the port in `config/dev.exs`:
```elixir
http: [ip: {127, 0, 0, 1}, port: 4001],  # Use 4001 instead
```

### Assets Not Loading

**Problem:** CSS/JS not appearing

**Solution:**
1. Make sure `npm install` completed successfully
2. Restart the server - it should auto-compile assets
3. Check browser console for errors
4. Try manually building assets:
   ```bash
   cd assets
   npm run build
   ```

### Mix Command Not Found

**Error:** `mix: command not found`

**Solution:**
1. Install Elixir: https://elixir-lang.org/install.html
2. Restart your terminal
3. Verify installation:
   ```bash
   elixir --version
   mix --version
   ```

## 📝 Common Commands

```bash
# Start development server
mix phx.server

# Stop server
Ctrl+C (twice)

# Reset database (DANGER: deletes all data)
mix ecto.reset

# Run tests
mix test

# Check for compilation errors
mix compile

# Format code
mix format
```

## 🔧 Development Tips

1. **Hot Reloading**: Code changes automatically reload (no restart needed)
2. **Asset Watching**: CSS/JS changes auto-compile when you save
3. **Live Dashboard**: Visit `http://localhost:4000/dev/dashboard` (dev only)
4. **Database Console**: Run `mix ecto.gen.migration name` to create migrations

## 🎯 Quick Test

1. Open `http://localhost:4000` in browser #1
2. Login as `alice@example.com` / `password123`
3. Open `http://localhost:4000` in browser #2 (incognito window)
4. Login as `bob@example.com` / `password123`
5. Send messages - they should appear instantly in both browsers!

## ✨ Next Steps

- Customize colors in `lib/real_time_chat_app/accounts/user.ex` (avatar_color)
- Add more rooms by creating new channels
- Add file uploads for images
- Add emoji support
- Add message reactions

Happy coding! 🎉

