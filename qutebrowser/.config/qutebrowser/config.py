# vim:fileencoding=utf-8:ft=conf:foldmethod=marker
import os
import dracula.draw
from qutebrowser.api import interceptor

config.load_autoconfig(False)

# ui {{{
dracula.draw.blood(c, {'spacing': {'vertical': 3, 'horizontal': 8}})

c.colors.webpage.preferred_color_scheme = "dark"
c.completion.shrink = True
c.completion.use_best_match = True
c.statusbar.widgets = ["progress", "keypress", "url", "history"]
c.scrolling.bar = "always"
c.tabs.title.format = "{index}: {audio}{current_title}"
c.tabs.title.format_pinned = "{index}: {audio}{current_title}"
# }}}

# general {{{
c.auto_save.session = True
c.content.default_encoding = "utf-8"
c.content.javascript.can_access_clipboard = True
c.content.notifications.enabled = True  # notifications aren't supported now anyway
c.content.pdfjs = True
c.editor.command = [
    os.environ["TERMINAL"], "-e", os.environ["EDITOR"], "-f", "{file}", "-c",
    "normal {line}G{column0}1"
]
c.fileselect.handler = "external"
c.fileselect.folder.command = [
    os.environ["TERMINAL"], "-e", "lf", "-selection-path", "{}"
]
c.fileselect.single_file.command = [
    os.environ["TERMINAL"], "-e", "lf", "-selection-path", "{}"
]
c.fileselect.multiple_files.command = [
    os.environ["TERMINAL"], "-e", "lf", "-selection-path", "{}"
]
c.downloads.location.prompt = False
c.input.insert_mode.auto_load = True
c.spellcheck.languages = ["en-GB"]
c.tabs.last_close = "close"
c.tabs.mousewheel_switching = False
c.qt.args += [
    "enable-gpu-rasterization", "ignore-gpu-blocklist",
    "enable-accelerated-video-decode", "blink-settings=preferredColorScheme=1",
    "blink-settings=darkMode=4"
]
# }}}

# privacy {{{
c.content.cookies.accept = "no-3rdparty"
c.content.webrtc_ip_handling_policy = "default-public-interface-only"
c.content.site_specific_quirks.enabled = False
c.content.headers.user_agent = "Mozilla/5.0 (X11; Linux x86_64; rv:57.0) Gecko/20100101 Firefox/57.0"
# }}}

# per-domain settings {{{
config.set("content.register_protocol_handler", True,
           "*://calendar.google.com")

config.set("content.register_protocol_handler", True,
           "*://teams.microsoft.com")
config.set("content.media.audio_video_capture", True,
           "*://teams.microsoft.com")
config.set("content.media.audio_capture", True, "*://teams.microsoft.com")
config.set("content.media.video_capture", True, "*://teams.microsoft.com")
config.set("content.desktop_capture", True, "*://teams.microsoft.com")

# MS Teams: setting to root domain due to https://bugreports.qt.io/browse/QTBUG-90231
config.set("content.cookies.accept", "all", "*://microsoft.com")
# }}}

# keys {{{
c.bindings.commands = {
    'normal': {
        ",m": "spawn --userscript view_in_mpv",
        ",M": "hint links spawn mpv {hint-url}",
        # ",p":
        # "spawn --userscript qute-pass --dmenu-invocation 'dmenu -p credentials'",
        # ",P":
        # "spawn --userscript qute-pass --dmenu-invocation 'dmenu -p password' --password-only",
        ",b": "config-cycle colors.webpage.bg '#32302f' 'white'",
        ",o": "spawn --userscript qute-pass --otp",
        ",E": "hint links edit-text",
        ",e": "edit-text",
        "<Ctrl-Shift-J>": "tab-move +",
        "<Ctrl-Shift-K>": "tab-move -",
        "<Shift-Escape>": "fake-key <Escape>",
        "o": "set-cmd-text -s :open -s",
        "O": "set-cmd-text -s :open -t -s"
    },
    'insert': {
        "<Ctrl-W>": "tab-close",
        "<Escape>": "mode-leave ;; jseval -q document.activeElement.blur()"
    }
}

# }}}

# youtube adblock {{{
def filter_yt(info: interceptor.Request):
    """Block the given request if necessary."""
    url = info.request_url
    if (url.host() == "www.youtube.com" and url.path() == "/get_video_info"
            and "&adformat=" in url.query()):
        info.block()


interceptor.register(filter_yt)
# }}}
