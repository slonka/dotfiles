local previousApp = nil

hs.hotkey.bind({"cmd"}, "j", function()
    local currentApp = hs.application.frontmostApplication()

    if currentApp:name() == "Ghostty" then
        local ghostty = hs.application.get("Ghostty")
        if ghostty then
            local wins = ghostty:allWindows()
            local focused = hs.window.focusedWindow()
            if #wins > 1 and focused then
                for i, w in ipairs(wins) do
                    if w:id() == focused:id() then
                        wins[(i % #wins) + 1]:focus()
                        return
                    end
                end
            end
        end
    else
        previousApp = currentApp
        hs.application.launchOrFocus("Ghostty")
    end
end)
