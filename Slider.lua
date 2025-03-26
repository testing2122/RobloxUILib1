-- Slider Component for RobloxUILib1

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Slider = {}

function Slider.Create(Tab, options)
    options = options or {}
    
    local sliderOptions = {
        Name = options.Name or "Slider",
        Min = options.Min or 0,
        Max = options.Max or 100,
        Default = options.Default or 50,
        Increment = options.Increment or 1,
        Callback = options.Callback or function() end,
        Description = options.Description or nil,
        Suffix = options.Suffix or "",
        Prefix = options.Prefix or ""
    }
    
    -- Make sure default is within min and max
    sliderOptions.Default = math.clamp(sliderOptions.Default, sliderOptions.Min, sliderOptions.Max)
    
    -- Create container
    local SliderContainer = Instance.new("Frame")
    local SliderFrame = Instance.new("Frame")
    local UICorner = Instance.new("UICorner")
    local SliderLabel = Instance.new("TextLabel")
    local SliderValue = Instance.new("TextLabel")
    local SliderBackground = Instance.new("Frame")
    local UICorner_2 = Instance.new("UICorner")
    local SliderFill = Instance.new("Frame")
    local UICorner_3 = Instance.new("UICorner")
    local SliderDrag = Instance.new("TextButton")
    local UICorner_4 = Instance.new("UICorner")
    
    -- Current value
    local currentValue = sliderOptions.Default
    
    -- Slider Container
    SliderContainer.Name = sliderOptions.Name .. "Container"
    SliderContainer.Parent = Tab.TabContent
    SliderContainer.BackgroundTransparency = 1
    SliderContainer.Size = UDim2.new(1, 0, 0, 50)
    
    -- Slider Frame
    SliderFrame.Name = sliderOptions.Name .. "Frame"
    SliderFrame.Parent = SliderContainer
    SliderFrame.BackgroundColor3 = _G.RobloxUILib1.Theme.PrimaryElementColor
    SliderFrame.Size = UDim2.new(1, 0, 1, 0)
    
    UICorner.CornerRadius = UDim.new(0, 4)
    UICorner.Parent = SliderFrame
    
    -- Slider Label
    SliderLabel.Name = "SliderLabel"
    SliderLabel.Parent = SliderFrame
    SliderLabel.BackgroundTransparency = 1
    SliderLabel.Position = UDim2.new(0, 10, 0, 5)
    SliderLabel.Size = UDim2.new(1, -20, 0, 20)
    SliderLabel.Font = Enum.Font.SourceSansSemibold
    SliderLabel.Text = sliderOptions.Name
    SliderLabel.TextColor3 = _G.RobloxUILib1.Theme.PrimaryTextColor
    SliderLabel.TextSize = 14
    SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Slider Value
    SliderValue.Name = "SliderValue"
    SliderValue.Parent = SliderFrame
    SliderValue.BackgroundTransparency = 1
    SliderValue.Position = UDim2.new(1, -60, 0, 5)
    SliderValue.Size = UDim2.new(0, 50, 0, 20)
    SliderValue.Font = Enum.Font.SourceSansSemibold
    SliderValue.TextColor3 = _G.RobloxUILib1.Theme.SecondaryTextColor
    SliderValue.TextSize = 14
    SliderValue.TextXAlignment = Enum.TextXAlignment.Right
    
    -- Slider Background
    SliderBackground.Name = "SliderBackground"
    SliderBackground.Parent = SliderFrame
    SliderBackground.BackgroundColor3 = _G.RobloxUILib1.Theme.SecondaryElementColor
    SliderBackground.Position = UDim2.new(0, 10, 0, 30)
    SliderBackground.Size = UDim2.new(1, -20, 0, 5)
    
    UICorner_2.CornerRadius = UDim.new(0, 3)
    UICorner_2.Parent = SliderBackground
    
    -- Slider Fill
    SliderFill.Name = "SliderFill"
    SliderFill.Parent = SliderBackground
    SliderFill.BackgroundColor3 = _G.RobloxUILib1.Theme.AccentColor
    SliderFill.Size = UDim2.new(0, 0, 1, 0)
    
    UICorner_3.CornerRadius = UDim.new(0, 3)
    UICorner_3.Parent = SliderFill
    
    -- Slider Drag
    SliderDrag.Name = "SliderDrag"
    SliderDrag.Parent = SliderBackground
    SliderDrag.BackgroundColor3 = _G.RobloxUILib1.Theme.PrimaryTextColor
    SliderDrag.Position = UDim2.new(0, -6, 0.5, 0)
    SliderDrag.Size = UDim2.new(0, 12, 0, 12)
    SliderDrag.AnchorPoint = Vector2.new(0, 0.5)
    SliderDrag.Text = ""
    
    UICorner_4.CornerRadius = UDim.new(1, 0)
    UICorner_4.Parent = SliderDrag
    
    -- If there's a description, add it and adjust size
    if sliderOptions.Description then
        SliderContainer.Size = UDim2.new(1, 0, 0, 70)
        
        local DescriptionLabel = Instance.new("TextLabel")
        DescriptionLabel.Name = "DescriptionLabel"
        DescriptionLabel.Parent = SliderFrame
        DescriptionLabel.BackgroundTransparency = 1
        DescriptionLabel.Position = UDim2.new(0, 10, 0, 45)
        DescriptionLabel.Size = UDim2.new(1, -20, 0, 20)
        DescriptionLabel.Font = Enum.Font.SourceSans
        DescriptionLabel.Text = sliderOptions.Description
        DescriptionLabel.TextColor3 = _G.RobloxUILib1.Theme.SecondaryTextColor
        DescriptionLabel.TextSize = 12
        DescriptionLabel.TextXAlignment = Enum.TextXAlignment.Left
    end
    
    -- Function to update slider visuals
    local function updateSlider(value)
        value = value or currentValue
        
        -- Round to the nearest increment if needed
        if sliderOptions.Increment > 0 then
            value = math.floor(value / sliderOptions.Increment + 0.5) * sliderOptions.Increment
        end
        
        -- Clamp value to min and max
        value = math.clamp(value, sliderOptions.Min, sliderOptions.Max)
        
        -- Calculate the percentage filled
        local percent = (value - sliderOptions.Min) / (sliderOptions.Max - sliderOptions.Min)
        
        -- Update fill size
        SliderFill:TweenSize(UDim2.new(percent, 0, 1, 0), "Out", "Quad", 0.1, true)
        
        -- Update drag position
        SliderDrag:TweenPosition(UDim2.new(percent, -6, 0.5, 0), "Out", "Quad", 0.1, true)
        
        -- Format the displayed value
        local formattedValue = value
        if sliderOptions.Increment == 1 then
            formattedValue = math.floor(value)
        elseif sliderOptions.Increment > 0 then
            -- Convert to string with appropriate decimal places
            local decimalPlaces = 0
            local incrementStr = tostring(sliderOptions.Increment)
            
            if incrementStr:find("%.") then
                decimalPlaces = #incrementStr:match("%.(.*)$")
            end
            
            formattedValue = string.format("%." .. decimalPlaces .. "f", value)
        end
        
        -- Update the value label
        SliderValue.Text = sliderOptions.Prefix .. formattedValue .. sliderOptions.Suffix
        
        -- Store the current value
        currentValue = value
        
        -- Call the callback function
        sliderOptions.Callback(value)
    end
    
    -- Set initial value
    updateSlider(sliderOptions.Default)
    
    -- Track sliding
    local sliding = false
    
    -- Function to update slider based on mouse position
    local function updateFromMouse(input)
        -- Get the absolute position of mouse/touch
        local mousePos = input.Position.X
        
        -- Get the position of the slider background
        local sliderPos = SliderBackground.AbsolutePosition.X
        local sliderWidth = SliderBackground.AbsoluteSize.X
        
        -- Calculate relative position in the slider (0 to 1)
        local relativePos = math.clamp((mousePos - sliderPos) / sliderWidth, 0, 1)
        
        -- Map to value range
        local mappedValue = sliderOptions.Min + (relativePos * (sliderOptions.Max - sliderOptions.Min))
        
        -- Update the slider
        updateSlider(mappedValue)
    end
    
    -- Slider drag functionality
    SliderDrag.MouseButton1Down:Connect(function()
        sliding = true
    end)
    
    SliderBackground.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            sliding = true
            updateFromMouse(input)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            sliding = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if sliding and input.UserInputType == Enum.UserInputType.MouseMovement then
            updateFromMouse(input)
        end
    end)
    
    -- Button effects
    local hoverTween = TweenService:Create(
        SliderFrame,
        TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {BackgroundColor3 = _G.RobloxUILib1.Theme.SecondaryElementColor}
    )
    
    local normalTween = TweenService:Create(
        SliderFrame,
        TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {BackgroundColor3 = _G.RobloxUILib1.Theme.PrimaryElementColor}
    )
    
    SliderFrame.MouseEnter:Connect(function()
        hoverTween:Play()
    end)
    
    SliderFrame.MouseLeave:Connect(function()
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
        Container = SliderContainer,
        Frame = SliderFrame,
        Label = SliderLabel,
        Value = SliderValue,
        Background = SliderBackground,
        Fill = SliderFill,
        Drag = SliderDrag,
        Options = sliderOptions,
        
        -- Method to set the slider value
        SetValue = function(self, value)
            updateSlider(value)
            return self
        end,
        
        -- Method to get the slider value
        GetValue = function()
            return currentValue
        end
    }
    
    table.insert(Tab.Elements, Element)
    
    return Element
end

return Slider 
