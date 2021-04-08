import dracula.draw
config.load_autoconfig(False)

# ui
dracula.draw.blood(c, {
    'spacing': {
        'vertical': 3,
        'horizontal': 8
    }
})

c.colors.webpage.preferred_color_scheme = "dark"
c.completion.shrink = True
c.completion.use_best_match = True
c.statusbar.widgets = ["progress", "keypress", "url", "history"]
c.scrolling.bar = "always"
c.tabs.title.format = "{index}: {audio}{current_title}"
c.tabs.title.format_pinned = "{index}: {audio}{current_title}"

# general
c.auto_save.session = True
c.content.default_encoding = "utf-8"
c.content.javascript.can_access_clipboard = True
c.content.notifications = True  # notifications aren't supported now anyway
c.content.pdfjs = True
c.editor.command = ["kitty", "kak", "-e", "exec {line}g{column0}l", "{}"]
c.fileselect.handler = "external"
c.fileselect.single_file.command = ["kitty", "nnn", "-p", "{}"]
c.fileselect.multiple_files.command = ["kitty", "nnn", "-p", "{}"]
c.downloads.location.prompt = False
c.input.insert_mode.auto_load = True
c.spellcheck.languages = ["en-GB"]
c.tabs.last_close = "close"
c.tabs.mousewheel_switching = False
c.qt.args += [
    "enable-gpu-rasterization",
    "blink-settings=preferredColorScheme=1",
    "blink-settings=darkMode=4"
]

# privacy
c.content.cookies.accept = "no-3rdparty"
c.content.webrtc_ip_handling_policy = "default-public-interface-only"
c.content.site_specific_quirks = False
c.content.headers.user_agent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/89.0.4389.114 Safari/537.36"

# urls
# c.url.searchengines = {
#     "DEFAULT": "https://google.com/search?q={}",
#     "?": "https://google.com/search?q={}",
# }
# c.url.default_page = "~/.config/qutebrowser/blank.html"
# c.url.start_pages = ["~/.config/qutebrowser/blank.html"]

# per-domain settings
config.set("content.register_protocol_handler", True, "*://calendar.google.com")

config.set("content.media.audio_video_capture", True, "*://app.wire.com")
config.set("content.media.audio_capture", True, "*://app.wire.com")
config.set("content.media.video_capture", True, "*://app.wire.com")
config.set("content.desktop_capture", True, "*://app.wire.com")

config.set("content.register_protocol_handler", True, "*://teams.microsoft.com")
config.set("content.media.audio_video_capture", True, "*://teams.microsoft.com")
config.set("content.media.audio_capture", True, "*://teams.microsoft.com")
config.set("content.media.video_capture", True, "*://teams.microsoft.com")
config.set("content.desktop_capture", True, "*://teams.microsoft.com")

config.bind('e', 'spawn mpv {url}')
config.bind('E', 'hint links spawn mpv --force-window yes {hint-url}')

# MS Teams: setting to root domain due to https://bugreports.qt.io/browse/QTBUG-90231
config.set("content.cookies.accept", "all", "*://microsoft.com")

# keys
bindings = {
    ",m": "spawn --userscript view_in_mpv",
    ",M": "hint links spawn mpv {hint-url}",
    ",p": "spawn --userscript qute-pass --username-target secret --username-pattern 'user: (.+)' --dmenu-invocation 'dmenu -p credentials'",
    ",P": "spawn --userscript qute-pass --username-target secret --username-pattern 'user: (.+)' --dmenu-invocation 'dmenu -p password' --password-only",
    ",b": "config-cycle colors.webpage.bg '#32302f' 'white'",
    "<Ctrl-Shift-J>": "tab-move +",
    "<Ctrl-Shift-K>": "tab-move -",
    "M": "nop",
    "co": "nop",
    "<Shift-Escape>": "fake-key <Escape>",
    "o": "set-cmd-text -s :open -s",
    "O": "set-cmd-text -s :open -t -s",
}

for key, bind in bindings.items():
    config.bind(key, bind)
