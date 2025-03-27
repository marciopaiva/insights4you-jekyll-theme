// Ensure jsyaml is available
if (typeof jsyaml === "undefined") {
  throw new Error("js-yaml library is not loaded. Please include it in your project.");
}

const THEME_STORAGE_KEY = "tablerTheme";
const DEFAULT_THEME = "light";

// Proxy to access URL parameters securely
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

  // Accessibility: Notify screen readers of theme change
  const themeAnnouncement = document.getElementById("theme-announcement");
  if (themeAnnouncement) {
    themeAnnouncement.textContent = `Theme changed to ${theme}`;
  }
}

// Save the selected theme to localStorage
function saveTheme(theme) {
  localStorage.setItem(THEME_STORAGE_KEY, theme);
}

// Load the current theme based on priority: URL > localStorage > system preference > default
function loadTheme() {
  let selectedTheme;

  // Prioritize theme from URL (sanitize input to prevent XSS)
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
    // Fetch local and remote notifications
    const [localNotifications, remoteNotifications] = await Promise.all([
      getLocalNotifications(),
      fetchRemoteNotifications(),
    ]);

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
    return Array.isArray(window.siteData?.notifications) ? window.siteData.notifications : [];
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
    const parsedData = jsyaml.load(yamlText); // Parse YAML data
    return Array.isArray(parsedData) ? parsedData : [];
  } catch (error) {
    console.error("Error fetching remote notifications:", error);
    return [];
  }
}

// Combine and sort notifications by date
function combineAndSortNotifications(local, remote) {
  return [...remote, ...local]
    .filter((notification) => notification.date) // Ensure each notification has a valid date
    .sort((a, b) => new Date(b.date) - new Date(a.date))
    .slice(0, 5); // Display only the latest 5 notifications
}

// Render notifications in the DOM securely
function renderNotifications(notifications, listElement, badgeElement) {
  badgeElement.textContent = notifications.length;

  // Clear existing notifications
  listElement.innerHTML = "";

  // Append notifications using DOM manipulation for security
  notifications.forEach((notification) => {
    const item = createNotificationItem(notification);
    listElement.appendChild(item);
  });
}

// Create a single notification item securely
function createNotificationItem(notification) {
  const container = document.createElement("div");
  container.className = "list-group-item";

  const row = document.createElement("div");
  row.className = "row align-items-center";

  const colAuto = document.createElement("div");
  colAuto.className = "col-auto";
  const statusDot = document.createElement("span");
  statusDot.className = `status-dot bg-${notification.color || "blue"} d-block`;
  colAuto.appendChild(statusDot);

  const colText = document.createElement("div");
  colText.className = "col text-truncate";
  const title = document.createElement("a");
  title.href = notification.link;
  title.className = "text-body d-block";
  title.textContent = notification.title || "Untitled Notification";
  const description = document.createElement("div");
  description.className = "text-secondary";
  description.textContent = notification.description || "No description available";
  const date = document.createElement("small");
  date.className = "text-muted";
  date.textContent = new Date(notification.date).toLocaleDateString();
  colText.append(title, description, date);

  const colActions = document.createElement("div");
  colActions.className = "col-auto";
  const actionLink = document.createElement("a");
  actionLink.href = notification.link;
  actionLink.className = "list-group-item-actions";
  actionLink.target = "_blank";
  const svgIcon = document.createElementNS("http://www.w3.org/2000/svg", "svg");
  svgIcon.setAttribute("class", "icon text-muted icon-2");
  svgIcon.setAttribute("viewBox", "0 0 24 24");
  svgIcon.setAttribute("stroke", "currentColor");
  svgIcon.setAttribute("fill", "none");
  const path = document.createElementNS("http://www.w3.org/2000/svg", "path");
  path.setAttribute("d", "M12 17.75l-6.172 3.245l1.179 -6.873l-5 -4.867l6.9 -1l3.086 -6.253l3.086 6.253l6.9 1l-5 4.867l1.179 6.873z");
  svgIcon.appendChild(path);
  actionLink.appendChild(svgIcon);
  colActions.appendChild(actionLink);

  row.append(colAuto, colText, colActions);
  container.appendChild(row);

  return container;
}

// Initialize theme and notifications when the page loads
document.addEventListener("DOMContentLoaded", () => {
  loadTheme();
  loadNotifications();
});