local Module = {}

local Stored = {}
local Plr = game.Players.LocalPlayer

function Module:Utils(Type, ...)
    local UtilData = ...
    if Type == "GetPlayerCharacterPart" then
        return Plr.Character and Plr.Character:FindFirstChild(UtilData[1])

    elseif Type == "TeleportPlayer" then
        local HRP = Module:Utils("GetPlayerCharacterPart", { "HumanoidRootPart" })
        if HRP then
            local TargetCFrame
        
            if typeof(UtilData[1]) == "CFrame" then
                TargetCFrame = UtilData[1]
            else
                TargetCFrame = UtilData[1]:GetPivot()
            end

            if UtilData[2] and typeof(UtilData[2]) == "CFrame" then
                HRP.CFrame = TargetCFrame * UtilData[2]
            else
                HRP.CFrame = TargetCFrame
            end
        end

    elseif Type == "TeleportThing" then
        local HRP = Module:Utils("GetPlayerCharacterPart", { "HumanoidRootPart" })
        if HRP then
            UtilData[1].CFrame = HRP.CFrame
        end

    elseif Type == "FormatTime" then
        local Hours   = math.floor(UtilData[1] / 3600)
        local Minutes = math.floor((UtilData[1] % 3600) / 60)
        local Seconds = UtilData[1] % 60
        return string.format("%02dh:%02dm:%02ds", Hours, Minutes, Seconds)

    elseif Type == "AbbreviateNumber" then
        local Suffixes = {"", "K", "M", "B", "T", "QA", "QI", "SX", "SP", "OC", "NO", "DC", "UD", "DD", "TD", "QAD", "QID", "SXD", "SPD", "OCD", "NOD", "VG", "UVG", "DVG", "TVG", "QTV", "QIV", "SXV", "SPV", "OVG", "NVG", "TG", "UTG", "DTG", "TTG", "QTG", "QIT"}
        local Number = tostring(math.floor(UtilData[1]))
        return string.sub(Number, 1, ((#Number - 1) % 3) + 1) .. " " .. Suffixes[math.floor((#Number - 1) / 3) + 1]

    elseif Type == "WorldsFunction" then
        if UtilData[1] == "Save" then
            Stored["WorldsFunction"] = {World = UtilData[2], Position = UtilData[3], Orientation = UtilData[4]}
        elseif UtilData[1] == "Get" then
            if Stored["WorldsFunction"] then
                return {World = Stored["WorldsFunction"].World, Position = Stored["WorldsFunction"].Position, Orientation = Stored["WorldsFunction"].Orientation}
            else
                return {World = "None", Position = "None", Orientation = "None"}
            end
        end

    elseif Type == "Notification" then
        local NotificationLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/Vodizera/NotificationService/main/Script"))()
        NotificationLibrary:SendNotification(UtilData[1] or "Info", UtilData[2], UtilData[3])

    elseif Type == "GetMagnitude" then
        return (UtilData[1].Position - UtilData[2].Position).Magnitude

    elseif Type == "TargetSelector" then
        local NearestEnemie, NearestDistance = nil, math.huge
        local LimitDistance = 1000
        for _, Target in ipairs(UtilData[1]:GetChildren()) do
            local isValid = Target:IsA(UtilData[2]) and Target:GetAttribute(UtilData[3]) > 0
            if UtilData[4] then
                isValid = isValid and table.find(UtilData[4], Target:GetAttribute(UtilData[5]))
            end
            if isValid then
                local HRP = Plr.Character and Plr.Character:FindFirstChild("HumanoidRootPart")
                if HRP then
                    local Distance = (HRP.Position - Target.Position).Magnitude
                    if Distance < NearestDistance and Distance <= LimitDistance then
                        NearestEnemie, NearestDistance = Target, Distance
                    end
                end
            end
        end
        return NearestEnemie

    elseif Type == "FireTouchInterest" then
        local PlayersPos = Plr.Character and Plr.Character:FindFirstChild("HumanoidRootPart")
        local Part = UtilData[1].Parent
        if PlayersPos and Part then
            local originalCFrame = Part.CFrame
            if UtilData[1]:IsA("TouchTransmitter") then
                Part.CFrame = PlayersPos.CFrame
                task.wait()
                Part.CFrame = originalCFrame
            else
                warn("Path is not a TouchTransmitter!")
            end
        end

    elseif Type == "SimulateTouch" then
        local Position  = UtilData[1].AbsolutePosition
        local Size      = UtilData[1].AbsoluteSize
        local centerX   = Position.X + Size.X / 2
        local centerY   = Position.Y + Size.Y / 2
        local adjustedY = centerY + (UtilData[2] or 30)
        game:GetService("VirtualInputManager"):SendMouseButtonEvent(centerX, adjustedY, 0, true, game, 1)
        task.wait(0.1)
        game:GetService("VirtualInputManager"):SendMouseButtonEvent(centerX, adjustedY, 0, false, game, 1)
    end
end

return Module
