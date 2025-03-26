-- TextBox Component for RobloxUILib1

local TweenService = game:GetService("TweenService")

local TextBox = {}

function TextBox.Create(Tab, options)
    options = options or {}
    
    local textBoxOptions = {
        Name = options.Name or "TextBox",
        Default = options.Default or "",
        PlaceholderText = options.PlaceholderText or "Enter text here...",
        ClearOnFocus = options.ClearOnFocus ~= nil and options.ClearOnFocus or true,
        Callback = options.Callback or function() end,
        Description = options.Description or nil,
        NumbersOnly = options.NumbersOnly or false
    }
    
    -- Create container
    local TextBoxContainer = Instance.new("Frame")
    local UICorner = Instance.new("UICorner")
    local TextBoxFrame = Instance.new("Frame")
    local UICorner_2 = Instance.new("UICorner")
    local TextBoxLabel = Instance.new("TextLabel")
    local InputBox = Instance.new("TextBox")
    local UICorner_3 = Instance.new("UICorner")
    
    -- Current value
    local currentValue = textBoxOptions.Default
    
    -- TextBox Container
    TextBoxContainer.Name = textBoxOptions.Name .. "Container"
    TextBoxContainer.Parent = Tab.TabContent
    TextBoxContainer.BackgroundTransparency = 1
    TextBoxContainer.Size = UDim2.new(1, 0, 0, 60)
    
    -- TextBox Frame
    TextBoxFrame.Name = textBoxOptions.Name .. "Frame"
    TextBoxFrame.Parent = TextBoxContainer
    TextBoxFrame.BackgroundColor3 = _G.RobloxUILib1.Theme.PrimaryElementColor
    TextBoxFrame.Size = UDim2.new(1, 0, 1, 0)
    
    UICorner_2.CornerRadius = UDim.new(0, 4)
    UICorner_2.Parent = TextBoxFrame
    
    -- TextBox Label
    TextBoxLabel.Name = "TextBoxLabel"
    TextBoxLabel.Parent = TextBoxFrame
    TextBoxLabel.BackgroundTransparency = 1
    TextBoxLabel.Position = UDim2.new(0, 10, 0, 5)
    TextBoxLabel.Size = UDim2.new(1, -20, 0, 20)
    TextBoxLabel.Font = Enum.Font.SourceSansSemibold
    TextBoxLabel.Text = textBoxOptions.Name
    TextBoxLabel.TextColor3 = _G.RobloxUILib1.Theme.PrimaryTextColor
    TextBoxLabel.TextSize = 14
    TextBoxLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Input Box
    InputBox.Name = "InputBox"
    InputBox.Parent = TextBoxFrame
    InputBox.BackgroundColor3 = _G.RobloxUILib1.Theme.SecondaryElementColor
    InputBox.Position = UDim2.new(0, 10, 0, 30)
    InputBox.Size = UDim2.new(1, -20, 0, 20)
    InputBox.Font = Enum.Font.SourceSans
    InputBox.Text = textBoxOptions.Default
    InputBox.PlaceholderText = textBoxOptions.PlaceholderText
    InputBox.TextColor3 = _G.RobloxUILib1.Theme.PrimaryTextColor
    InputBox.TextSize = 14
    InputBox.ClearTextOnFocus = textBoxOptions.ClearOnFocus
    
    -- If numbers only, set appropriate input type
    if textBoxOptions.NumbersOnly then
        InputBox.PlaceholderText = textBoxOptions.PlaceholderText .. " (Numbers Only)"
    end
    
    UICorner_3.CornerRadius = UDim.new(0, 4)
    UICorner_3.Parent = InputBox
    
    -- If there's a description, add it and adjust size
    if textBoxOptions.Description then
        TextBoxContainer.Size = UDim2.new(1, 0, 0, 80)
        
        local DescriptionLabel = Instance.new("TextLabel")
        DescriptionLabel.Name = "DescriptionLabel"
        DescriptionLabel.Parent = TextBoxFrame
        DescriptionLabel.BackgroundTransparency = 1
        DescriptionLabel.Position = UDim2.new(0, 10, 0, 55)
        DescriptionLabel.Size = UDim2.new(1, -20, 0, 20)
        DescriptionLabel.Font = Enum.Font.SourceSans
        DescriptionLabel.Text = textBoxOptions.Description
        DescriptionLabel.TextColor3 = _G.RobloxUILib1.Theme.SecondaryTextColor
        DescriptionLabel.TextSize = 12
        DescriptionLabel.TextXAlignment = Enum.TextXAlignment.Left
    end
    
    -- Text box functionality
    InputBox.FocusLost:Connect(function(enterPressed)
        local text = InputBox.Text
        
        -- Handle numbers only mode
        if textBoxOptions.NumbersOnly then
            if text == "" then
                text = "0"
                InputBox.Text = text
            else
                local number = tonumber(text)
                if number then
                    text = tostring(number)
                    InputBox.Text = text
                else
                    text = currentValue
                    InputBox.Text = text
                end
            end
        end
        
        currentValue = text
        textBoxOptions.Callback(text, enterPressed)
    end)
    
    -- Button effects
    local hoverTween = TweenService:Create(
        TextBoxFrame,
        TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {BackgroundColor3 = _G.RobloxUILib1.Theme.SecondaryElementColor}
    )
    
    local normalTween = TweenService:Create(
        TextBoxFrame,
        TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {BackgroundColor3 = _G.RobloxUILib1.Theme.PrimaryElementColor}
    )
    
    local inputHoverTween = TweenService:Create(
        InputBox,
        TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {BackgroundColor3 = _G.RobloxUILib1.Theme.OtherElementColor}
    )
    
    local inputNormalTween = TweenService:Create(
        InputBox,
        TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {BackgroundColor3 = _G.RobloxUILib1.Theme.SecondaryElementColor}
    )
    
    -- Frame hover effects
    TextBoxFrame.MouseEnter:Connect(function()
        hoverTween:Play()
    end)
    
    TextBoxFrame.MouseLeave:Connect(function()
        normalTween:Play()
    end)
    
    -- Input box hover effects
    InputBox.MouseEnter:Connect(function()
        inputHoverTween:Play()
    end)
    
    InputBox.MouseLeave:Connect(function()
        if InputBox:IsFocused() then return end
        inputNormalTween:Play()
    end)
    
    InputBox.Focused:Connect(function()
        inputHoverTween:Play()
    end)
    
    InputBox.FocusLost:Connect(function()
        inputNormalTween:Play()
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
        Container = TextBoxContainer,
        Frame = TextBoxFrame,
        Label = TextBoxLabel,
        Input = InputBox,
        Options = textBoxOptions,
        
        -- Method to set the textbox value
        SetValue = function(self, value)
            InputBox.Text = tostring(value)
            currentValue = tostring(value)
            return self
        end,
        
        -- Method to get the textbox value
        GetValue = function()
            return currentValue
        end
    }
    
    table.insert(Tab.Elements, Element)
    
    return Element
end

return TextBox 
