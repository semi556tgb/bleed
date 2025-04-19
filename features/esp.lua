-- esp.lua content
local ESP = {}

function ESP:Init(tab)
    local Section = tab:AddSection("ESP Settings")

    Section:AddToggle({
        text = "Enable ESP",
        flag = "esp_enabled",
        state = false
    })

    Section:AddSlider({
        text = "ESP Distance",
        min = 50,
        max = 1000,
        float = 0,
        flag = "esp_distance",
        suffix = " studs",
        state = 500
    })
end

return ESP
