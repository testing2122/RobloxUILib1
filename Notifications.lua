-- Notifications Utility for RobloxUILib1

local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local Notifications = {}
local notificationList = {}
local maxNotifications = 5

-- Function to create a notification container if it doesn't exist
local function getNotificationContainer()
    local existingContainer = nil
    
    -- Try to find existing notification container
    pcall(function()
        for _, gui in pairs(CoreGui:GetChildren()) do
            if gui.Name:match("^RobloxUILib1_Notifications") then
                existingContainer = gui
            end
        end
    end)
    
    if existingContainer then 
        return existingContainer
    end
    
    -- Create a new container if none exists
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "RobloxUILib1_Notifications_" .. tostring(math.random(1000000, 9999999))
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false
    
    -- Try to use CoreGui, otherwise use player's PlayerGui
    pcall(function()
        ScreenGui.Parent = CoreGui
    end)
    
    if not ScreenGui.Parent then
        ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    end
    
    -- Create notification container
    local NotificationsFrame = Instance.new("Frame")
    NotificationsFrame.Name = "NotificationsFrame"
    NotificationsFrame.Parent = ScreenGui
    NotificationsFrame.BackgroundTransparency = 1
    NotificationsFrame.Position = UDim2.new(1, -320, 0, 20)
    NotificationsFrame.Size = UDim2.new(0, 300, 1, -40)
    NotificationsFrame.AnchorPoint = Vector2.new(0, 0)
    
    -- Create list layout
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Parent = NotificationsFrame
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Top
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    UIListLayout.Padding = UDim.new(0, 10)
    
    return ScreenGui
end

-- Function to create a notification
function Notifications.Send(options)
    options = options or {}
    
    local notificationOptions = {
        Title = options.Title or "Notification",
        Text = options.Text or "",
        Duration = options.Duration or 3, -- seconds
        Type = options.Type or "Info", -- Info, Success, Warning, Error
        Callback = options.Callback or nil
    }
    
    -- Get or create the notification container
    local notificationContainer = getNotificationContainer()
    local notificationsFrame = notificationContainer.NotificationsFrame
    
    -- Create notification frame
    local NotificationFrame = Instance.new("Frame")
    local UICorner = Instance.new("UICorner")
    local TitleLabel = Instance.new("TextLabel")
    local TextLabel = Instance.new("TextLabel")
    local IconLabel = Instance.new("ImageLabel")
    local CloseButton = Instance.new("TextButton")
    
    -- Configure the notification frame
    NotificationFrame.Name = "Notification_" .. tostring(#notificationList + 1)
    NotificationFrame.Parent = notificationsFrame
    NotificationFrame.BackgroundColor3 = _G.RobloxUILib1.Theme.NotificationColor
    NotificationFrame.Size = UDim2.new(1, 0, 0, 80)
    NotificationFrame.BackgroundTransparency = 0
    NotificationFrame.LayoutOrder = #notificationList + 1
    
    UICorner.CornerRadius = UDim.new(0, 6)
    UICorner.Parent = NotificationFrame
    
    -- Set icon based on notification type
    local iconId = "6031071057" -- Default info icon
    local iconColor = Color3.fromRGB(0, 160, 255) -- Blue for info
    
    if notificationOptions.Type == "Success" then
        iconId = "6031071053" -- Checkmark icon
        iconColor = Color3.fromRGB(0, 180, 60) -- Green for success
    elseif notificationOptions.Type == "Warning" then
        iconId = "6031071054" -- Warning icon
        iconColor = Color3.fromRGB(255, 180, 0) -- Yellow for warning
    elseif notificationOptions.Type == "Error" then
        iconId = "6031071055" -- X icon
        iconColor = Color3.fromRGB(255, 40, 40) -- Red for error
    end
    
    -- Icon
    IconLabel.Name = "IconLabel"
    IconLabel.Parent = NotificationFrame
    IconLabel.BackgroundTransparency = 1
    IconLabel.Position = UDim2.new(0, 15, 0, 15)
    IconLabel.Size = UDim2.new(0, 24, 0, 24)
    IconLabel.Image = "rbxassetid://" .. iconId
    IconLabel.ImageColor3 = iconColor
    
    -- Title
    TitleLabel.Name = "TitleLabel"
    TitleLabel.Parent = NotificationFrame
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Position = UDim2.new(0, 50, 0, 10)
    TitleLabel.Size = UDim2.new(1, -70, 0, 20)
    TitleLabel.Font = Enum.Font.SourceSansBold
    TitleLabel.Text = notificationOptions.Title
    TitleLabel.TextColor3 = _G.RobloxUILib1.Theme.PrimaryTextColor
    TitleLabel.TextSize = 16
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Text
    TextLabel.Name = "TextLabel"
    TextLabel.Parent = NotificationFrame
    TextLabel.BackgroundTransparency = 1
    TextLabel.Position = UDim2.new(0, 50, 0, 35)
    TextLabel.Size = UDim2.new(1, -60, 0, 35)
    TextLabel.Font = Enum.Font.SourceSans
    TextLabel.Text = notificationOptions.Text
    TextLabel.TextColor3 = _G.RobloxUILib1.Theme.SecondaryTextColor
    TextLabel.TextSize = 14
    TextLabel.TextWrapped = true
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel.TextYAlignment = Enum.TextYAlignment.Top
    
    -- Close button
    CloseButton.Name = "CloseButton"
    CloseButton.Parent = NotificationFrame
    CloseButton.BackgroundTransparency = 1
    CloseButton.Position = UDim2.new(1, -25, 0, 10)
    CloseButton.Size = UDim2.new(0, 20, 0, 20)
    CloseButton.Font = Enum.Font.SourceSansBold
    CloseButton.Text = "×"
    CloseButton.TextColor3 = _G.RobloxUILib1.Theme.SecondaryTextColor
    CloseButton.TextSize = 22
    
    -- Add to list
    table.insert(notificationList, NotificationFrame)
    
    -- Limit the number of notifications
    if #notificationList > maxNotifications then
        local oldestNotification = table.remove(notificationList, 1)
        oldestNotification:Destroy()
    end
    
    -- Animate in
    NotificationFrame.Position = UDim2.new(1, 0, 0, 0)
    TweenService:Create(
        NotificationFrame,
        TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {Position = UDim2.new(0, 0, 0, 0)}
    ):Play()
    
    -- Close animation
    local function closeNotification()
        local index = table.find(notificationList, NotificationFrame)
        if index then
            table.remove(notificationList, index)
        end
        
        TweenService:Create(
            NotificationFrame,
            TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {Position = UDim2.new(1, 0, 0, 0)}
        ):Play()
        
        wait(0.3)
        NotificationFrame:Destroy()
    end
    
    -- Auto-close after duration
    if notificationOptions.Duration > 0 then
        delay(notificationOptions.Duration, closeNotification)
    end
    
    -- Close button functionality
    CloseButton.MouseButton1Click:Connect(closeNotification)
    
    -- Add callback if specified
    if notificationOptions.Callback then
        NotificationFrame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                notificationOptions.Callback()
            end
        end)
    end
    
    -- Return methods to control the notification
    return {
        Close = closeNotification,
        
        -- Change notification content
        Update = function(newOptions)
            newOptions = newOptions or {}
            
            if newOptions.Title then
                TitleLabel.Text = newOptions.Title
            end
            
            if newOptions.Text then
                TextLabel.Text = newOptions.Text
            end
            
            if newOptions.Type then
                local newIconId = "6031071057" -- Default info icon
                local newIconColor = Color3.fromRGB(0, 160, 255) -- Blue for info
                
                if newOptions.Type == "Success" then
                    newIconId = "6031071053" -- Checkmark icon
                    newIconColor = Color3.fromRGB(0, 180, 60) -- Green for success
                elseif newOptions.Type == "Warning" then
                    newIconId = "6031071054" -- Warning icon
                    newIconColor = Color3.fromRGB(255, 180, 0) -- Yellow for warning
                elseif newOptions.Type == "Error" then
                    newIconId = "6031071055" -- X icon
                    newIconColor = Color3.fromRGB(255, 40, 40) -- Red for error
                end
                
                IconLabel.Image = "rbxassetid://" .. newIconId
                IconLabel.ImageColor3 = newIconColor
            end
        end
    }
end

-- Function to set max notifications
function Notifications.SetMaxNotifications(max)
    maxNotifications = max
end

-- Function to clear all notifications
function Notifications.ClearAll()
    local container = getNotificationContainer()
    local notificationsFrame = container.NotificationsFrame
    
    for i = #notificationList, 1, -1 do
        local notification = notificationList[i]
        
        TweenService:Create(
            notification,
            TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {Position = UDim2.new(1, 0, 0, 0)}
        ):Play()
        
        wait(0.1) -- Stagger animations
    end
    
    wait(0.3)
    
    for _, v in pairs(notificationList) do
        v:Destroy()
    end
    
    notificationList = {}
end

return Notifications 
