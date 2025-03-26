-- Dropdown Component for RobloxUILib1

local TweenService = game:GetService("TweenService")

local Dropdown = {}

function Dropdown.Create(Tab, options)
    options = options or {}
    
    local dropdownOptions = {
        Name = options.Name or "Dropdown",
        Options = options.Options or {},
        Default = options.Default or nil,
        Callback = options.Callback or function() end,
        Description = options.Description or nil,
        Multi = options.Multi or false
    }
    
    -- Create container
    local DropdownContainer = Instance.new("Frame")
    local DropdownFrame = Instance.new("Frame")
    local UICorner = Instance.new("UICorner")
    local DropdownLabel = Instance.new("TextLabel")
    local DropdownButton = Instance.new("TextButton")
    local UICorner_2 = Instance.new("UICorner")
    local DropdownIcon = Instance.new("ImageLabel")
    local DropdownText = Instance.new("TextLabel")
    local DropdownItemsFrame = Instance.new("Frame")
    local UICorner_3 = Instance.new("UICorner")
    local ItemsScrollFrame = Instance.new("ScrollingFrame")
    local UIListLayout = Instance.new("UIListLayout")
    local UIPadding = Instance.new("UIPadding")
    
    -- Selected values
    local selectedOption = nil
    local selectedOptions = {}
    
    -- Dropdown is open flag
    local isOpen = false
    
    -- Dropdown Container
    DropdownContainer.Name = dropdownOptions.Name .. "Container"
    DropdownContainer.Parent = Tab.TabContent
    DropdownContainer.BackgroundTransparency = 1
    DropdownContainer.Size = UDim2.new(1, 0, 0, 60)
    DropdownContainer.ClipsDescendants = true
    
    -- Dropdown Frame
    DropdownFrame.Name = dropdownOptions.Name .. "Frame"
    DropdownFrame.Parent = DropdownContainer
    DropdownFrame.BackgroundColor3 = _G.RobloxUILib1.Theme.PrimaryElementColor
    DropdownFrame.Size = UDim2.new(1, 0, 0, 60)
    
    UICorner.CornerRadius = UDim.new(0, 4)
    UICorner.Parent = DropdownFrame
    
    -- Dropdown Label
    DropdownLabel.Name = "DropdownLabel"
    DropdownLabel.Parent = DropdownFrame
    DropdownLabel.BackgroundTransparency = 1
    DropdownLabel.Position = UDim2.new(0, 10, 0, 5)
    DropdownLabel.Size = UDim2.new(1, -20, 0, 20)
    DropdownLabel.Font = Enum.Font.SourceSansSemibold
    DropdownLabel.Text = dropdownOptions.Name
    DropdownLabel.TextColor3 = _G.RobloxUILib1.Theme.PrimaryTextColor
    DropdownLabel.TextSize = 14
    DropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Dropdown Button
    DropdownButton.Name = "DropdownButton"
    DropdownButton.Parent = DropdownFrame
    DropdownButton.BackgroundColor3 = _G.RobloxUILib1.Theme.SecondaryElementColor
    DropdownButton.Position = UDim2.new(0, 10, 0, 30)
    DropdownButton.Size = UDim2.new(1, -20, 0, 20)
    DropdownButton.Text = ""
    DropdownButton.AutoButtonColor = false
    
    UICorner_2.CornerRadius = UDim.new(0, 4)
    UICorner_2.Parent = DropdownButton
    
    -- Dropdown Text
    DropdownText.Name = "DropdownText"
    DropdownText.Parent = DropdownButton
    DropdownText.BackgroundTransparency = 1
    DropdownText.Position = UDim2.new(0, 5, 0, 0)
    DropdownText.Size = UDim2.new(1, -25, 1, 0)
    DropdownText.Font = Enum.Font.SourceSans
    DropdownText.Text = dropdownOptions.Multi and "Select..." or "Select option..."
    DropdownText.TextColor3 = _G.RobloxUILib1.Theme.SecondaryTextColor
    DropdownText.TextSize = 14
    DropdownText.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Dropdown Icon
    DropdownIcon.Name = "DropdownIcon"
    DropdownIcon.Parent = DropdownButton
    DropdownIcon.BackgroundTransparency = 1
    DropdownIcon.Position = UDim2.new(1, -20, 0.5, 0)
    DropdownIcon.Size = UDim2.new(0, 16, 0, 16)
    DropdownIcon.AnchorPoint = Vector2.new(0, 0.5)
    DropdownIcon.Image = "rbxassetid://6031091004" -- Arrow down icon
    DropdownIcon.ImageColor3 = _G.RobloxUILib1.Theme.SecondaryTextColor
    
    -- Dropdown Items Frame
    DropdownItemsFrame.Name = "DropdownItemsFrame"
    DropdownItemsFrame.Parent = DropdownFrame
    DropdownItemsFrame.BackgroundColor3 = _G.RobloxUILib1.Theme.SecondaryElementColor
    DropdownItemsFrame.Position = UDim2.new(0, 10, 0, 55)
    DropdownItemsFrame.Size = UDim2.new(1, -20, 0, 0) -- Start with no height
    DropdownItemsFrame.Visible = false
    
    UICorner_3.CornerRadius = UDim.new(0, 4)
    UICorner_3.Parent = DropdownItemsFrame
    
    -- Items Scroll Frame
    ItemsScrollFrame.Name = "ItemsScrollFrame"
    ItemsScrollFrame.Parent = DropdownItemsFrame
    ItemsScrollFrame.BackgroundTransparency = 1
    ItemsScrollFrame.Position = UDim2.new(0, 0, 0, 0)
    ItemsScrollFrame.Size = UDim2.new(1, 0, 1, 0)
    ItemsScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    ItemsScrollFrame.ScrollBarThickness = 2
    ItemsScrollFrame.ScrollBarImageColor3 = _G.RobloxUILib1.Theme.ScrollBarColor
    
    UIListLayout.Parent = ItemsScrollFrame
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0, 2)
    
    UIPadding.Parent = ItemsScrollFrame
    UIPadding.PaddingLeft = UDim.new(0, 5)
    UIPadding.PaddingRight = UDim.new(0, 5)
    UIPadding.PaddingTop = UDim.new(0, 5)
    UIPadding.PaddingBottom = UDim.new(0, 5)
    
    -- If there's a description, add it and adjust size
    if dropdownOptions.Description then
        DropdownContainer.Size = UDim2.new(1, 0, 0, 80)
        DropdownFrame.Size = UDim2.new(1, 0, 0, 80)
        
        local DescriptionLabel = Instance.new("TextLabel")
        DescriptionLabel.Name = "DescriptionLabel"
        DescriptionLabel.Parent = DropdownFrame
        DescriptionLabel.BackgroundTransparency = 1
        DescriptionLabel.Position = UDim2.new(0, 10, 0, 55)
        DescriptionLabel.Size = UDim2.new(1, -20, 0, 20)
        DescriptionLabel.Font = Enum.Font.SourceSans
        DescriptionLabel.Text = dropdownOptions.Description
        DescriptionLabel.TextColor3 = _G.RobloxUILib1.Theme.SecondaryTextColor
        DescriptionLabel.TextSize = 12
        DescriptionLabel.TextXAlignment = Enum.TextXAlignment.Left
        
        -- Adjust position of the DropdownItemsFrame
        DropdownItemsFrame.Position = UDim2.new(0, 10, 0, 75)
    end
    
    -- Function to update the dropdown text based on selection
    local function updateDropdownText()
        if dropdownOptions.Multi then
            if #selectedOptions == 0 then
                DropdownText.Text = "Select..."
            elseif #selectedOptions == 1 then
                DropdownText.Text = selectedOptions[1]
            else
                DropdownText.Text = tostring(#selectedOptions) .. " selected"
            end
        else
            if selectedOption then
                DropdownText.Text = selectedOption
            else
                DropdownText.Text = "Select option..."
            end
        end
    end
    
    -- Function to create dropdown items
    local function createDropdownItems()
        -- Clear existing items
        for _, child in ipairs(ItemsScrollFrame:GetChildren()) do
            if child:IsA("TextButton") then
                child:Destroy()
            end
        end
        
        -- Track height for canvas size
        local totalHeight = 0
        
        -- Add new items
        for i, option in ipairs(dropdownOptions.Options) do
            local ItemButton = Instance.new("TextButton")
            local UICorner_4 = Instance.new("UICorner")
            
            ItemButton.Name = "Item_" .. option
            ItemButton.Parent = ItemsScrollFrame
            ItemButton.BackgroundColor3 = _G.RobloxUILib1.Theme.PrimaryElementColor
            ItemButton.Size = UDim2.new(1, 0, 0, 25)
            ItemButton.Text = option
            ItemButton.Font = Enum.Font.SourceSans
            ItemButton.TextColor3 = _G.RobloxUILib1.Theme.PrimaryTextColor
            ItemButton.TextSize = 14
            ItemButton.TextXAlignment = Enum.TextXAlignment.Left
            ItemButton.AutoButtonColor = false
            
            -- If using multi-select, show checks for selected items
            if dropdownOptions.Multi then
                -- Check if this option is selected
                local isSelected = table.find(selectedOptions, option) ~= nil
                
                -- Add visual indicator (e.g., different background color)
                if isSelected then
                    ItemButton.BackgroundColor3 = _G.RobloxUILib1.Theme.AccentColor
                end
            else
                -- For single select, highlight the selected option
                if option == selectedOption then
                    ItemButton.BackgroundColor3 = _G.RobloxUILib1.Theme.AccentColor
                end
            end
            
            UICorner_4.CornerRadius = UDim.new(0, 4)
            UICorner_4.Parent = ItemButton
            
            -- Button effects
            ItemButton.MouseEnter:Connect(function()
                if (dropdownOptions.Multi and table.find(selectedOptions, option) == nil) or 
                   (not dropdownOptions.Multi and option ~= selectedOption) then
                    TweenService:Create(
                        ItemButton,
                        TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                        {BackgroundColor3 = _G.RobloxUILib1.Theme.SecondaryElementColor}
                    ):Play()
                end
            end)
            
            ItemButton.MouseLeave:Connect(function()
                if (dropdownOptions.Multi and table.find(selectedOptions, option) == nil) or 
                   (not dropdownOptions.Multi and option ~= selectedOption) then
                    TweenService:Create(
                        ItemButton,
                        TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                        {BackgroundColor3 = _G.RobloxUILib1.Theme.PrimaryElementColor}
                    ):Play()
                end
            end)
            
            -- Click handler
            ItemButton.MouseButton1Click:Connect(function()
                if dropdownOptions.Multi then
                    -- Find if already selected
                    local index = table.find(selectedOptions, option)
                    
                    if index then
                        -- Remove from selected
                        table.remove(selectedOptions, index)
                        ItemButton.BackgroundColor3 = _G.RobloxUILib1.Theme.PrimaryElementColor
                    else
                        -- Add to selected
                        table.insert(selectedOptions, option)
                        ItemButton.BackgroundColor3 = _G.RobloxUILib1.Theme.AccentColor
                    end
                    
                    -- Update visuals and trigger callback
                    updateDropdownText()
                    dropdownOptions.Callback(selectedOptions)
                else
                    -- Single selection
                    selectedOption = option
                    
                    -- Update all items
                    for _, child in ipairs(ItemsScrollFrame:GetChildren()) do
                        if child:IsA("TextButton") then
                            if child.Text == option then
                                child.BackgroundColor3 = _G.RobloxUILib1.Theme.AccentColor
                            else
                                child.BackgroundColor3 = _G.RobloxUILib1.Theme.PrimaryElementColor
                            end
                        end
                    end
                    
                    -- Toggle dropdown
                    toggleDropdown()
                    
                    -- Update visuals and trigger callback
                    updateDropdownText()
                    dropdownOptions.Callback(selectedOption)
                end
            end)
            
            totalHeight = totalHeight + 25 + UIListLayout.Padding.Offset
        end
        
        -- Update canvas size
        ItemsScrollFrame.CanvasSize = UDim2.new(0, 0, 0, totalHeight)
    end
    
    -- Function to toggle dropdown visibility
    local function toggleDropdown()
        isOpen = not isOpen
        
        if isOpen then
            -- Create the item buttons
            createDropdownItems()
            
            -- Show dropdown items
            DropdownItemsFrame.Visible = true
            
            -- Calculate max height (limited to 150 pixels)
            local itemsHeight = math.min(ItemsScrollFrame.CanvasSize.Y.Offset + 10, 150)
            
            -- Update container size to accommodate the dropdown items
            local baseHeight = dropdownOptions.Description and 80 or 60
            DropdownContainer:TweenSize(UDim2.new(1, 0, 0, baseHeight + itemsHeight), "Out", "Quad", 0.3, true)
            
            -- Expand the items frame
            DropdownItemsFrame:TweenSize(UDim2.new(1, -20, 0, itemsHeight), "Out", "Quad", 0.3, true)
            
            -- Rotate arrow
            TweenService:Create(
                DropdownIcon,
                TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {Rotation = 180}
            ):Play()
        else
            -- Collapse the items frame
            DropdownItemsFrame:TweenSize(UDim2.new(1, -20, 0, 0), "Out", "Quad", 0.3, true)
            
            -- Reset container size
            local baseHeight = dropdownOptions.Description and 80 or 60
            DropdownContainer:TweenSize(UDim2.new(1, 0, 0, baseHeight), "Out", "Quad", 0.3, true)
            
            -- Hide dropdown items after tween completes
            wait(0.3)
            DropdownItemsFrame.Visible = false
            
            -- Rotate arrow back
            TweenService:Create(
                DropdownIcon,
                TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {Rotation = 0}
            ):Play()
        end
    end
    
    -- Set default value(s) if provided
    if dropdownOptions.Default then
        if dropdownOptions.Multi then
            -- Multi-select: Default should be a table
            if type(dropdownOptions.Default) == "table" then
                selectedOptions = dropdownOptions.Default
            elseif type(dropdownOptions.Default) == "string" then
                -- If just one string is provided, wrap it in a table
                selectedOptions = {dropdownOptions.Default}
            end
        else
            -- Single-select: Default should be a string
            if type(dropdownOptions.Default) == "string" then
                selectedOption = dropdownOptions.Default
            end
        end
        
        updateDropdownText()
    end
    
    -- Dropdown button functionality
    DropdownButton.MouseButton1Click:Connect(toggleDropdown)
    
    -- Button effects
    local hoverTween = TweenService:Create(
        DropdownButton,
        TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {BackgroundColor3 = _G.RobloxUILib1.Theme.OtherElementColor}
    )
    
    local normalTween = TweenService:Create(
        DropdownButton,
        TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {BackgroundColor3 = _G.RobloxUILib1.Theme.SecondaryElementColor}
    )
    
    DropdownButton.MouseEnter:Connect(function()
        hoverTween:Play()
    end)
    
    DropdownButton.MouseLeave:Connect(function()
        normalTween:Play()
    end)
    
    -- Frame effects
    local frameHoverTween = TweenService:Create(
        DropdownFrame,
        TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {BackgroundColor3 = _G.RobloxUILib1.Theme.SecondaryElementColor}
    )
    
    local frameNormalTween = TweenService:Create(
        DropdownFrame,
        TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {BackgroundColor3 = _G.RobloxUILib1.Theme.PrimaryElementColor}
    )
    
    DropdownFrame.MouseEnter:Connect(function()
        frameHoverTween:Play()
    end)
    
    DropdownFrame.MouseLeave:Connect(function()
        frameNormalTween:Play()
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
        Container = DropdownContainer,
        Frame = DropdownFrame,
        Label = DropdownLabel,
        Button = DropdownButton,
        ItemsFrame = DropdownItemsFrame,
        ScrollFrame = ItemsScrollFrame,
        Options = dropdownOptions,
        
        -- Method to set the dropdown value(s)
        SetValue = function(self, value)
            if dropdownOptions.Multi then
                if type(value) == "table" then
                    selectedOptions = value
                elseif value ~= nil then
                    selectedOptions = {value}
                else
                    selectedOptions = {}
                end
            else
                selectedOption = value
            end
            
            updateDropdownText()
            
            if isOpen then
                createDropdownItems()
            end
            
            return self
        end,
        
        -- Method to get the dropdown value(s)
        GetValue = function()
            return dropdownOptions.Multi and selectedOptions or selectedOption
        end,
        
        -- Method to refresh the dropdown options
        Refresh = function(self, newOptions)
            dropdownOptions.Options = newOptions or dropdownOptions.Options
            
            -- Reset selection if the selected option(s) no longer exist
            if dropdownOptions.Multi then
                local validOptions = {}
                for _, selected in ipairs(selectedOptions) do
                    if table.find(dropdownOptions.Options, selected) then
                        table.insert(validOptions, selected)
                    end
                end
                selectedOptions = validOptions
            else
                if not table.find(dropdownOptions.Options, selectedOption) then
                    selectedOption = nil
                end
            end
            
            updateDropdownText()
            
            if isOpen then
                createDropdownItems()
            end
            
            return self
        end
    }
    
    table.insert(Tab.Elements, Element)
    
    return Element
end

return Dropdown 
