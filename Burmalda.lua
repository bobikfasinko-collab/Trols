local ReplicatedStorage = game:GetService("ReplicatedStorage")

local event = Instance.new("RemoteEvent")
event.Name = "OGURCHIK_EVENT"
event.Parent = ReplicatedStorage

local function boom(pos, r)
	local e = Instance.new("Explosion")
	e.Position = pos
	e.BlastRadius = r
	e.BlastPressure = 500000
	e.Parent = workspace
end

event.OnServerEvent:Connect(function(plr, action)
	local char = plr.Character
	if not char then return end

	local root = char:FindFirstChild("HumanoidRootPart")
	local head = char:FindFirstChild("Head")
	if not root then return end

	-- 💣
	if action == "BOMB" then
		boom(head.Position, 12)

	-- 🍉
	elseif action == "MELON" then
		boom(root.Position, 15)

	-- 💀 AP
	elseif action == "APOC" then
		task.spawn(function()
			for i = 1, 25 do
				boom(root.Position + Vector3.new(math.random(-25,25),0,math.random(-25,25)), 10)
				task.wait(0.25)
			end
		end)

	-- 🚀
	elseif action == "ROCKET" then
		local r = Instance.new("Part")
		r.Shape = Enum.PartType.Ball
		r.Size = Vector3.new(1,1,1)
		r.Position = root.Position + Vector3.new(0,10,0)
		r.Anchored = false
		r.Parent = workspace

		task.spawn(function()
			while r.Parent do
				r.Velocity = (root.Position - r.Position).Unit * 90
				task.wait(0.1)
			end
		end)

		task.wait(3)
		boom(r.Position, 10)
		r:Destroy()

	-- 🕳 VOID
	elseif action == "VOID" then
		local h = Instance.new("Part")
		h.Shape = Enum.PartType.Ball
		h.Size = Vector3.new(7,7,7)
		h.Material = Enum.Material.Neon
		h.Color = Color3.new(0,0,0)
		h.Anchored = true
		h.Position = root.Position + Vector3.new(0,3,0)
		h.Parent = workspace

		task.wait(3)
		boom(h.Position, 20)
		h:Destroy()

	-- 🧠 NPC OGURCHIKS
	elseif action == "NPC" then
		for i = 1, 5 do
			local npc = Instance.new("Part")
			npc.Shape = Enum.PartType.Ball
			npc.Size = Vector3.new(2,2,2)
			npc.Position = root.Position + Vector3.new(math.random(-10,10),5,math.random(-10,10))
			npc.Color = Color3.fromRGB(0,255,0)
			npc.Parent = workspace

			task.spawn(function()
				for t = 1, 30 do
					npc.Position = npc.Position + (root.Position - npc.Position).Unit * 0.5
					task.wait(0.1)
				end
				boom(npc.Position, 8)
				npc:Destroy()
			end)
		end
	end
end)
