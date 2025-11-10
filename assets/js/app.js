// Import our CSS styles - this gets processed by Tailwind and bundled by esbuild
import "../css/app.css"

// Import the progress bar library for nice loading indicators
import topbar from "topbar"
// Import Phoenix Socket and LiveSocket - these connect our browser to Phoenix LiveView
import { Socket } from "phoenix"
import { LiveSocket } from "phoenix_live_view"

// Custom JavaScript hooks for LiveView
// These let us add client-side behavior that Phoenix can trigger
let Hooks = {}

// Hook to auto-scroll the messages container when new messages arrive
// This makes the chat feel smooth and natural - always showing the latest message
Hooks.ScrollToBottom = {
  updated() {
    // When Phoenix updates this element, scroll to the bottom
    this.el.scrollTop = this.el.scrollHeight
  }
}

// Hook to set CSRF tokens in forms
// This ensures CSRF tokens are always set when forms are rendered
Hooks.SetCSRFToken = {
  mounted() {
    this.setCSRFToken()
  },
  updated() {
    this.setCSRFToken()
  },
  setCSRFToken() {
    const metaToken = document.querySelector("meta[name='csrf-token']")
    if (metaToken) {
      const csrfToken = metaToken.getAttribute("content")
      const loginInput = document.getElementById("login-csrf-token")
      const registerInput = document.getElementById("register-csrf-token")
      if (loginInput && !loginInput.value) loginInput.value = csrfToken
      if (registerInput && !registerInput.value) registerInput.value = csrfToken
    }
  }
}

// Get the CSRF token from the page - Phoenix needs this for security
// CSRF tokens prevent cross-site request forgery attacks
let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")

// Create the LiveSocket connection
// This establishes a WebSocket connection to Phoenix for real-time updates
let liveSocket = new LiveSocket("/live", Socket, {
  params: { _csrf_token: csrfToken },  // Send CSRF token with every request
  hooks: Hooks  // Register our custom hooks
})

// Configure the progress bar - that blue bar at the top when loading
topbar.config({ barColors: { 0: "#29d" }, shadowColor: "rgba(0, 0, 0, .3)" })

// Show progress bar when LiveView starts loading (navigation, form submits, etc.)
window.addEventListener("phx:page-loading-start", info => topbar.show())
window.addEventListener("phx:page-loading-stop", info => topbar.hide())

// Connect to the server - this opens the WebSocket connection
liveSocket.connect()

// Expose liveSocket globally for debugging
// You can open the browser console and run:
//   liveSocket.enableDebug()  // See all LiveView events
//   liveSocket.enableLatencySim(1000)  // Simulate slow network (for testing)
//   liveSocket.disableLatencySim()
window.liveSocket = liveSocket

// Custom event listener for scrolling to bottom
// Phoenix can trigger this via push_event("scroll_to_bottom", %{})
// This gives us fine-grained control over when to scroll
window.addEventListener("phx:scroll_to_bottom", () => {
  const messagesContainer = document.getElementById("messages")
  if (messagesContainer) {
    // Smooth scroll to the bottom to show the latest message
    messagesContainer.scrollTop = messagesContainer.scrollHeight
  }
})

