local TweenService = game:GetService("TweenService")
local InputService = game:GetService("UserInputService")

local Library = {
    Version = "1.1.0",
    Theme = {
        Font = "Gotham",
        Accent = Color3.fromRGB(147, 112, 219),
        AcrylicMain = Color3.fromRGB(20, 0, 40),
        AcrylicBorder = Color3.fromRGB(147, 112, 219),
        TitleBarLine = Color3.fromRGB(50, 50, 50),
        Element = Color3.fromRGB(30, 30, 30),
        ElementBorder = Color3.fromRGB(50, 50, 50),
        InElementBorder = Color3.fromRGB(40, 40, 40),
        ElementTransparency = 0,
        FontColor = Color3.fromRGB(255, 255, 255),
        FontColorSecondary = Color3.fromRGB(150, 150, 150),
        HideKey = "LeftAlt",
        DialogInput = Color3.fromRGB(40, 40, 40),
        DialogInputLine = Color3.fromRGB(60, 60, 60),
        TabBackground = Color3.fromRGB(30, 0, 60),
        TabSelected = Color3.fromRGB(147, 112, 219),
        TabUnselected = Color3.fromRGB(20, 0, 40)
    }
}

local CreateModule = {
    reg = {}
}

local function AddToReg(Instance)
    table.insert(CreateModule.reg, Instance)
end

function CreateModule.Instance(instance, properties)
    local CreatedInstance = Instance.new(instance)
    for property, value in pairs(properties) do
        CreatedInstance[property] = value
    end
    return CreatedInstance
end

function Library.Main(Name)
    for _, v in pairs(game.CoreGui:GetChildren()) do
        if v.Name == "DarkSquareLib" then
            v:Destroy()
        end
    end

    local DarkSquareLib = CreateModule.Instance("ScreenGui", {
        Name = "DarkSquareLib",
        Parent = game.CoreGui,
        ResetOnSpawn = false
    })

    local MainFrame = CreateModule.Instance("Frame", {
        Name = "MainFrame",
        Parent = DarkSquareLib,
        BackgroundColor3 = Library.Theme.AcrylicMain,
        BorderSizePixel = 0,
        Position = UDim2.new(0.5, -250, 0.5, -150),
        Size = UDim2.new(0, 500, 0, 300),
        Active = true,
        Draggable = false,
        Visible = true,
        ZIndex = 3
    })

    CreateModule.Instance("UICorner", {
        Parent = MainFrame,
        Name = "Corner",
        CornerRadius = UDim.new(0, 8)
    })

    CreateModule.Instance("UIStroke", {
        Parent = MainFrame,
        Name = "Stroke",
        Thickness = 2,
        Color = Library.Theme.AcrylicBorder,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    })

    local TabFrame = CreateModule.Instance("Frame", {
        Parent = MainFrame,
        Name = "TabFrame",
        BackgroundColor3 = Library.Theme.TabBackground,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0, 0),
        Size = UDim2.new(1, 0, 0, 40),
        ZIndex = 4
    })

    CreateModule.Instance("UICorner", {
        Parent = TabFrame,
        Name = "Corner",
        CornerRadius = UDim.new(0, 8)
    })

    local TabList = CreateModule.Instance("UIListLayout", {
        Parent = TabFrame,
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Left,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        Padding = UDim.new(0, 5)
    })

    local TabPadding = CreateModule.Instance("UIPadding", {
        Parent = TabFrame,
        PaddingLeft = UDim.new(0, 5),
        PaddingRight = UDim.new(0, 5)
    })

    local ContainerFrame = CreateModule.Instance("Frame", {
        Parent = MainFrame,
        Name = "ContainerFrame",
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0, 40),
        Size = UDim2.new(1, 0, 1, -40),
        ZIndex = 3
    })

    CreateModule.Instance("UIStroke", {
        Parent = ContainerFrame,
        Name = "Stroke",
        Thickness = 1,
        Color = Library.Theme.ElementBorder,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    })

    local isDraggingUI = false
    local dragStartPos = nil
    local dragStartFramePos = nil

    TabFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            isDraggingUI = true
            dragStartPos = input.Position
            dragStartFramePos = MainFrame.Position
        end
    end)

    TabFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch and isDraggingUI then
            local delta = input.Position - dragStartPos
            local newPos = UDim2.new(
                dragStartFramePos.X.Scale,
                dragStartFramePos.X.Offset + delta.X,
                dragStartFramePos.Y.Scale,
                dragStartFramePos.Y.Offset + delta.Y
            )
            MainFrame.Position = newPos
        end
    end)

    TabFrame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            isDraggingUI = false
            dragStartPos = nil
            dragStartFramePos = nil
        end
    end)

    InputService.InputBegan:Connect(function(input, IsTyping)
        if input.KeyCode == Enum.KeyCode[Library.Theme.HideKey] and not IsTyping then
            MainFrame.Visible = not MainFrame.Visible
        end
    end)

    local InMain = {}
    local Tabs = {}
    local CurrentTab = nil

    local function CalculateTabWidth(TabName)
        local TextService = game:GetService("TextService")
        local TextSize = TextService:GetTextSize(TabName, 14, Enum.Font[Library.Theme.Font], Vector2.new(1000, 1000))
        return math.max(75, TextSize.X + 10)
    end

    local function CreateTab(TabName)
        local TabWidth = CalculateTabWidth(TabName)

        local TabButton = CreateModule.Instance("TextButton", {
            Parent = TabFrame,
            Name = TabName,
            BackgroundColor3 = Library.Theme.TabUnselected,
            BorderSizePixel = 0,
            Size = UDim2.new(0, TabWidth, 0, 30),
            Font = Enum.Font[Library.Theme.Font],
            Text = TabName,
            TextColor3 = Library.Theme.FontColor,
            TextSize = 14,
            AutoButtonColor = false,
            ZIndex = 4
        })

        CreateModule.Instance("UICorner", {
            Parent = TabButton,
            Name = "Corner",
            CornerRadius = UDim.new(0, 4)
        })

        local TabContainer = CreateModule.Instance("ScrollingFrame", {
            Parent = ContainerFrame,
            Name = TabName .. "Container",
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Position = UDim2.new(0, 5, 0, 5),
            Size = UDim2.new(1, -10, 1, -10),
            CanvasSize = UDim2.new(0, 0, 0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            ScrollBarThickness = 0,
            ScrollingEnabled = false,
            Visible = false,
            ZIndex = 3
        })

        CreateModule.Instance("UIStroke", {
            Parent = TabContainer,
            Name = "Stroke",
            Thickness = 1,
            Color = Library.Theme.ElementBorder,
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        })

        local ElementList = CreateModule.Instance("UIListLayout", {
            Parent = TabContainer,
            Padding = UDim.new(0, 5),
            HorizontalAlignment = Enum.HorizontalAlignment.Left,
            SortOrder = Enum.SortOrder.LayoutOrder
        })

        ElementList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabContainer.CanvasSize = UDim2.new(0, 0, 0, ElementList.AbsoluteContentSize.Y + 4)
        end)

        local isScrolling = false
        local lastTouchPos = nil
        local scrollSpeed = 2
        local velocity = 0
        local lastDelta = 0
        local decay = 0.95
        local minVelocity = 5

        TabContainer.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch and not isDraggingUI then
                isScrolling = true
                lastTouchPos = input.Position.Y
                velocity = 0
            end
        end)

        TabContainer.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch and isScrolling then
                local currentTouchPos = input.Position.Y
                lastDelta = (lastTouchPos - currentTouchPos) * scrollSpeed
                local newCanvasPos = TabContainer.CanvasPosition.Y + lastDelta
                newCanvasPos = math.clamp(newCanvasPos, 0, math.max(0, TabContainer.CanvasSize.Y.Offset - TabContainer.AbsoluteSize.Y))
                TabContainer.CanvasPosition = Vector2.new(0, newCanvasPos)
                velocity = lastDelta
                lastTouchPos = currentTouchPos
            end
        end)

        TabContainer.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch then
                isScrolling = false
                lastTouchPos = nil
                if math.abs(velocity) > minVelocity then
                    spawn(function()
                        while math.abs(velocity) > minVelocity and not isScrolling do
                            local newCanvasPos = TabContainer.CanvasPosition.Y + velocity
                            newCanvasPos = math.clamp(newCanvasPos, 0, math.max(0, TabContainer.CanvasSize.Y.Offset - TabContainer.AbsoluteSize.Y))
                            TabContainer.CanvasPosition = Vector2.new(0, newCanvasPos)
                            velocity = velocity * decay
                            wait()
                        end
                        local finalPos = math.clamp(TabContainer.CanvasPosition.Y, 0, math.max(0, TabContainer.CanvasSize.Y.Offset - TabContainer.AbsoluteSize.Y))
                        TweenService:Create(TabContainer, TweenInfo.new(0.2), {CanvasPosition = Vector2.new(0, finalPos)}):Play()
                    end)
                end
            end
        end)

        TabButton.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch then
                if CurrentTab then
                    Tabs[CurrentTab].Container.Visible = false
                    Tabs[CurrentTab].Button.BackgroundColor3 = Library.Theme.TabUnselected
                end
                TabContainer.Visible = true
                TabButton.BackgroundColor3 = Library.Theme.TabSelected
                CurrentTab = TabName
            end
        end)

        Tabs[TabName] = {
            Button = TabButton,
            Container = TabContainer
        }

        return TabContainer
    end

    function InMain.Tab(TabName)
        local TabContainer = CreateTab(TabName)
        if not CurrentTab then
            CurrentTab = TabName
            TabContainer.Visible = true
            Tabs[TabName].Button.BackgroundColor3 = Library.Theme.TabSelected
        end

        local TabFunctions = {}

        function TabFunctions.Checkbox(config)
            local Checkbox = CreateModule.Instance("TextButton", {
                Parent = TabContainer,
                Name = config.Name,
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                Position = UDim2.new(0, 0, 0, 0),
                Size = UDim2.new(1, 0, 0, 30),
                Font = Enum.Font[Library.Theme.Font],
                Text = "",
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                AutoButtonColor = false,
                ZIndex = 3
            })

            CreateModule.Instance("TextLabel", {
                Parent = Checkbox,
                Name = "Label",
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                Position = UDim2.new(0, 5, 0, 0),
                Size = UDim2.new(0.7, 0, 1, 0),
                Font = Enum.Font[Library.Theme.Font],
                Text = config.Name,
                TextSize = 14,
                TextColor3 = Library.Theme.FontColor,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 3
            })

            local IsActive = CreateModule.Instance("BoolValue", {
                Parent = Checkbox,
                Name = "IsActive",
                Value = config.Default or false
            })

            local CheckFrame = CreateModule.Instance("Frame", {
                Parent = Checkbox,
                Name = "CheckFrame",
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                Position = UDim2.new(1, -25, 0.5, -10),
                Size = UDim2.new(0, 20, 0, 20),
                ZIndex = 3
            })

            local CheckFrameInner = CreateModule.Instance("Frame", {
                Parent = CheckFrame,
                Name = "CheckFrameInner",
                BackgroundColor3 = Library.Theme.Accent,
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                Position = UDim2.new(0, 0, 0, 0),
                Size = UDim2.new(1, 0, 1, 0),
                ZIndex = 3
            })

            CreateModule.Instance("UICorner", {
                Parent = CheckFrameInner,
                Name = "Corner",
                CornerRadius = UDim.new(0, 4)
            })

            local CheckStroke = CreateModule.Instance("UIStroke", {
                Parent = CheckFrameInner,
                Name = "Stroke",
                Thickness = 1,
                Color = Library.Theme.ElementBorder,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            })

            local CheckMark = CreateModule.Instance("ImageLabel", {
                Parent = CheckFrameInner,
                Name = "CheckMark",
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                Position = UDim2.new(0, 2, 0, 2),
                Size = UDim2.new(1, -4, 1, -4),
                Image = "rbxassetid://10709790644",
                ImageColor3 = Color3.fromRGB(255, 255, 255),
                ImageTransparency = 1,
                ZIndex = 3
            })

            local function UpdateVisuals()
                CheckMark.Visible = IsActive.Value
                if IsActive.Value then
                    CheckStroke.Transparency = 1
                    CheckFrameInner.BackgroundTransparency = 0
                    CheckMark.ImageTransparency = 0
                else
                    CheckStroke.Transparency = 0
                    CheckFrameInner.BackgroundTransparency = 1
                    CheckMark.ImageTransparency = 1
                end
            end

            UpdateVisuals()

            IsActive.Changed:Connect(function()
                UpdateVisuals()
                spawn(function() config.Callback(IsActive.Value) end)
            end)

            local touchStartTime = 0
            local touchStartPos = nil
            local maxTouchTime = 0.3
            local maxTouchDistance = 10

            Checkbox.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch then
                    touchStartTime = tick()
                    touchStartPos = input.Position
                end
            end)

            Checkbox.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch then
                    local touchEndTime = tick()
                    local touchEndPos = input.Position
                    local touchDuration = touchEndTime - touchStartTime
                    local touchDistance = (touchEndPos - touchStartPos).Magnitude
                    if touchDuration <= maxTouchTime and touchDistance <= maxTouchDistance then
                        IsActive.Value = not IsActive.Value
                    end
                end
            end)

            AddToReg(Checkbox)
            return Checkbox
        end

        function TabFunctions.Slider(config)
            local Slider = CreateModule.Instance("Frame", {
                Parent = TabContainer,
                Name = config.Name,
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                Position = UDim2.new(0, 0, 0, 0),
                Size = UDim2.new(1, 0, 0, 40),
                ZIndex = 3
            })

            CreateModule.Instance("TextLabel", {
                Parent = Slider,
                Name = "Label",
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                Position = UDim2.new(0, 5, 0, 0),
                Size = UDim2.new(0.4, 0, 0, 20),
                Font = Enum.Font[Library.Theme.Font],
                Text = config.Name,
                TextSize = 14,
                TextColor3 = Library.Theme.FontColor,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 3
            })

            local ValueLabel = CreateModule.Instance("TextLabel", {
                Parent = Slider,
                Name = "ValueLabel",
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                Position = UDim2.new(0.8, 0, 0, 0),
                Size = UDim2.new(0.2, -10, 0, 20),
                Font = Enum.Font[Library.Theme.Font],
                Text = tostring(config.Default or 0),
                TextSize = 14,
                TextColor3 = Library.Theme.FontColorSecondary,
                TextXAlignment = Enum.TextXAlignment.Right,
                ZIndex = 3
            })

            local SliderBar = CreateModule.Instance("Frame", {
                Parent = Slider,
                Name = "SliderBar",
                BackgroundColor3 = Library.Theme.ElementBorder,
                BorderSizePixel = 0,
                Position = UDim2.new(0, 5, 0, 25),
                Size = UDim2.new(1, -10, 0, 5),
                ZIndex = 3
            })

            CreateModule.Instance("UICorner", {
                Parent = SliderBar,
                Name = "Corner",
                CornerRadius = UDim.new(0, 2)
            })

            local SliderFill = CreateModule.Instance("Frame", {
                Parent = SliderBar,
                Name = "SliderFill",
                BackgroundColor3 = Library.Theme.Accent,
                BorderSizePixel = 0,
                Position = UDim2.new(0, 0, 0, 0),
                Size = UDim2.new(0, 0, 1, 0),
                ZIndex = 3
            })

            CreateModule.Instance("UICorner", {
                Parent = SliderFill,
                Name = "Corner",
                CornerRadius = UDim.new(0, 2)
            })

            local SliderButton = CreateModule.Instance("TextButton", {
                Parent = SliderBar,
                Name = "SliderButton",
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BorderSizePixel = 0,
                Position = UDim2.new(0, 0, 0.5, -5),
                Size = UDim2.new(0, 10, 0, 10),
                AutoButtonColor = false,
                Text = "",
                ZIndex = 4
            })

            CreateModule.Instance("UICorner", {
                Parent = SliderButton,
                Name = "Corner",
                CornerRadius = UDim.new(1, 0)
            })

            local CurrentValue = config.Default or 0
            local MinValue = config.Min or 0
            local MaxValue = config.Max or 100

            local function UpdateSlider()
                local percentage = (CurrentValue - MinValue) / (MaxValue - MinValue)
                percentage = math.clamp(percentage, 0, 1)
                SliderFill.Size = UDim2.new(percentage, 0, 1, 0)
                SliderButton.Position = UDim2.new(percentage, -5, 0.5, -5)
                ValueLabel.Text = tostring(math.floor(CurrentValue))
                spawn(function() config.Callback(CurrentValue) end)
            end

            UpdateSlider()

            local isDraggingSlider = false

            SliderButton.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch then
                    isDraggingSlider = true
                end
            end)

            SliderButton.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch then
                    isDraggingSlider = false
                end
            end)

            SliderBar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch then
                    isDraggingSlider = true
                end
            end)

            SliderBar.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch then
                    isDraggingSlider = false
                end
            end)

            InputService.InputChanged:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch and isDraggingSlider then
                    local touchPos = input.Position
                    local sliderPos = SliderBar.AbsolutePosition
                    local sliderSize = SliderBar.AbsoluteSize
                    local relativePos = (touchPos.X - sliderPos.X) / sliderSize.X
                    relativePos = math.clamp(relativePos, 0, 1)
                    CurrentValue = MinValue + (relativePos * (MaxValue - MinValue))
                    UpdateSlider()
                end
            end)

            AddToReg(Slider)
            return Slider
        end

        return TabFunctions
    end

    return InMain
end

return Library
