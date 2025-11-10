defmodule RealTimeChatAppWeb.HomeLive do
  use RealTimeChatAppWeb, :live_view

  on_mount {RealTimeChatAppWeb.UserAuth, :redirect_if_authenticated}

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, show_register: false)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div id="home-page" class="min-h-screen bg-gradient-to-br from-blue-50 via-indigo-50 to-purple-50 flex items-center justify-center p-4" phx-hook="SetCSRFToken">
      <div class="max-w-md w-full">
        <div class="bg-white rounded-2xl shadow-xl p-8">
          <div class="text-center mb-8">
            <h1 class="text-4xl font-bold text-gray-900 mb-2">💬 ChatApp</h1>
            <p class="text-gray-600">Connect with friends in real-time</p>
          </div>

          <.flash_group flash={@flash} />

          <div class="space-y-6">
            <!-- Login Form -->
            <div :if={!@show_register} class="space-y-4">
              <h2 class="text-2xl font-semibold text-gray-800 text-center">Sign In</h2>

              <form action="/login" method="post" class="space-y-4" id="login-form">
                <input type="hidden" name="_csrf_token" id="login-csrf-token" />
                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-1">Email</label>
                  <input
                    type="email"
                    name="email"
                    required
                    class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent transition"
                    placeholder="you@example.com"
                  />
                </div>

                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-1">Password</label>
                  <input
                    type="password"
                    name="password"
                    required
                    class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent transition"
                    placeholder="••••••••"
                  />
                </div>

                <button
                  type="submit"
                  class="w-full bg-blue-600 hover:bg-blue-700 text-white font-semibold py-3 px-4 rounded-lg transition duration-200 shadow-md hover:shadow-lg"
                >
                  Sign In
                </button>
              </form>

              <div class="text-center">
                <button
                  phx-click="toggle_register"
                  class="text-blue-600 hover:text-blue-700 font-medium"
                >
                  Don't have an account? Sign up
                </button>
              </div>
            </div>

            <!-- Register Form -->
            <div :if={@show_register} class="space-y-4">
              <h2 class="text-2xl font-semibold text-gray-800 text-center">Create Account</h2>

              <form action="/register" method="post" class="space-y-4" id="register-form">
                <input type="hidden" name="_csrf_token" id="register-csrf-token" />
                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-1">Email</label>
                  <input
                    type="email"
                    name="email"
                    required
                    class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent transition"
                    placeholder="you@example.com"
                  />
                </div>

                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-1">Username</label>
                  <input
                    type="text"
                    name="username"
                    required
                    minlength="3"
                    maxlength="20"
                    class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent transition"
                    placeholder="choose a username"
                  />
                </div>

                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-1">Password</label>
                  <input
                    type="password"
                    name="password"
                    required
                    minlength="8"
                    class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent transition"
                    placeholder="••••••••"
                  />
                </div>

                <button
                  type="submit"
                  class="w-full bg-purple-600 hover:bg-purple-700 text-white font-semibold py-3 px-4 rounded-lg transition duration-200 shadow-md hover:shadow-lg"
                >
                  Create Account
                </button>
              </form>

              <div class="text-center">
                <button
                  phx-click="toggle_register"
                  class="text-blue-600 hover:text-blue-700 font-medium"
                >
                  Already have an account? Sign in
                </button>
              </div>
            </div>

            <div class="pt-6 border-t border-gray-100">
              <.card class="max-w-md mx-auto">
                <h3 class="text-xl font-semibold">Welcome aboard</h3>
                <p class="mt-2 text-sm text-slate-500">
                  You now have access to 100+ LiveView components styled with Tailwind and motion-ready tokens.
                </p>
                <div class="mt-4">
                  <.button variant={:primary} icon="rocket-launch" size={:lg}>
                    Deploy Changes
                  </.button>
                </div>
              </.card>
            </div>
          </div>
        </div>
      </div>
    </div>
    """
  end
  @impl true
  def handle_event("toggle_register", _params, socket) do
    {:noreply, update(socket, :show_register, &(!&1))}
  end
end
