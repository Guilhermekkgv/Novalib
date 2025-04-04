local TweenService = game:GetService("TweenService")
local InputService = game:GetService("UserInputService")

local Library = {
    Version = "1.1.0",
    Theme = {
        Font = "Gotham",
        Accent = Color3.fromRGB(90, 60, 150),
        AcrylicMain = Color3.fromRGB(20, 0, 40),
        AcrylicBorder = Color3.fromRGB(90, 60, 150),
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
        TabSelected = Color3.fromRGB(90, 60, 150),
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
        Color = Library.Theme.AcrylicBorder,
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
        return math.max(60, TextSize.X + 10)
    end

    local function CreateTab(TabName)
        local TabWidth = CalculateTabWidth(TabName)

        local TabButton = CreateModule.Instance("TextButton", {
            Parent = TabFrame,
            Name = TabName,
            BackgroundColor3 = Library.Theme.TabUnselected,
            BorderSizePixel = 0,
            Size = UDim2.new(0, TabWidth, 0, 25),
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

        local TabContainer = CreateModule.Instance("Frame", {
            Parent = ContainerFrame,
            Name = TabName .. "Container",
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Position = UDim2.new(0, 5, 0, 5),
            Size = UDim2.new(1, -10, 1, -10),
            Visible = false,
            ZIndex = 3
        })

        local MainContainer = CreateModule.Instance("ScrollingFrame", {
            Parent = TabContainer,
            Name = "MainContainer",
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Position = UDim2.new(0, 0, 0, 20),
            Size = UDim2.new(0.5, -5, 1, -20),
            CanvasSize = UDim2.new(0, 0, 0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            ScrollBarThickness = 4,
            ScrollBarImageColor3 = Library.Theme.Accent,
            ScrollingEnabled = true,
            ZIndex = 3
        })

        local MainStroke = CreateModule.Instance("UIStroke", {
            Parent = MainContainer,
            Name = "Stroke",
            Thickness = 1,
            Color = Library.Theme.AcrylicBorder,
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        })

        local MainSection = CreateModule.Instance("TextLabel", {
            Parent = TabContainer,
            Name = "MainSection",
            BackgroundColor3 = Library.Theme.AcrylicMain,
            BorderSizePixel = 0,
            Position = UDim2.new(0, 5, 0, 5),
            Size = UDim2.new(0, 100, 0, 14),
            Font = Enum.Font[Library.Theme.Font],
            Text = "Main",
            TextColor3 = Library.Theme.FontColor,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Center,
            ZIndex = 4
        })

        local MainElementList = CreateModule.Instance("UIListLayout", {
            Parent = MainContainer,
            Padding = UDim.new(0, 5),
            HorizontalAlignment = Enum.HorizontalAlignment.Left,
            SortOrder = Enum.SortOrder.LayoutOrder
        })

        local BasicContainer = CreateModule.Instance("ScrollingFrame", {
            Parent = TabContainer,
            Name = "BasicContainer",
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Position = UDim2.new(0.5, 5, 0, 20),
            Size = UDim2.new(0.5, -5, 1, -20),
            CanvasSize = UDim2.new(0, 0, 0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            ScrollBarThickness = 4,
            ScrollBarImageColor3 = Library.Theme.Accent,
            ScrollingEnabled = true,
            ZIndex = 3
        })

        local BasicStroke = CreateModule.Instance("UIStroke", {
            Parent = BasicContainer,
            Name = "Stroke",
            Thickness = 1,
            Color = Library.Theme.AcrylicBorder,
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        })

        local BasicSection = CreateModule.Instance("TextLabel", {
            Parent = TabContainer,
            Name = "BasicSection",
            BackgroundColor3 = Library.Theme.AcrylicMain,
            BorderSizePixel = 0,
            Position = UDim2.new(0.5, 5, 0, 5),
            Size = UDim2.new(0, 100, 0, 14),
            Font = Enum.Font[Library.Theme.Font],
            Text = "Basic",
            TextColor3 = Library.Theme.FontColor,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Center,
            ZIndex = 4
        })

        local BasicElementList = CreateModule.Instance("UIListLayout", {
            Parent = BasicContainer,
            Padding = UDim.new(0, 5),
            HorizontalAlignment = Enum.HorizontalAlignment.Left,
            SortOrder = Enum.SortOrder.LayoutOrder
        })

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
            Container = TabContainer,
            MainContainer = MainContainer,
            BasicContainer = BasicContainer,
            MainSection = MainSection,
            BasicSection = BasicSection
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

        function TabFunctions.MainCheckbox(config)
            local Checkbox = CreateModule.Instance("TextButton", {
                Parent = Tabs[TabName].MainContainer,
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

        function TabFunctions.BasicCheckbox(config)
            local Checkbox = CreateModule.Instance("TextButton", {
                Parent = Tabs[TabName].BasicContainer,
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

        function TabFunctions.MainSlider(config)
            local Slider = CreateModule.Instance("Frame", {
                Parent = Tabs[TabName].MainContainer,
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
            local lastTouchPos = nil

            SliderButton.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch then
                    isDraggingSlider = true
                    lastTouchPos = input.Position.X
                end
            end)

            SliderButton.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch then
                    isDraggingSlider = false
                    lastTouchPos = nil
                end
            end)

            SliderBar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch then
                    isDraggingSlider = true
                    lastTouchPos = input.Position.X
                end
            end)

            SliderBar.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch then
                    isDraggingSlider = false
                    lastTouchPos = nil
                end
            end)

            InputService.InputChanged:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch and isDraggingSlider then
                    local touchPos = input.Position.X
                    local sliderPos = SliderBar.AbsolutePosition.X
                    local sliderSize = SliderBar.AbsoluteSize.X
                    local relativePos = (touchPos - sliderPos) / sliderSize
                    relativePos = math.clamp(relativePos, 0, 1)
                    CurrentValue = MinValue + (relativePos * (MaxValue - MinValue))
                    UpdateSlider()
                    lastTouchPos = touchPos
                end
            end)

            AddToReg(Slider)
            return Slider
        end

        function TabFunctions.BasicSlider(config)
            local Slider = CreateModule.Instance("Frame", {
                Parent = Tabs[TabName].BasicContainer,
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
            local lastTouchPos = nil

            SliderButton.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch then
                    isDraggingSlider = true
                    lastTouchPos = input.Position.X
                end
            end)

            SliderButton.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch then
                    isDraggingSlider = false
                    lastTouchPos = nil
                end
            end)

            SliderBar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch then
                    isDraggingSlider = true
                    lastTouchPos = input.Position.X
                end
            end)

            SliderBar.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch then
                    isDraggingSlider = false
                    lastTouchPos = nil
                end
            end)

            InputService.InputChanged:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch and isDraggingSlider then
                    local touchPos = input.Position.X
                    local sliderPos = SliderBar.AbsolutePosition.X
                    local sliderSize = SliderBar.AbsoluteSize.X
                    local relativePos = (touchPos - sliderPos) / sliderSize
                    relativePos = math.clamp(relativePos, 0, 1)
                    CurrentValue = MinValue + (relativePos * (MaxValue - MinValue))
                    UpdateSlider()
                    lastTouchPos = touchPos
                end
            end)

            AddToReg(Slider)
            return Slider
        end

        function TabFunctions.SetSection(config)
            if config.Type == "Main" then
                Tabs[TabName].MainSection.Text = config.Text
            elseif config.Type == "Basic" then
                Tabs[TabName].BasicSection.Text = config.Text
            end
        end

        return TabFunctions
    end

    return InMain
end

return Library
