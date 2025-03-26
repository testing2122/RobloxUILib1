-- Button Component for RobloxUILib1

local TweenService = game:GetService("TweenService")

local Button = {}

function Button.Create(Tab, options)
    options = options or {}
    
    local buttonOptions = {
        Name = options.Name or "Button",
        Callback = options.Callback or function() end,
        Description = options.Description or nil,
        Icon = options.Icon or nil
    }
    
    -- Create container
    local ButtonContainer = Instance.new("Frame")
    local UICorner = Instance.new("UICorner")
    local ButtonFrame = Instance.new("TextButton")
    local UICorner_2 = Instance.new("UICorner")
    local ButtonLabel = Instance.new("TextLabel")
    local IconImage = nil
    
    -- Button Container
    ButtonContainer.Name = buttonOptions.Name .. "Container"
    ButtonContainer.Parent = Tab.TabContent
    ButtonContainer.BackgroundTransparency = 1
    ButtonContainer.Size = UDim2.new(1, 0, 0, 40)
    
    -- Button Frame
    ButtonFrame.Name = buttonOptions.Name .. "Frame"
    ButtonFrame.Parent = ButtonContainer
    ButtonFrame.BackgroundColor3 = _G.RobloxUILib1.Theme.PrimaryElementColor
    ButtonFrame.Size = UDim2.new(1, 0, 1, 0)
    ButtonFrame.Text = ""
    ButtonFrame.AutoButtonColor = false
    
    UICorner_2.CornerRadius = UDim.new(0, 4)
    UICorner_2.Parent = ButtonFrame
    
    -- Button Label
    ButtonLabel.Name = "ButtonLabel"
    ButtonLabel.Parent = ButtonFrame
    ButtonLabel.BackgroundTransparency = 1
    
    -- Add icon if specified
    if buttonOptions.Icon then
        IconImage = Instance.new("ImageLabel")
        IconImage.Name = "IconImage"
        IconImage.Parent = ButtonFrame
        IconImage.BackgroundTransparency = 1
        IconImage.Position = UDim2.new(0, 5, 0.5, 0)
        IconImage.Size = UDim2.new(0, 20, 0, 20)
        IconImage.AnchorPoint = Vector2.new(0, 0.5)
        IconImage.Image = buttonOptions.Icon
        
        ButtonLabel.Position = UDim2.new(0, 30, 0, 0)
        ButtonLabel.Size = UDim2.new(1, -35, 1, 0)
    else
        ButtonLabel.Position = UDim2.new(0, 10, 0, 0)
        ButtonLabel.Size = UDim2.new(1, -10, 1, 0)
    end
    
    ButtonLabel.Font = Enum.Font.SourceSansSemibold
    ButtonLabel.Text = buttonOptions.Name
    ButtonLabel.TextColor3 = _G.RobloxUILib1.Theme.PrimaryTextColor
    ButtonLabel.TextSize = 14
    ButtonLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    -- If there's a description, add it
    if buttonOptions.Description then
        ButtonContainer.Size = UDim2.new(1, 0, 0, 60)
        
        local DescriptionLabel = Instance.new("TextLabel")
        DescriptionLabel.Name = "DescriptionLabel"
        DescriptionLabel.Parent = ButtonFrame
        DescriptionLabel.BackgroundTransparency = 1
        DescriptionLabel.Position = UDim2.new(0, 10, 0, 25)
        if buttonOptions.Icon then
            DescriptionLabel.Position = UDim2.new(0, 30, 0, 25)
        end
        DescriptionLabel.Size = UDim2.new(1, -20, 0, 20)
        DescriptionLabel.Font = Enum.Font.SourceSans
        DescriptionLabel.Text = buttonOptions.Description
        DescriptionLabel.TextColor3 = _G.RobloxUILib1.Theme.SecondaryTextColor
        DescriptionLabel.TextSize = 12
        DescriptionLabel.TextXAlignment = Enum.TextXAlignment.Left
        
        ButtonLabel.Size = UDim2.new(1, -10, 0, 20)
    end
    
    -- Button effects
    local hoverTween = TweenService:Create(
        ButtonFrame,
        TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {BackgroundColor3 = _G.RobloxUILib1.Theme.SecondaryElementColor}
    )
    
    local normalTween = TweenService:Create(
        ButtonFrame,
        TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {BackgroundColor3 = _G.RobloxUILib1.Theme.PrimaryElementColor}
    )
    
    ButtonFrame.MouseEnter:Connect(function()
        hoverTween:Play()
    end)
    
    ButtonFrame.MouseLeave:Connect(function()
        normalTween:Play()
    end)
    
    -- Button click functionality
    ButtonFrame.MouseButton1Click:Connect(function()
        local clickTween = TweenService:Create(
            ButtonFrame,
            TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {BackgroundColor3 = _G.RobloxUILib1.Theme.AccentColor}
        )
        
        clickTween:Play()
        
        -- Call the callback function
        buttonOptions.Callback()
        
        wait(0.1)
        hoverTween:Play()
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
        Container = ButtonContainer,
        Button = ButtonFrame,
        Label = ButtonLabel,
        Icon = IconImage,
        Options = buttonOptions
    }
    
    table.insert(Tab.Elements, Element)
    
    return Element
end

return Button 
