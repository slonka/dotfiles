local previousApp = nil

hs.hotkey.bind({"cmd"}, "j", function()
    local currentApp = hs.application.frontmostApplication()

    if currentApp:name() == "Ghostty" then
        if previousApp and previousApp:isRunning() then
            previousApp:activate()
        end
    else
        previousApp = currentApp
        local ghostty = hs.application.get("Ghostty")
        if ghostty then
            ghostty:activate(true)
        else
            hs.application.launchOrFocus("Ghostty")
        end
    end
end)
