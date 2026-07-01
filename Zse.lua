local p=game.Players.LocalPlayer
local g=Instance.new("ScreenGui",p.PlayerGui)
g.ResetOnSpawn=false
local uis=game:GetService("UserInputService")
local rs=game:GetService("RunService")
local ts=game:GetService("TweenService")

local b=Instance.new("TextButton",g)
b.Size=UDim2.new(0,40,0,40)
b.Position=UDim2.new(0,10,.5,-20)
b.Text="≡"
b.BackgroundColor3=Color3.new()
b.TextColor3=Color3.new(1,1,1)
b.BorderSizePixel=2
Instance.new("UICorner",b)

local f=Instance.new("Frame",g)
f.Size=UDim2.new(0,200,0,140)
f.Position=UDim2.new(0,60,.5,-70)
f.BackgroundColor3=Color3.new()
f.BorderSizePixel=2
Instance.new("UICorner",f)

local t=Instance.new("TextLabel",f)
t.Size=UDim2.new(1,0,0,30)
t.BackgroundTransparency=1
t.Text=p.Name.." привет!"
t.TextScaled=true
t.TextColor3=Color3.new(1,1,1)

local box=Instance.new("TextBox",f)
box.Position=UDim2.new(.5,-75,0,40)
box.Size=UDim2.new(0,150,0,30)
box.Text="16"
box.PlaceholderText="1-1000"
box.BackgroundColor3=Color3.fromRGB(30,30,30)
box.TextColor3=Color3.new(1,1,1)
Instance.new("UICorner",box)

local sw=Instance.new("TextButton",f)
sw.Position=UDim2.new(.5,-75,0,80)
sw.Size=UDim2.new(0,150,0,30)
sw.Text="OFF"
sw.BackgroundColor3=Color3.fromRGB(30,30,30)
sw.TextColor3=Color3.new(1,1,1)
Instance.new("UICorner",sw)

local on=false
sw.MouseButton1Click:Connect(function()
	on=not on
	sw.Text=on and "ON" or "OFF"
end)

rs.RenderStepped:Connect(function()
	local c=Color3.fromHSV((tick()*0.2)%1,1,1)
	f.BorderColor3=c
	b.BorderColor3=c
	if on and p.Character and p.Character:FindFirstChild("Humanoid") then
		p.Character.Humanoid.WalkSpeed=math.clamp(tonumber(box.Text) or 16,1,1000)
	end
end)

local open=true
b.MouseButton1Click:Connect(function()
	open=not open
	ts:Create(f,TweenInfo.new(.2),{Position=open and UDim2.new(0,60,.5,-70) or UDim2.new(-1,0,.5,-70)}):Play()
end)

local drag,pos,start
b.InputBegan:Connect(function(i)
	if i.UserInputType.Name=="MouseButton1" or i.UserInputType.Name=="Touch" then
		drag=true
		start=i.Position
		pos=b.Position
		i.Changed:Connect(function()
			if i.UserInputState==Enum.UserInputState.End then
				drag=false
			end
		end)
	end
end)

uis.InputChanged:Connect(function(i)
	if drag and (i.UserInputType.Name=="MouseMovement" or i.UserInputType.Name=="Touch") then
		local d=i.Position-start
		b.Position=UDim2.new(pos.X.Scale,pos.X.Offset+d.X,pos.Y.Scale,pos.Y.Offset+d.Y)
	end
end)
