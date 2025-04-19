local ESP = {}

function ESP:Init(tab)
    local Section = tab:AddSection("ESP Settings")

    Section:AddToggle({
        text = "Enable ESP",
        flag = "esp_enabled",
        state = false
    })
end

return ESP
