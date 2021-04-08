import dracula.draw
config.load_autoconfig(False)

dracula.draw.blood(c, {
    'spacing': {
        'vertical': 3,
        'horizontal': 8
    }
})

c.content.default_encoding = "utf-8"
c.colors.webpage.preferred_color_scheme = "dark"
c.content.images = False
c.content.javascript.enabled = False
c.content.cookies.accept = "never"
c.content.webrtc_ip_handling_policy = "disable-non-proxied-udp"
c.tabs.last_close = "close"
c.tabs.show = "never"

config.bind("q", "quit")
