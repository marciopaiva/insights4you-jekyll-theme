const THEME_STORAGE_KEY = "tablerTheme";
const DEFAULT_THEME = "light";

// Proxy to access URL parameters
const params = new Proxy(new URLSearchParams(window.location.search), {
  get: (searchParams, prop) => searchParams.get(prop),
});

// Validate theme values
function isValidTheme(theme) {
  return ["light", "dark"].includes(theme);
}

// Apply the selected theme to the document
function applyTheme(theme) {
  document.body.setAttribute("data-bs-theme", theme);
}

// Save the selected theme to localStorage
function saveTheme(theme) {
  localStorage.setItem(THEME_STORAGE_KEY, theme);
}

// Load the current theme based on priority: URL > localStorage > system preference > default
function loadTheme() {
  let selectedTheme;

  // Prioritize theme from URL
  if (params.theme && isValidTheme(params.theme)) {
    selectedTheme = params.theme;
    saveTheme(selectedTheme);
  } else {
    // Use localStorage or system preference
    const storedTheme = localStorage.getItem(THEME_STORAGE_KEY);
    selectedTheme = isValidTheme(storedTheme)
      ? storedTheme
      : window.matchMedia("(prefers-color-scheme: dark)").matches
      ? "dark"
      : DEFAULT_THEME;
  }

  // Apply the selected theme
  applyTheme(selectedTheme);
}

// Toggle between light and dark themes
function toggleTheme(theme) {
  saveTheme(theme);
  applyTheme(theme);
}

// Load dynamic notifications
async function loadNotifications() {
  const notificationsList = document.getElementById("notifications-list");
  const badge = document.getElementById("notification-badge");

  if (!notificationsList || !badge) return;

  try {
    // Fetch local notifications if available
    const localNotifications = getLocalNotifications();

    // Fetch remote notifications
    const remoteNotifications = await fetchRemoteNotifications();

    // Combine, sort, and render notifications
    const allNotifications = combineAndSortNotifications(localNotifications, remoteNotifications);
    renderNotifications(allNotifications, notificationsList, badge);
  } catch (error) {
    console.error("Error loading notifications:", error);
  }
}

// Fetch local notifications from site data
function getLocalNotifications() {
  try {
    return window.siteData?.notifications || [];
  } catch (error) {
    console.error("Error loading local notifications:", error);
    return [];
  }
}

// Fetch remote notifications from GitHub repository
async function fetchRemoteNotifications() {
  try {
    const response = await fetch(
      "https://raw.githubusercontent.com/marciopaiva/insights4you-jekyll-theme/main/_data/notifications.yml"
    );
    if (!response.ok) throw new Error("Failed to fetch remote notifications");
    const yamlText = await response.text();
    return jsyaml.load(yamlText) || [];
  } catch (error) {
    console.error("Error fetching remote notifications:", error);
    return [];
  }
}

// Combine and sort notifications by date
function combineAndSortNotifications(local, remote) {
  return [...remote, ...local]
    .sort((a, b) => new Date(b.date) - new Date(a.date))
    .slice(0, 5); // Display only the latest 5 notifications
}

// Render notifications in the DOM
function renderNotifications(notifications, listElement, badgeElement) {
  badgeElement.textContent = notifications.length;
  notifications.forEach((notification) => {
    const item = `
      <div class="list-group-item">
        <div class="row align-items-center">
          <div class="col-auto">
            <span class="status-dot bg-${notification.color || "blue"} d-block"></span>
          </div>
          <div class="col text-truncate">
            <a href="${notification.link}" class="text-body d-block">${notification.title}</a>
            <div class="text-secondary">${notification.description}</div>
            <small class="text-muted">${new Date(notification.date).toLocaleDateString()}</small>
          </div>
          <div class="col-auto">
            <a href="${notification.link}" class="list-group-item-actions" target="_blank">
              <svg class="icon text-muted icon-2" viewBox="0 0 24 24" stroke="currentColor" fill="none">
                <path d="M12 17.75l-6.172 3.245l1.179 -6.873l-5 -4.867l6.9 -1l3.086 -6.253l3.086 6.253l6.9 1l-5 4.867l1.179 6.873z" />
              </svg>
            </a>
          </div>
        </div>
      </div>
    `;
    listElement.innerHTML += item;
  });
}

// Initialize theme and notifications when the page loads
document.addEventListener("DOMContentLoaded", () => {
  
  loadTheme();
  loadNotifications();
});
