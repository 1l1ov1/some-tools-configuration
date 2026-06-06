-- 加载 wezterm API和获取 config 对象
local wezterm = require 'wezterm'
local config = wezterm.config_builder()

--------- 颜色配置 -----------------
config.color_scheme = 'Catppuccin Mocha'
config.window_decorations = 'RESIZE'
config.use_fancy_tab_bar = false
config.enable_tab_bar = true
config.show_tab_index_in_tab_bar = true
config.hide_tab_bar_if_only_one_tab = false

config.window_padding = {
    left = 8,
    right = 8,
    top = 8,
    bottom = 8,
}

config.inactive_pane_hsb = {
    saturation = 0.9,
    brightness = 0.7,
}

-- 设置字体+中文兜底
config.font = wezterm.font_with_fallback({
    'Hack Nerd Font Mono',
    'JetBrains Mono',
    'Microsoft YaHei'
    
})
config.font_size = 12.0
config.initial_cols = 140
config.initial_rows = 30

-- 滚动缓存行数
config.scrollback_lines = 5000

-- 设置默认启动的shell
config.set_environment_variables = {
    COMSPEC = 'D:\\build-tools\\nu\\bin\\nu.exe',
}

-------------------- 键盘绑定 ----------------
local act = wezterm.action

-- Leader前缀：Ctrl+a，1秒等待二次按键
config.leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 1000 }

config.keys = {
    -- ============== Leader 全量绑定（Ctrl+a + 按键） ==============
    -- Ctrl+q 退出wezterm
    {
        key = 'q', mods = 'CTRL', action = act.QuitApplication,
    },
    -- Ctrl+a Shift + h 垂直右分屏
    { key = 'H',          mods = 'LEADER',     action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
    -- Ctrl+a Shift + v 水平下分屏
    { key = 'V',          mods = 'LEADER',     action = act.SplitVertical { domain = 'CurrentPaneDomain' } },
    -- Ctrl w 关闭当前面板
    { key = 'w',          mods = 'CTRL',       action = act.CloseCurrentPane { confirm = false } },
    -- Ctrl t 新建标签
    { key = 't',          mods = 'CTRL',       action = act.SpawnTab 'DefaultDomain' },
    -- Ctrl+a 方向键 在分屏之间跳转
    { key = 'LeftArrow',  mods = 'SHIFT|CTRL', action = act.ActivatePaneDirection 'Left' },
    { key = 'RightArrow', mods = 'SHIFT|CTRL', action = act.ActivatePaneDirection 'Right' },
    { key = 'UpArrow',    mods = 'SHIFT|CTRL', action = act.ActivatePaneDirection 'Up' },
    { key = 'DownArrow',  mods = 'SHIFT|CTRL', action = act.ActivatePaneDirection 'Down' },

    -- Ctrl+a z 面板全屏缩放
    { key = 'z',          mods = 'LEADER',     action = act.TogglePaneZoomState },
    -- Ctrl+a n/p 标签翻页(备选)
    { key = 'n',          mods = 'LEADER',     action = act.ActivateTabRelative(1) },
    { key = 'p',          mods = 'LEADER',     action = act.ActivateTabRelative(-1) },
    -- Ctrl+a , 重命名标签
    {
        key = ',',
        mods = 'LEADER',
        action = act.PromptInputLine {
            description = '输入标签名称',
            action = wezterm.action_callback(function(window, _, name)
                if name then window:active_tab():set_title(name) end
            end)
        }
    },
    -- Ctrl+a q 数字选择面板
    { key = 'q', mods = 'LEADER', action = act.PaneSelect },
    -- Ctrl+a x 关闭面板(弹窗确认)
    { key = 'x', mods = 'LEADER', action = act.CloseCurrentPane { confirm = true } },
}

-- ============== Ctrl+1~9 直接切换标签（不用Leader，单独配置） ==============
for i = 1, 9 do
    table.insert(config.keys, {
        key = tostring(i),
        mods = 'CTRL',
        action = act.ActivateTab(i - 1) -- tab下标从0开始
    })
end

---------- 鼠标绑定 ----------------
config.mouse_bindings = {
    -- 鼠标左键拖动选中 → 自动复制到系统剪贴板
    {
        event = { Down = { streak = 1, button = 'Left' } },
        mods = 'NONE',
        action = act.SelectTextAtMouseCursor 'Cell',
    },
    {
        event = { Up = { streak = 1, button = 'Left' } },
        mods = 'NONE',
        action = act.CopyTo 'Clipboard',
    },

    -- 右键单击 = 粘贴剪贴板内容
    {
        event = { Down = { streak = 1, button = 'Right' } },
        mods = 'NONE',
        action = act.PasteFrom 'Clipboard',
    },

    -- Ctrl+左键单击：打开链接（可选）
    {
        event = { Up = { streak = 1, button = 'Left' } },
        mods = 'CTRL',
        action = act.OpenLinkAtMouseCursor,
    },
    -- 左键三连击选中整行
    {
        event = { Down = { streak = 3, button = 'Left' } },
        mods = 'NONE',
        action = act.SelectTextAtMouseCursor 'Line',
    },
}

return config
