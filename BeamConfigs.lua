return {
    ["8-Bit"] = {
        properties = {
            Name = "gb",
            Brightness = 1,
            TextureLength = 1,
            Width0 = 0.5,
            Width1 = 0.5,
            FaceCamera = true,
            LightInfluence = 0,
            LightEmission = 0.7,
            Segments = 10,
            Texture = "rbxassetid://277037193",
            TextureSpeed = 5,
            Transparency = NumberSequence.new(0, 0),
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 251, 255)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 242, 255))
            })
        },
        animate = function(p1)
            local v1 = TweenInfo.new(1)
            TweenService:Create(p1, v1, {Width1 = 0}):Play()
            v1 = TweenInfo.new(0.8)
            TweenService:Create(p1, v1, {Width0 = 0}):Play()
        end,
        debris = 1
    },

    ["Cosmic"] = {
        properties = {
            Name = "gb",
            Brightness = 1.5,
            TextureLength = 1.5,
            Width0 = 0.03,
            Width1 = 0.03,
            FaceCamera = true,
            LightInfluence = 0,
            LightEmission = 0.6,
            Segments = 16,
            TextureSpeed = 1,
            Texture = "rbxassetid://11894951813",
            Transparency = NumberSequence.new(0.4, 0.1),
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(75, 0, 130)),
                ColorSequenceKeypoint.new(0.25, Color3.fromRGB(138, 43, 226)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 0, 255)),
                ColorSequenceKeypoint.new(0.75, Color3.fromRGB(0, 191, 255)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(75, 0, 130))
            })
        },
        animate = function(p1)
            local v1 = TweenInfo.new(0.3, Enum.EasingStyle.Sine)
            TweenService:Create(p1, v1, {Width0 = 0.08, Width1 = 0.05}):Play()
            task.spawn(function()
                while p1.Parent do
                    local t1 = TweenInfo.new(1.5, Enum.EasingStyle.Sine)
                    TweenService:Create(p1, t1, {TextureSpeed = 2}):Play()
                    task.wait(1.5)
                    if not p1.Parent then
                        break
                    end
                    local t2 = TweenInfo.new(1.5, Enum.EasingStyle.Sine)
                    TweenService:Create(p1, t2, {TextureSpeed = 0.5}):Play()
                    task.wait(1.5)
                end
            end)
            task.delay(1.5, function()
                if p1 and p1.Parent then
                    local t3 = TweenInfo.new(0.5, Enum.EasingStyle.Sine)
                    TweenService:Create(p1, t3, {Width0 = 0, Width1 = 0}):Play()
                end
            end)
        end,
        debris = 1.5
    },

    ["Electric"] = {
        properties = {
            Name = "gb",
            Brightness = 5,
            TextureLength = 0.5,
            Width0 = 0.2,
            Width1 = 0.2,
            FaceCamera = true,
            LightInfluence = 0,
            LightEmission = 0.8,
            Segments = 12,
            TextureSpeed = 6,
            Texture = "rbxassetid://150182107",
            Transparency = NumberSequence.new(0.1, 0.1),
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
                ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 127, 0)),
                ColorSequenceKeypoint.new(0.33, Color3.fromRGB(255, 255, 0)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 0)),
                ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 0, 255)),
                ColorSequenceKeypoint.new(0.83, Color3.fromRGB(75, 0, 130)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 255))
            })
        },
        animate = function(p1)
            local v1 = TweenInfo.new(0.3)
            TweenService:Create(p1, v1, {Width0 = 0.5, Width1 = 0.5}):Play()
            task.spawn(function()
                while p1.Parent do
                    local t1 = TweenInfo.new(0.8, Enum.EasingStyle.Sine)
                    TweenService:Create(p1, t1, {TextureSpeed = 10}):Play()
                    task.wait(0.8)
                    if not p1.Parent then
                        break
                    end
                    local t2 = TweenInfo.new(0.8, Enum.EasingStyle.Sine)
                    TweenService:Create(p1, t2, {TextureSpeed = 2}):Play()
                    task.wait(0.8)
                end
            end)
            task.delay(2.5, function()
                if p1 and p1.Parent then
                    local t3 = TweenInfo.new(1)
                    TweenService:Create(p1, t3, {Width0 = 0, Width1 = 0}):Play()
                end
            end)
        end,
        debris = 2
    },


    ["FireWings"] = {
        properties = {
            Name = "gb",
            Brightness = 6,
            TextureLength = 0.4,
            Width0 = 0.2,
            Width1 = 0.4,
            FaceCamera = true,
            LightInfluence = 0,
            LightEmission = 0.9,
            Segments = 10,
            TextureSpeed = 12,
            Texture = "rbxassetid://241594419",
            Transparency = NumberSequence.new(1, 1),
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 69, 0)),
                ColorSequenceKeypoint.new(0.3, Color3.fromRGB(255, 140, 0)),
                ColorSequenceKeypoint.new(0.7, Color3.fromRGB(255, 215, 0)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 0))
            })
        },
        animate = function(p1)
            task.spawn(function()
                for i = 1, 8, 1 do
                    if not p1.Parent then
                        break
                    end
                    local v1 = 0.15 + math.random() * 0.3
                    local v2 = TweenInfo.new(0.1)
                    TweenService:Create(p1, v2, {Width0 = v1, Width1 = v1 * 1.5}):Play()
                    task.wait(0.1)
                end
            end)
            task.delay(0.8, function()
                if p1 and p1.Parent then
                    local v1 = TweenInfo.new(0.6)
                    TweenService:Create(p1, v1, {Width0 = 0, Width1 = 0}):Play()
                end
            end)
        end,
        debris = 1
    },

    ["Flash"] = {
        properties = {
            Name = "gb",
            Brightness = 6,
            TextureLength = 0.7,
            Width0 = 1,
            Width1 = 1,
            FaceCamera = true,
            LightInfluence = 0,
            LightEmission = 1,
            Segments = 14,
            TextureSpeed = 6,
            Texture = "rbxassetid://241594419",
            Transparency = NumberSequence.new(0.1, 0.6),
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 120, 0)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 200, 50)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
            })
        },
        animate = function(p1)
            local v1 = TweenInfo.new(0.1)
            TweenService:Create(p1, v1, {Width0 = 0.22, Width1 = 0.16}):Play()
            task.spawn(function()
                for i = 1, 5, 1 do
                    if not p1.Parent then
                        break
                    end
                    local t1 = TweenInfo.new(0.08)
                    TweenService:Create(p1, t1, {
                        Width0 = 0.18 + math.random() * 0.05,
                        Width1 = 0.12 + math.random() * 0.05
                    }):Play()
                    task.wait(0.08)
                end
            end)
            task.delay(0.5, function()
                if p1 and p1.Parent then
                    p1.Transparency = NumberSequence.new(0.8, 1)
                    local t2 = TweenInfo.new(0.3)
                    TweenService:Create(p1, t2, {Width0 = 0, Width1 = 0}):Play()
                end
            end)
        end,
        debris = 0.8
    },

    ["Frost"] = {
        properties = {
            Name = "gb",
            Brightness = 50,
            TextureLength = 1,
            Width0 = 0.7,
            Width1 = 0.7,
            FaceCamera = true,
            LightInfluence = 0,
            LightEmission = 0.7,
            Segments = 10,
            Texture = "rbxassetid://11624551967",
            TextureSpeed = 1,
            Transparency = NumberSequence.new(1, 0),
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(173, 216, 230)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(135, 206, 235))
            })
        },
        animate = function(p1)
            local v1 = TweenInfo.new(1)
            TweenService:Create(p1, v1, {Width1 = 0.09}):Play()
            v1 = TweenInfo.new(0.8)
            TweenService:Create(p1, v1, {Width0 = 0.09}):Play()
            task.delay(0.1, function()
                if not p1.Parent then
                    return
                end
                local t1 = TweenInfo.new(1.2)
                TweenService:Create(p1, t1, {Width1 = 0}):Play()
                local t2 = TweenInfo.new(1.15)
                TweenService:Create(p1, t2, {Width0 = 0}):Play()
            end)
        end,
        debris = 2
    },

    ["Ice"] = {
        properties = {
            Name = "gb",
            Brightness = 2,
            TextureLength = 0.6,
            Width0 = 0.2,
            Width1 = 0.2,
            FaceCamera = true,
            LightInfluence = 0,
            LightEmission = 0.5,
            Segments = 8,
            TextureSpeed = 2,
            Texture = "rbxassetid://11894951813",
            Transparency = NumberSequence.new(0.3, 0.1),
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(173, 216, 230)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(135, 206, 235))
            })
        },
        animate = function(p1)
            local v1 = TweenInfo.new(0.4)
            TweenService:Create(p1, v1, {Width0 = 0.5, Width1 = 0.25}):Play()
            task.delay(0.4, function()
                if not p1.Parent then
                    return
                end
                local t1 = TweenInfo.new(0.6)
                TweenService:Create(p1, t1, {Width0 = 0.1, Width1 = 0.05}):Play()
            end)
            task.delay(1.2, function()
                if not p1.Parent then
                    return
                end
                local t2 = TweenInfo.new(0.8)
                TweenService:Create(p1, t2, {Width0 = 0, Width1 = 0}):Play()
            end)
        end,
        debris = 1.5
    },

    ["Invisible"] = {
        properties = {
            Name = "gb",
            Brightness = 0,
            TextureLength = 1,
            Width0 = 0,
            Width1 = 0,
            FaceCamera = true,
            LightInfluence = 0,
            LightEmission = 0,
            Segments = 1,
            Texture = "",
            Transparency = NumberSequence.new(1, 1),
            Color = ColorSequence.new(Color3.new(1, 1, 1))
        },
        animate = function(p1)
        end,
        debris = 0.1
    },

    ["Laser"] = {
        properties = {
            Name = "gb",
            Brightness = 8,
            TextureLength = 1.2,
            Width0 = 0.16,
            Width1 = 0.16,
            FaceCamera = true,
            LightInfluence = 0,
            LightEmission = 0.9,
            Segments = 15,
            TextureSpeed = 3,
            Texture = "rbxassetid://150182107",
            Transparency = NumberSequence.new(0.05, 0.2),
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
                ColorSequenceKeypoint.new(0.2, Color3.fromRGB(255, 255, 0)),
                ColorSequenceKeypoint.new(0.4, Color3.fromRGB(0, 255, 0)),
                ColorSequenceKeypoint.new(0.6, Color3.fromRGB(0, 255, 255)),
                ColorSequenceKeypoint.new(0.8, Color3.fromRGB(0, 0, 255)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 255))
            })
        },
        animate = function(p1)
            local v1 = TweenInfo.new(0.2)
            TweenService:Create(p1, v1, {Width1 = 0.22, Width0 = 0.22}):Play()
            task.delay(0.2, function()
                if not p1.Parent then
                    return
                end
                local t1 = TweenInfo.new(0.8)
                TweenService:Create(p1, t1, {Width1 = 0.06, Width0 = 0.06}):Play()
            end)
        end,
        debris = 1
    },

    ["Light"] = {
        properties = {
            Name = "gb",
            Brightness = 100,
            TextureLength = 0.5,
            Width0 = 1.5,
            Width1 = 1.5,
            FaceCamera = true,
            LightInfluence = 0,
            LightEmission = 0.95,
            Segments = 10,
            Texture = "rbxassetid://6528210403",
            Transparency = NumberSequence.new(0),
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(138, 43, 226)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 0, 255)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(138, 43, 226))
            })
        },
        animate = function(p1)
            local v1 = TweenInfo.new(0.3)
            TweenService:Create(p1, v1, {Width0 = 0.4, Width1 = 0.4}):Play()
            task.spawn(function()
                while p1.Parent do
                    local t1 = TweenInfo.new(0.4, Enum.EasingStyle.Sine)
                    TweenService:Create(p1, t1, {LightEmission = 1}):Play()
                    task.wait(0.4)
                    if not p1.Parent then
                        break
                    end
                    local t2 = TweenInfo.new(0.4, Enum.EasingStyle.Sine)
                    TweenService:Create(p1, t2, {LightEmission = 0.6}):Play()
                    task.wait(0.4)
                end
            end)
            task.delay(1.5, function()
                if p1 and p1.Parent then
                    local t3 = TweenInfo.new(0.8)
                    TweenService:Create(p1, t3, {Width0 = 0, Width1 = 0}):Play()
                end
            end)
        end,
        debris = 2
    },

    ["Lightning"] = {
        properties = {
            Name = "gb",
            Brightness = 50,
            TextureLength = 0.5,
            Width0 = 3,
            Width1 = 3,
            FaceCamera = true,
            LightInfluence = 0,
            LightEmission = 0.7,
            Segments = 10,
            Texture = "rbxassetid://7151842823",
            TextureSpeed = 25,
            Transparency = NumberSequence.new(1, 0),
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 251, 255)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 242, 255))
            })
        },
        animate = function(p1)
            local v1 = TweenInfo.new(1)
            TweenService:Create(p1, v1, {Width1 = 0}):Play()
            v1 = TweenInfo.new(0.8)
            TweenService:Create(p1, v1, {Width0 = 0}):Play()
        end,
        debris = 2
    },

    ["Linger"] = {
        properties = {
            Name = "gb",
            Brightness = 2.5,
            TextureLength = 0.5,
            Width0 = 0.95,
            Width1 = 0.95,
            FaceCamera = true,
            LightInfluence = 0,
            LightEmission = 0.95,
            Segments = 10,
            Transparency = NumberSequence.new(0.1, 0),
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 156, 56)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 94, 0))
            })
        },
        animate = function(p1)
            local v1 = TweenInfo.new(0.075)
            TweenService:Create(p1, v1, {Width1 = 0.09}):Play()
            v1 = TweenInfo.new(0.075)
            TweenService:Create(p1, v1, {Width0 = 0.09}):Play()
            task.delay(0.1, function()
                if not p1.Parent then
                    return
                end
                p1.Transparency = NumberSequence.new(0.2, 0.2)
                local t1 = TweenInfo.new(1.2)
                TweenService:Create(p1, t1, {Width1 = 0}):Play()
                local t2 = TweenInfo.new(1.15)
                TweenService:Create(p1, t2, {Width0 = 0}):Play()
            end)
        end,
        debris = 1.2
    },

    ["ProjectileTest"] = {
        properties = {
            Name = "gb",
            Brightness = 3,
            TextureLength = 0.45,
            Width0 = 0.13,
            Width1 = 0.18,
            FaceCamera = true,
            LightInfluence = 0,
            LightEmission = 1,
            Segments = 10,
            TextureSpeed = 2.6,
            Texture = "rbxassetid://11894951813",
            Transparency = NumberSequence.new(0.1, 0),
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 156, 56)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 94, 0))
            })
        },
        animate = function(Beam)
            TweenService:Create(Beam, TweenInfo.new(0.5), {Width1 = 0}):Play()
            TweenService:Create(Beam, TweenInfo.new(0.15), {Width0 = 0}):Play()
            TweenService:Create(Beam, TweenInfo.new(0.25), {TextureSpeed = 0.75}):Play()
        end,
        debris = 0.6
    },

    ["Roses"] = {
        properties = {
            Name = "gb",
            Brightness = 50,
            TextureLength = 0.5,
            Width0 = 0.1,
            Width1 = 0.1,
            FaceCamera = true,
            LightInfluence = 0,
            LightEmission = 0,
            Segments = 10,
            Texture = "rbxassetid://11894951813",
            Transparency = NumberSequence.new(0, 0),
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
                ColorSequenceKeypoint.new(0.1, Color3.fromRGB(10, 10, 10)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(20, 20, 20)),
                ColorSequenceKeypoint.new(0.9, Color3.fromRGB(10, 10, 10)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
            })
        },
        animate = function(Beam)
            TweenService:Create(Beam, TweenInfo.new(0.075), {Width1 = 0.3}):Play()
            TweenService:Create(Beam, TweenInfo.new(0.075), {Width0 = 0.3}):Play()
            task.delay(0.1, function()
                if not Beam.Parent then
                    return
                end
                TweenService:Create(Beam, TweenInfo.new(6), {Width1 = 0}):Play()
                TweenService:Create(Beam, TweenInfo.new(6), {Width0 = 0}):Play()
                for Index = 1, 50 do
                    if not Beam.Parent then
                        break
                    end
                    Beam.Transparency = NumberSequence.new(Index / 50)
                    task.wait(0.12)
                end
            end)
        end,
        debris = 2
    },

    ["SuperGlow1"] = {
        properties = {
            Name = "gb",
            Brightness = 5,
            TextureLength = 0.5,
            Width0 = 0.95,
            Width1 = 0.95,
            FaceCamera = true,
            LightInfluence = 0,
            LightEmission = 0.95,
            Segments = 6,
            Transparency = NumberSequence.new(0.1, 0),
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 156, 56)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 94, 0))
            })
        },
        animate = function(Beam)
            TweenService:Create(Beam, TweenInfo.new(0.075), {Width1 = 0.2}):Play()
            TweenService:Create(Beam, TweenInfo.new(0.075), {Width0 = 0.2}):Play()
            task.delay(0.1, function()
                if not Beam.Parent then
                    return
                end
                TweenService:Create(Beam, TweenInfo.new(3), {Width1 = 0}):Play()
                TweenService:Create(Beam, TweenInfo.new(3), {Width0 = 0}):Play()
            end)
        end,
        debris = 2
    },

    ["SuperGlow2"] = {
        properties = {
            Name = "gb",
            Brightness = 5,
            TextureLength = 0.5,
            Width0 = 0.95,
            Width1 = 0.95,
            FaceCamera = true,
            LightInfluence = 0,
            LightEmission = 0.95,
            Segments = 6,
            Transparency = NumberSequence.new(0.1, 0),
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 156, 56)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 94, 0))
            })
        },
        animate = function(Beam)
            TweenService:Create(Beam, TweenInfo.new(0.075), {Width1 = 0.2}):Play()
            TweenService:Create(Beam, TweenInfo.new(0.075), {Width0 = 0.2}):Play()
            task.delay(0.1, function()
                if not Beam.Parent then
                    return
                end
                TweenService:Create(Beam, TweenInfo.new(3), {Width1 = 0}):Play()
                TweenService:Create(Beam, TweenInfo.new(3), {Width0 = 0}):Play()
            end)
        end,
        debris = 2
    },

    ["SuperGlow3"] = {
        properties = {
            Name = "gb",
            Brightness = 0,
            TextureLength = 0.5,
            Width0 = 0.95,
            Width1 = 0.95,
            FaceCamera = true,
            LightInfluence = 0,
            LightEmission = 0,
            Segments = 6,
            Transparency = NumberSequence.new(0),
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
                ColorSequenceKeypoint.new(0.1, Color3.fromRGB(10, 10, 10)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(20, 20, 20)),
                ColorSequenceKeypoint.new(0.9, Color3.fromRGB(10, 10, 10)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
            })
        },
        animate = function(Beam)
            TweenService:Create(Beam, TweenInfo.new(0.075), {Width1 = 0.2}):Play()
            TweenService:Create(Beam, TweenInfo.new(0.075), {Width0 = 0.2}):Play()
            task.delay(0.1, function()
                if not Beam.Parent then
                    return
                end
                TweenService:Create(Beam, TweenInfo.new(3), {Width1 = 0}):Play()
                TweenService:Create(Beam, TweenInfo.new(3), {Width0 = 0}):Play()
            end)
        end,
        debris = 2
    },

    ["SuperGlow4"] = {
        properties = {
            Name = "gb",
            Brightness = 15,
            TextureLength = 0.5,
            Width0 = 0.95,
            Width1 = 0.95,
            FaceCamera = true,
            LightInfluence = 0,
            LightEmission = 0,
            Segments = 6,
            Texture = "rbxassetid://11894951813",
            Transparency = NumberSequence.new(0, 0),
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
                ColorSequenceKeypoint.new(0.1, Color3.fromRGB(10, 10, 10)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(20, 20, 20)),
                ColorSequenceKeypoint.new(0.9, Color3.fromRGB(10, 10, 10)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
            })
        },
        animate = function(Beam)
            TweenService:Create(Beam, TweenInfo.new(0.075), {Width0 = 0.3, Width1 = 0.3}):Play()
            task.delay(0.1, function()
                if not Beam.Parent then
                    return
                end
                TweenService:Create(Beam, TweenInfo.new(2), {Width0 = 0, Width1 = 0}):Play()
                local StartTime = os.clock()
                while Beam.Parent and os.clock() - StartTime < 2 do
                    Beam.Transparency = NumberSequence.new((os.clock() - StartTime) / 2)
                    task.wait()
                end
                if Beam.Parent then
                    Beam.Transparency = NumberSequence.new(1)
                end
            end)
        end,
        debris = 2
    },

    ["SuperGlow5"] = {
        properties = {
            Name = "gb",
            Brightness = 50,
            TextureLength = 0.5,
            Width0 = 0.95,
            Width1 = 0.95,
            FaceCamera = true,
            LightInfluence = 0,
            LightEmission = 0,
            Segments = 10,
            Texture = "rbxassetid://11894951813",
            Transparency = NumberSequence.new(0, 0),
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
                ColorSequenceKeypoint.new(0.1, Color3.fromRGB(10, 10, 10)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(20, 20, 20)),
                ColorSequenceKeypoint.new(0.9, Color3.fromRGB(10, 10, 10)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
            })
        },
        animate = function(Beam)
            TweenService:Create(Beam, TweenInfo.new(0.075), {Width1 = 0.3}):Play()
            TweenService:Create(Beam, TweenInfo.new(0.075), {Width0 = 0.3}):Play()
            task.delay(0.1, function()
                if not Beam.Parent then
                    return
                end
                TweenService:Create(Beam, TweenInfo.new(3), {Width1 = 0}):Play()
                TweenService:Create(Beam, TweenInfo.new(3), {Width0 = 0}):Play()
                for Index = 1, 25 do
                    if not Beam.Parent then
                        break
                    end
                    Beam.Transparency = NumberSequence.new(Index / 25)
                    task.wait(0.12)
                end
            end)
        end,
        debris = 3
    },

    ["SuperSuperGlow5"] = {
        properties = {
            Name = "gb",
            Brightness = 50,
            TextureLength = 0.5,
            Width0 = 0.6,
            Width1 = 0.6,
            FaceCamera = true,
            LightInfluence = 0,
            LightEmission = 0,
            Segments = 10,
            Texture = "rbxassetid://11894951813",
            Transparency = NumberSequence.new(0, 0),
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
                ColorSequenceKeypoint.new(0.1, Color3.fromRGB(10, 10, 10)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(20, 20, 20)),
                ColorSequenceKeypoint.new(0.9, Color3.fromRGB(10, 10, 10)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
            })
        },
        animate = function(Beam)
            TweenService:Create(Beam, TweenInfo.new(0.075), {Width0 = 0.3, Width1 = 0.3}):Play()
            task.delay(0.1, function()
                if not Beam.Parent then
                    return
                end
                TweenService:Create(Beam, TweenInfo.new(1.5), {Width0 = 0, Width1 = 0}):Play()
                task.spawn(function()
                    for Index = 1, 20 do
                        if not Beam.Parent then
                            break
                        end
                        Beam.Transparency = NumberSequence.new(Index / 20)
                        task.wait(0.075)
                    end
                end)
            end)
        end,
        debris = 1.5
    },


    ["Test"] = {
        properties = {
            Name = "gb",
            Brightness = 50,
            TextureLength = 0.5,
            Width0 = 0.95,
            Width1 = 0.95,
            FaceCamera = true,
            LightInfluence = 0,
            LightEmission = 0,
            Segments = 10,
            Texture = "rbxassetid://11894951813",
            Transparency = NumberSequence.new(0, 0),
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
                ColorSequenceKeypoint.new(0.1, Color3.fromRGB(10, 10, 10)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(20, 20, 20)),
                ColorSequenceKeypoint.new(0.9, Color3.fromRGB(10, 10, 10)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
            })
        },
        animate = function(Beam)
            TweenService:Create(Beam, TweenInfo.new(0.075), {Width1 = 0.3}):Play()
            TweenService:Create(Beam, TweenInfo.new(0.075), {Width0 = 0.3}):Play()
            task.delay(0.1, function()
                if not Beam.Parent then
                    return
                end
                TweenService:Create(Beam, TweenInfo.new(3), {Width1 = 0}):Play()
                TweenService:Create(Beam, TweenInfo.new(3), {Width0 = 0}):Play()
                for Index = 1, 25 do
                    if not Beam.Parent then
                        break
                    end
                    Beam.Transparency = NumberSequence.new(Index / 25)
                    task.wait(0.12)
                end
            end)
        end,
        debris = 3
    },

    ["Toxic"] = {
        properties = {
            Name = "gb",
            Brightness = 4,
            TextureLength = 0.7,
            Width0 = 0.1,
            Width1 = 0.1,
            FaceCamera = true,
            LightInfluence = 0,
            LightEmission = 0.7,
            Segments = 11,
            TextureSpeed = 4,
            Texture = "rbxassetid://8343011237",
            Transparency = NumberSequence.new(0.2, 0.3),
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 255, 0)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(173, 255, 47)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(127, 255, 0))
            })
        },
        animate = function(Beam)
            TweenService:Create(Beam, TweenInfo.new(0.3), {Width0 = 0.5, Width1 = 0.5}):Play()
            task.spawn(function()
                while Beam.Parent do
                    TweenService:Create(Beam, TweenInfo.new(0.5, Enum.EasingStyle.Elastic), {
                        Width0 = 0.2,
                        Width1 = 0.6
                    }):Play()
                    task.wait(0.5)
                    if not Beam.Parent then
                        break
                    end
                    TweenService:Create(Beam, TweenInfo.new(0.5, Enum.EasingStyle.Elastic), {
                        Width0 = 0.6,
                        Width1 = 0.2
                    }):Play()
                    task.wait(0.5)
                end
            end)
            task.delay(2, function()
                if Beam.Parent then
                    TweenService:Create(Beam, TweenInfo.new(0.7), {
                        Width0 = 0,
                        Width1 = 0
                    }):Play()
                end
            end)
        end,
        debris = 2.5
    },

    ["UpDown"] = {
        properties = {
            Name = "gb",
            Brightness = 5,
            TextureLength = 0.5,
            Width0 = 0,
            Width1 = 0,
            FaceCamera = true,
            LightInfluence = 0,
            LightEmission = 0.95,
            Segments = 10,
            Transparency = NumberSequence.new(0.1, 0),
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 156, 56)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 94, 0))
            })
        },
        animate = function(Beam)
            TweenService:Create(Beam, TweenInfo.new(0.075), {Width1 = 0.1}):Play()
            TweenService:Create(Beam, TweenInfo.new(0.075), {Width0 = 0.1}):Play()
            task.delay(0.075, function()
                if not Beam.Parent then
                    return
                end
                TweenService:Create(Beam, TweenInfo.new(0.25), {Width1 = 0}):Play()
                TweenService:Create(Beam, TweenInfo.new(0.2), {Width0 = 0}):Play()
            end)
        end,
        debris = 0.5
    },

    ["Wiggle"] = {
        properties = {
            Name = "gb",
            Brightness = 1.5,
            TextureLength = 0.5,
            Width0 = 0.35,
            Width1 = 0.01,
            FaceCamera = true,
            LightInfluence = 0,
            LightEmission = 0.95,
            Segments = 10,
            Transparency = NumberSequence.new(0.1, 0),
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 156, 56)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 94, 0))
            })
        },
        animate = function(Beam)
            TweenService:Create(Beam, TweenInfo.new(0.2), {Width0 = 0.01}):Play()
            TweenService:Create(Beam, TweenInfo.new(0.15), {Width1 = 0.2}):Play()
            task.delay(0.2, function()
                if not Beam.Parent then
                    return
                end
                TweenService:Create(Beam, TweenInfo.new(0.5), {Width1 = 0}):Play()
                TweenService:Create(Beam, TweenInfo.new(0.5), {Width0 = 0}):Play()
            end)
        end,
        debris = 1.2
    },

    ["WindBurst"] = {
        properties = {
            Name = "gb",
            Brightness = 7,
            TextureLength = 0.6,
            Width0 = 0.15,
            Width1 = 0.15,
            FaceCamera = true,
            LightInfluence = 0,
            LightEmission = 0.95,
            Segments = 8,
            TextureSpeed = 3,
            Texture = "rbxassetid://8343011237",
            Transparency = NumberSequence.new(0.05, 0.15),
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 215, 0)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 0)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 165, 0))
            })
        },
        animate = function(Beam)
            TweenService:Create(Beam, TweenInfo.new(0.4), {Width0 = 0.3, Width1 = 0.3}):Play()
            task.delay(0.4, function()
                if not Beam.Parent then
                    return
                end
                TweenService:Create(Beam, TweenInfo.new(0.5, Enum.EasingStyle.Bounce), {
                    Width0 = 0.15,
                    Width1 = 0.15
                }):Play()
                task.delay(0.5, function()
                    if not Beam.Parent then
                        return
                    end
                    TweenService:Create(Beam, TweenInfo.new(0.5, Enum.EasingStyle.Bounce), {
                        Width0 = 0.15,
                        Width1 = 0.15
                    }):Play()
                end)
            end)
            task.delay(1.2, function()
                if not Beam.Parent then
                    return
                end
                Beam.Transparency = NumberSequence.new(1)
                TweenService:Create(Beam, TweenInfo.new(0.8), {
                    Width0 = 0,
                    Width1 = 0
                }):Play()
            end)
        end,
        debris = 2
    }
}
