# config.nu
#
# Installed by:
# version = "0.113.1"
#
# This file is used to override default Nushell settings, define
# (or import) custom commands, or run any other startup tasks.
# See https://www.nushell.sh/book/configuration.html
#
# Nushell sets "sensible defaults" for most configuration settings, 
# so your `config.nu` only needs to override these defaults if desired.
#
# You can open this file in your default editor using:
#     config nu
#
# You can also pretty-print and page through the documentation for configuration
# options using:
#     config nu --doc | nu-highlight | less -R
# 关闭开机欢迎横幅
$env.config.show_banner = false
# 关闭OSC全系列集成，根治协议滚动bug
$env.config.shell_integration = {
    osc2: false    # 窗口标题
    osc7: false    # 当前目录同步
    osc8: true     # 链接点击（可选保留）
    osc9_9: false
    osc133: false  # 核心：关闭命令区块标记
}

mkdir ($nu.data-dir | path join "vendor/autoload")
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")