-- RobloxUILib1 - A UI Library for Roblox Lua Exploiting

local Library = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Initialize the global library table if it doesn't exist
if not _G.RobloxUILib1 then
    _G.RobloxUILib1 = {}
end

-- Default theme
Library.DefaultTheme = {
    BackgroundColor = Color3.fromRGB(25, 25, 25),
    SidebarColor = Color3.fromRGB(30, 30, 30),
    PrimaryTextColor = Color3.fromRGB(255, 255, 255),
    SecondaryTextColor = Color3.fromRGB(175, 175, 175),
    UIStrokeColor = Color3.fromRGB(40, 40, 40),
    PrimaryElementColor = Color3.fromRGB(35, 35, 35),
    SecondaryElementColor = Color3.fromRGB(45, 45, 45),
    OtherElementColor = Color3.fromRGB(50, 50, 50),
    ScrollBarColor = Color3.fromRGB(40, 40, 40),
    PromptColor = Color3.fromRGB(50, 50, 50),
    NotificationColor = Color3.fromRGB(25, 25, 25),
    AccentColor = Color3.fromRGB(0, 170, 255)
}

-- Set default theme if not already set
if not _G.RobloxUILib1.Theme then
    _G.RobloxUILib1.Theme = Library.DefaultTheme
end

-- Create a uniquely named ScreenGui
local function createScreenGui()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "RobloxUILib1_" .. tostring(math.random(1000000, 9999999))
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false
    
    -- Try to use CoreGui, otherwise use player's PlayerGui
    pcall(function()
        ScreenGui.Parent = CoreGui
    end)
    
    if not ScreenGui.Parent then
        ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    end
    
    return ScreenGui
end

-- Function to create new window
function Library:CreateWindow(config)
    config = config or {}
    local windowConfig = {
        Title = config.Title or "RobloxUILib1",
        Size = config.Size or UDim2.new(0, 550, 0, 400),
        Theme = config.Theme or _G.RobloxUILib1.Theme
    }
    
    -- Apply theme from config if specified
    if config.Theme then
        _G.RobloxUILib1.Theme = config.Theme
    end
    
    local Window = {}
    Window.Tabs = {}
    
    -- Create window GUI
    local ScreenGui = createScreenGui()
    local MainFrame = Instance.new("Frame")
    local UICorner = Instance.new("UICorner")
    local TopBar = Instance.new("Frame")
    local UICorner_2 = Instance.new("UICorner")
    local Title = Instance.new("TextLabel")
    local CloseButton = Instance.new("TextButton")
    local MinimizeButton = Instance.new("TextButton")
    local TabContainer = Instance.new("Frame")
    local TabList = Instance.new("ScrollingFrame")
    local UIListLayout = Instance.new("UIListLayout")
    local ContentContainer = Instance.new("Frame")
    
    -- Main Frame
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = _G.RobloxUILib1.Theme.BackgroundColor
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainFrame.Size = windowConfig.Size
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    
    UICorner.CornerRadius = UDim.new(0, 6)
    UICorner.Parent = MainFrame
    
    -- Top Bar
    TopBar.Name = "TopBar"
    TopBar.Parent = MainFrame
    TopBar.BackgroundColor3 = _G.RobloxUILib1.Theme.SidebarColor
    TopBar.Size = UDim2.new(1, 0, 0, 30)
    
    UICorner_2.CornerRadius = UDim.new(0, 6)
    UICorner_2.Parent = TopBar
    
    -- Title
    Title.Name = "Title"
    Title.Parent = TopBar
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 10, 0, 0)
    Title.Size = UDim2.new(1, -60, 1, 0)
    Title.Font = Enum.Font.SourceSansBold
    Title.Text = windowConfig.Title
    Title.TextColor3 = _G.RobloxUILib1.Theme.PrimaryTextColor
    Title.TextSize = 16
    Title.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Close Button
    CloseButton.Name = "CloseButton"
    CloseButton.Parent = TopBar
    CloseButton.BackgroundTransparency = 1
    CloseButton.Position = UDim2.new(1, -25, 0, 5)
    CloseButton.Size = UDim2.new(0, 20, 0, 20)
    CloseButton.Font = Enum.Font.SourceSansBold
    CloseButton.Text = "X"
    CloseButton.TextColor3 = _G.RobloxUILib1.Theme.PrimaryTextColor
    CloseButton.TextSize = 16
    
    -- Minimize Button
    MinimizeButton.Name = "MinimizeButton"
    MinimizeButton.Parent = TopBar
    MinimizeButton.BackgroundTransparency = 1
    MinimizeButton.Position = UDim2.new(1, -45, 0, 5)
    MinimizeButton.Size = UDim2.new(0, 20, 0, 20)
    MinimizeButton.Font = Enum.Font.SourceSansBold
    MinimizeButton.Text = "-"
    MinimizeButton.TextColor3 = _G.RobloxUILib1.Theme.PrimaryTextColor
    MinimizeButton.TextSize = 16
    
    -- Tab Container
    TabContainer.Name = "TabContainer"
    TabContainer.Parent = MainFrame
    TabContainer.BackgroundColor3 = _G.RobloxUILib1.Theme.SidebarColor
    TabContainer.Position = UDim2.new(0, 0, 0, 30)
    TabContainer.Size = UDim2.new(0, 120, 1, -30)
    
    -- Tab List
    TabList.Name = "TabList"
    TabList.Parent = TabContainer
    TabList.BackgroundTransparency = 1
    TabList.Position = UDim2.new(0, 0, 0, 10)
    TabList.Size = UDim2.new(1, 0, 1, -10)
    TabList.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabList.ScrollBarThickness = 2
    TabList.ScrollBarImageColor3 = _G.RobloxUILib1.Theme.ScrollBarColor
    
    UIListLayout.Parent = TabList
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0, 5)
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    
    -- Content Container
    ContentContainer.Name = "ContentContainer"
    ContentContainer.Parent = MainFrame
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Position = UDim2.new(0, 120, 0, 30)
    ContentContainer.Size = UDim2.new(1, -120, 1, -30)
    
    -- Make window draggable
    local dragging
    local dragInput
    local dragStart
    local startPos
    
    local function updateDrag(input)
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    
    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
        end
    end)
    
    TopBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    TopBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            updateDrag(input)
        end
    end)
    
    -- Close button functionality
    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)
    
    -- Minimize button functionality
    local minimized = false
    MinimizeButton.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            MainFrame:TweenSize(UDim2.new(0, MainFrame.Size.X.Offset, 0, 30), "Out", "Quad", 0.3, true)
        else
            MainFrame:TweenSize(windowConfig.Size, "Out", "Quad", 0.3, true)
        end
    end)
    
    -- Function to create a tab
    function Window:CreateTab(name)
        local Tab = {}
        Tab.Elements = {}
        
        -- Create tab button
        local TabButton = Instance.new("TextButton")
        TabButton.Name = name .. "Tab"
        TabButton.Parent = TabList
        TabButton.BackgroundColor3 = _G.RobloxUILib1.Theme.PrimaryElementColor
        TabButton.Size = UDim2.new(1, -10, 0, 30)
        TabButton.Position = UDim2.new(0, 5, 0, 0)
        TabButton.Font = Enum.Font.SourceSansSemibold
        TabButton.Text = name
        TabButton.TextColor3 = _G.RobloxUILib1.Theme.SecondaryTextColor
        TabButton.TextSize = 14
        TabButton.AutoButtonColor = false
        
        local UICorner_3 = Instance.new("UICorner")
        UICorner_3.CornerRadius = UDim.new(0, 4)
        UICorner_3.Parent = TabButton
        
        -- Create tab content
        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Name = name .. "Content"
        TabContent.Parent = ContentContainer
        TabContent.BackgroundTransparency = 1
        TabContent.Position = UDim2.new(0, 10, 0, 10)
        TabContent.Size = UDim2.new(1, -20, 1, -20)
        TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabContent.ScrollBarThickness = 3
        TabContent.ScrollBarImageColor3 = _G.RobloxUILib1.Theme.ScrollBarColor
        TabContent.Visible = false
        
        local UIListLayout_2 = Instance.new("UIListLayout")
        UIListLayout_2.Parent = TabContent
        UIListLayout_2.SortOrder = Enum.SortOrder.LayoutOrder
        UIListLayout_2.Padding = UDim.new(0, 8)
        
        -- Add tab to Window
        table.insert(Window.Tabs, Tab)
        
        -- Show first tab by default
        if #Window.Tabs == 1 then
            TabContent.Visible = true
            TabButton.BackgroundColor3 = _G.RobloxUILib1.Theme.AccentColor
            TabButton.TextColor3 = _G.RobloxUILib1.Theme.PrimaryTextColor
        end
        
        -- Tab button functionality
        TabButton.MouseButton1Click:Connect(function()
            for _, otherTab in pairs(Window.Tabs) do
                otherTab.TabButton.BackgroundColor3 = _G.RobloxUILib1.Theme.PrimaryElementColor
                otherTab.TabButton.TextColor3 = _G.RobloxUILib1.Theme.SecondaryTextColor
                otherTab.TabContent.Visible = false
            end
            TabButton.BackgroundColor3 = _G.RobloxUILib1.Theme.AccentColor
            TabButton.TextColor3 = _G.RobloxUILib1.Theme.PrimaryTextColor
            TabContent.Visible = true
        end)
        
        -- Store references
        Tab.TabButton = TabButton
        Tab.TabContent = TabContent
        
        return Tab
    end
    
    return Window
end

return Library
