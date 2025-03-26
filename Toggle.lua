-- Toggle Component for RobloxUILib1

local TweenService = game:GetService("TweenService")

local Toggle = {}

function Toggle.Create(Tab, options)
    options = options or {}
    
    local toggleOptions = {
        Name = options.Name or "Toggle",
        Default = options.Default or false,
        Callback = options.Callback or function() end,
        Description = options.Description or nil,
        Icon = options.Icon or nil
    }
    
    -- Create container
    local ToggleContainer = Instance.new("Frame")
    local UICorner = Instance.new("UICorner")
    local ToggleFrame = Instance.new("Frame")
    local UICorner_2 = Instance.new("UICorner")
    local ToggleLabel = Instance.new("TextLabel")
    local ToggleButton = Instance.new("TextButton")
    local UICorner_3 = Instance.new("UICorner")
    local ToggleIndicator = Instance.new("Frame")
    local UICorner_4 = Instance.new("UICorner")
    local IconImage = nil
    
    -- Toggle value
    local toggled = toggleOptions.Default
    
    -- Toggle Container
    ToggleContainer.Name = toggleOptions.Name .. "Container"
    ToggleContainer.Parent = Tab.TabContent
    ToggleContainer.BackgroundTransparency = 1
    ToggleContainer.Size = UDim2.new(1, 0, 0, 40)
    
    -- Toggle Frame
    ToggleFrame.Name = toggleOptions.Name .. "Frame"
    ToggleFrame.Parent = ToggleContainer
    ToggleFrame.BackgroundColor3 = _G.RobloxUILib1.Theme.PrimaryElementColor
    ToggleFrame.Size = UDim2.new(1, 0, 1, 0)
    
    UICorner_2.CornerRadius = UDim.new(0, 4)
    UICorner_2.Parent = ToggleFrame
    
    -- Toggle Label
    ToggleLabel.Name = "ToggleLabel"
    ToggleLabel.Parent = ToggleFrame
    ToggleLabel.BackgroundTransparency = 1
    
    -- Toggle Button
    ToggleButton.Name = "ToggleButton"
    ToggleButton.Parent = ToggleFrame
    ToggleButton.BackgroundColor3 = _G.RobloxUILib1.Theme.SecondaryElementColor
    ToggleButton.Position = UDim2.new(1, -50, 0.5, 0)
    ToggleButton.Size = UDim2.new(0, 36, 0, 18)
    ToggleButton.AnchorPoint = Vector2.new(0, 0.5)
    ToggleButton.Text = ""
    ToggleButton.AutoButtonColor = false
    
    UICorner_3.CornerRadius = UDim.new(1, 0)
    UICorner_3.Parent = ToggleButton
    
    -- Toggle Indicator
    ToggleIndicator.Name = "ToggleIndicator"
    ToggleIndicator.Parent = ToggleButton
    ToggleIndicator.BackgroundColor3 = _G.RobloxUILib1.Theme.PrimaryTextColor
    ToggleIndicator.Position = UDim2.new(0, 2, 0.5, 0)
    ToggleIndicator.Size = UDim2.new(0, 14, 0, 14)
    ToggleIndicator.AnchorPoint = Vector2.new(0, 0.5)
    
    UICorner_4.CornerRadius = UDim.new(1, 0)
    UICorner_4.Parent = ToggleIndicator
    
    -- Add icon if specified
    if toggleOptions.Icon then
        IconImage = Instance.new("ImageLabel")
        IconImage.Name = "IconImage"
        IconImage.Parent = ToggleFrame
        IconImage.BackgroundTransparency = 1
        IconImage.Position = UDim2.new(0, 5, 0.5, 0)
        IconImage.Size = UDim2.new(0, 20, 0, 20)
        IconImage.AnchorPoint = Vector2.new(0, 0.5)
        IconImage.Image = toggleOptions.Icon
        
        ToggleLabel.Position = UDim2.new(0, 30, 0, 0)
        ToggleLabel.Size = UDim2.new(1, -85, 1, 0)
    else
        ToggleLabel.Position = UDim2.new(0, 10, 0, 0)
        ToggleLabel.Size = UDim2.new(1, -65, 1, 0)
    end
    
    ToggleLabel.Font = Enum.Font.SourceSansSemibold
    ToggleLabel.Text = toggleOptions.Name
    ToggleLabel.TextColor3 = _G.RobloxUILib1.Theme.PrimaryTextColor
    ToggleLabel.TextSize = 14
    ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    -- If there's a description, add it
    if toggleOptions.Description then
        ToggleContainer.Size = UDim2.new(1, 0, 0, 60)
        
        local DescriptionLabel = Instance.new("TextLabel")
        DescriptionLabel.Name = "DescriptionLabel"
        DescriptionLabel.Parent = ToggleFrame
        DescriptionLabel.BackgroundTransparency = 1
        DescriptionLabel.Position = UDim2.new(0, 10, 0, 25)
        if toggleOptions.Icon then
            DescriptionLabel.Position = UDim2.new(0, 30, 0, 25)
        end
        DescriptionLabel.Size = UDim2.new(1, -65, 0, 20)
        DescriptionLabel.Font = Enum.Font.SourceSans
        DescriptionLabel.Text = toggleOptions.Description
        DescriptionLabel.TextColor3 = _G.RobloxUILib1.Theme.SecondaryTextColor
        DescriptionLabel.TextSize = 12
        DescriptionLabel.TextXAlignment = Enum.TextXAlignment.Left
        
        ToggleLabel.Size = UDim2.new(1, -65, 0, 20)
    end
    
    -- Function to update toggle visuals
    local function updateToggle()
        local targetPosition = toggled and UDim2.new(1, -16, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)
        local targetColor = toggled and _G.RobloxUILib1.Theme.AccentColor or _G.RobloxUILib1.Theme.SecondaryElementColor
        
        TweenService:Create(
            ToggleIndicator,
            TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {Position = targetPosition}
        ):Play()
        
        TweenService:Create(
            ToggleButton,
            TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {BackgroundColor3 = targetColor}
        ):Play()
    end
    
    -- Set initial state
    if toggled then
        ToggleIndicator.Position = UDim2.new(1, -16, 0.5, 0)
        ToggleButton.BackgroundColor3 = _G.RobloxUILib1.Theme.AccentColor
    end
    
    -- Toggle button functionality
    ToggleButton.MouseButton1Click:Connect(function()
        toggled = not toggled
        updateToggle()
        toggleOptions.Callback(toggled)
    end)
    
    -- Make entire frame clickable
    ToggleFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            toggled = not toggled
            updateToggle()
            toggleOptions.Callback(toggled)
        end
    end)
    
    -- Button effects
    local hoverTween = TweenService:Create(
        ToggleFrame,
        TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {BackgroundColor3 = _G.RobloxUILib1.Theme.SecondaryElementColor}
    )
    
    local normalTween = TweenService:Create(
        ToggleFrame,
        TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {BackgroundColor3 = _G.RobloxUILib1.Theme.PrimaryElementColor}
    )
    
    ToggleFrame.MouseEnter:Connect(function()
        hoverTween:Play()
    end)
    
    ToggleFrame.MouseLeave:Connect(function()
        normalTween:Play()
    end)
    
    -- Update canvas size of parent ScrollingFrame
    local function updateCanvasSize()
        local contentHeight = Tab.TabContent.UIListLayout.AbsoluteContentSize.Y
        Tab.TabContent.CanvasSize = UDim2.new(0, 0, 0, contentHeight + 10)
    end
    
    Tab.TabContent.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvasSize)
    updateCanvasSize()
    
    -- Return the element in case further modification is needed
    local Element = {
        Container = ToggleContainer,
        Frame = ToggleFrame,
        Label = ToggleLabel,
        Button = ToggleButton,
        Indicator = ToggleIndicator,
        Icon = IconImage,
        Options = toggleOptions,
        
        -- Method to set the toggle state
        SetValue = function(self, value)
            toggled = value
            updateToggle()
            return self
        end,
        
        -- Method to get the toggle state
        GetValue = function()
            return toggled
        end
    }
    
    table.insert(Tab.Elements, Element)
    
    return Element
end

return Toggle 
