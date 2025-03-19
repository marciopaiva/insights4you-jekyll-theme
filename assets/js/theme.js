/**
 * demo-theme is specifically loaded right after the body and not deferred
 * to ensure we switch to the chosen dark/light theme as fast as possible.
 * This will prevent any flashes of the light theme (default) before switching.
 */

const THEME_STORAGE_KEY = "tablerTheme";
const defaultTheme = "light";
let selectedTheme;

// https://stackoverflow.com/a/901144
// Create a Proxy for URLSearchParams to simplify access to query parameters.
// This allows us to use `params.key` instead of `params.get('key')`.
const params = new Proxy(new URLSearchParams(window.location.search), {
	get: (searchParams, prop) => searchParams.get(prop)
});

if (params.theme) {
  localStorage.setItem(THEME_STORAGE_KEY, params.theme);
  selectedTheme = params.theme;
} else {
  const storedTheme = localStorage.getItem(THEME_STORAGE_KEY);
  selectedTheme = storedTheme || defaultTheme;
}

// Apply the selected theme to the document body
if (selectedTheme === "dark") {
  document.body.setAttribute("data-bs-theme", "dark");
} else if (selectedTheme === "light") {
  document.body.setAttribute("data-bs-theme", "light");
}