document.addEventListener("DOMContentLoaded", function () {
    if (localStorage.getItem('theme') === 'dark' || (!localStorage.getItem('theme') && window.matchMedia('(prefers-color-scheme: dark)').matches)) {
        document.documentElement.classList.add('dark');
    }
});

// Theme Settings Handler
document.addEventListener("DOMContentLoaded", function () {
    var themeConfig = {
        theme: "light",
        "theme-base": "gray",
        "theme-font": "sans-serif",
        "theme-primary": "blue",
        "theme-radius": "1",
    };

    var url = new URL(window.location);
    var form = document.getElementById("offcanvasSettings");
    var resetButton = document.getElementById("reset-changes");

    // Function to update theme mode
    var updateThemeMode = function(mode) {
        if (mode === 'dark') {
            document.body.classList.add('theme-dark');
            document.documentElement.setAttribute('data-bs-theme', 'dark');
        } else {
            document.body.classList.remove('theme-dark');
            document.documentElement.setAttribute('data-bs-theme', 'light');
        }
    };

    // Function to update font family
    var updateFontFamily = function(font) {
        const fontMap = {
            'sans-serif': 'var(--tblr-font-sans-serif)',
            'serif': 'var(--tblr-font-serif)',
            'monospace': 'var(--tblr-font-monospace)',
            'comic': 'var(--tblr-font-comic)'
        };
        
        document.documentElement.style.setProperty('--tblr-font-family', fontMap[font] || fontMap['sans-serif']);
        document.body.style.fontFamily = fontMap[font] || fontMap['sans-serif'];
    };

    // Function to update corner radius
    var updateCornerRadius = function(radius) {
        document.documentElement.style.setProperty('--tblr-border-radius', `${radius}rem`);
    };

    // Function to update gray shade
    var updateGrayShade = function(base) {
        console.log("Updating gray shade to:", base); // Log for debugging
        document.documentElement.setAttribute('data-bs-theme-base', base);
        // Remove any existing base classes
        document.body.classList.remove('theme-slate', 'theme-gray', 'theme-zinc', 'theme-neutral', 'theme-stone');
        // Add the new base class
        document.body.classList.add(`theme-${base}`);
    };

    var checkItems = function () {
        for (var key in themeConfig) {
            var value = localStorage.getItem("tabler-" + key) || themeConfig[key];
            if (value) {
                var radios = form.querySelectorAll(`[name="${key}"]`);
                if (radios) {
                    radios.forEach(function(radio) {
                        radio.checked = radio.value === value;
                        
                        // If this is a color input, update the color
                        if (key === 'theme-primary') {
                            document.documentElement.style.setProperty('--tblr-primary', `var(--tblr-${value})`);
                        }
                        // If this is theme mode, update the theme
                        if (key === 'theme') {
                            updateThemeMode(value);
                        }
                        // If this is font family, update the font
                        if (key === 'theme-font') {
                            updateFontFamily(value);
                        }
                        // If this is corner radius, update the radius
                        if (key === 'theme-radius') {
                            updateCornerRadius(value);
                        }
                        // If this is gray shade, update the base
                        if (key === 'theme-base') {
                            updateGrayShade(value);
                        }
                    });
                }
            }
        }
    };

    form.addEventListener("change", function (event) {
        var target = event.target;
        var name = target.name;
        var value = target.value;

        for (var key in themeConfig) {
            if (name === key) {
                document.documentElement.setAttribute("data-" + key, value);
                localStorage.setItem("tabler-" + key, value);
                url.searchParams.set(key, value);

                // If changing color, update CSS variable
                if (key === 'theme-primary') {
                    document.documentElement.style.setProperty('--tblr-primary', `var(--tblr-${value})`);
                }
                // If changing theme mode
                if (key === 'theme') {
                    updateThemeMode(value);
                }
                // If changing font family
                if (key === 'theme-font') {
                    updateFontFamily(value);
                }
                // If changing corner radius
                if (key === 'theme-radius') {
                    updateCornerRadius(value);
                }
                // If changing gray shade
                if (key === 'theme-base') {
                    updateGrayShade(value);
                }
            }
        }

        window.history.pushState({}, "", url);
    });

    resetButton.addEventListener("click", function () {
        for (var key in themeConfig) {
            var value = themeConfig[key];
            document.documentElement.removeAttribute("data-" + key);
            localStorage.removeItem("tabler-" + key);
            url.searchParams.delete(key);

            // Reset color if it's the primary theme
            if (key === 'theme-primary') {
                document.documentElement.style.setProperty('--tblr-primary', `var(--tblr-${value})`);
            }
            // Reset theme mode
            if (key === 'theme') {
                updateThemeMode(value);
            }
            // Reset font family
            if (key === 'theme-font') {
                updateFontFamily(value);
            }
            // Reset corner radius
            if (key === 'theme-radius') {
                updateCornerRadius(value);
            }
            // Reset gray shade
            if (key === 'theme-base') {
                updateGrayShade(value);
            }
        }

        checkItems();
        window.history.pushState({}, "", url);
    });

    // Initial setup
    checkItems();

    // Load settings from URL if present
    for (const [key, value] of url.searchParams.entries()) {
        if (themeConfig.hasOwnProperty(key)) {
            localStorage.setItem("tabler-" + key, value);
        }
    }
    checkItems();
});
