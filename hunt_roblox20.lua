local SOURCE_URL = "https://raw.githubusercontent.com/LostMorality/RScripts/main/hunt_roblox20.lua"
local LOCAL_FILE = "hunt_roblox20.lua"

local CHANGELOG_UPDATED = "2026-09-18"

local CHANGELOG_ORDER = { 1, 2, 3, 4, 6, 7, 8, 9, 10 }

local CHANGELOG = {
	general = {
		"One loadstring runs everywhere: hub and every Hunt game load the right UI automatically.",
		"Re-runs itself after teleports between the hub and the island games.",
		"Every Hunt game without its own tools gets a basic UI with badge status and Return to hub.",
		"Changelog tab in every UI.",
		"Settings tab in every UI: save configs and pick one to autoload (Obsidian SaveManager).",
		"Tip: run tasks in a private (VIP) server - often free, especially for Roblox Premium members.",
	},
	hub = {
		title = "Hub",
		items = {
			"Quest farm for the 20 island NPCs with live status.",
			"Auto-claims each island's UGC once you have that island's badge, and skips UGC you already claimed.",
			"Claiming stands still at the pedestal and waits out server retries instead of re-teleporting.",
			"Finds pedestals that are not streamed in yet.",
			"Founders office teleport in the Places box on the Farm tab.",
			"Travel to any island and jump straight into its game.",
		},
	},
	[1] = {
		title = "Crossroads",
		items = { "Live KO tracker, badge status, player ESP (AFK players in yellow) and Return to hub." },
	},
	[2] = {
		title = "Sword Fights on the Heights IV",
		items = { "Sword ESP that hides swords you already collected, plus Return to hub." },
	},
	[3] = {
		title = "Rocket Arena",
		items = { "Live KO tracker, badge status, player ESP (AFK players in yellow) and Return to hub." },
	},
	[4] = {
		title = "Chaos Canyon",
		items = { "Live KO tracker, badge status, player ESP (AFK players in yellow) and Return to hub." },
	},
	[6] = {
		title = "Natural Disaster Survival",
		items = {
			"Auto rescue animals: grabs one free animal at a time and skips animals other players are holding.",
			"Waits in the lobby at the pen and drops the animal off once the round ends.",
			"Animal ESP: green = free, red = held by someone, blue = yours.",
			"Live rescued counter, badge status and Return to hub.",
		},
	},
	[7] = {
		title = "Base Wars",
		items = {
			"Live Skirmish quest progress, timer and team scores.",
			"Tip: you can just sit AFK while Skirmishes run - a loss still counts 50%.",
			"Silent aim with FOV circle: torso, or head when holding a sniper.",
			"Faster fire rate toggle with multiplier, no spread and no bullet drop.",
			"Enemy ESP: red when visible, white when behind cover.",
			"Automatic anti-cheat bypass.",
		},
	},
	[8] = {
		title = "Apocalypse Rising 2",
		items = {
			"Live tracker for all 3 quest steps, read straight from the game's Event tab.",
			"Day/night clock with a countdown to the next sunrise or sunset.",
			"Walked-distance counter for the 5,000 stud step.",
			"Smart quest ESP: highlights only the primary, backpack and melee you still need, and drops each type once it counts.",
			"Separate loot ESP with real item names: primaries, backpacks, melee, food & drink, ammo, everything else, and vehicles.",
			"Smart backpack ESP: only shows backpacks bigger than the one you're wearing, with slot counts.",
			"Smart ammo ESP: only shows ammo that fits your equipped primary or secondary, with the caliber.",
			"Empty magazines (0 rounds) are skipped by both ammo ESP and auto loot.",
			"Missing gear ESP: if your primary, secondary, backpack or melee slot is empty, all items for it show until you equip one.",
			"Lootable corpse ESP with the dead player's name.",
			"Auto loot: picks up nearby items that your ESP filters show, using the game's own pickup.",
			"Auto loot never grabs a weapon for a slot you already fill, and only takes bigger backpacks.",
			"Auto loot also opens nearby corpses and takes what your filters want.",
			"Ammo for my guns works on its own (on by default); All ammo is a separate toggle.",
			"Silent aim for zombies and players (headshots) with bullet drop and lead compensation.",
			"No spread and no recoil toggles.",
			"Zombie ESP and survivor ESP with display name and @username, plus Return to hub.",
		},
	},
	[9] = {
		title = "Murder Mystery 2",
		items = {
			"Live event quest coin counter (50 coins).",
			"Auto collect: teleports to the closest coin each time (risky), stops when you get killed.",
			"Badge status and Return to hub.",
		},
	},
	[10] = {
		title = "Lumber Tycoon 2",
		items = {
			"Teleport to the nearest free or owned log, and to Geck's WoodBox.",
			"Drag a log, teleport to the WoodBox while holding it, and drop it in.",
			"Log ESP (free and yours) and a WoodBox marker.",
			"Badge status and Return to hub.",
		},
	},
}

local function addChangelogSection(box, section)
	for i, line in section.items do
		box:AddLabel("- " .. line, true)
		if i < #section.items then
			box:AddDivider()
		end
	end
end

local SAVE_MANAGER_URL = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/addons/SaveManager.lua"

local function addChangelogTab(Window, key, Library)
	if Library then
		local ok, SaveManager = pcall(function()
			return loadstring(game:HttpGet(SAVE_MANAGER_URL))()
		end)
		if ok and type(SaveManager) == "table" then
			pcall(function()
				SaveManager:SetLibrary(Library)
				SaveManager:IgnoreThemeSettings()
				SaveManager:SetFolder("Hunt20/" .. tostring(key or "general"))
				local settingsTab = Window:AddTab("Settings")
				local tip = settingsTab:AddLeftGroupbox("Tip")
				tip:AddLabel(
					"For the smoothest and safest runs, use a private (VIP) server for these tasks and for the script in general - fewer players, nobody watching or reporting. Private servers are often free, especially for Roblox Premium members.",
					true
				)
				local info = settingsTab:AddLeftGroupbox("Configs")
				info:AddLabel(
					"Save your toggles and sliders as a config. Set one as autoload and it loads every time you open this game's UI.",
					true
				)
				SaveManager:BuildConfigSection(settingsTab)
				task.delay(2, function()
					pcall(function()
						SaveManager:LoadAutoloadConfig()
					end)
				end)
			end)
		end
	end
	local tab = Window:AddTab("Changelog")

	local hubBox = tab:AddGroupbox({ Side = 1, Name = "Hub", DisableCollapsing = true })
	addChangelogSection(hubBox, CHANGELOG.hub)

	local general = tab:AddGroupbox({ Side = 2, Name = "General", DisableCollapsing = true })
	general:AddLabel("Last updated " .. CHANGELOG_UPDATED, true)
	general:AddDivider()
	addChangelogSection(general, { items = CHANGELOG.general })

	local keys = {}
	if key == "hub" then
		for _, k in CHANGELOG_ORDER do
			if type(k) == "number" and CHANGELOG[k] then
				keys[#keys + 1] = k
			end
		end
	elseif type(key) == "number" then
		keys[1] = key
	end

	for i, k in keys do
		local s = CHANGELOG[k]
		local name = "Island " .. k .. " - " .. (s and s.title or "this game")
		local box = tab:AddGroupbox({ Side = (i % 2 == 1) and 1 or 2, Name = name, Collapsed = true })
		if s then
			addChangelogSection(box, s)
		else
			box:AddLabel("No game-specific tools yet - badge status and Return to hub only.", true)
		end
	end
end

local HUB_PLACE = 74205509034203
local HEIGHTS_PLACE = 47324
local NDS_PLACE = 189707
local BASEWARS_PLACE = 18164449
local AR2_PLACE = 863266079
local MM2_PLACE = 142823291
local LT2_PLACE = 13822889

local HUNT_ISLAND_PLACES = {
	[1818] = { 1, "Crossroads", 4036544995812202 },
	[47324] = { 2, "Sword Fights on the Heights IV", 2176983117961323 },
	[25415] = { 3, "Rocket Arena", 2032546335850202 },
	[14403] = { 4, "Chaos Canyon", 823979884544596 },
	[192800] = { 5, "Work at a Pizza Place", 31088659531866 },
	[189707] = { 6, "Natural Disaster Survival", 1950450904039809 },
	[18164449] = { 7, "Base Wars", 4449519854199008 },
	[863266079] = { 8, "Apocalypse Rising 2", 1985785484439323 },
	[142823291] = { 9, "Murder Mystery 2", 3774948711767093 },
	[13822889] = { 10, "Lumber Tycoon 2", 2747787858420374 },
	[9689581] = { 11, "Roblox High School", 2518870989628698 },
	[606849621] = { 12, "Jailbreak", 4306759006767505 },
	[537413528] = { 13, "Build a Boat", 4387926669504103 },
	[920587237] = { 14, "Adopt Me!", 3720272393025103 },
	[2727067538] = { 15, "World // Zero", 2124728509 },
	[4623386862] = { 16, "Piggy", 702906516594361 },
	[8481844229] = { 17, "Berry Avenue RP", 4082518353991699 },
	[13772394625] = { 18, "Blade Ball", 1873215711178593 },
	[15101393044] = { 19, "Dress to Impress", 2648924952692335 },
	[126884695634066] = { 20, "Grow a Garden", 4292816078974682 },
}

local function loadMSESP()
	local G = getgenv()
	if not G.MSESP then
		local ok, lib = pcall(function()
			getgenv().mstudio45_ESP = nil
			local src = game:HttpGet("https://raw.githubusercontent.com/mstudio45/MSESP/main/source.luau")
			src = src:gsub("CoreGuiAllowed = successCoreGui and CoreGui ~= nil;", "CoreGuiAllowed = false;")
			return loadstring(src)()
		end)
		if ok then
			G.MSESP = lib
		end
	end
	local ESP = G.MSESP
	if ESP then
		ESP.GlobalConfig.Boxes2D = false
		ESP.GlobalConfig.Boxes3D = false
		ESP.GlobalConfig.Skeleton = false
		ESP.GlobalConfig.Arrows = false
		ESP.GlobalConfig.Tracers = false
		ESP.GlobalConfig.Rainbow = false
		ESP.GlobalConfig.Highlighters = true
		ESP.GlobalConfig.Billboards = true
		ESP.GlobalConfig.Distance = true
	end
	return ESP
end

local function addReturnToHub(Library, box, conns)
	local TeleportService = game:GetService("TeleportService")
	local LocalPlayer = game:GetService("Players").LocalPlayer
	local returning = false
	conns[#conns + 1] = TeleportService.TeleportInitFailed:Connect(function(player, _, msg)
		if player ~= LocalPlayer then
			return
		end
		returning = false
		if tostring(msg):find("different creator") or tostring(msg):find("Unauthorized") then
			Library:Notify("This game blocks teleports to the hub. Leave and join The Hunt from Roblox.", 8)
		else
			Library:Notify("Hub teleport failed: " .. tostring(msg), 6)
		end
	end)
	box:AddButton({
		Text = "Return to hub",
		Func = function()
			if returning then
				return
			end
			returning = true
			local ok, err = pcall(function()
				TeleportService:Teleport(HUB_PLACE, LocalPlayer)
			end)
			if not ok then
				returning = false
				Library:Notify("Hub teleport failed: " .. tostring(err), 5)
			end
		end,
	})
end

local TARGETS_FILE = "hunt20_targets.json"
local TARGETS_URL = "https://raw.githubusercontent.com/LostMorality/RScripts/main/hunt20_targets.json"

local function addSniperTab(Window, Library)
	local HttpService = game:GetService("HttpService")
	local TeleportService = game:GetService("TeleportService")
	local LocalPlayer = game:GetService("Players").LocalPlayer
	local G = getgenv()

	local ACTIVITY_FILE = "hunt20_activity.json"
	local PRESENCE_URL = "https://presence.roblox.com/v1/presence/users"
	local PRESENCE_PROXY_URL = "https://presence.roproxy.com/v1/presence/users"
	local PRESENCE_FF_PROXY_URL = "https://presence.ff-roproxy.com/v1/presence/users"
	local BATCH = 50
	local HOT_SIZE = 200
	local HARD_BLOCK_PAUSE = 600
	local FOUND_TTL = 900
	local WEIGHT = { videostars = 3, developers = 3, admins = 1 }
	local LABEL = { admins = "Admin", developers = "Developer", videostars = "Video Star" }
	local TOGGLE = { admins = "SnipeAdmins", developers = "SnipeDevs", videostars = "SnipeStars" }

	local tab = Window:AddTab("Sniper")
	local setup = tab:AddLeftGroupbox("Launcher targets")
	local statusLabel = setup:AddLabel("Loading target list...", true)
	setup:AddToggle("SnipeAdmins", { Text = "Admins", Default = true })
	setup:AddToggle("SnipeDevs", { Text = "Developers", Default = true })
	setup:AddToggle("SnipeStars", { Text = "Video Stars", Default = true })
	setup:AddDivider()
	setup:AddLabel(
		"Only people whose joins are open can be found - that's Roblox privacy. Launchers only work in The Hunt itself, so only people in The Hunt count - being in their server when they launch gives you that wing.",
		true
	)

	local controls = tab:AddLeftGroupbox("Sniper")
	local engineLabel = controls:AddLabel("Stopped.", true)
	local hotLabel = controls:AddLabel("Watching: -", true)
	controls:AddToggle("SnipeRun", { Text = "Run sniper", Default = false })
	controls:AddToggle("SnipeAutoJoin", { Text = "Auto join", Default = true })
	controls:AddLabel(
		"Auto join keeps a live copy of every hub server's player count and joins the emptiest server when several people are found at once.",
		true
	)
	controls:AddLabel(
		"Watches up to 200 targets who are online right now, rechecking them every few seconds, and slowly sweeps everyone else to spot people coming online. Activity is remembered between sessions. Uses three routes (Roblox, roproxy and ff-roproxy), running side by side with their own limits (Roblox ~22 checks a minute, each proxy ~40), so if Roblox blocks one the others keep going. The watched list is rechecked first whenever a route comes back.",
		true
	)

	local hereBox = tab:AddRightGroupbox("In your server")
	local hereLabel = hereBox:AddLabel("No admins, developers or video stars here.", true)
	hereBox:AddToggle("SnipePauseHere", { Text = "Pause sniper while one is here", Default = true })
	hereBox:AddToggle("SnipeHighlightHere", { Text = "Highlight them", Default = true })
	hereBox:AddToggle("SnipeFollowIsland", { Text = "Follow them to new islands", Default = false })
	hereBox:AddDropdown("SnipeArrive", {
		Text = "After joining go to",
		Values = { "Their island", "Founders office", "Stay put" },
		Default = "Their island",
	})
	local hereState = { list = {} }
	local ARRIVE_FILE = "hunt20_arrive.json"
	local FOUNDERS_POS = Vector3.new(990, 12, 340)
	task.spawn(function()
		local raw
		pcall(function()
			if isfile(ARRIVE_FILE) then
				raw = readfile(ARRIVE_FILE)
				delfile(ARRIVE_FILE)
			end
		end)
		local ok, mark = pcall(function()
			return HttpService:JSONDecode(raw)
		end)
		if not ok or type(mark) ~= "table" or mark.job ~= game.JobId or os.time() - (mark.t or 0) > 300 then
			return
		end
		task.wait(3)
		local choice = Library.Options.SnipeArrive and Library.Options.SnipeArrive.Value or "Their island"
		if Library.Unloaded or choice == "Stay put" then
			return
		end
		local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
		char:WaitForChild("HumanoidRootPart", 10)
		local pos, where = FOUNDERS_POS, "the Founders office"
		if choice == "Their island" then
			local who
			for _ = 1, 20 do
				who = mark.uid and game:GetService("Players"):GetPlayerByUserId(mark.uid)
				if who and who.Team then
					break
				end
				task.wait(0.5)
			end
			local spawnPos = who and hereState.spawnFor and hereState.spawnFor(who)
			if spawnPos then
				pos, where = spawnPos + Vector3.new(0, 4, 0), who.Team.Name .. "'s spawn"
			end
		end
		pcall(function()
			LocalPlayer:RequestStreamAroundAsync(pos)
		end)
		char:PivotTo(CFrame.new(pos))
		Library:Notify("Joined " .. tostring(mark.name) .. " - moved you to " .. where .. ".", 6)
	end)

	local resultsBox = tab:AddRightGroupbox("Found in The Hunt")
	local foundLabel = resultsBox:AddLabel("Nothing yet.", true)
	local pick = resultsBox:AddDropdown("SnipePick", { Text = "Target", Values = {}, AllowNull = true })

	local function toggleOn(name)
		local t = Library.Toggles[name]
		return t ~= nil and t.Value == true
	end

	local targets = {}
	task.spawn(function()
		local raw
		if type(isfile) == "function" and isfile(TARGETS_FILE) then
			pcall(function()
				raw = readfile(TARGETS_FILE)
			end)
		end
		if not raw then
			pcall(function()
				raw = game:HttpGet(TARGETS_URL)
			end)
		end
		local ok, data = pcall(function()
			return HttpService:JSONDecode(raw)
		end)
		if not ok or type(data) ~= "table" then
			statusLabel:SetText("Could not load the target list.")
			return
		end
		local counts = { admins = 0, developers = 0, videostars = 0 }
		for cat in LABEL do
			for id, info in data[cat] or {} do
				local uid = tonumber(id)
				if uid then
					targets[uid] = targets[uid] or { name = info.name, cats = {} }
					targets[uid].cats[cat] = true
					counts[cat] += 1
				end
			end
		end
		statusLabel:SetText(
			string.format(
				"Loaded %d admins, %d developers, %d video stars.",
				counts.admins,
				counts.developers,
				counts.videostars
			)
		)
	end)

	local activity = {}
	pcall(function()
		if type(isfile) == "function" and isfile(ACTIVITY_FILE) then
			for k, v in HttpService:JSONDecode(readfile(ACTIVITY_FILE)) do
				activity[tonumber(k)] = v
			end
		end
	end)
	local activityDirty, lastSave = false, os.clock()
	local function saveActivity(force)
		if not activityDirty or (not force and os.clock() - lastSave < 15) then
			return
		end
		pcall(function()
			local out = {}
			for k, v in activity do
				out[tostring(k)] = v
			end
			writefile(ACTIVITY_FILE, HttpService:JSONEncode(out))
		end)
		activityDirty, lastSave = false, os.clock()
	end

	local function wanted(uid)
		local info = targets[uid]
		if not info then
			return false
		end
		for cat in info.cats do
			if toggleOn(TOGGLE[cat]) then
				return true
			end
		end
		return false
	end

	local function weight(uid)
		local w = 1
		for cat in targets[uid].cats do
			w = math.max(w, WEIGHT[cat] or 1)
		end
		return w
	end

	local function catText(uid)
		local parts = {}
		for cat in targets[uid].cats do
			parts[#parts + 1] = LABEL[cat]
		end
		table.sort(parts)
		return table.concat(parts, "/")
	end

	local BadgeService = game:GetService("BadgeService")
	local WINGS = {
		developers = { badge = 3356878288476533, name = "Obsidian Reignment of Creation" },
		admins = { badge = 1701637363750056, name = "Gossamer Reignment of Authority" },
		videostars = { badge = 1057612555382579, name = "Aureate Reignment of Renown" },
	}
	local owned = {}
	local wingBox = tab:AddRightGroupbox("Your launcher wings")
	local wingLabels = {}
	for _, cat in { "developers", "admins", "videostars" } do
		wingLabels[cat] = wingBox:AddLabel(LABEL[cat] .. ": checking...", true)
	end
	wingBox:AddDivider()
	wingBox:AddToggle("SnipeSkipOwned", { Text = "Skip wings I have", Default = true })
	wingBox:AddToggle("SnipeGrab", { Text = "Auto grab launched items", Default = true })
	wingBox:AddToggle("SnipeGrabTeleport", { Text = "Teleport as a last resort", Default = true })
	wingBox:AddLabel(
		"Launchers shoot items you claim by touching them. Auto grab first fakes the touch from where you stand, then pulls the item onto you if your game controls it. Only if both fail does it teleport to the item and put you back.",
		true
	)

	local function refreshWings()
		for cat, w in WINGS do
			local ok, has = pcall(function()
				return BadgeService:UserHasBadgeAsync(LocalPlayer.UserId, w.badge)
			end)
			if ok then
				owned[cat] = has
			end
			wingLabels[cat]:SetText(
				string.format("%s - %s: %s", LABEL[cat], w.name, owned[cat] and "OWNED" or "not yet")
			)
		end
	end
	task.spawn(function()
		while Library and not Library.Unloaded do
			refreshWings()
			task.wait(60)
		end
	end)

	local grabbed = setmetatable({}, { __mode = "k" })
	local LAUNCH_NAMES = {}
	pcall(function()
		for _, item in game:GetService("ReplicatedStorage").ClientAssets.LauncherItems:GetChildren() do
			LAUNCH_NAMES[item.Name] = true
		end
	end)
	local function launchRoot(inst)
		local node = inst
		while node and node ~= workspace do
			if LAUNCH_NAMES[node.Name] then
				return node
			end
			node = node.Parent
		end
		local tag = inst:GetAttribute("BadgeName")
		if type(tag) == "string" and tag:find("^Launcher") then
			return inst.Parent ~= workspace and inst.Parent or inst
		end
	end
	local function worn(inst)
		local node = inst
		while node and node ~= workspace do
			if node:IsA("Model") and game:GetService("Players"):GetPlayerFromCharacter(node) then
				return true
			end
			node = node.Parent
		end
		return false
	end
	local function isLaunched(inst)
		if LAUNCH_NAMES[inst.Name] then
			return not worn(inst)
		end
		if inst.Name == "Handle" then
			local tag = inst:GetAttribute("BadgeName")
			return type(tag) == "string" and tag:find("^Launcher") ~= nil and not worn(inst)
		end
		return false
	end
	local function grab(inst)
		if grabbed[inst] or not toggleOn("SnipeGrab") then
			return
		end
		grabbed[inst] = true
		task.spawn(function()
			local char = LocalPlayer.Character
			local hrp = char and char:FindFirstChild("HumanoidRootPart")
			if not hrp then
				return
			end
			local parts = {}
			if inst:IsA("BasePart") then
				parts[1] = inst
			end
			for _, d in inst:GetDescendants() do
				if d:IsA("BasePart") then
					parts[#parts + 1] = d
				end
			end
			if #parts == 0 then
				return
			end
			local function touchAll(fromParts)
				for _, p in parts do
					if p.Parent then
						for _, mine in fromParts do
							pcall(firetouchinterest, mine, p, 0)
							pcall(firetouchinterest, mine, p, 1)
						end
					end
				end
			end
			local function bodyParts()
				local list = {}
				for _, d in char:GetChildren() do
					if d:IsA("BasePart") then
						list[#list + 1] = d
					end
				end
				return list
			end
			local function owned(p)
				if p.Anchored then
					return false
				end
				local ok, res = pcall(isnetworkowner, p)
				return ok and res == true
			end
			local function claimed()
				return not inst.Parent or not parts[1].Parent or worn(inst)
			end
			local body = bodyParts()
			local t0 = os.clock()
			while not claimed() and os.clock() - t0 < 1.5 do
				touchAll(body)
				task.wait(0.15)
			end
			local pulled = false
			t0 = os.clock()
			while not claimed() and os.clock() - t0 < 2.5 do
				local target = parts[1]
				if not owned(target) then
					break
				end
				pulled = true
				target.AssemblyLinearVelocity = Vector3.zero
				target.CFrame = hrp.CFrame
				touchAll(body)
				task.wait(0.1)
			end
			if not claimed() and not pulled and toggleOn("SnipeGrabTeleport") then
				local origin = char:GetPivot()
				local floor = workspace.FallenPartsDestroyHeight + 100
				local function safeGoal()
					local target = parts[1]
					if not target.Parent or target.AssemblyLinearVelocity.Magnitude > 20 then
						return nil
					end
					local pos = target.Position
					if pos.Y < floor or pos.Y < origin.Position.Y - 60 then
						return nil
					end
					return pos
				end
				t0 = os.clock()
				while not claimed() and os.clock() - t0 < 3 do
					local goal = safeGoal()
					if goal then
						hrp.AssemblyLinearVelocity = Vector3.zero
						char:PivotTo(CFrame.new(goal))
						touchAll(body)
					end
					task.wait(0.1)
				end
				task.wait(0.3)
				hrp.AssemblyLinearVelocity = Vector3.zero
				char:PivotTo(origin)
			end
			task.delay(3, refreshWings)
		end)
	end
	G.HUNT_GRAB_CONN = G.HUNT_GRAB_CONN
	if G.HUNT_GRAB_CONN then
		pcall(function()
			G.HUNT_GRAB_CONN:Disconnect()
		end)
	end
	G.HUNT_GRAB_CONN = workspace.DescendantAdded:Connect(function(inst)
		if isLaunched(inst) then
			grab(launchRoot(inst))
		end
	end)
	task.spawn(function()
		for _, inst in workspace:GetDescendants() do
			if isLaunched(inst) then
				grab(launchRoot(inst))
			end
		end
	end)

	local baseWanted = wanted
	wanted = function(uid)
		local info = targets[uid]
		if info and toggleOn("SnipeSkipOwned") then
			local needed = false
			for cat in info.cats do
				if not owned[cat] then
					needed = true
				end
			end
			if not needed then
				return false
			end
		end
		return baseWanted(uid)
	end

	local function hotList()
		local now = os.time()
		local scored = {}
		for uid, act in activity do
			if wanted(uid) then
				if act.online and now - (act.last_seen or 0) <= 900 then
					local score = (act.sightings or 0) * weight(uid)
					if act.last_type == 2 then
						score *= 4
					end
					scored[#scored + 1] = { score = score, uid = uid }
				end
			end
		end
		table.sort(scored, function(x, y)
			return x.score > y.score
		end)
		local out = {}
		for i = 1, math.min(#scored, HOT_SIZE) do
			out[i] = scored[i].uid
		end
		return out
	end

	local sweepQueue = {}
	local sweepPos = 1
	local function refillSweep()
		local heavy, light = {}, {}
		for uid in targets do
			if wanted(uid) then
				if weight(uid) > 1 then
					heavy[#heavy + 1] = uid
				else
					light[#light + 1] = uid
				end
			end
		end
		sweepQueue = {}
		for _, list in { heavy, heavy, light } do
			for _, uid in list do
				sweepQueue[#sweepQueue + 1] = uid
			end
		end
		sweepPos = 1
	end

	local found = {}
	local foundDirty = false
	local SERVER_HOSTS = { "games.roblox.com", "games.ff-roproxy.com" }
	local INDEX_TTL = 150
	local serverIndex = {}
	local indexStats = { servers = 0, lastPass = nil }
	local firstPageLog = {}
	local function firstPageFree(host)
		local log = firstPageLog[host] or {}
		firstPageLog[host] = log
		local now = os.clock()
		while log[1] and now - log[1] > 62 do
			table.remove(log, 1)
		end
		return #log < 3
	end
	local function fetchServerPage(host, order, cursor)
		if not cursor then
			if not firstPageFree(host) then
				return nil, "budget"
			end
			table.insert(firstPageLog[host], os.clock())
		end
		local ok, res = pcall(function()
			return request({
				Url = string.format(
					"https://%s/v1/games/%d/servers/Public?limit=100&sortOrder=%s%s",
					host,
					HUB_PLACE,
					order,
					cursor and ("&cursor=" .. cursor) or ""
				),
				Method = "GET",
			})
		end)
		if not ok or not res or res.StatusCode ~= 200 then
			return nil, res and res.StatusCode
		end
		local okD, d = pcall(function()
			return HttpService:JSONDecode(res.Body)
		end)
		if not okD or type(d) ~= "table" or type(d.data) ~= "table" then
			return nil
		end
		return d
	end
	local function indexed(gameId)
		local s = serverIndex[gameId]
		if s and os.clock() - s.t <= INDEX_TTL then
			return s
		end
	end
	local function applyIndex(e)
		local s = indexed(e.gameId)
		if s then
			e.playing, e.maxPlayers = s.playing, s.maxPlayers
			return true
		end
		return false
	end

	local function indexerWanted()
		return toggleOn("SnipeRun")
	end
	task.spawn(function()
		while Library and not Library.Unloaded do
			if indexerWanted() then
				local passStart = os.clock()
				local pass = {}
				local count = 0
				local finished = 0
				for i, host in SERVER_HOSTS do
					task.spawn(function()
						local cursor
						local order = i == 1 and "Asc" or "Desc"
						local strikes = 0
						while indexerWanted() and not Library.Unloaded do
							local d, code = fetchServerPage(host, order, cursor)
							if not d and code == "budget" then
								task.wait(2)
							elseif not d then
								strikes += 1
								if strikes >= 6 then
									break
								end
								task.wait(code == 429 and 6 or 2)
							else
								strikes = 0
								local overlap = 0
								local now = os.clock()
								for _, s in d.data do
									local seenBy = pass[s.id]
									if seenBy and seenBy ~= i then
										overlap += 1
									elseif not seenBy then
										pass[s.id] = i
										count += 1
										indexStats.progress = count
									end
									serverIndex[s.id] =
										{ playing = s.playing or 0, maxPlayers = s.maxPlayers or 30, t = now }
								end
								cursor = d.nextPageCursor
								if overlap >= math.max(10, #d.data // 3) or not cursor then
									break
								end
								task.wait(0.5)
							end
						end
						finished += 1
					end)
				end
				while finished < #SERVER_HOSTS and not Library.Unloaded do
					task.wait(0.2)
				end
				indexStats.servers, indexStats.lastPass = count, os.clock()
				local cutoff = os.clock() - INDEX_TTL * 2
				for id, s in serverIndex do
					if s.t < cutoff then
						serverIndex[id] = nil
					end
				end
				local waitLeft = 30 - (os.clock() - passStart)
				while waitLeft > 0 and indexerWanted() and not Library.Unloaded do
					task.wait(math.min(waitLeft, 1))
					waitLeft = 30 - (os.clock() - passStart)
				end
			else
				task.wait(1)
			end
		end
	end)

	local function lookupCounts(entries, cap)
		local want, left = {}, 0
		for _, e in entries do
			if not applyIndex(e) and not want[e.gameId] then
				want[e.gameId] = e
				left += 1
			end
		end
		if left == 0 or indexStats.lastPass then
			return
		end
		local deadline = os.clock() + cap
		local done = 0
		for i, host in SERVER_HOSTS do
			task.spawn(function()
				local cursor
				while left > 0 and os.clock() < deadline do
					local d = fetchServerPage(host, i == 1 and "Asc" or "Desc", cursor)
					if not d then
						break
					end
					local now = os.clock()
					for _, s in d.data do
						serverIndex[s.id] = { playing = s.playing or 0, maxPlayers = s.maxPlayers or 30, t = now }
						local e = want[s.id]
						if e and e.playing == nil then
							e.playing, e.maxPlayers = s.playing, s.maxPlayers
							left -= 1
						end
					end
					cursor = d.nextPageCursor
					if not cursor then
						break
					end
				end
				done += 1
			end)
		end
		while done < #SERVER_HOSTS and left > 0 and os.clock() < deadline + 1 do
			task.wait(0.1)
		end
	end

	local function countText(e)
		if e.dead then
			return " (server closed)"
		elseif e.full then
			local seats = e.playing and string.format(" %d/%d", e.playing, e.maxPlayers or 30) or ""
			if (e.levelTries or 0) > 0 then
				return string.format(" (full%s, try %d/15)", seats, e.levelTries)
			end
			return " (full" .. seats .. ", waiting for a slot)"
		elseif e.playing then
			return string.format(" (%d/%d)", e.playing, e.maxPlayers or 30)
		end
		return ""
	end

	local joinState = { active = nil, queue = {}, busy = false, gen = 0 }
	local fullServers = {}
	local refreshFound
	local function joinable(e)
		return e and e.gameId ~= game.JobId and not fullServers[e.gameId]
	end
	local function cancelJoins()
		joinState.gen += 1
		joinState.active = nil
		joinState.queue = {}
		joinState.busy = false
	end
	local function teleportTo(entry)
		joinState.active = entry
		joinState.startedAt = os.clock()
		pcall(function()
			writefile(
				"hunt20_arrive.json",
				HttpService:JSONEncode({ job = entry.gameId, name = entry.name, uid = entry.uid, t = os.time() })
			)
		end)
		pcall(function()
			TeleportService:TeleportToPlaceInstance(entry.placeId, entry.gameId, LocalPlayer)
		end)
	end
	local function join(entry)
		if not entry or entry.gameId == game.JobId then
			return
		end
		if fullServers[entry.gameId] then
			Library:Notify(entry.name .. "'s server is full.", 4)
			return
		end
		joinState.queue = {}
		Library:Notify("Joining " .. entry.name .. countText(entry) .. "...", 4)
		teleportTo(entry)
	end
	local function joinBest(candidates)
		if not toggleOn("SnipeRun") or (toggleOn("SnipePauseHere") and #hereState.list > 0) then
			return
		end
		local inFlight = joinState.active and os.clock() - (joinState.startedAt or 0) < 6
		if joinState.busy or inFlight then
			for _, c in candidates do
				if joinable(c) then
					joinState.queue[#joinState.queue + 1] = c
				end
			end
			return
		end
		joinState.busy = true
		local gen = joinState.gen
		task.spawn(function()
			local list = {}
			for _, c in candidates do
				if joinable(c) then
					list[#list + 1] = c
				end
			end
			if #list > 1 then
				lookupCounts(list, 4)
			else
				for _, c in list do
					applyIndex(c)
				end
			end
			if gen ~= joinState.gen or not toggleOn("SnipeRun") then
				return
			end
			refreshFound()
			local open = {}
			for _, c in list do
				if c.playing and c.maxPlayers and c.playing >= c.maxPlayers then
					fullServers[c.gameId] = true
					c.full = true
				elseif joinable(c) then
					open[#open + 1] = c
				end
			end
			table.sort(open, function(x, y)
				local px = x.playing or 29.5
				local py = y.playing or 29.5
				if px ~= py then
					return px < py
				end
				return x.time > y.time
			end)
			if open[1] then
				joinState.queue = { table.unpack(open, 2) }
				Library:Notify("Joining " .. open[1].name .. countText(open[1]) .. "...", 4)
				teleportTo(open[1])
			end
			joinState.busy = false
		end)
	end

	G.HUNT_TP_FAIL_CONN = G.HUNT_TP_FAIL_CONN
	if G.HUNT_TP_FAIL_CONN then
		pcall(function()
			G.HUNT_TP_FAIL_CONN:Disconnect()
		end)
	end
	G.HUNT_TP_FAIL_CONN = TeleportService.TeleportInitFailed:Connect(function(player, result, msg)
		if player ~= LocalPlayer or Library.Unloaded then
			return
		end
		local entry = joinState.active
		if not entry then
			return
		end
		joinState.active = nil
		local isFull = result == Enum.TeleportResult.GameFull
		if entry.watchAttempt then
			entry.watchAttempt = nil
			if isFull then
				entry.levelTries = (entry.levelTries or 0) + 1
				if entry.levelTries >= 15 then
					entry.refusedAt = entry.playing or entry.refusedAt
					entry.levelTries = 0
				else
					entry.refusedAt = (entry.playing or 29) + 1
				end
			else
				entry.dead = true
			end
			refreshFound()
			return
		end
		if isFull then
			fullServers[entry.gameId] = true
			entry.full = true
			local s = indexed(entry.gameId)
			local seen = s and s.playing or entry.playing or 30
			local cap = s and s.maxPlayers or entry.maxPlayers or 30
			entry.playing = seen
			if seen < cap then
				entry.refusedAt = seen + 1
				entry.levelTries = 1
			else
				entry.refusedAt = seen
				entry.levelTries = 0
			end
			refreshFound()
		end
		if not toggleOn("SnipeRun") then
			joinState.queue = {}
			return
		end
		local nextUp = table.remove(joinState.queue, 1)
		while nextUp and not joinable(nextUp) do
			nextUp = table.remove(joinState.queue, 1)
		end
		if nextUp then
			Library:Notify(
				(isFull and "Server full" or ("Join failed: " .. tostring(msg))) .. " - trying " .. nextUp.name,
				4
			)
			teleportTo(nextUp)
		else
			Library:Notify(
				isFull and (entry.name .. "'s server is full - skipped.") or ("Join failed: " .. tostring(msg)),
				5
			)
		end
	end)

	Library.Toggles.SnipeRun:OnChanged(function(value)
		if not value then
			cancelJoins()
		end
	end)

	local WATCH_GAP = 12
	local lastWatch = 0
	local watchHost = 0
	task.spawn(function()
		while Library and not Library.Unloaded do
			task.wait(1)
			local paused = toggleOn("SnipePauseHere") and #hereState.list > 0
			local inFlight = joinState.active and os.clock() - (joinState.startedAt or 0) < 6
			local ready = toggleOn("SnipeRun")
				and toggleOn("SnipeAutoJoin")
				and not paused
				and not inFlight
				and not joinState.busy
			if ready and #joinState.queue > 0 then
				local backlog = joinState.queue
				joinState.queue = {}
				local fresh = {}
				for _, c in backlog do
					if joinable(c) and os.time() - c.time <= 90 then
						fresh[#fresh + 1] = c
					end
				end
				if #fresh > 0 then
					joinBest(fresh)
					ready = false
				end
			end
			if ready then
				local nowT, nowC = os.time(), os.clock()
				local retry
				for _, e in found do
					if
						e.full
						and not e.dead
						and e.gameId ~= game.JobId
						and nowT - e.time <= 90
						and (e.levelTries or 0) > 0
						and e.playing
						and e.playing < (e.maxPlayers or 30)
						and nowC - (e.lastTry or 0) >= 3
						and (not retry or e.playing < retry.playing)
					then
						retry = e
					end
				end
				if retry then
					retry.lastTry = nowC
					retry.watchAttempt = true
					refreshFound()
					teleportTo(retry)
					ready = false
				end
			end
			if ready and os.clock() - lastWatch >= WATCH_GAP then
				local nowT = os.time()
				local watched, left = {}, 0
				for _, e in found do
					if e.full and not e.dead and e.gameId ~= game.JobId and nowT - e.time <= 90 then
						watched[e.gameId] = e
						left += 1
					end
				end
				if left > 0 then
					local host
					for _ = 1, #SERVER_HOSTS do
						watchHost = watchHost % #SERVER_HOSTS + 1
						if firstPageFree(SERVER_HOSTS[watchHost]) then
							host = SERVER_HOSTS[watchHost]
							break
						end
					end
					if host then
						lastWatch = os.clock()
						local seen = {}
						local cursor
						local lowest = math.huge
						for _ = 1, 5 do
							local d = fetchServerPage(host, "Desc", cursor)
							if not d then
								break
							end
							local now = os.clock()
							for _, s in d.data do
								serverIndex[s.id] =
									{ playing = s.playing or 0, maxPlayers = s.maxPlayers or 30, t = now }
								lowest = math.min(lowest, s.playing or 0)
								local e = watched[s.id]
								if e and not seen[s.id] then
									seen[s.id] = true
									e.playing, e.maxPlayers = s.playing, s.maxPlayers
									left -= 1
								end
							end
							cursor = d.nextPageCursor
							if left <= 0 or not cursor then
								break
							end
						end
						local best
						for id, e in watched do
							local refused = e.refusedAt or 30
							local opened
							if seen[id] then
								opened = e.playing < refused
							else
								opened = lowest < refused
							end
							if opened and (not best or (e.playing or 30) < (best.playing or 30)) then
								best = e
							end
						end
						refreshFound()
						if best then
							best.watchAttempt = true
							Library:Notify("A slot opened in " .. best.name .. "'s server - joining...", 4)
							teleportTo(best)
						end
					end
				end
			end
		end
	end)

	refreshFound = function()
		local now = os.time()
		local list = {}
		for uid, e in found do
			if now - e.time <= FOUND_TTL then
				list[#list + 1] = e
			else
				found[uid] = nil
			end
		end
		table.sort(list, function(x, y)
			return x.time > y.time
		end)
		local values, lines = {}, {}
		for i, e in list do
			values[#values + 1] = i .. ". " .. e.name
			lines[#lines + 1] = string.format(
				"%s [%s] - %s%s, %ds ago%s",
				e.name,
				e.cats,
				e.where,
				countText(e),
				now - e.time,
				e.gameId == game.JobId and " (here)" or ""
			)
		end
		pick:SetValues(values)
		G.HUNT_SNIPE_LIST = list
		foundLabel:SetText(#list == 0 and "Nothing yet." or table.concat(lines, "\n", 1, math.min(#lines, 12)))
	end

	local function record(presences)
		local now = os.time()
		local fresh = {}
		for _, u in presences do
			local uid = u.userId
			local ptype = u.userPresenceType or 0
			if targets[uid] and ptype == 0 and activity[uid] and activity[uid].online then
				activity[uid].online = false
				activity[uid].last_type = 0
				activityDirty = true
			end
			if targets[uid] and ptype > 0 then
				local act = activity[uid] or { sightings = 0 }
				act.online = true
				act.sightings = (act.sightings or 0) + 1
				act.last_seen = now
				act.last_type = ptype
				activity[uid] = act
				activityDirty = true
				local root = u.rootPlaceId or u.placeId
				local inHub = root == HUB_PLACE or u.placeId == HUB_PLACE
				if u.gameId and inHub then
					local prev = found[uid]
					if not prev or prev.gameId ~= u.gameId then
						found[uid] = {
							uid = uid,
							name = targets[uid].name,
							cats = catText(uid),
							where = "The Hunt",
							placeId = u.placeId,
							gameId = u.gameId,
							time = now,
						}
						foundDirty = true
						if u.gameId ~= game.JobId then
							fresh[#fresh + 1] = found[uid]
						end
					else
						prev.time = now
					end
				end
			end
		end
		if #fresh > 0 then
			if toggleOn("SnipeAutoJoin") then
				joinBest(fresh)
			else
				for _, e in fresh do
					Library:Notify(e.name .. " [" .. e.cats .. "] is joinable in " .. e.where, 6)
				end
			end
		end
	end

	local ROUTES = {
		{ name = "roblox", url = PRESENCE_URL, gap = 60 / 22, nextAt = 0, blockedUntil = 0, strikes = 0 },
		{ name = "roproxy", url = PRESENCE_PROXY_URL, gap = 60 / 40, nextAt = 0, blockedUntil = 0, strikes = 0 },
		{ name = "ff-roproxy", url = PRESENCE_FF_PROXY_URL, gap = 60 / 40, nextAt = 0, blockedUntil = 0, strikes = 0 },
	}
	local hotFirst = true
	local hotPos = 1
	local function fetch(route, ids)
		route.nextAt = os.clock() + route.gap
		local ok, res = pcall(function()
			return request({
				Url = route.url,
				Method = "POST",
				Headers = { ["Content-Type"] = "application/json" },
				Body = HttpService:JSONEncode({ userIds = ids }),
			})
		end)
		local reset, remaining = nil, nil
		if ok and res then
			for k, v in res.Headers or {} do
				local key = tostring(k):lower()
				if key == "x-ratelimit-reset" then
					reset = tonumber(v)
				elseif key == "x-ratelimit-remaining" then
					remaining = tonumber(v)
				end
			end
		end
		if ok and res and res.StatusCode == 200 then
			if route.strikes > 0 or route.wasBlocked then
				hotFirst = true
			end
			route.strikes, route.wasBlocked = 0, false
			if remaining and remaining <= 2 and reset then
				route.nextAt = math.max(route.nextAt, os.clock() + reset + 1)
			end
			local okD, d = pcall(function()
				return HttpService:JSONDecode(res.Body)
			end)
			return okD and type(d) == "table" and d.userPresences or {}
		end
		if ok and res and res.StatusCode == 429 then
			route.strikes += 1
			route.wasBlocked = true
			if route.strikes >= 2 and remaining and remaining > 0 then
				route.blockedUntil = os.clock() + HARD_BLOCK_PAUSE
				route.strikes = 0
			else
				route.blockedUntil = os.clock() + (reset or 9) + 1
			end
		else
			route.nextAt = os.clock() + 5
		end
		return {}
	end

	local Players = game:GetService("Players")
	local hereMarks = {}
	local function clearMark(uid)
		local m = hereMarks[uid]
		if m then
			pcall(function()
				m:Destroy()
			end)
			hereMarks[uid] = nil
		end
	end
	local CollectionService = game:GetService("CollectionService")
	local INFINITY_POINTS = {
		Vector3.new(-1835, 501, -3721),
		Vector3.new(-1845, 490, -3928),
		Vector3.new(-1850, 500, -3500),
		Vector3.new(-2021, 501, -3265),
		Vector3.new(-1760, 500, -3310),
		Vector3.new(-1720, 500, -3715),
	}
	local lastPos, probeIdx, probing = {}, {}, {}
	local hereTeams = {}
	local function withCommas(n)
		local v = math.floor(n + 0.5)
		local s = tostring(math.abs(v))
		local out = s:reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
		return (v < 0 and "-" or "") .. out
	end
	local function areaPoints(p)
		local team = p.Team and p.Team.Name or ""
		if team:find("Infinity") then
			return INFINITY_POINTS
		end
		local n = tonumber(team:match("(%d+)"))
		if not n then
			return {}
		end
		for _, a in CollectionService:GetTagged("TeleTargetAttachment") do
			if a.Name == "LevelSpawnLocation" .. n then
				local c = a.WorldPosition
				return {
					c,
					c + Vector3.new(0, 0, -200),
					c + Vector3.new(0, 0, 200),
					c + Vector3.new(-250, 0, 0),
					c + Vector3.new(250, 0, 0),
				}
			end
		end
		return {}
	end
	hereState.spawnFor = function(p)
		return areaPoints(p)[1]
	end
	local function locate(e)
		local uid = e.uid
		local char = e.player.Character
		local hrp = char and char:FindFirstChild("HumanoidRootPart")
		if hrp then
			lastPos[uid] = { pos = hrp.Position, t = os.clock() }
		end
		if probing[uid] then
			return
		end
		local target
		local lp = lastPos[uid]
		if lp and os.clock() - lp.t < 20 then
			if hrp then
				local myChar = LocalPlayer.Character
				local my = myChar and myChar:FindFirstChild("HumanoidRootPart")
				if my and (my.Position - hrp.Position).Magnitude > 500 then
					target = hrp.Position
				end
			else
				target = lp.pos
			end
		else
			local pts = areaPoints(e.player)
			if #pts > 0 then
				probeIdx[uid] = (probeIdx[uid] or 0) % #pts + 1
				target = pts[probeIdx[uid]]
			end
		end
		if target then
			probing[uid] = true
			task.spawn(function()
				pcall(function()
					LocalPlayer:RequestStreamAroundAsync(target, 5)
				end)
				probing[uid] = nil
			end)
		end
	end
	local function whereText(e)
		local team = e.player.Team and e.player.Team.Name or "unknown area"
		local lp = lastPos[e.uid]
		if lp and os.clock() - lp.t < 20 then
			local myChar = LocalPlayer.Character
			local my = myChar and myChar:FindFirstChild("HumanoidRootPart")
			local dist = my and (" - " .. withCommas((my.Position - lp.pos).Magnitude) .. " studs away") or ""
			return string.format(
				"%s at (%s, %s, %s)%s",
				team,
				withCommas(lp.pos.X),
				withCommas(lp.pos.Y),
				withCommas(lp.pos.Z),
				dist
			)
		end
		return team .. " - locating..."
	end

	local function updateHere()
		local list = {}
		for _, p in Players:GetPlayers() do
			if p ~= LocalPlayer and targets[p.UserId] then
				list[#list + 1] = { player = p, uid = p.UserId, cats = catText(p.UserId) }
			end
		end
		local was = {}
		for _, e in hereState.list do
			was[e.uid] = true
		end
		local now = {}
		for _, e in list do
			now[e.uid] = true
			if not was[e.uid] then
				Library:Notify(
					string.format(
						"%s [%s] is in your server!",
						e.player.DisplayName .. " (@" .. e.player.Name .. ")",
						e.cats
					),
					10
				)
			end
			local char = e.player.Character
			if toggleOn("SnipeHighlightHere") and char then
				local m = hereMarks[e.uid]
				if not m or m.Parent ~= char then
					clearMark(e.uid)
					m = Instance.new("Highlight")
					m.FillColor = Color3.fromRGB(255, 200, 40)
					m.OutlineColor = Color3.fromRGB(255, 255, 255)
					m.FillTransparency = 0.4
					m.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
					m.Parent = char
					hereMarks[e.uid] = m
				end
			else
				clearMark(e.uid)
			end
		end
		for uid in hereMarks do
			if not now[uid] then
				clearMark(uid)
			end
		end
		hereState.list = list
		if #list == 0 then
			hereLabel:SetText("No admins, developers or video stars here.")
		else
			local lines = {}
			for _, e in list do
				locate(e)
				local team = e.player.Team and e.player.Team.Name
				local prevTeam = hereTeams[e.uid]
				hereTeams[e.uid] = team
				if team and prevTeam and team ~= prevTeam then
					if toggleOn("SnipeFollowIsland") then
						local spawnPos = hereState.spawnFor(e.player)
						local char = LocalPlayer.Character
						if spawnPos and char then
							local goal = spawnPos + Vector3.new(0, 4, 0)
							task.spawn(function()
								pcall(function()
									LocalPlayer:RequestStreamAroundAsync(goal)
								end)
								char:PivotTo(CFrame.new(goal))
							end)
						end
						Library:Notify(e.player.DisplayName .. " moved to " .. team .. " - following.", 6)
					else
						Library:Notify(e.player.DisplayName .. " moved to " .. team .. ".", 6)
					end
				end
				lines[#lines + 1] =
					string.format("HERE: %s (@%s) [%s]\n%s", e.player.DisplayName, e.player.Name, e.cats, whereText(e))
			end
			hereLabel:SetText(table.concat(lines, "\n"))
		end
	end
	for _, key in { "HUNT_HERE_ADD", "HUNT_HERE_REM" } do
		if G[key] then
			pcall(function()
				G[key]:Disconnect()
			end)
		end
	end
	G.HUNT_HERE_ADD = Players.PlayerAdded:Connect(function()
		task.delay(1, updateHere)
	end)
	G.HUNT_HERE_REM = Players.PlayerRemoving:Connect(function()
		task.defer(updateHere)
	end)
	task.spawn(function()
		while Library and not Library.Unloaded do
			if next(targets) then
				pcall(updateHere)
			end
			task.wait(3)
		end
		for uid in hereMarks do
			clearMark(uid)
		end
	end)

	local hotCache, hotCacheAt = {}, 0
	local function cachedHot()
		if os.clock() - hotCacheAt > 2 then
			hotCache, hotCacheAt = hotList(), os.clock()
		end
		return hotCache
	end
	local cycle = 0
	local lastAction = ""
	local function nextChunk()
		cycle += 1
		local hot = cachedHot()
		if #hot > 0 and (hotFirst or cycle % 4 ~= 0) then
			hotFirst = false
			if hotPos > #hot then
				hotPos = 1
			end
			local last = math.min(hotPos + BATCH - 1, #hot)
			local chunk = table.move(hot, hotPos, last, 1, {})
			hotPos = last + 1
			return chunk, "checking who's online"
		end
		if sweepPos > #sweepQueue then
			refillSweep()
		end
		local last = math.min(sweepPos + BATCH - 1, #sweepQueue)
		local chunk = table.move(sweepQueue, sweepPos, last, 1, {})
		sweepPos = last + 1
		return chunk, string.format("sweeping (%d/%d this pass)", last, #sweepQueue)
	end
	local function sniperActive()
		return toggleOn("SnipeRun")
			and next(targets) ~= nil
			and not (toggleOn("SnipePauseHere") and #hereState.list > 0)
	end

	for _, route in ROUTES do
		task.spawn(function()
			while Library and not Library.Unloaded do
				local now = os.clock()
				if sniperActive() and now >= route.blockedUntil and now >= route.nextAt then
					local chunk, what = nextChunk()
					if #chunk > 0 then
						lastAction = what .. ", " .. route.name
						record(fetch(route, chunk))
						saveActivity(false)
					else
						task.wait(0.5)
					end
				else
					task.wait(0.1)
				end
			end
		end)
	end

	task.spawn(function()
		local lastFoundDraw = 0
		while Library and not Library.Unloaded do
			if foundDirty or os.clock() - lastFoundDraw > 5 then
				foundDirty = false
				lastFoundDraw = os.clock()
				refreshFound()
			end
			if toggleOn("SnipeRun") and toggleOn("SnipePauseHere") and #hereState.list > 0 then
				engineLabel:SetText("Paused - " .. hereState.list[1].player.Name .. " is in your server.")
			elseif toggleOn("SnipeRun") and next(targets) then
				local now = os.clock()
				local blocked, soonest = 0, math.huge
				for _, r in ROUTES do
					if now < r.blockedUntil then
						blocked += 1
						soonest = math.min(soonest, r.blockedUntil)
					end
				end
				if blocked == #ROUTES then
					engineLabel:SetText(
						string.format("Rate limited on every route - resuming in %ds.", math.ceil(soonest - now))
					)
				else
					engineLabel:SetText(
						string.format("Running on %d/%d routes - %s", #ROUTES - blocked, #ROUTES, lastAction)
					)
				end
				hotLabel:SetText(
					string.format(
						"Watching: %d online now\nServer index: %s",
						#cachedHot(),
						indexStats.lastPass and (indexStats.servers .. " hub servers")
							or ("building... " .. (indexStats.progress or 0) .. " so far")
					)
				)
			else
				engineLabel:SetText(next(targets) and "Stopped." or "Loading targets...")
			end
			task.wait(0.5)
		end
		saveActivity(true)
	end)

	resultsBox:AddButton({
		Text = "Join selected",
		Func = function()
			local v = pick.Value
			local idx = v and tonumber(tostring(v):match("^(%d+)%."))
			local list = G.HUNT_SNIPE_LIST or {}
			join(idx and list[idx])
		end,
	})
	resultsBox:AddLabel(
		"Finds stay listed for 15 minutes. Auto join jumps to each new find that isn't your server.",
		true
	)
end

local function addBadgeLabel(box, badgeId)
	local BadgeService = game:GetService("BadgeService")
	local LocalPlayer = game:GetService("Players").LocalPlayer
	local label = box:AddLabel("Badge: checking...", true)
	local function refresh()
		task.spawn(function()
			local ok, has = pcall(function()
				return BadgeService:UserHasBadgeAsync(LocalPlayer.UserId, badgeId)
			end)
			if ok and has then
				label:SetText("Badge: EARNED - return to hub to claim")
			elseif ok then
				label:SetText("Badge: not yet")
			else
				label:SetText("Badge: check failed")
			end
		end)
	end
	refresh()
	return refresh
end
local BRICKBATTLE_PLACES = { [1818] = true, [25415] = true, [14403] = true }

local HUNT_QUEUE_SOURCE
if SOURCE_URL ~= "" then
	HUNT_QUEUE_SOURCE = 'pcall(function() loadstring(game:HttpGet("' .. SOURCE_URL .. '"))() end)'
else
	HUNT_QUEUE_SOURCE = 'pcall(function() loadstring(readfile("' .. LOCAL_FILE .. '"))() end)'
end

do
	local G = getgenv()
	local queue = queue_on_teleport or queueonteleport
	if queue and not G.HUNT_AUTOLOAD_QUEUED then
		G.HUNT_AUTOLOAD_QUEUED = true
		queue(HUNT_QUEUE_SOURCE)
	end
end

repeat
	task.wait()
until game:IsLoaded()

do
	local G = getgenv()
	if G.HUNT_RUN_JOB == game.JobId and G.HUNT_RUN_PLACE == game.PlaceId and not G.HUNT_FORCE_RELOAD then
		return
	end
	G.HUNT_RUN_JOB = game.JobId
	G.HUNT_RUN_PLACE = game.PlaceId
	G.HUNT_FORCE_RELOAD = nil
end

local function runHub()
	local Players = game:GetService("Players")
	local CollectionService = game:GetService("CollectionService")
	local HttpService = game:GetService("HttpService")
	local RunService = game:GetService("RunService")
	local BadgeService = game:GetService("BadgeService")

	local LocalPlayer = Players.LocalPlayer

	repeat
		task.wait()
	until game:IsLoaded()

	local Remotes = game:GetService("ReplicatedStorage"):WaitForChild("Remotes")
	local YearFolders = workspace:WaitForChild("YearFolders")
	local QuestActivities = require(game:GetService("ReplicatedStorage").Config.QuestActivities)
	local QuestTagPrefixes = require(game:GetService("ReplicatedStorage").Config.QuestTagPrefixes)
	local ATT = QuestTagPrefixes.ATT_PREFIX

	local G = getgenv()
	G.HUNT_STOP = false
	G.HUNT_LOG = {}

	G.HUNT_REWARD_INFO = G.HUNT_REWARD_INFO or {}
	G.HUNT_HAS_BADGE = G.HUNT_HAS_BADGE or {}
	G.HUNT_CLAIMED = G.HUNT_CLAIMED or {}

	local CLAIM_FILE = "hunt20_claimed_" .. LocalPlayer.UserId .. ".json"
	pcall(function()
		if isfile and isfile(CLAIM_FILE) then
			for k, v in HttpService:JSONDecode(readfile(CLAIM_FILE)) do
				if v then
					G.HUNT_CLAIMED[tonumber(k)] = true
				end
			end
		end
	end)

	local function markClaimed(i)
		G.HUNT_CLAIMED[i] = true
		pcall(function()
			if writefile then
				local out = {}
				for k, v in G.HUNT_CLAIMED do
					if v then
						out[tostring(k)] = true
					end
				end
				writefile(CLAIM_FILE, HttpService:JSONEncode(out))
			end
		end)
	end
	local function log(...)
		local parts = {}
		for _, v in { ... } do
			parts[#parts + 1] = tostring(v)
		end
		local line = table.concat(parts, " ")
		table.insert(G.HUNT_LOG, line)
		if #G.HUNT_LOG > 200 then
			table.remove(G.HUNT_LOG, 1)
		end
		if Library and Library.Notify then
			pcall(function()
				Library:Notify(line, 3)
			end)
		end
	end

	local function comma(n)
		n = tostring(math.floor(tonumber(n) or 0))
		local sign = ""
		if n:sub(1, 1) == "-" then
			sign = "-"
			n = n:sub(2)
		end
		local out = n:reverse():gsub("(%d%d%d)", "%1,"):reverse()
		out = out:gsub("^,", "")
		return sign .. out
	end

	local COORDS = {
		[1] = Vector3.new(-26, 6, 321),
		[2] = Vector3.new(-699, 6, 300),
		[3] = Vector3.new(-1421, 6, 350),
		[4] = Vector3.new(-2100, 46, 325),
		[5] = Vector3.new(-2800, 10, 300),
		[6] = Vector3.new(-3599, 7, 103),
		[7] = Vector3.new(-4252, 26, 447),
		[8] = Vector3.new(-4929, -20, 536),
		[9] = Vector3.new(-5584, 34, 74),
		[10] = Vector3.new(-6221, 17, 260),
		[11] = Vector3.new(-7013, 5, -1),
		[12] = Vector3.new(-7872, 15, -62),
		[13] = Vector3.new(-8510, 5, -65),
		[14] = Vector3.new(-9104, 4, 370),
		[15] = Vector3.new(-9580, 1, 214),
		[16] = Vector3.new(-10452, 5, 268),
		[17] = Vector3.new(-11108, 3, 392),
		[18] = Vector3.new(-11810, 8, 176),
		[19] = Vector3.new(-12599, 19, 136),
		[20] = Vector3.new(-13403, 7, 239),
	}

	local ISLANDS = {}
	for i = 1, 20 do
		local cfg = QuestActivities["Island" .. i]
		if cfg then
			ISLANDS[i] = {
				n = i,
				label = cfg.HudLabel or ("Island " .. i),
				count = cfg.Count or 1,
				activity = cfg.Activity,
				spawnTag = cfg.SpawnTag,
				reward = cfg.RewardTool or "-",
				startFlag = cfg.StartFlag,
				progressFlag = cfg.ProgressFlag,
				turnInFlag = cfg.TurnInFlag,
				pos = COORDS[i],
			}
		end
	end

	local function attr(flag)
		return LocalPlayer:GetAttribute(ATT .. flag) or 0
	end

	local function getSession()
		local raw = LocalPlayer:GetAttribute("ActivitySession")
		if not raw then
			return nil
		end
		local ok, decoded = pcall(function()
			return HttpService:JSONDecode(raw)
		end)
		return ok and decoded or nil
	end

	local function hrpNow()
		local char = LocalPlayer.Character
		return char and char:FindFirstChild("HumanoidRootPart")
	end

	local function teleport(pos, settle)
		local char = LocalPlayer.Character
		if not char then
			return false
		end
		char:PivotTo(CFrame.new(pos + Vector3.new(0, 5, 0)))
		local t0 = os.clock()
		repeat
			task.wait(0.2)
			local hrp = hrpNow()
			if hrp then
				if (hrp.Position - pos).Magnitude <= 25 then
					if settle then
						task.wait(settle)
					end
					return true
				end
				char:PivotTo(CFrame.new(pos + Vector3.new(0, 5, 0)))
			end
		until os.clock() - t0 > 5 or G.HUNT_STOP
		return true
	end

	local function tp(pos)
		return teleport(pos, 0.3)
	end

	local function findNpc(year)
		for _, c in year:GetChildren() do
			local ir = c:FindFirstChild("Interact")
			if ir and ir:IsA("RemoteEvent") then
				return ir, c
			end
		end
		return nil
	end

	local function arrive(isl)
		local key = "Year_" .. string.format("%02d", isl.n)
		tp(isl.pos)
		local year, npc
		local t0 = os.clock()
		repeat
			year = YearFolders:FindFirstChild(key)
			if year then
				npc = findNpc(year)
			end
			if not npc then
				task.wait(0.25)
			end
		until npc or os.clock() - t0 > 6 or G.HUNT_STOP
		return npc, year
	end

	local function npcWorldPos(ir)
		local model = ir and ir.Parent
		if not model then
			return nil
		end
		if model:IsA("Model") then
			return model:GetPivot().Position
		elseif model:IsA("BasePart") then
			return model.Position
		end
		return nil
	end

	local function gotoNpc(ir)
		local pos = npcWorldPos(ir)
		if not pos then
			return
		end
		teleport(pos + Vector3.new(0, 0, 4), 0.6)
	end

	local function startQuest(isl, npc)
		if attr(isl.turnInFlag) >= 1 then
			return true
		end
		if npc then
			gotoNpc(npc)
			npc:FireServer("accept")
			task.wait(0.35)
			npc:FireServer("start")
		end
		local t0 = os.clock()
		repeat
			task.wait(0.2)
		until getSession() or attr(isl.startFlag) >= 1 or os.clock() - t0 > 4 or G.HUNT_STOP
		return attr(isl.startFlag) >= 1 or getSession() ~= nil
	end

	local function taggedPos(pt)
		if not pt:IsDescendantOf(workspace) then
			return nil
		end
		local ok, pos = pcall(function()
			return (pt:IsA("Model") and pt:GetPivot().Position) or pt.Position
		end)
		return ok and pos or nil
	end

	local function partPresent(tag, id)
		for _, pt in CollectionService:GetTagged(tag) do
			if pt:GetAttribute("ID") == id and pt:IsDescendantOf(workspace) then
				return pt
			end
		end
		return nil
	end

	local function parsePos(id)
		local x, y, z = tostring(id):match("(-?%d+%.?%d*)_(-?%d+%.?%d*)_(-?%d+%.?%d*)")
		if x then
			return Vector3.new(tonumber(x), tonumber(y), tonumber(z))
		end
		return nil
	end

	local function gotoPos(target)
		return teleport(target, 0.15)
	end

	local function resolveTarget(isl, id)
		local target = parsePos(id)
		if target then
			return target
		end
		local pt = partPresent(isl.spawnTag, id)
		if not pt then
			teleport(isl.pos, 0.3)
			pt = partPresent(isl.spawnTag, id)
		end
		if pt then
			return taggedPos(pt)
		end
		return nil
	end

	local function doPickup(isl)
		local remote = Remotes:FindFirstChild("PickupMinigameCollect")
		if not remote then
			return
		end
		for pass = 1, 3 do
			if G.HUNT_STOP then
				return
			end
			local session = getSession()
			if not session or not session.SpawnIds then
				return
			end
			local anyLeft = false
			for _, id in ipairs(session.SpawnIds) do
				if G.HUNT_STOP then
					return
				end
				if not session.Collected[id] then
					local target = resolveTarget(isl, id)
					if target then
						gotoPos(target)
						task.wait(0.2)
						remote:FireServer(tostring(id))
						task.wait(0.35)
						session = getSession() or session
						if not session.Collected[id] then
							anyLeft = true
						end
					else
						anyLeft = true
					end
				end
			end
			if attr(isl.progressFlag) >= isl.count or not anyLeft then
				return
			end
		end
	end

	local function doIsland2(isl)
		local ev = Remotes:FindFirstChild("Island2ButtonPress")
		if not ev then
			return
		end
		for pass = 1, 3 do
			if attr(isl.progressFlag) >= isl.count or G.HUNT_STOP then
				return
			end
			for _, pt in CollectionService:GetTagged("Island2Button") do
				if G.HUNT_STOP then
					return
				end
				teleport(taggedPos(pt), 0.2)
				ev:FireServer(pt)
				task.wait(0.3)
			end
		end
	end

	local function doIsland3(isl)
		local ev = Remotes:FindFirstChild("PaintballMinigame")
		if not ev then
			return
		end
		for pass = 1, 4 do
			if attr(isl.progressFlag) >= isl.count or G.HUNT_STOP then
				return
			end
			local session = getSession()
			local targets = session and session.TargetEggIds
			if not targets then
				return
			end
			for _, id in ipairs(targets) do
				if G.HUNT_STOP then
					return
				end
				local painted = session.PaintedEggIds and session.PaintedEggIds[id]
				if not painted then
					local pt
					for _, egg in CollectionService:GetTagged("PaintableEgg") do
						if tostring(egg:GetAttribute("Id")) == tostring(id) then
							pt = egg
							break
						end
					end
					if pt then
						teleport(taggedPos(pt), 0.2)
						ev:FireServer(tostring(id))
						task.wait(0.3)
					end
				end
			end
			task.wait(0.3)
		end
	end

	local function doIsland4(isl)
		local pt = CollectionService:GetTagged("Island4TornadoPath")[1]
		if not pt then
			return
		end
		local pos = taggedPos(pt)
		local t0 = os.clock()
		while os.clock() - t0 < 34 and attr(isl.progressFlag) < isl.count and not G.HUNT_STOP do
			local char = LocalPlayer.Character
			if char then
				char:PivotTo(CFrame.new(pos + Vector3.new(0, 3, 0)))
			end
			task.wait(0.4)
		end
	end

	local function doIsland5(isl)
		local collectEv = Remotes:FindFirstChild("Island5PizzaCollect")
		local placeEv = Remotes:FindFirstChild("Island5PizzaPlace")
		if not collectEv or not placeEv then
			return
		end
		local session = getSession()
		if not session or not session.Pieces then
			return
		end
		for id in pairs(session.Pieces) do
			if G.HUNT_STOP then
				return
			end
			local pos = parsePos(id)
			if pos then
				gotoPos(pos)
				collectEv:FireServer(id)
				task.wait(0.3)
			end
		end
		task.wait(0.2)
		local podium = CollectionService:GetTagged("PizzaPodium")[1]
		if podium then
			teleport(taggedPos(podium), 0.2)
		end
		placeEv:FireServer()
		task.wait(0.4)
	end

	local function doIsland6(isl)
		local t0 = os.clock()
		while attr(isl.progressFlag) < isl.count and os.clock() - t0 < isl.count + 6 and not G.HUNT_STOP do
			task.wait(0.5)
		end
	end

	local function doIsland7(isl)
		local ev = Remotes:FindFirstChild("Island7FlagGrab")
		local pt = CollectionService:GetTagged("Island7FlagModel")[1]
		if not ev or not pt then
			return
		end
		teleport(taggedPos(pt), 0.2)
		ev:FireServer()
		task.wait(0.4)
	end

	local function doIsland8(isl)
		local ev = Remotes:FindFirstChild("SurvivalKitMinigame")
		if not ev then
			return
		end
		for _, pt in CollectionService:GetTagged("SurvivalKitItem") do
			if attr(isl.progressFlag) >= isl.count or G.HUNT_STOP then
				return
			end
			teleport(taggedPos(pt), 0.2)
			ev:FireServer(pt)
			task.wait(0.3)
		end
	end

	local function doIsland9(isl)
		local goal = CollectionService:GetTagged("SpeedrunGoal")[1]
		local ev = Remotes:FindFirstChild("SpeedrunMinigame")
		if not goal or not ev then
			return
		end
		teleport(goal.Position, 0.3)
		local hrp = hrpNow()
		if hrp and typeof(firetouchinterest) == "function" then
			pcall(firetouchinterest, hrp, goal, 0)
			task.wait(0.1)
			pcall(firetouchinterest, hrp, goal, 1)
		end
		ev:FireServer(goal, goal.Position, workspace:GetServerTimeNow())
		task.wait(0.6)
	end

	local function doIsland10(isl)
		local ev = Remotes:FindFirstChild("Island10Drop")
		local btn = CollectionService:GetTagged("Island10Button")[1]
		if not ev or not btn then
			return
		end
		teleport(taggedPos(btn), 0.2)
		ev:FireServer()
		local t0 = os.clock()
		while attr(isl.progressFlag) < isl.count and os.clock() - t0 < 10 and not G.HUNT_STOP do
			task.wait(0.3)
		end
	end

	local function doIsland11(isl)
		local ev = Remotes:FindFirstChild("Island11ButtonPress")
		local btn = CollectionService:GetTagged("Island11Button")[1]
		if not ev or not btn then
			return
		end
		teleport(taggedPos(btn), 0.2)
		for i = 1, 90 do
			if attr(isl.progressFlag) >= isl.count or G.HUNT_STOP then
				return
			end
			local session = getSession()
			if not session then
				return
			end
			if (session.Balance or 0) < (session.ClickCost or math.huge) and (session.Balance or 0) <= 0 then
				return
			end
			ev:FireServer()
			task.wait(0.25)
		end
	end

	local function doIsland12(isl)
		local ev = Remotes:FindFirstChild("FloodMinigame")
		local btn = CollectionService:GetTagged("FloodButton")[1]
		if not ev or not btn then
			return
		end
		teleport(taggedPos(btn), 0.2)
		ev:FireServer(btn)
		task.wait(0.4)
	end

	local function doIsland13(isl)
		local ev = Remotes:FindFirstChild("Island13Hit")
		if not ev then
			return
		end
		for _, orderId in ipairs({ "1", "2", "3" }) do
			if G.HUNT_STOP then
				return
			end
			local pt
			for _, ore in CollectionService:GetTagged("Island13Ores") do
				if tostring(ore:GetAttribute("Order")) == orderId then
					pt = ore
					break
				end
			end
			if pt then
				teleport(taggedPos(pt), 0.15)
				for hit = 1, 65 do
					local session = getSession()
					if not session or (session.Health[orderId] or 0) <= 0 or G.HUNT_STOP then
						break
					end
					ev:FireServer(orderId)
					task.wait(0.13)
				end
			end
		end
	end

	local function doIsland14(isl)
		local ev = Remotes:FindFirstChild("PetEggMinigame")
		if not ev then
			return
		end
		for _, pt in CollectionService:GetTagged("Island14CoinSpawn") do
			if G.HUNT_STOP then
				return
			end
			teleport(taggedPos(pt), 0.2)
			ev:FireServer("Collect", tostring(pt:GetAttribute("SpawnId")))
			task.wait(0.3)
		end
		task.wait(0.2)
		local disp = CollectionService:GetTagged("Island14Dispenser")[1]
		if disp then
			teleport(taggedPos(disp), 0.2)
			ev:FireServer("Dispense")
			task.wait(0.5)
		end
		for i = 1, 12 do
			local session = getSession()
			if not session or session.Hatched or G.HUNT_STOP then
				break
			end
			ev:FireServer("Hatch")
			task.wait(0.25)
		end
	end

	local function doIsland15(isl)
		local ev = Remotes:FindFirstChild("Island15Dig")
		if not ev then
			return
		end
		for i = 1, 9 do
			local session = getSession()
			if not session or (session.Digs or 0) >= isl.count or G.HUNT_STOP then
				return
			end
			local key = tostring(session.SpawnKey)
			local pt
			for _, spot in CollectionService:GetTagged("Island15TreasureSpawns") do
				if tostring(spot:GetAttribute("Order")) == key then
					pt = spot
					break
				end
			end
			if pt then
				teleport(taggedPos(pt), 0.25)
				ev:FireServer()
				task.wait(0.4)
			end
		end
	end

	local function doIsland17(isl)
		local ev = Remotes:FindFirstChild("MonsterEscapeMinigame")
		local model = CollectionService:GetTagged("Island17")[1]
		if not ev or not model then
			return
		end
		local keys = model:FindFirstChild("Keys")
		if not keys then
			return
		end
		for pass = 1, 2 do
			if G.HUNT_STOP then
				return
			end
			local session = getSession()
			local collected = session and session.CollectedIds or {}
			for _, c in keys:GetChildren() do
				if c:IsA("BasePart") then
					local id = tostring(c:GetAttribute("Id"))
					if not collected[id] then
						teleport(c.Position, 0.2)
						ev:FireServer(id)
						task.wait(0.3)
					end
				end
			end
			if attr(isl.progressFlag) >= isl.count then
				return
			end
		end
	end

	local function doIsland18(isl)
		local ev = Remotes:FindFirstChild("HyperlaserMinigame")
		local ball = CollectionService:GetTagged("BladeBalls")[1]
		if not ev or not ball then
			return
		end
		for pass = 1, 2 do
			if G.HUNT_STOP then
				return
			end
			local session = getSession()
			local hit = session and session.HitIds or {}
			for _, c in ball:GetDescendants() do
				if c:IsA("BasePart") and (c:GetAttribute("ID") or c:GetAttribute("Id")) then
					local id = tostring(c:GetAttribute("ID") or c:GetAttribute("Id"))
					if not hit[id] then
						teleport(c.Position, 0.15)
						ev:FireServer(id, c.Position, workspace:GetServerTimeNow())
						task.wait(0.3)
					end
				end
			end
			if attr(isl.progressFlag) >= isl.count then
				return
			end
		end
	end

	local function doIsland19(isl)
		local fashionEv = Remotes:FindFirstChild("FashionMinigame")
		local equipEv = Remotes:FindFirstChild("EquippableDisplay")
		local i19 = workspace:FindFirstChild("Gimmicks") and workspace.Gimmicks:FindFirstChild("Island19")
		if not fashionEv or not i19 then
			return
		end
		local accessories = i19:FindFirstChild("Accessories")
		if accessories and equipEv then
			for _, board in accessories:GetChildren() do
				if G.HUNT_STOP then
					return
				end

				for _, item in board:GetDescendants() do
					if item:IsA("Accessory") or item:IsA("Accoutrement") then
						local handle = item:FindFirstChild("Handle")
						if handle then
							teleport(handle.Position, 0.15)
							equipEv:FireServer(item)
							task.wait(0.3)
						end
						break
					end
				end
			end
		end
		task.wait(0.3)
		local runway = i19:FindFirstChild("Runway")
		if runway then
			local pos = runway:IsA("Model") and runway:GetPivot().Position
				or (runway:FindFirstChildWhichIsA("BasePart") and runway:FindFirstChildWhichIsA("BasePart").Position)
			if pos then
				teleport(pos, 0.3)
			end
		end
		fashionEv:FireServer("RunwayComplete")
		task.wait(0.4)
	end

	local function doIsland20(isl)
		local ev = Remotes:FindFirstChild("GrowTreeMinigame")
		local model = workspace:FindFirstChild("Gimmicks") and workspace.Gimmicks:FindFirstChild("Island20")
		if not ev or not model then
			return
		end
		local seed, farmland, button =
			model:FindFirstChild("Seed"), model:FindFirstChild("Farmland"), model:FindFirstChild("Button")
		if seed and attr(isl.progressFlag) < 1 then
			teleport(seed.Position, 0.2)
			ev:FireServer("Collect")
			task.wait(0.4)
		end
		if farmland and attr(isl.progressFlag) < 2 then
			teleport(farmland:GetPivot().Position, 0.2)
			ev:FireServer("Deposit")
			task.wait(0.4)
		end
		if button and attr(isl.progressFlag) < isl.count then
			teleport(button:GetPivot().Position, 0.2)
			ev:FireServer("Water")
			task.wait(0.4)
		end
	end

	local ISLAND_HANDLERS = {
		[1] = doPickup,
		[2] = doIsland2,
		[3] = doIsland3,
		[4] = doIsland4,
		[5] = doIsland5,
		[6] = doIsland6,
		[7] = doIsland7,
		[8] = doIsland8,
		[9] = doIsland9,
		[10] = doIsland10,
		[11] = doIsland11,
		[12] = doIsland12,
		[13] = doIsland13,
		[14] = doIsland14,
		[15] = doIsland15,
		[16] = doPickup,
		[17] = doIsland17,
		[18] = doIsland18,
		[19] = doIsland19,
		[20] = doIsland20,
	}

	local function turnIn(isl, npc)
		if attr(isl.turnInFlag) >= 1 then
			return true
		end
		if attr(isl.progressFlag) < isl.count then
			return false
		end
		if not npc then
			npc = select(1, arrive(isl))
		end
		if npc then
			gotoNpc(npc)
			npc:FireServer("turnIn")
			task.wait(0.35)
			npc:FireServer("finish")
			task.wait(0.5)
		end
		return attr(isl.turnInFlag) >= 1
	end

	local function scanReward(i)
		local isl = ISLANDS[i]
		local key = "Year_" .. string.format("%02d", i)
		local year = YearFolders:FindFirstChild(key)
		if not year then
			teleport(isl.pos, 0.4)
			year = YearFolders:FindFirstChild(key)
		end
		if not year then
			return nil
		end
		local portal = year:FindFirstChild("Portal")
		local ped = year:FindFirstChild("UGCPedestal")
		local info = {
			game = portal and portal:GetAttribute("experienceName"),
			placeId = portal and portal:GetAttribute("placeId"),
			badgeId = ped and ped:GetAttribute("BadgeId"),
			ugcModel = ped and ped:GetAttribute("UGCModel"),
		}
		G.HUNT_REWARD_INFO[i] = info
		if info.badgeId then
			local ok, has = pcall(function()
				return BadgeService:UserHasBadgeAsync(LocalPlayer.UserId, info.badgeId)
			end)
			G.HUNT_HAS_BADGE[i] = ok and has or nil
		end
		return info
	end

	local function claimReward(i)
		local isl = ISLANDS[i]
		local key = "Year_" .. string.format("%02d", i)
		local function findPed()
			local year = YearFolders:FindFirstChild(key)
			return year and year:FindFirstChild("UGCPedestal")
		end
		local ped = findPed()
		if not ped then
			teleport(isl.pos, 0.3)
			local t0 = os.clock()
			repeat
				task.wait(0.25)
				ped = findPed()
			until ped or os.clock() - t0 > 8
		end
		if not ped then
			return false, "pedestal not found"
		end
		local check = ped:FindFirstChild("CheckRemote") or ped:WaitForChild("CheckRemote", 5)
		if not check then
			return false, "no CheckRemote"
		end
		local standAt = CFrame.new(ped.Position + Vector3.new(0, 3, 0))
		local function hold()
			local char = LocalPlayer.Character
			local hrp = char and char:FindFirstChild("HumanoidRootPart")
			if not hrp then
				return nil
			end
			hrp.Anchored = false
			if (hrp.Position - standAt.Position).Magnitude > 2 then
				char:PivotTo(standAt)
			end
			hrp.AssemblyLinearVelocity = Vector3.zero
			return hrp
		end
		local function release() end
		local BACKOFF = { 1.2, 3, 5, 8, 12 }
		local lastErr
		for attempt = 1, #BACKOFF do
			if not hold() then
				lastErr = "no character"
				break
			end
			task.wait(BACKOFF[attempt])
			local ok, claimed, err = pcall(function()
				return check:InvokeServer()
			end)
			if not ok then
				lastErr = tostring(claimed)
			elseif claimed then
				release()
				markClaimed(i)
				return true, nil
			elseif tostring(err) == "You already claimed this prize!" then
				release()
				markClaimed(i)
				return true, "already claimed"
			elseif err ~= nil and not tostring(err):find("Try again") then
				release()
				return false, tostring(err)
			else
				lastErr = err and tostring(err) or "rejected (not at pedestal)"
			end
		end
		release()
		return false, lastErr
	end

	local function farmIsland(isl)
		if attr(isl.turnInFlag) >= 1 then
			log("Island " .. isl.n, "already done")
			return true
		end
		log("Island " .. isl.n, "-> travel")
		local npc = arrive(isl)
		if not npc then
			log("Island " .. isl.n, "no NPC found")
		end
		startQuest(isl, npc)
		local handler = ISLAND_HANDLERS[isl.n]
		if handler then
			pcall(handler, isl)
		end
		local prog = attr(isl.progressFlag)
		if prog >= isl.count then
			local ok = turnIn(isl, npc)
			log("Island " .. isl.n, ok and "COMPLETE" or "collected, turn-in failed")
			return ok
		else
			log("Island " .. isl.n, "progress " .. prog .. "/" .. isl.count .. " (island 9 needs real platforming)")
			return false
		end
	end

	local farmThread
	local function farmAll()
		if farmThread then
			return
		end
		G.HUNT_STOP = false
		farmThread = task.spawn(function()
			local origin = hrpNow() and hrpNow().CFrame
			for i = 1, 20 do
				if G.HUNT_STOP then
					break
				end
				pcall(farmIsland, ISLANDS[i])
			end
			if origin and hrpNow() then
				hrpNow().CFrame = origin
			end
			log("Farm All finished")
			farmThread = nil
			if G.HUNT_LIB and G.HUNT_LIB.Toggles and G.HUNT_LIB.Toggles.FarmAllToggle then
				G.HUNT_LIB.Toggles.FarmAllToggle:SetValue(false)
			end
		end)
	end

	if G.HUNT_LIB then
		pcall(function()
			G.HUNT_LIB:Unload()
		end)
		G.HUNT_LIB = nil
	end
	do
		local containers = {}
		local ok, hidden = pcall(function()
			return gethui()
		end)
		if ok and hidden then
			containers[#containers + 1] = hidden
		end
		containers[#containers + 1] = game:GetService("CoreGui")
		local pg = LocalPlayer:FindFirstChild("PlayerGui")
		if pg then
			containers[#containers + 1] = pg
		end
		for _, c in containers do
			for _, gui in c:GetChildren() do
				if gui:IsA("ScreenGui") then
					for _, d in gui:GetDescendants() do
						if
							d:IsA("TextLabel")
							and (tostring(d.Text):find("auto quest") or tostring(d.Text):find("The Hunt: Roblox 20"))
						then
							gui:Destroy()
							break
						end
					end
				end
			end
		end
	end

	local Library =
		loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/main/Library.lua"))()
	G.HUNT_LIB = Library
	local Options = Library.Options
	local Toggles = Library.Toggles

	local Window = Library:CreateWindow({
		Title = "The Hunt: Roblox 20",
		Footer = "auto quest / badge farm",
		Center = true,
		AutoShow = true,
		Size = UDim2.fromOffset(820, 600),
	})

	local TabFarm = Window:AddTab("Farm")
	local TabStatus = Window:AddTab("Status")
	addSniperTab(Window, Library)
	addChangelogTab(Window, "hub", Library)

	local ctl = TabFarm:AddLeftGroupbox("Controls")
	ctl:AddToggle("FarmAllToggle", {
		Text = "Farm All",
		Default = false,
		Callback = function(value)
			if value then
				farmAll()
			else
				G.HUNT_STOP = true
			end
		end,
	})

	local perBox = TabFarm:AddRightGroupbox("Single island")
	local islandDropdown = perBox:AddDropdown("IslandPick", {
		Values = (function()
			local t = {}
			for i = 1, 20 do
				t[i] = "Island " .. i
			end
			return t
		end)(),
		Default = 1,
		Text = "Target",
	})

	local singleThread
	perBox:AddToggle("FarmSelectedToggle", {
		Text = "Farm selected",
		Default = false,
		Callback = function(value)
			if value then
				local idx = tonumber((Options.IslandPick.Value:match("Island (%d+)")))
				if idx and not farmThread and not singleThread then
					G.HUNT_STOP = false
					singleThread = task.spawn(function()
						pcall(farmIsland, ISLANDS[idx])
						singleThread = nil
						if Toggles.FarmSelectedToggle then
							Toggles.FarmSelectedToggle:SetValue(false)
						end
					end)
				end
			else
				G.HUNT_STOP = true
			end
		end,
	})

	local travelling = false
	perBox:AddButton({
		Text = "Travel to selected",
		Func = function()
			if travelling then
				return
			end
			local idx = tonumber((Options.IslandPick.Value:match("Island (%d+)")))
			if idx then
				travelling = true
				task.spawn(function()
					pcall(arrive, ISLANDS[idx])
					travelling = false
				end)
			end
		end,
	})

	local ISLAND_GAMES = {
		[1] = 1818,
		[2] = 47324,
		[3] = 25415,
		[4] = 14403,
		[5] = 192800,
		[6] = 189707,
		[7] = 18164449,
		[8] = 863266079,
		[9] = 142823291,
		[10] = 13822889,
		[11] = 9689581,
		[12] = 606849621,
		[13] = 537413528,
		[14] = 920587237,
		[15] = 2727067538,
		[16] = 4623386862,
		[17] = 8481844229,
		[18] = 13772394625,
		[19] = 15101393044,
		[20] = 126884695634066,
	}

	local ISLAND_BADGES = {
		[1] = 4036544995812202,
		[2] = 2176983117961323,
		[3] = 2032546335850202,
		[4] = 823979884544596,
		[5] = 31088659531866,
		[6] = 1950450904039809,
		[7] = 4449519854199008,
		[8] = 1985785484439323,
		[9] = 3774948711767093,
		[10] = 2747787858420374,
		[11] = 2518870989628698,
		[12] = 4306759006767505,
		[13] = 4387926669504103,
		[14] = 3720272393025103,
		[15] = 2124728509,
		[16] = 702906516594361,
		[17] = 4082518353991699,
		[18] = 1873215711178593,
		[19] = 2648924952692335,
		[20] = 4292816078974682,
	}

	local ISLAND_GAME_NAMES = {
		[1] = "Crossroads",
		[2] = "Sword Fights on the Heights IV",
		[3] = "Rocket Arena",
		[4] = "Chaos Canyon",
		[5] = "Work at a Pizza Place",
		[6] = "Natural Disaster Survival",
		[7] = "Base Wars",
		[8] = "Apocalypse Rising 2",
		[9] = "Murder Mystery 2",
		[10] = "Lumber Tycoon 2",
		[11] = "Roblox High School",
		[12] = "Jailbreak",
		[13] = "Build a Boat",
		[14] = "Adopt Me!",
		[15] = "World // Zero",
		[16] = "Piggy",
		[17] = "Berry Avenue RP",
		[18] = "Blade Ball",
		[19] = "Dress to Impress",
		[20] = "Grow a Garden",
	}

	local pickInfo = perBox:AddLabel("", true)
	local function refreshPickInfo()
		local idx = tonumber((tostring(Options.IslandPick.Value):match("Island (%d+)")))
		if not idx then
			pickInfo:SetText("")
			return
		end
		pickInfo:SetText(
			"Game: "
				.. tostring(ISLAND_GAME_NAMES[idx] or "-")
				.. "\nQuest: "
				.. tostring(ISLANDS[idx] and ISLANDS[idx].label or "-")
		)
	end
	Options.IslandPick:OnChanged(refreshPickInfo)
	refreshPickInfo()

	for i = 1, 20 do
		local info = G.HUNT_REWARD_INFO[i] or {}
		info.game = info.game or ISLAND_GAME_NAMES[i]
		info.placeId = info.placeId or ISLAND_GAMES[i]
		info.badgeId = info.badgeId or ISLAND_BADGES[i]
		G.HUNT_REWARD_INFO[i] = info
	end

	local function queueAutoload()
		local queue = queue_on_teleport or queueonteleport
		if queue and not G.HUNT_AUTOLOAD_QUEUED then
			G.HUNT_AUTOLOAD_QUEUED = true
			queue(HUNT_QUEUE_SOURCE)
		end
	end
	queueAutoload()

	local gameTeleporting = false
	perBox:AddButton({
		Text = "Go to island's game",
		Func = function()
			if gameTeleporting then
				return
			end
			local idx = tonumber((Options.IslandPick.Value:match("Island (%d+)")))
			local placeId = idx and ISLAND_GAMES[idx]
			local remote = game:GetService("ReplicatedStorage"):FindFirstChild("TeleportRequest")
			if not placeId or not remote then
				Library:Notify("No game/teleport remote for that island", 4)
				return
			end
			gameTeleporting = true
			queueAutoload()
			task.spawn(function()
				local ok, success, err = pcall(function()
					return remote:InvokeServer(placeId)
				end)
				if not ok or not success then
					gameTeleporting = false
					Library:Notify("Teleport failed: " .. tostring(ok and err or success), 5)
				end
			end)
		end,
	})

	local placesBox = TabFarm:AddRightGroupbox("Places")
	placesBox:AddButton({
		Text = "Founders office",
		Func = function()
			local lp = game:GetService("Players").LocalPlayer
			local char = lp.Character
			if not char then
				return
			end
			local pos = Vector3.new(990, 12, 340)
			pcall(function()
				lp:RequestStreamAroundAsync(pos)
			end)
			char:PivotTo(CFrame.new(pos))
		end,
	})
	placesBox:AddButton({
		Text = "Infinity",
		Func = function()
			local lp = game:GetService("Players").LocalPlayer
			local char = lp.Character
			if not char then
				return
			end
			local pos = Vector3.new(-1835.6, 505, -3721.6)
			pcall(function()
				lp:RequestStreamAroundAsync(pos)
			end)
			char:PivotTo(CFrame.new(pos))
		end,
	})
	placesBox:AddLabel(
		"Founders office: the void room with the obby. Infinity: the 2026 area with every year's touchstone.",
		true
	)

	local statusBox = TabStatus:AddLeftGroupbox("Quest status")
	statusBox:AddLabel("Quest turn-in does NOT unlock the podium.", true)
	local totalLabel = statusBox:AddLabel("Quests completed: 0/20", true)
	local claimedLabel = statusBox:AddLabel("UGC actually claimed: 0/20", true)

	local updateIsland, updateTotals

	local claiming = false
	local function autoClaim()
		if claiming or not updateIsland then
			return
		end
		claiming = true
		local origin = hrpNow() and hrpNow().CFrame
		local moved = false
		for i = 1, 20 do
			if not (Toggles.AutoClaimToggle and Toggles.AutoClaimToggle.Value) then
				break
			end
			if not G.HUNT_CLAIMED[i] and ISLAND_BADGES[i] then
				local ok, has = pcall(function()
					return BadgeService:UserHasBadgeAsync(LocalPlayer.UserId, ISLAND_BADGES[i])
				end)
				if ok then
					G.HUNT_HAS_BADGE[i] = has
				end
				if ok and has then
					moved = true
					local claimed, err = claimReward(i)
					log(
						"Island " .. i,
						claimed and ("UGC claimed" .. (err and (" (" .. err .. ")") or ""))
							or ("claim failed: " .. tostring(err))
					)
				end
				updateIsland(i)
				updateTotals()
			end
		end
		if moved and origin and hrpNow() then
			hrpNow().CFrame = origin
		end
		claiming = false
	end

	statusBox:AddToggle("AutoClaimToggle", {
		Text = "Auto-claim UGC",
		Default = true,
		Callback = function(value)
			if value then
				task.spawn(autoClaim)
			end
		end,
	})
	statusBox:AddDivider()

	local islandLabels = {}
	local rewardLabels = {}
	for i = 1, 20 do
		islandLabels[i] = statusBox:AddLabel("...", true)
		rewardLabels[i] = statusBox:AddLabel("...", true)
	end

	updateIsland = function(i)
		local isl = ISLANDS[i]
		local prog = attr(isl.progressFlag)
		local turned = attr(isl.turnInFlag) >= 1
		local started = attr(isl.startFlag) >= 1
		local state
		if turned then
			state = "quest DONE"
		elseif started then
			state = "quest " .. comma(math.min(prog, isl.count)) .. "/" .. comma(isl.count)
		else
			state = "quest not started"
		end
		local mark = turned and "[x]" or "[ ]"
		islandLabels[i]:SetText(mark .. " I" .. i .. " " .. isl.label .. ": " .. state)

		local info = G.HUNT_REWARD_INFO[i]
		local hasBadge = G.HUNT_HAS_BADGE[i]
		local claimed = G.HUNT_CLAIMED[i]
		local rewardState
		if claimed then
			rewardState = "UGC CLAIMED"
		elseif hasBadge == nil then
			rewardState = "checking badge..."
		elseif hasBadge then
			rewardState = "badge earned, not claimed"
		else
			local game = tostring(info.game or "cross-game challenge")
			if #game > 26 then
				game = game:sub(1, 25) .. "\xE2\x80\xA6"
			end
			rewardState = "needs badge: " .. game
		end
		local rmark = claimed and "    [x]" or "    [ ]"
		rewardLabels[i]:SetText(rmark .. " " .. rewardState)
	end

	updateTotals = function()
		local done, claimedCount = 0, 0
		for i = 1, 20 do
			if attr(ISLANDS[i].turnInFlag) >= 1 then
				done = done + 1
			end
			if G.HUNT_CLAIMED[i] then
				claimedCount = claimedCount + 1
			end
		end
		totalLabel:SetText("Quests completed: " .. comma(done) .. "/20")
		claimedLabel:SetText("UGC actually claimed: " .. comma(claimedCount) .. "/20")
	end

	if G.HUNT_CONNS then
		for _, c in G.HUNT_CONNS do
			pcall(function()
				c:Disconnect()
			end)
		end
	end
	G.HUNT_CONNS = {}

	for i = 1, 20 do
		updateIsland(i)
		local isl = ISLANDS[i]
		local seen = {}
		for _, flag in ipairs({ isl.startFlag, isl.progressFlag, isl.turnInFlag }) do
			if not seen[flag] then
				seen[flag] = true
				table.insert(
					G.HUNT_CONNS,
					LocalPlayer:GetAttributeChangedSignal(ATT .. flag):Connect(function()
						updateIsland(i)
						updateTotals()
					end)
				)
			end
		end
	end
	updateTotals()

	G.HUNT_API = {
		farmIsland = farmIsland,
		farmAll = farmAll,
		arrive = arrive,
		islands = ISLANDS,
		status = function()
			local done = 0
			for i = 1, 20 do
				if attr(ISLANDS[i].turnInFlag) >= 1 then
					done = done + 1
				end
			end
			return done
		end,
	}

	log("Hunt farm loaded - all 20 islands mapped (island 9 is real-platforming, best-effort only)")

	if Toggles.AutoClaimToggle and Toggles.AutoClaimToggle.Value then
		task.spawn(autoClaim)
	end
end

local function runHeights()
	if game.PlaceId ~= 47324 then
		return
	end

	local Players = game:GetService("Players")
	local HttpService = game:GetService("HttpService")
	local TeleportService = game:GetService("TeleportService")

	repeat
		task.wait()
	until game:IsLoaded()

	local LocalPlayer = Players.LocalPlayer
	local G = getgenv()

	do
		local queue = queue_on_teleport or queueonteleport
		if queue and not G.HUNT_AUTOLOAD_QUEUED then
			G.HUNT_AUTOLOAD_QUEUED = true
			queue(HUNT_QUEUE_SOURCE)
		end
	end

	local HUB_PLACE = 74205509034203
	local CACHE_FILE = "heights_sword_textures.json"
	local SWORD_ORDER = { "IceDagger", "Firebrand", "Venomshank", "Windforce", "Illumina", "Ghostwalker", "Darkheart" }
	local SWORDS = {}
	for _, n in SWORD_ORDER do
		SWORDS[n] = true
	end

	if G.SWORDESP_CONNS then
		for _, c in G.SWORDESP_CONNS do
			pcall(function()
				c:Disconnect()
			end)
		end
	end
	if G.SWORDESP_ENTRIES then
		for _, e in G.SWORDESP_ENTRIES do
			pcall(function()
				e:Destroy()
			end)
		end
	end
	G.SWORDESP_CONNS = {}
	G.SWORDESP_ENTRIES = {}
	G.SWORDESP_ENABLED = true

	if not G.MSESP then
		local ok, lib = pcall(function()
			getgenv().mstudio45_ESP = nil
			local src = game:HttpGet("https://raw.githubusercontent.com/mstudio45/MSESP/main/source.luau")
			src = src:gsub("CoreGuiAllowed = successCoreGui and CoreGui ~= nil;", "CoreGuiAllowed = false;")
			return loadstring(src)()
		end)
		if ok then
			G.MSESP = lib
		end
	end
	local ESP = G.MSESP
	if ESP then
		ESP.GlobalConfig.Boxes2D = false
		ESP.GlobalConfig.Boxes3D = false
		ESP.GlobalConfig.Skeleton = false
		ESP.GlobalConfig.Arrows = false
		ESP.GlobalConfig.Tracers = false
		ESP.GlobalConfig.Rainbow = false
		ESP.GlobalConfig.Highlighters = true
		ESP.GlobalConfig.Billboards = true
		ESP.GlobalConfig.Distance = true
	end

	local function assetId(url)
		return url and tostring(url):match("(%d+)") or nil
	end

	local textures = {
		IceDagger = "83689547",
		Venomshank = "82741319",
	}
	pcall(function()
		if isfile and isfile(CACHE_FILE) then
			for k, v in HttpService:JSONDecode(readfile(CACHE_FILE)) do
				textures[k] = v
			end
		end
	end)

	local function saveTextures()
		pcall(function()
			if writefile then
				writefile(CACHE_FILE, HttpService:JSONEncode(textures))
			end
		end)
	end

	local function discovered()
		return LocalPlayer:GetAttribute("QuestSwordsDiscovered") or 0
	end

	local function questDone()
		return discovered() >= 3
	end

	local function collectedSet()
		local set = {}
		for i = 1, 3 do
			local id = assetId(LocalPlayer:GetAttribute("QuestSwordIcon" .. i))
			if id then
				for name, tex in textures do
					if tex == id then
						set[name] = true
					end
				end
			end
		end
		return set
	end

	local function swordName(inst)
		if inst.Name:sub(1, 6) ~= "Proxy_" then
			return nil
		end
		local name = inst.Name:sub(7)
		return SWORDS[name] and name or nil
	end

	local function remove(inst)
		local e = G.SWORDESP_ENTRIES[inst]
		if e then
			pcall(function()
				e:Destroy()
			end)
			G.SWORDESP_ENTRIES[inst] = nil
		end
	end

	local function add(inst)
		if not ESP or not G.SWORDESP_ENABLED then
			return
		end
		local name = swordName(inst)
		if not name or G.SWORDESP_ENTRIES[inst] then
			return
		end
		if questDone() or collectedSet()[name] then
			return
		end
		local ok, e = pcall(function()
			return ESP:Add({
				Model = inst,
				Name = name,
				Color = Color3.fromRGB(80, 255, 120),
				ESPType = "Highlight",
				FillTransparency = 0.4,
				OutlineTransparency = 0,
				MaxDistance = 5000,
			})
		end)
		if ok and e then
			G.SWORDESP_ENTRIES[inst] = e
		end
	end

	local updateLabels

	local function refresh()
		local done = questDone()
		local collected = collectedSet()
		for inst in G.SWORDESP_ENTRIES do
			local name = swordName(inst)
			if not G.SWORDESP_ENABLED or done or not inst.Parent or (name and collected[name]) then
				remove(inst)
			end
		end
		if G.SWORDESP_ENABLED and not done then
			for _, inst in workspace:GetChildren() do
				add(inst)
			end
		end
		if updateLabels then
			updateLabels()
		end
	end

	local function learnTool(tool)
		if tool:IsA("Tool") and SWORDS[tool.Name] then
			local id = assetId(tool.TextureId)
			if id and textures[tool.Name] ~= id then
				textures[tool.Name] = id
				saveTextures()
				refresh()
			end
		end
	end

	local function watchContainer(container)
		for _, t in container:GetChildren() do
			learnTool(t)
		end
		table.insert(G.SWORDESP_CONNS, container.ChildAdded:Connect(learnTool))
	end

	if G.HEIGHTS_LIB then
		pcall(function()
			G.HEIGHTS_LIB:Unload()
		end)
		G.HEIGHTS_LIB = nil
	end

	local Library =
		loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/main/Library.lua"))()
	G.HEIGHTS_LIB = Library

	local Window = Library:CreateWindow({
		Title = "Heights IV",
		Footer = "sword quest",
		Center = true,
		AutoShow = true,
		Size = UDim2.fromOffset(520, 360),
	})

	local Tab = Window:AddTab("Swords")
	addChangelogTab(Window, 2, Library)
	local box = Tab:AddLeftGroupbox("Sword quest")

	local countLabel = box:AddLabel("Swords: -", true)
	local leftLabel = box:AddLabel("Not collected: -", true)
	box:AddDivider()

	box:AddToggle("SwordESPToggle", {
		Text = "Sword ESP",
		Default = true,
		Callback = function(value)
			G.SWORDESP_ENABLED = value
			refresh()
		end,
	})

	local returning = false
	box:AddButton({
		Text = "Return to hub",
		Func = function()
			if returning then
				return
			end
			returning = true
			local queue = queue_on_teleport or queueonteleport
			if queue and not G.HUNT_AUTOLOAD_QUEUED then
				G.HUNT_AUTOLOAD_QUEUED = true
				queue(HUNT_QUEUE_SOURCE)
			end
			local ok, err = pcall(function()
				TeleportService:Teleport(HUB_PLACE, LocalPlayer)
			end)
			if not ok then
				returning = false
				Library:Notify("Teleport failed: " .. tostring(err), 4)
			end
		end,
	})

	updateLabels = function()
		local shown = math.min(discovered() + 1, 4)
		if questDone() then
			countLabel:SetText("Swords: 4/4 - quest complete")
			leftLabel:SetText("Nothing left to collect.")
			return
		end
		countLabel:SetText("Swords: " .. shown .. "/4")
		local collected = collectedSet()
		local left = {}
		for _, n in SWORD_ORDER do
			if not collected[n] then
				left[#left + 1] = n
			end
		end
		leftLabel:SetText("Not collected: " .. table.concat(left, ", "))
	end

	table.insert(G.SWORDESP_CONNS, workspace.ChildAdded:Connect(add))
	table.insert(G.SWORDESP_CONNS, workspace.ChildRemoved:Connect(remove))
	for i = 1, 3 do
		table.insert(G.SWORDESP_CONNS, LocalPlayer:GetAttributeChangedSignal("QuestSwordIcon" .. i):Connect(refresh))
	end
	table.insert(G.SWORDESP_CONNS, LocalPlayer:GetAttributeChangedSignal("QuestSwordsDiscovered"):Connect(refresh))

	watchContainer(LocalPlayer:WaitForChild("Backpack"))
	if LocalPlayer.Character then
		watchContainer(LocalPlayer.Character)
	end
	table.insert(G.SWORDESP_CONNS, LocalPlayer.CharacterAdded:Connect(watchContainer))
	table.insert(
		G.SWORDESP_CONNS,
		LocalPlayer.ChildAdded:Connect(function(child)
			if child:IsA("Backpack") then
				watchContainer(child)
			end
		end)
	)

	refresh()
end

local function runBrickBattle()
	local GAMES = {
		[1818] = { name = "Crossroads", island = 1, badge = 4036544995812202 },
		[25415] = { name = "Rocket Arena", island = 3, badge = 2032546335850202 },
		[14403] = { name = "Chaos Canyon", island = 4, badge = 823979884544596 },
	}

	local CONFIG = GAMES[game.PlaceId]
	if not CONFIG then
		return
	end

	local Players = game:GetService("Players")
	local TeleportService = game:GetService("TeleportService")
	local BadgeService = game:GetService("BadgeService")
	local ReplicatedStorage = game:GetService("ReplicatedStorage")
	local RunService = game:GetService("RunService")

	repeat
		task.wait()
	until game:IsLoaded()

	local LocalPlayer = Players.LocalPlayer
	local G = getgenv()

	local HUB_PLACE = 74205509034203
	local AFK_SECONDS = 15
	local AFK_MOVE = 2

	do
		local queue = queue_on_teleport or queueonteleport
		if queue and not G.HUNT_AUTOLOAD_QUEUED then
			G.HUNT_AUTOLOAD_QUEUED = true
			queue(HUNT_QUEUE_SOURCE)
		end
	end

	for _, key in { "ROCKET_CLEANUP", "BB_CLEANUP" } do
		if G[key] then
			pcall(G[key])
			G[key] = nil
		end
	end
	for _, key in { "ROCKET_LIB", "BB_LIB" } do
		if G[key] then
			pcall(function()
				G[key]:Unload()
			end)
			G[key] = nil
		end
	end

	pcall(function()
		local ctx = LocalPlayer:FindFirstChild("BrickBattleInputContext")
		local remote = ctx and ctx:FindFirstChild("SetGamepadAim")
		if remote then
			remote:FireServer(false)
		end
		LocalPlayer:SetAttribute("BrickBattleGamepadAim", false)
	end)

	local conns = {}
	local espEntries = {}
	local afkState = {}

	if not G.MSESP then
		local ok, lib = pcall(function()
			getgenv().mstudio45_ESP = nil
			local src = game:HttpGet("https://raw.githubusercontent.com/mstudio45/MSESP/main/source.luau")
			src = src:gsub("CoreGuiAllowed = successCoreGui and CoreGui ~= nil;", "CoreGuiAllowed = false;")
			return loadstring(src)()
		end)
		if ok then
			G.MSESP = lib
		end
	end
	local ESP = G.MSESP
	if ESP then
		ESP.GlobalConfig.Boxes2D = false
		ESP.GlobalConfig.Boxes3D = false
		ESP.GlobalConfig.Skeleton = false
		ESP.GlobalConfig.Arrows = false
		ESP.GlobalConfig.Tracers = false
		ESP.GlobalConfig.Rainbow = false
		ESP.GlobalConfig.Highlighters = true
		ESP.GlobalConfig.Billboards = true
		ESP.GlobalConfig.Distance = true
	end

	local showSessionOnly = false
	pcall(function()
		local mod = ReplicatedStorage.BrickBattle:FindFirstChild("getFlagShowKOsForThisSessionOnly")
		if mod then
			local f = require(mod)
			showSessionOnly = (type(f) == "function" and f()) or f == true
		end
	end)

	local Library =
		loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/main/Library.lua"))()
	G.BB_LIB = Library

	local Window = Library:CreateWindow({
		Title = CONFIG.name,
		Footer = "island " .. CONFIG.island,
		Center = true,
		AutoShow = true,
		Size = UDim2.fromOffset(560, 300),
	})

	local Tab = Window:AddTab("Main")
	addChangelogTab(Window, CONFIG.island, Library)
	local box = Tab:AddLeftGroupbox("Badge")

	local needLabel = box:AddLabel("Need - KOs for the badge.", true)
	local koLabel = box:AddLabel("KOs: -", true)
	local badgeLabel = box:AddLabel("Badge: checking...", true)
	box:AddDivider()

	local returning = false
	conns[#conns + 1] = TeleportService.TeleportInitFailed:Connect(function(player, _, msg)
		if player ~= LocalPlayer then
			return
		end
		returning = false
		if tostring(msg):find("different creator") then
			Library:Notify(
				"This game blocks teleports to the hub. Leave and join The Hunt from Roblox - the hub UI loads automatically.",
				8
			)
		else
			Library:Notify("Hub teleport failed: " .. tostring(msg), 6)
		end
	end)
	box:AddButton({
		Text = "Return to hub",
		Func = function()
			if returning then
				return
			end
			returning = true
			local ok, err = pcall(function()
				TeleportService:Teleport(HUB_PLACE, LocalPlayer)
			end)
			if not ok then
				returning = false
				Library:Notify("Hub teleport failed: " .. tostring(err), 5)
			end
		end,
	})

	local function isAfk(p)
		local s = afkState[p]
		return s ~= nil and os.clock() - s.lastMove >= AFK_SECONDS
	end

	local function removeEsp(p)
		local e = espEntries[p]
		if e then
			pcall(function()
				e.entry:Destroy()
			end)
			espEntries[p] = nil
		end
	end

	local function addEsp(p)
		if not ESP or p == LocalPlayer or not (Library.Toggles.PlayerESP and Library.Toggles.PlayerESP.Value) then
			return
		end
		local char = p.Character
		if not char then
			return
		end
		removeEsp(p)
		local afk = isAfk(p)
		local ok, e = pcall(function()
			return ESP:Add({
				Model = char,
				Name = (afk and "[AFK] " or "") .. p.DisplayName,
				Color = afk and Color3.fromRGB(255, 220, 60) or Color3.fromRGB(255, 70, 70),
				ESPType = "Highlight",
				FillTransparency = 0.6,
				OutlineTransparency = 0,
				MaxDistance = 2000,
			})
		end)
		if ok and e then
			espEntries[p] = { entry = e, afk = afk }
		end
	end

	local function refreshAllEsp()
		for p in espEntries do
			removeEsp(p)
		end
		for _, p in Players:GetPlayers() do
			addEsp(p)
		end
	end

	local espBox = Tab:AddRightGroupbox("ESP")
	espBox:AddToggle("PlayerESP", {
		Text = "Player ESP",
		Default = true,
		Callback = refreshAllEsp,
	})
	espBox:AddLabel("Yellow = AFK player", true)

	local function watchPlayer(p)
		if p == LocalPlayer then
			return
		end
		conns[#conns + 1] = p.CharacterAdded:Connect(function()
			afkState[p] = nil
			task.wait(0.5)
			addEsp(p)
		end)
		if p.Character then
			addEsp(p)
		end
	end

	for _, p in Players:GetPlayers() do
		watchPlayer(p)
	end
	conns[#conns + 1] = Players.PlayerAdded:Connect(watchPlayer)
	conns[#conns + 1] = Players.PlayerRemoving:Connect(function(p)
		removeEsp(p)
		afkState[p] = nil
	end)

	local afkAccum = 0
	conns[#conns + 1] = RunService.Heartbeat:Connect(function(dt)
		afkAccum += dt
		if afkAccum < 1 then
			return
		end
		afkAccum = 0
		for _, p in Players:GetPlayers() do
			if p ~= LocalPlayer then
				local char = p.Character
				local hrp = char and char:FindFirstChild("HumanoidRootPart")
				if hrp then
					local s = afkState[p]
					if not s or (hrp.Position - s.pos).Magnitude > AFK_MOVE then
						afkState[p] = { pos = hrp.Position, lastMove = os.clock() }
					end
					local entry = espEntries[p]
					if entry and entry.afk ~= isAfk(p) then
						addEsp(p)
					end
				end
			end
		end
	end)

	local function totalKOs()
		local ls = LocalPlayer:FindFirstChild("leaderstats")
		local kos = ls and ls:FindFirstChild("KOs")
		if not kos then
			return 0, nil
		end
		local saved = kos:GetAttribute("savedKOs") or 0
		return showSessionOnly and (saved + kos.Value) or kos.Value, kos
	end

	local function updateBadge()
		task.spawn(function()
			local ok, has = pcall(function()
				return BadgeService:UserHasBadgeAsync(LocalPlayer.UserId, CONFIG.badge)
			end)
			if ok and has then
				badgeLabel:SetText("Badge: EARNED - return to hub to claim")
			elseif ok then
				badgeLabel:SetText("Badge: not yet")
			else
				badgeLabel:SetText("Badge: check failed")
			end
		end)
	end

	local function threshold()
		return workspace:GetAttribute("KOBadgeThreshold")
	end

	local function updateKOs()
		local need = threshold()
		local total = totalKOs()
		if not need then
			needLabel:SetText("KO requirement not set yet.")
			koLabel:SetText("KOs: " .. total)
			return
		end
		needLabel:SetText("Need " .. need .. " KOs for the badge.")
		koLabel:SetText("KOs: " .. math.min(total, need) .. "/" .. need)
		if total >= need then
			updateBadge()
		end
	end

	conns[#conns + 1] = workspace:GetAttributeChangedSignal("KOBadgeThreshold"):Connect(updateKOs)

	task.spawn(function()
		local ls = LocalPlayer:WaitForChild("leaderstats", 30)
		local kos = ls and ls:WaitForChild("KOs", 30)
		if kos then
			conns[#conns + 1] = kos.Changed:Connect(updateKOs)
			conns[#conns + 1] = kos:GetAttributeChangedSignal("savedKOs"):Connect(updateKOs)
			conns[#conns + 1] = kos:GetAttributeChangedSignal("badgeAwarded"):Connect(updateBadge)
		end
		updateKOs()
	end)
	updateBadge()

	G.BB_CLEANUP = function()
		for _, c in conns do
			pcall(function()
				c:Disconnect()
			end)
		end
		table.clear(conns)
		for p in espEntries do
			removeEsp(p)
		end
	end
end

local function runNDS()
	local Players = game:GetService("Players")
	local TeleportService = game:GetService("TeleportService")
	local BadgeService = game:GetService("BadgeService")
	local ReplicatedStorage = game:GetService("ReplicatedStorage")

	local LocalPlayer = Players.LocalPlayer
	local G = getgenv()
	local BADGE = 1950450904039809

	if G.NDS_CLEANUP then
		pcall(G.NDS_CLEANUP)
		G.NDS_CLEANUP = nil
	end
	if G.NDS_LIB then
		pcall(function()
			G.NDS_LIB:Unload()
		end)
		G.NDS_LIB = nil
	end

	local required = 3
	pcall(function()
		required = require(ReplicatedStorage.Modules.RescueEventConfig).RequiredAnimals or 3
	end)

	local conns = {}
	local espEntries = {}
	local alive = true

	if not G.MSESP then
		local ok, lib = pcall(function()
			getgenv().mstudio45_ESP = nil
			local src = game:HttpGet("https://raw.githubusercontent.com/mstudio45/MSESP/main/source.luau")
			src = src:gsub("CoreGuiAllowed = successCoreGui and CoreGui ~= nil;", "CoreGuiAllowed = false;")
			return loadstring(src)()
		end)
		if ok then
			G.MSESP = lib
		end
	end
	local ESP = G.MSESP
	if ESP then
		ESP.GlobalConfig.Boxes2D = false
		ESP.GlobalConfig.Boxes3D = false
		ESP.GlobalConfig.Skeleton = false
		ESP.GlobalConfig.Arrows = false
		ESP.GlobalConfig.Tracers = false
		ESP.GlobalConfig.Rainbow = false
		ESP.GlobalConfig.Highlighters = true
		ESP.GlobalConfig.Billboards = true
		ESP.GlobalConfig.Distance = true
	end

	local NPCs = workspace:WaitForChild("NPCs", 30)

	local function myChar()
		return LocalPlayer.Character
	end

	local function rootOf(m)
		return m:FindFirstChild("HumanoidRootPart") or m.PrimaryPart or m:FindFirstChildWhichIsA("BasePart")
	end

	local function holderOf(m)
		for _, w in m:GetDescendants() do
			if w.Name == "RescueEventCarryWeld" and (w:IsA("Weld") or w:IsA("WeldConstraint")) then
				for _, p in { w.Part0, w.Part1 } do
					if p and not p:IsDescendantOf(m) then
						local char = p:FindFirstAncestorOfClass("Model")
						return Players:GetPlayerFromCharacter(char) or char
					end
				end
			end
		end
		return nil
	end

	local function isAnimal(m)
		return m:IsA("Model") and m:GetAttribute("AnimalType") ~= nil
	end

	local function touchPart(m)
		local t = m:FindFirstChildWhichIsA("TouchTransmitter", true)
		return t and t.Parent
	end

	local function carrying()
		if not NPCs then
			return nil
		end
		for _, m in NPCs:GetChildren() do
			if isAnimal(m) and holderOf(m) == LocalPlayer then
				return m
			end
		end
		return nil
	end

	local function freeAnimals()
		local out = {}
		if not NPCs then
			return out
		end
		for _, m in NPCs:GetChildren() do
			if isAnimal(m) and not holderOf(m) and touchPart(m) and rootOf(m) then
				out[#out + 1] = m
			end
		end
		return out
	end

	local function penHitbox()
		local world = workspace:FindFirstChild("RescueEventWorld")
		local pen = world and world:FindFirstChild("LobbyPen")
		return pen and pen:FindFirstChild("Hitbox")
	end

	local function count()
		return LocalPlayer:GetAttribute("RescueEvent_AnimalCount") or 0
	end

	local function done()
		return LocalPlayer:GetAttribute("RescueEvent_MainComplete") == true or count() >= required
	end

	local Library =
		loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/main/Library.lua"))()
	G.NDS_LIB = Library

	local Window = Library:CreateWindow({
		Title = "NDS Rescue",
		Footer = "Natural Disaster Survival - island 6",
		Center = true,
		AutoShow = true,
		Size = UDim2.fromOffset(600, 320),
	})

	local Tab = Window:AddTab("Main")
	addChangelogTab(Window, 6, Library)
	local box = Tab:AddLeftGroupbox("Animal Rescue")
	local countLabel = box:AddLabel("Rescued: -", true)
	local stateLabel = box:AddLabel("Status: idle", true)
	local badgeLabel = box:AddLabel("Badge: checking...", true)
	box:AddDivider()

	local function setState(s)
		stateLabel:SetText("Status: " .. s)
	end

	local function updateBadge()
		task.spawn(function()
			local ok, has = pcall(function()
				return BadgeService:UserHasBadgeAsync(LocalPlayer.UserId, BADGE)
			end)
			if ok and has then
				badgeLabel:SetText("Badge: EARNED - return to hub to claim")
			elseif ok then
				badgeLabel:SetText("Badge: not yet")
			else
				badgeLabel:SetText("Badge: check failed")
			end
		end)
	end

	local function updateCount()
		countLabel:SetText("Rescued: " .. math.min(count(), required) .. "/" .. required)
		if done() then
			updateBadge()
		end
	end

	conns[#conns + 1] = LocalPlayer:GetAttributeChangedSignal("RescueEvent_AnimalCount"):Connect(updateCount)
	conns[#conns + 1] = LocalPlayer:GetAttributeChangedSignal("RescueEvent_MainComplete"):Connect(updateCount)
	updateCount()
	updateBadge()

	local function tp(cf)
		local char = myChar()
		local hrp = char and char:FindFirstChild("HumanoidRootPart")
		if hrp then
			hrp.AssemblyLinearVelocity = Vector3.zero
			hrp.CFrame = cf
		end
		return hrp
	end

	local function tryPickup(m)
		local part = touchPart(m)
		local root = rootOf(m)
		if not part or not root then
			return false
		end
		local hrp = tp(root.CFrame + Vector3.new(0, 2.5, 0))
		if not hrp then
			return false
		end
		pcall(firetouchinterest, hrp, part, 0)
		task.wait(0.05)
		pcall(firetouchinterest, hrp, part, 1)
		local t0 = os.clock()
		repeat
			task.wait(0.1)
		until carrying() or (holderOf(m) and holderOf(m) ~= LocalPlayer) or not m.Parent or os.clock() - t0 > 2
		return carrying() ~= nil
	end

	local function tryDeposit()
		local hit = penHitbox()
		if not hit then
			return false
		end
		local before = count()
		local hrp = tp(hit.CFrame + Vector3.new(0, 3, 0))
		if not hrp then
			return false
		end
		local t0 = os.clock()
		repeat
			if hit:FindFirstChildWhichIsA("TouchTransmitter") then
				pcall(firetouchinterest, hrp, hit, 0)
				task.wait(0.05)
				pcall(firetouchinterest, hrp, hit, 1)
			end
			task.wait(0.25)
			tp(hit.CFrame + Vector3.new(0, 3, 0))
		until count() > before or not carrying() or os.clock() - t0 > 3
		return count() > before
	end

	local roundOver = true
	local roundOverAt = 0
	local failedAt = setmetatable({}, { __mode = "k" })
	local roundRemote = ReplicatedStorage:FindFirstChild("Remotes")
		and ReplicatedStorage.Remotes:FindFirstChild("Round")
	if roundRemote then
		conns[#conns + 1] = roundRemote.OnClientEvent:Connect(function(kind)
			if kind == "Display Survivors" then
				roundOver = true
				roundOverAt = os.clock()
			elseif kind == "Warn Disaster" then
				roundOver = false
			end
		end)
	end

	local function rescueStep()
		if done() then
			setState("complete")
			return
		end
		local held = carrying()
		if held then
			local hit = penHitbox()
			local me = myChar() and myChar():FindFirstChild("HumanoidRootPart")
			if hit and me and (me.Position - hit.Position).Magnitude > 20 then
				tp(hit.CFrame + Vector3.new(0, 3, 0))
			end
			if not roundOver then
				setState("carrying " .. held.Name .. " - waiting in lobby for round end")
				return
			end
			if os.clock() - roundOverAt < 3 then
				setState("round over - letting lobby respawn settle")
				return
			end
			setState("round over - depositing " .. held.Name)
			if tryDeposit() then
				setState("deposited")
			elseif os.clock() - roundOverAt > 25 then
				roundOver = false
			end
			return
		end
		local list = freeAnimals()
		if #list == 0 then
			setState("no free animals - waiting for round")
			return
		end
		local char = myChar()
		local hrp = char and char:FindFirstChild("HumanoidRootPart")
		if hrp then
			table.sort(list, function(a, b)
				return (rootOf(a).Position - hrp.Position).Magnitude < (rootOf(b).Position - hrp.Position).Magnitude
			end)
		end
		local target
		for _, m in list do
			if (failedAt[m] or 0) < os.clock() - 10 then
				target = m
				break
			end
		end
		if not target then
			setState("free animals unreachable - retrying soon")
			return
		end
		setState("grabbing " .. target.Name)
		if tryPickup(target) then
			setState("picked up " .. (carrying() or target).Name)
			roundOver = false
		else
			failedAt[target] = os.clock()
			setState("pickup failed on " .. target.Name)
		end
	end

	box:AddToggle("AutoRescue", {
		Text = "Auto rescue animals",
		Default = false,
	})

	task.spawn(function()
		while alive do
			if Library.Toggles.AutoRescue and Library.Toggles.AutoRescue.Value then
				local ok, err = pcall(rescueStep)
				if not ok then
					setState("error: " .. tostring(err))
				end
			end
			task.wait(0.5)
		end
	end)

	local returning = false
	conns[#conns + 1] = TeleportService.TeleportInitFailed:Connect(function(player, _, msg)
		if player ~= LocalPlayer then
			return
		end
		returning = false
		if tostring(msg):find("different creator") or tostring(msg):find("Unauthorized") then
			Library:Notify("This game blocks teleports to the hub. Leave and join The Hunt from Roblox.", 8)
		else
			Library:Notify("Hub teleport failed: " .. tostring(msg), 6)
		end
	end)
	box:AddButton({
		Text = "Return to hub",
		Func = function()
			if returning then
				return
			end
			returning = true
			local ok, err = pcall(function()
				TeleportService:Teleport(HUB_PLACE, LocalPlayer)
			end)
			if not ok then
				returning = false
				Library:Notify("Hub teleport failed: " .. tostring(err), 5)
			end
		end,
	})

	local function removeEsp(m)
		local e = espEntries[m]
		if e then
			pcall(function()
				e.entry:Destroy()
			end)
			espEntries[m] = nil
		end
	end

	local function espWanted(m)
		local h = holderOf(m)
		if h == LocalPlayer then
			return "mine"
		elseif h then
			return "held"
		end
		return "free"
	end

	local COLORS = {
		free = Color3.fromRGB(80, 255, 120),
		held = Color3.fromRGB(255, 80, 80),
		mine = Color3.fromRGB(80, 170, 255),
	}

	local function refreshEsp(m)
		if not ESP or not (Library.Toggles.AnimalESP and Library.Toggles.AnimalESP.Value) then
			removeEsp(m)
			return
		end
		if not m.Parent or not isAnimal(m) then
			removeEsp(m)
			return
		end
		local state = espWanted(m)
		local cur = espEntries[m]
		if cur and cur.state == state then
			return
		end
		removeEsp(m)
		local h = holderOf(m)
		local label = m.Name
		if state == "held" then
			label = m.Name
				.. " [held"
				.. (typeof(h) == "Instance" and h:IsA("Player") and (": " .. h.DisplayName) or "")
				.. "]"
		elseif state == "mine" then
			label = m.Name .. " [carrying]"
		end
		local ok, e = pcall(function()
			return ESP:Add({
				Model = m,
				Name = label,
				Color = COLORS[state],
				ESPType = "Highlight",
				FillTransparency = 0.6,
				OutlineTransparency = 0,
				MaxDistance = 5000,
			})
		end)
		if ok and e then
			espEntries[m] = { entry = e, state = state }
		end
	end

	local function refreshAll()
		if not NPCs then
			return
		end
		for m in espEntries do
			if not m.Parent then
				removeEsp(m)
			end
		end
		for _, m in NPCs:GetChildren() do
			refreshEsp(m)
		end
	end

	local espBox = Tab:AddRightGroupbox("ESP")
	espBox:AddToggle("AnimalESP", {
		Text = "Animal ESP",
		Default = true,
		Callback = function()
			for m in espEntries do
				removeEsp(m)
			end
			refreshAll()
		end,
	})
	espBox:AddLabel("Green = free, red = held by someone, blue = yours", true)

	local function watchAnimal(m)
		if not isAnimal(m) then
			return
		end
		conns[#conns + 1] = m.DescendantAdded:Connect(function(d)
			if d.Name == "RescueEventCarryWeld" then
				task.defer(refreshEsp, m)
			end
		end)
		conns[#conns + 1] = m.DescendantRemoving:Connect(function(d)
			if d.Name == "RescueEventCarryWeld" then
				task.defer(refreshEsp, m)
			end
		end)
		refreshEsp(m)
	end

	if NPCs then
		for _, m in NPCs:GetChildren() do
			watchAnimal(m)
		end
		conns[#conns + 1] = NPCs.ChildAdded:Connect(function(m)
			task.wait(0.3)
			watchAnimal(m)
		end)
		conns[#conns + 1] = NPCs.ChildRemoved:Connect(removeEsp)
	end

	G.NDS_CLEANUP = function()
		alive = false
		for _, c in conns do
			pcall(function()
				c:Disconnect()
			end)
		end
		table.clear(conns)
		for m in espEntries do
			removeEsp(m)
		end
	end
	Library:OnUnload(function()
		if G.NDS_CLEANUP then
			G.NDS_CLEANUP()
			G.NDS_CLEANUP = nil
		end
	end)
end

local function patchBaseWarsAntiCheat()
	local G = getgenv()
	if G.BW_AC_PATCHED then
		return true, G.BW_AC_PATCHED
	end
	local renvG = getrenv()._G
	local noop = function() end
	local patched = {}
	local TARGETS = { Kill = true, BypassDetected = true, FireESignal = true, FireXSignal = true }
	for _, f in getgc(false) do
		if type(f) == "function" and islclosure(f) then
			local okName, name = pcall(debug.info, f, "n")
			if okName and TARGETS[name] then
				local src = debug.info(f, "s")
				if src:find("Animate", 1, true) or src:find("Client_ClientGameloop", 1, true) then
					if pcall(hookfunction, f, noop) then
						patched[#patched + 1] = name
					end
				end
			end
		end
	end
	local shoot = renvG.ShootProjSignal
	if type(shoot) == "function" then
		for _, up in debug.getupvalues(shoot) do
			if type(up) == "table" then
				local mt = getrawmetatable(up)
				local idx = mt and rawget(mt, "__index")
				if type(idx) == "table" and type(rawget(idx, "FireExploitDetection")) == "function" then
					for _, key in { "FireExploitDetection", "FireOnExploitDetected" } do
						local fn = rawget(idx, key)
						if type(fn) == "function" and pcall(hookfunction, fn, noop) then
							patched[#patched + 1] = key
						end
					end
				end
			end
		end
	end
	if #patched == 0 then
		return false, "no anti-cheat functions found"
	end
	G.BW_AC_PATCHED = table.concat(patched, ", ")
	return true, G.BW_AC_PATCHED
end

local function runBaseWars()
	local Players = game:GetService("Players")
	local RunService = game:GetService("RunService")
	local ReplicatedStorage = game:GetService("ReplicatedStorage")
	local UserInputService = game:GetService("UserInputService")

	local LocalPlayer = Players.LocalPlayer
	local Camera = workspace.CurrentCamera
	local G = getgenv()
	local renvG = getrenv()._G
	local INFO = HUNT_ISLAND_PLACES[BASEWARS_PLACE]

	if G.BWR_CLEANUP then
		pcall(G.BWR_CLEANUP)
		G.BWR_CLEANUP = nil
	end
	if G.BWR_LIB then
		pcall(function()
			G.BWR_LIB:Unload()
		end)
		G.BWR_LIB = nil
	end

	repeat
		task.wait(0.25)
	until type(renvG.ShootProjSignal) == "function"

	local acOk, acInfo = patchBaseWarsAntiCheat()

	local conns = {}
	local state = {
		silent = false,
		fov = 150,
		visibleOnly = true,
		showFov = true,
		rofMult = 2,
		rofOn = false,
		noSpread = false,
		noDrop = false,
	}

	local ESP = loadMSESP()
	local Library =
		loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/main/Library.lua"))()
	G.BWR_LIB = Library

	local Window = Library:CreateWindow({
		Title = "Base Wars",
		Footer = "island " .. INFO[1],
		Center = true,
		AutoShow = true,
		Size = UDim2.fromOffset(640, 420),
	})

	local TabQuest = Window:AddTab("Quest")
	local TabCombat = Window:AddTab("Combat")
	local TabEsp = Window:AddTab("ESP")
	addChangelogTab(Window, 7, Library)

	local questBox = TabQuest:AddLeftGroupbox("Skirmish quest")
	local progressLabel = questBox:AddLabel("Progress: -", true)
	local skirmishLabel = questBox:AddLabel("Skirmish: -", true)
	local timeLabel = questBox:AddLabel("Time: -", true)
	local scoreLabel = questBox:AddLabel("Score: -", true)
	local refreshBadge = addBadgeLabel(questBox, INFO[3])
	questBox:AddDivider()
	addReturnToHub(Library, questBox, conns)

	local noteBox = TabQuest:AddRightGroupbox("Note")
	noteBox:AddLabel(
		"You don't have to fight. Just sit AFK in-game while Skirmishes run: a loss still counts 50%, so two Skirmishes finish the quest (one if your team wins).",
		true
	)
	noteBox:AddDivider()
	noteBox:AddLabel(
		"Anti-cheat: " .. (acOk and ("patched (" .. tostring(acInfo) .. ")") or ("NOT patched - " .. tostring(acInfo))),
		true
	)

	local function updateProgress()
		local p = LocalPlayer:GetAttribute("BW20_QuestProgress") or 0
		progressLabel:SetText("Progress: " .. math.min(p, 100) .. "/100")
		if p >= 100 then
			refreshBadge()
		end
	end
	conns[#conns + 1] = LocalPlayer:GetAttributeChangedSignal("BW20_QuestProgress"):Connect(updateProgress)
	updateProgress()

	local alertData = ReplicatedStorage:WaitForChild("ClientSideEngine", 10)
	alertData = alertData and alertData:WaitForChild("AlertObjectiveSystem", 10)
	alertData = alertData and alertData:WaitForChild("CurrentAlertData", 10)

	local function updateAlert()
		if not alertData then
			return
		end
		local name = tostring(alertData:GetAttribute("CurrentAlertName") or "-")
		skirmishLabel:SetText("Event: " .. name)
		timeLabel:SetText("Time left: " .. tostring(alertData:GetAttribute("Alert_RemainingTime") or "-"))
		local parts = {}
		for _, team in { "Green", "Yellow", "Blue" } do
			local v = alertData:GetAttribute("TeamPoints_" .. team)
			if v ~= nil then
				parts[#parts + 1] = team .. " " .. tostring(v)
			end
		end
		local mine = LocalPlayer.Team and LocalPlayer.Team.Name or "?"
		scoreLabel:SetText("Score: " .. (#parts > 0 and table.concat(parts, " / ") or "-") .. "  (you: " .. mine .. ")")
	end
	if alertData then
		conns[#conns + 1] = alertData.AttributeChanged:Connect(updateAlert)
	end
	updateAlert()

	local function isEnemy(p)
		if p == LocalPlayer then
			return false
		end
		if LocalPlayer.Team and p.Team and p.Team == LocalPlayer.Team then
			return false
		end
		local char = p.Character
		if not char or char:GetAttribute("Spawned") == false then
			return false
		end
		local hp = char:GetAttribute("MainHealth_Current")
		return (type(hp) ~= "number" or hp > 0) and not char:FindFirstChildOfClass("ForceField")
	end

	local function holdingSniper()
		local ctrl = G.BWR_CTRL
		local cs = ctrl and ctrl.CurrentStats
		local wt = cs and cs.WeaponType
		return type(wt) == "string" and wt:find("Sniper") ~= nil
	end

	local function aimPart(char)
		if holdingSniper() then
			local head = char:FindFirstChild("Head")
			if head then
				return head
			end
		end
		return char:FindFirstChild("UpperTorso")
			or char:FindFirstChild("Torso")
			or char:FindFirstChild("HumanoidRootPart")
	end

	local rayParams = RaycastParams.new()
	rayParams.FilterType = Enum.RaycastFilterType.Exclude
	rayParams.IgnoreWater = true

	local function visible(from, part)
		local ignore = { Camera }
		if LocalPlayer.Character then
			ignore[#ignore + 1] = LocalPlayer.Character
		end
		rayParams.FilterDescendantsInstances = ignore
		local dir = part.Position - from
		local hit = workspace:Raycast(from, dir, rayParams)
		return hit == nil or hit.Instance:IsDescendantOf(part.Parent)
	end

	local function screenCenter()
		return UserInputService:GetMouseLocation()
	end

	local function pickTarget(from)
		local best, bestDist = nil, state.fov
		local center = screenCenter()
		for _, p in Players:GetPlayers() do
			if isEnemy(p) then
				local part = aimPart(p.Character)
				if part then
					local sp, onScreen = Camera:WorldToViewportPoint(part.Position)
					if onScreen then
						local d = (Vector2.new(sp.X, sp.Y) - center).Magnitude
						if d < bestDist and (not state.visibleOnly or visible(from, part)) then
							best, bestDist = part, d
						end
					end
				end
			end
		end
		return best
	end

	local function currentProjectileSpeed()
		local ctrl = G.BWR_CTRL
		local cp = ctrl and ctrl.CurrentProperties
		local v = cp and cp.CurrentVelocity
		return (type(v) == "number" and v > 0) and v * 3 or 2250
	end

	local function redirect(dir, origin)
		if not state.silent or typeof(dir) ~= "Vector3" or typeof(origin) ~= "Instance" then
			return dir
		end
		local ok, start = pcall(function()
			if origin.Name == "Camera" then
				return origin.Position + origin.CFrame.LookVector * 5
			end
			return origin.Position
		end)
		if not ok then
			return dir
		end
		local target = pickTarget(start)
		if not target then
			return dir
		end
		local pos = target.Position
		local root = target.Parent:FindFirstChild("HumanoidRootPart")
		if root then
			local t = (pos - start).Magnitude / currentProjectileSpeed()
			pos += root.AssemblyLinearVelocity * t
		end
		local aim = pos - start
		if aim.Magnitude < 0.01 then
			return dir
		end
		return aim.Unit * (dir.Magnitude > 0 and dir.Magnitude or 1)
	end

	G.BWR_ORIG_SHOOT = G.BWR_ORIG_SHOOT or renvG.ShootProjSignal
	local origShoot = G.BWR_ORIG_SHOOT
	renvG.ShootProjSignal = function(dir, origin, ...)
		return origShoot(redirect(dir, origin), origin, ...)
	end
	if type(renvG.ShootProjNew) == "function" then
		G.BWR_ORIG_SHOOTNEW = G.BWR_ORIG_SHOOTNEW or renvG.ShootProjNew
		local origNew = G.BWR_ORIG_SHOOTNEW
		renvG.ShootProjNew = function(dir, origin, ...)
			return origNew(redirect(dir, origin), origin, ...)
		end
	end

	local controllerCache = setmetatable({}, { __mode = "k" })
	local lastScan = 0
	local function findController(tool)
		local cached = controllerCache[tool]
		if cached and rawget(cached, "WeaponTool") == tool then
			return cached
		end
		if os.clock() - lastScan < 1 then
			return nil
		end
		lastScan = os.clock()
		for _, t in getgc(true) do
			if type(t) == "table" then
				local wt = rawget(t, "WeaponTool")
				if wt ~= nil and rawget(t, "FiringParts") ~= nil then
					controllerCache[wt] = t
				end
			end
		end
		return controllerCache[tool]
	end

	local saved = setmetatable({}, { __mode = "k" })
	local function restore(ctrl)
		local s = saved[ctrl]
		if not s then
			return
		end
		local cs = ctrl.CurrentStats
		pcall(function()
			rawset(cs, "MaxSpread", s.MaxSpread)
		end)
		if s.rofStats then
			pcall(function()
				s.rofStats.RoF = s.rof
				if s.minRof ~= nil then
					s.rofStats.MinRoF = s.minRof
				end
			end)
		end
		for ammo, drop in s.drops do
			pcall(function()
				ammo.DropMultiplier = drop
			end)
		end
		saved[ctrl] = nil
	end

	local function applyMods(ctrl)
		local cp, cs = ctrl.CurrentProperties, ctrl.CurrentStats
		if type(cp) ~= "table" or type(cs) ~= "table" then
			return
		end
		local s = saved[ctrl]
		if not s then
			s = { MaxSpread = rawget(cs, "MaxSpread"), drops = {} }
			local rs = cp.RoFStats
			if type(rs) == "table" and type(rs.RoF) == "number" then
				s.rofStats, s.rof, s.minRof = rs, rs.RoF, rs.MinRoF
			end
			saved[ctrl] = s
		end
		if s.rofStats then
			local want = s.rof * (state.rofOn and state.rofMult or 1)
			if s.rofStats.RoF ~= want then
				s.rofStats.RoF = want
				if type(s.minRof) == "number" then
					s.rofStats.MinRoF = s.minRof * (state.rofOn and state.rofMult or 1)
				end
				cp.CurrentFireRate = want
			end
		end
		if state.noSpread then
			rawset(cs, "MaxSpread", 0)
			cp.CurrentSpread = 0
		elseif rawget(cs, "MaxSpread") ~= s.MaxSpread then
			rawset(cs, "MaxSpread", s.MaxSpread)
		end
		local ammoInfo = cs.AmmoInfo
		if type(ammoInfo) == "table" then
			for _, ammo in ammoInfo do
				if type(ammo) == "table" then
					if s.drops[ammo] == nil then
						s.drops[ammo] = ammo.DropMultiplier
					end
					local wantDrop = state.noDrop and 0 or s.drops[ammo]
					if ammo.DropMultiplier ~= wantDrop then
						ammo.DropMultiplier = wantDrop
					end
				end
			end
		end
		if state.noDrop then
			cp.DropMultiplier = 0
		end
	end

	local currentTool
	local function onToolChanged()
		local char = LocalPlayer.Character
		local tool = char and char:FindFirstChildOfClass("Tool")
		if tool == currentTool then
			return
		end
		if G.BWR_CTRL then
			restore(G.BWR_CTRL)
		end
		currentTool = tool
		G.BWR_CTRL = nil
		if tool then
			task.spawn(function()
				for _ = 1, 8 do
					task.wait(0.3)
					if currentTool ~= tool then
						return
					end
					local ctrl = findController(tool)
					if ctrl then
						G.BWR_CTRL = ctrl
						pcall(applyMods, ctrl)
						return
					end
				end
			end)
		end
	end

	local function hookCharacter(char)
		conns[#conns + 1] = char.ChildAdded:Connect(function(c)
			if c:IsA("Tool") then
				onToolChanged()
			end
		end)
		conns[#conns + 1] = char.ChildRemoved:Connect(function(c)
			if c:IsA("Tool") then
				onToolChanged()
			end
		end)
		onToolChanged()
	end
	if LocalPlayer.Character then
		hookCharacter(LocalPlayer.Character)
	end
	conns[#conns + 1] = LocalPlayer.CharacterAdded:Connect(hookCharacter)

	local function reapply()
		local ctrl = G.BWR_CTRL
		if ctrl then
			pcall(applyMods, ctrl)
		end
	end
	task.spawn(function()
		while G.BWR_LIB == Library do
			reapply()
			task.wait(0.5)
		end
	end)

	local fovCircle
	pcall(function()
		fovCircle = Drawing.new("Circle")
		fovCircle.Thickness = 1
		fovCircle.NumSides = 64
		fovCircle.Filled = false
		fovCircle.Transparency = 1
		fovCircle.Color = Color3.fromRGB(255, 255, 255)
		fovCircle.Visible = false
	end)
	conns[#conns + 1] = RunService.RenderStepped:Connect(function()
		Camera = workspace.CurrentCamera
		if fovCircle then
			fovCircle.Visible = state.silent and state.showFov
			fovCircle.Radius = state.fov
			fovCircle.Position = screenCenter()
		end
	end)

	local aimBox = TabCombat:AddLeftGroupbox("Silent aim")
	aimBox:AddToggle("BWSilent", {
		Text = "Silent aim",
		Default = false,
		Callback = function(v)
			state.silent = v
		end,
	})
	aimBox:AddToggle("BWVisible", {
		Text = "Visible targets only",
		Default = true,
		Callback = function(v)
			state.visibleOnly = v
		end,
	})
	aimBox:AddToggle("BWShowFov", {
		Text = "Show FOV circle",
		Default = true,
		Callback = function(v)
			state.showFov = v
		end,
	})
	aimBox:AddSlider("BWFov", {
		Text = "FOV radius",
		Default = 150,
		Min = 25,
		Max = 800,
		Rounding = 0,
		Callback = function(v)
			state.fov = v
		end,
	})
	aimBox:AddLabel(
		"Shots hit the torso (head with snipers) of the enemy nearest your cursor inside the FOV circle. Leads moving targets.",
		true
	)

	local gunBox = TabCombat:AddRightGroupbox("Gun mods")
	gunBox:AddToggle("BWNoSpread", {
		Text = "No spread",
		Default = false,
		Callback = function(v)
			state.noSpread = v
			reapply()
		end,
	})
	gunBox:AddToggle("BWNoDrop", {
		Text = "No bullet drop",
		Default = false,
		Callback = function(v)
			state.noDrop = v
			reapply()
		end,
	})
	gunBox:AddToggle("BWRofOn", {
		Text = "Faster fire rate",
		Default = false,
		Callback = function(v)
			state.rofOn = v
			reapply()
		end,
	})
	gunBox:AddSlider("BWRof", {
		Text = "Fire rate multiplier",
		Default = 2,
		Min = 1,
		Max = 5,
		Rounding = 1,
		Callback = function(v)
			state.rofMult = v
			reapply()
		end,
	})
	gunBox:AddLabel("Mods apply to the gun you are holding and reset when you switch weapons.", true)

	local COLOR_VISIBLE = Color3.fromRGB(255, 60, 60)
	local COLOR_HIDDEN = Color3.fromRGB(255, 255, 255)
	local COLOR_TEAM = Color3.fromRGB(80, 170, 255)

	local espEntries = {}
	local function removeEsp(p)
		local rec = espEntries[p]
		if rec then
			pcall(function()
				rec.entry:Destroy()
			end)
			espEntries[p] = nil
		end
	end
	local function addEsp(p)
		removeEsp(p)
		if not ESP or p == LocalPlayer or not (Library.Toggles.BWEsp and Library.Toggles.BWEsp.Value) then
			return
		end
		local char = p.Character
		if not char then
			return
		end
		local enemy = not (LocalPlayer.Team and p.Team == LocalPlayer.Team)
		if not enemy and not (Library.Toggles.BWEspTeam and Library.Toggles.BWEspTeam.Value) then
			return
		end
		local ok, e = pcall(function()
			return ESP:Add({
				Model = char,
				Name = p.DisplayName,
				Color = enemy and COLOR_HIDDEN or COLOR_TEAM,
				ESPType = "Highlight",
				FillTransparency = 0.6,
				OutlineTransparency = 0,
				MaxDistance = 3000,
			})
		end)
		if ok and e then
			espEntries[p] = { entry = e, enemy = enemy, visible = false }
		end
	end

	local espRay = RaycastParams.new()
	espRay.FilterType = Enum.RaycastFilterType.Exclude
	espRay.IgnoreWater = true
	task.spawn(function()
		while G.BWR_LIB == Library do
			local cam = workspace.CurrentCamera
			local myChar = LocalPlayer.Character
			if cam then
				local from = cam.CFrame.Position
				for p, rec in espEntries do
					if rec.enemy then
						local char = p.Character
						local part = char and (char:FindFirstChild("UpperTorso") or char:FindFirstChild("Head"))
						local vis = false
						if part then
							espRay.FilterDescendantsInstances = { cam, myChar }
							local hit = workspace:Raycast(from, part.Position - from, espRay)
							vis = hit == nil or hit.Instance:IsDescendantOf(char)
						end
						if vis ~= rec.visible then
							rec.visible = vis
							pcall(function()
								rec.entry:SetEveryColor(vis and COLOR_VISIBLE or COLOR_HIDDEN, true)
							end)
						end
					end
				end
			end
			task.wait(0.1)
		end
	end)
	local function refreshEsp()
		for _, p in Players:GetPlayers() do
			addEsp(p)
		end
	end

	local espBox = TabEsp:AddLeftGroupbox("Player ESP")
	espBox:AddToggle("BWEsp", { Text = "Enemy ESP", Default = true, Callback = refreshEsp })
	espBox:AddToggle("BWEspTeam", { Text = "Show teammates", Default = false, Callback = refreshEsp })
	espBox:AddLabel("Enemies: red = visible, white = behind cover. Blue = teammate.", true)

	local function watchPlayer(p)
		if p == LocalPlayer then
			return
		end
		conns[#conns + 1] = p.CharacterAdded:Connect(function()
			task.wait(0.5)
			addEsp(p)
		end)
		conns[#conns + 1] = p:GetPropertyChangedSignal("Team"):Connect(function()
			addEsp(p)
		end)
		addEsp(p)
	end
	for _, p in Players:GetPlayers() do
		watchPlayer(p)
	end
	conns[#conns + 1] = Players.PlayerAdded:Connect(watchPlayer)
	conns[#conns + 1] = Players.PlayerRemoving:Connect(removeEsp)
	conns[#conns + 1] = LocalPlayer:GetPropertyChangedSignal("Team"):Connect(refreshEsp)

	G.BWR_CLEANUP = function()
		for _, c in conns do
			pcall(function()
				c:Disconnect()
			end)
		end
		table.clear(conns)
		for p in espEntries do
			removeEsp(p)
		end
		if fovCircle then
			pcall(function()
				fovCircle:Remove()
			end)
		end
		if G.BWR_CTRL then
			restore(G.BWR_CTRL)
			G.BWR_CTRL = nil
		end
		if G.BWR_ORIG_SHOOT then
			renvG.ShootProjSignal = G.BWR_ORIG_SHOOT
		end
		if G.BWR_ORIG_SHOOTNEW then
			renvG.ShootProjNew = G.BWR_ORIG_SHOOTNEW
		end
	end
	Library:OnUnload(function()
		if G.BWR_CLEANUP then
			G.BWR_CLEANUP()
			G.BWR_CLEANUP = nil
		end
	end)
end

local function runAR2()
	local Players = game:GetService("Players")
	local Lighting = game:GetService("Lighting")
	local LocalPlayer = Players.LocalPlayer
	local G = getgenv()
	local INFO = HUNT_ISLAND_PLACES[AR2_PLACE]

	if G.AR2_CLEANUP then
		pcall(G.AR2_CLEANUP)
		G.AR2_CLEANUP = nil
	end
	if G.AR2_LIB then
		pcall(function()
			G.AR2_LIB:Unload()
		end)
		G.AR2_LIB = nil
	end

	local conns = {}
	local state = { lootRange = 1000, lootRadius = 10 }
	local ESP = loadMSESP()
	local Library =
		loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/main/Library.lua"))()
	G.AR2_LIB = Library

	local Window = Library:CreateWindow({
		Title = "AR2 Survivor",
		Footer = "Apocalypse Rising 2 - island " .. INFO[1],
		Center = true,
		AutoShow = true,
		Size = UDim2.fromOffset(640, 440),
	})
	local TabQuest = Window:AddTab("Quest")
	local TabEsp = Window:AddTab("ESP")

	local stepBox = TabQuest:AddLeftGroupbox("Quest steps")
	local STEPS = {
		{
			key = "Step1",
			title = "1. Find the loot (same life)",
			items = { "Primary weapon", "Backpack", "Melee weapon (?)" },
			tips = {
				[3] = "Picking up a melee weapon isn't enough - equip it (hold it in your hands) for the quest to mark it complete.",
			},
		},
		{ key = "Step2", title = "2. Kill 5 zombies (no dying)", items = { "Zombies" } },
		{ key = "Step3", title = "3. Explore & survive (no dying)", items = { "Studs on foot", "Sunrise or sunset" } },
	}
	local rows = {}
	for si, step in STEPS do
		if si > 1 then
			stepBox:AddDivider()
		end
		stepBox:AddLabel(step.title, true)
		for ii, name in step.items do
			local label = stepBox:AddLabel(name .. ": -", true)
			local tip = step.tips and step.tips[ii]
			if tip and label.TextLabel then
				pcall(function()
					Library:AddTooltip(tip, tip, label.TextLabel)
				end)
			end
			rows[#rows + 1] = { step = step.key, sub = "Step" .. ii, name = name, label = label }
		end
	end
	stepBox:AddDivider()
	local refreshBadge = addBadgeLabel(stepBox, INFO[3])
	addReturnToHub(Library, stepBox, conns)

	local worldBox = TabQuest:AddRightGroupbox("World")
	local clockLabel = worldBox:AddLabel("Time: -", true)
	local nextLabel = worldBox:AddLabel("Next sunrise/sunset: -", true)
	local walkLabel = worldBox:AddLabel("Walked this session: 0 studs", true)
	worldBox:AddDivider()
	worldBox:AddLabel(
		"Tips: dying resets steps 2 and 3. Walk or run - vehicles don't count. Step 3 needs you alive when the sun rises or sets.",
		true
	)

	local function eventContent()
		local pg = LocalPlayer:FindFirstChildOfClass("PlayerGui")
		local mm = pg and pg:FindFirstChild("MainMenu")
		local content = mm and mm:FindFirstChild("Content")
		local ev = content and content:FindFirstChild("Event")
		return ev and ev:FindFirstChild("Content")
	end

	local function progressLabel(row)
		local c = eventContent()
		local step = c and c:FindFirstChild(row.step)
		local prog = step and step:FindFirstChild("Progress")
		local sub = prog and prog:FindFirstChild(row.sub)
		return sub and sub:FindFirstChild("Progress"), prog and prog:FindFirstChild("Unavailable")
	end

	local function comma(n)
		local s = tostring(n)
		repeat
			local k
			s, k = s:gsub("^(%d+)(%d%d%d)", "%1,%2")
		until k == 0
		return s
	end

	local function fmt(text)
		local a, b = tostring(text):match("(%d+)%s*/%s*(%d+)")
		if a then
			local done = tonumber(a) >= tonumber(b)
			return comma(a) .. "/" .. comma(b) .. (done and "  (done)" or "")
		end
		return tostring(text)
	end

	local function refreshRow(row)
		local label, unavailable = progressLabel(row)
		if unavailable and unavailable.Visible then
			row.label:SetText(row.name .. ": locked - finish the previous step")
		elseif label then
			row.label:SetText(row.name .. ": " .. fmt(label.Text))
		else
			row.label:SetText(row.name .. ": -")
		end
	end

	local bound = {}
	local lastBadgeCheck = os.clock()
	local function bindRows()
		for _, row in rows do
			local label, unavailable = progressLabel(row)
			for _, inst in { label, unavailable } do
				if inst and not bound[inst] then
					bound[inst] = true
					if inst:IsA("TextLabel") then
						conns[#conns + 1] = inst:GetPropertyChangedSignal("Text"):Connect(function()
							refreshRow(row)
							if os.clock() - lastBadgeCheck > 20 then
								lastBadgeCheck = os.clock()
								refreshBadge()
							end
						end)
					end
					conns[#conns + 1] = inst:GetPropertyChangedSignal("Visible"):Connect(function()
						refreshRow(row)
					end)
				end
			end
			refreshRow(row)
		end
	end
	bindRows()

	local function hhmm(t)
		local h = math.floor(t) % 24
		local m = math.floor((t % 1) * 60)
		return string.format("%02d:%02d", h, m)
	end

	local lastClock, lastReal, rate = Lighting.ClockTime, os.clock(), nil
	local walked, lastPos = 0, nil
	task.spawn(function()
		while G.AR2_LIB == Library do
			local now, clock = os.clock(), Lighting.ClockTime
			local dt = now - lastReal
			if dt >= 5 then
				local dc = (clock - lastClock) % 24
				if dc > 0 and dc < 6 then
					rate = dc / dt
				end
				lastClock, lastReal = clock, now
			end
			clockLabel:SetText("Time: " .. hhmm(clock) .. ((clock >= 6 and clock < 18) and " (day)" or " (night)"))
			local target = (clock >= 6 and clock < 18) and 18 or 6
			local name = target == 18 and "sunset" or "sunrise"
			local hours = (target - clock) % 24
			if rate and rate > 0 then
				local secs = hours / rate
				local whole = math.floor(secs)
				nextLabel:SetText(
					string.format("Next %s at %s - in %dm %02ds", name, hhmm(target), whole // 60, whole % 60)
				)
			else
				nextLabel:SetText(string.format("Next %s at %s (measuring speed...)", name, hhmm(target)))
			end

			local char = LocalPlayer.Character
			local hrp = char and char:FindFirstChild("HumanoidRootPart")
			local hum = char and char:FindFirstChildOfClass("Humanoid")
			if hrp and hum and hum.Health > 0 and not hum.SeatPart then
				local pos = hrp.Position * Vector3.new(1, 0, 1)
				if lastPos then
					local d = (pos - lastPos).Magnitude
					if d < 60 then
						walked += d
					end
				end
				lastPos = pos
			else
				lastPos = nil
			end
			walkLabel:SetText("Walked this session: " .. comma(math.floor(walked)) .. " studs")
			bindRows()
			task.wait(1)
		end
	end)

	local zombieEntries = {}
	local playerEntries = {}
	local function removeEntry(map, key)
		local e = map[key]
		if e then
			pcall(function()
				e:Destroy()
			end)
			map[key] = nil
		end
	end

	local function addZombie(model)
		removeEntry(zombieEntries, model)
		if not ESP or not (Library.Toggles.ARZombieEsp and Library.Toggles.ARZombieEsp.Value) then
			return
		end
		if not model:IsA("Model") then
			return
		end
		local ok, e = pcall(function()
			return ESP:Add({
				Model = model,
				Name = "Zombie",
				Color = Color3.fromRGB(120, 255, 90),
				ESPType = "Highlight",
				FillTransparency = 0.7,
				OutlineTransparency = 0,
				MaxDistance = 600,
			})
		end)
		if ok and e then
			zombieEntries[model] = e
		end
	end

	local function charOwner(model)
		for _, p in Players:GetPlayers() do
			if p.Character == model then
				return p
			end
		end
		return nil
	end

	local unnamedPlayers = setmetatable({}, { __mode = "k" })
	local function addPlayer(model)
		removeEntry(playerEntries, model)
		if not ESP or not (Library.Toggles.ARPlayerEsp and Library.Toggles.ARPlayerEsp.Value) then
			return
		end
		if not model:IsA("Model") or model == LocalPlayer.Character then
			return
		end
		local owner = charOwner(model)
		if owner == LocalPlayer then
			return
		end
		local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
		local theirRoot = model:FindFirstChild("HumanoidRootPart")
		if not owner and myRoot and theirRoot and (myRoot.Position - theirRoot.Position).Magnitude < 1 then
			return
		end
		local ok, e = pcall(function()
			return ESP:Add({
				Model = model,
				Name = owner and (owner.DisplayName .. " (@" .. owner.Name .. ")") or "Unknown survivor",
				Color = Color3.fromRGB(255, 70, 70),
				ESPType = "Highlight",
				FillTransparency = 0.7,
				OutlineTransparency = 0,
				MaxDistance = 2000,
			})
		end)
		if ok and e then
			playerEntries[model] = e
			unnamedPlayers[model] = owner == nil or nil
		end
	end

	local zombiesFolder = workspace:FindFirstChild("Zombies")
	local charsFolder = workspace:FindFirstChild("Characters")

	local function refreshZombies()
		for m in zombieEntries do
			removeEntry(zombieEntries, m)
		end
		if zombiesFolder then
			for _, m in zombiesFolder:GetChildren() do
				addZombie(m)
			end
		end
	end
	local function refreshPlayers()
		for m in playerEntries do
			removeEntry(playerEntries, m)
		end
		if charsFolder then
			for _, m in charsFolder:GetChildren() do
				addPlayer(m)
			end
		end
	end

	local espBox = TabEsp:AddLeftGroupbox("ESP")
	espBox:AddToggle("ARZombieEsp", { Text = "Zombie ESP", Default = true, Callback = refreshZombies })
	espBox:AddToggle("ARPlayerEsp", { Text = "Player ESP", Default = true, Callback = refreshPlayers })
	espBox:AddLabel("Green = zombie (within 600 studs), red = other survivors.", true)

	local LOOT_CATS = {
		Primary = { toggle = "ARLootPrimary", color = Color3.fromRGB(255, 170, 60), label = "Primary" },
		Secondary = { toggle = "ARLootSecondary", color = Color3.fromRGB(255, 230, 120), label = "Secondary" },
		Backpack = { toggle = "ARLootBackpack", color = Color3.fromRGB(80, 200, 255), label = "Backpack" },
		Melee = { toggle = "ARLootMelee", color = Color3.fromRGB(255, 120, 220), label = "Melee" },
		Consumable = { toggle = "ARLootFood", color = Color3.fromRGB(120, 255, 160), label = "Food/Drink" },
		Ammo = { toggle = "ARLootAmmo", color = Color3.fromRGB(200, 200, 200), label = "Ammo" },
		Other = { toggle = "ARLootOther", color = Color3.fromRGB(170, 170, 255), label = "Loot" },
	}
	local QUEST_COLOR = Color3.fromRGB(255, 215, 0)
	local QUEST_SLOT_ROW = { Primary = "Step1", Backpack = "Step2", Melee = "Step3" }

	local function questNeeds(slot)
		local sub = QUEST_SLOT_ROW[slot]
		if not sub then
			return false
		end
		local c = eventContent()
		local step = c and c:FindFirstChild("Step1")
		local prog = step and step:FindFirstChild("Progress")
		local row = prog and prog:FindFirstChild(sub)
		local label = row and row:FindFirstChild("Progress")
		if not label then
			return true
		end
		local a, b = tostring(label.Text):match("(%d+)%s*/%s*(%d+)")
		return not (a and tonumber(a) >= tonumber(b))
	end

	local entityRegistry, itemDb
	pcall(function()
		local Entities = require(game:GetService("ReplicatedStorage"):FindFirstChild("Client").Libraries.Entities)
		entityRegistry = debug.getupvalue(Entities.Find, 1)
	end)

	local nameCache = setmetatable({}, { __mode = "k" })
	local function itemOf(interactable)
		local cached = nameCache[interactable]
		if cached ~= nil then
			return cached or nil
		end
		local name
		pcall(function()
			local f = interactable.MakePromptInfo
			if not itemDb then
				local db = debug.getupvalue(f, 2)
				if type(db) == "table" then
					itemDb = db
				end
			end
			local info = debug.getupvalue(f, 3)
			name = type(info) == "table" and info.Name or nil
		end)
		nameCache[interactable] = name or false
		return name
	end

	local function categoryOf(name)
		local def = itemDb and itemDb[name]
		if type(def) ~= "table" then
			return "Other", name
		end
		local slot, kind = def.EquipSlot, def.Type
		local display = def.DisplayName or name
		if slot == "Primary" or slot == "Secondary" or slot == "Backpack" or slot == "Melee" then
			return slot, display
		elseif kind == "Consumable" then
			return "Consumable", display
		elseif kind == "Ammo" then
			return "Ammo", display
		end
		return "Other", display
	end

	local lootEntries = {}
	local function dropLoot(model)
		local rec = lootEntries[model]
		if rec then
			pcall(function()
				rec.entry:Destroy()
			end)
			lootEntries[model] = nil
		end
	end
	local function clearLoot()
		for m in lootEntries do
			dropLoot(m)
		end
	end

	local function toggleOn(name)
		local t = Library.Toggles[name]
		return t ~= nil and t.Value == true
	end

	local frameworkCache
	local function framework()
		if frameworkCache then
			return frameworkCache
		end
		for _, t in getgc(true) do
			if type(t) == "table" and rawget(t, "Libraries") and rawget(t, "Interface") then
				local classes = rawget(t, "Classes")
				local players = type(classes) == "table" and rawget(classes, "Players")
				if type(players) == "table" and type(rawget(players, "get")) == "function" then
					frameworkCache = t
					break
				end
			end
		end
		return frameworkCache
	end

	local function capacityOf(name)
		local def = itemDb and itemDb[name]
		local size = type(def) == "table" and def.ContainerSize
		if type(size) == "table" and type(size[1]) == "number" and type(size[2]) == "number" then
			return size[1] * size[2]
		end
		return 0
	end

	local function currentBackpackCapacity()
		local cap = 0
		pcall(function()
			local bp = framework().Classes.Players.get().Character.Inventory.Equipment.Backpack
			local name = bp and bp.Name
			if name then
				cap = capacityOf(name)
			end
		end)
		return cap
	end

	local myGuns = {}
	local myCalibers, myCaliberKey = {}, ""
	local function currentCalibers()
		local set, key, guns = {}, {}, {}
		pcall(function()
			local eq = framework().Classes.Players.get().Character.Inventory.Equipment
			for _, slot in { "Primary", "Secondary" } do
				local item = eq[slot]
				local n = item and item.Name
				local def = n and itemDb and itemDb[n]
				local cal = type(def) == "table" and def.Caliber
				if n then
					guns[#guns + 1] = n
					key[#key + 1] = n
				end
				if type(cal) == "string" then
					set[cal] = true
					key[#key + 1] = cal
				end
			end
		end)
		table.sort(key)
		myGuns = guns
		return set, table.concat(key, "|")
	end

	local function fitsMyGuns(name, def)
		local cal = def.Caliber
		if not (cal and myCalibers[cal]) then
			return false
		end
		if def.SubType ~= "Magazine" then
			return true
		end
		local suffix = name:match("Magazine%s+(.+)$")
		for _, gun in myGuns do
			if suffix then
				if gun:sub(1, #suffix) == suffix or suffix:sub(1, #gun) == gun then
					return true
				end
			elseif name:find(gun, 1, true) then
				return true
			end
		end
		return false
	end

	local knownEmpty = {}
	local function refreshGroundAmounts()
		pcall(function()
			local ground = framework().Classes.Players.get().Character.Inventory.GroundContainer
			for key, occ in ground.Occupants do
				local item = type(occ) == "table" and (rawget(occ, "__item") or occ)
				local amount = type(item) == "table" and rawget(item, "Amount")
				local id = type(item) == "table" and rawget(item, "Id") or key
				if type(amount) == "number" and id then
					knownEmpty[tostring(id)] = amount <= 0 or nil
				end
			end
		end)
	end

	local function isEmptyAmmo(cat, itemId)
		return cat == "Ammo" and itemId ~= nil and knownEmpty[tostring(itemId)] == true
	end

	local MISSING_COLOR = Color3.fromRGB(0, 230, 255)
	local missingSlots, missingKey = {}, ""
	local function currentMissing()
		local set, key = {}, {}
		local ok = pcall(function()
			local eq = framework().Classes.Players.get().Character.Inventory.Equipment
			for _, slot in { "Primary", "Secondary", "Backpack", "Melee" } do
				local item = eq[slot]
				if not (item and item.Name) then
					set[slot] = true
					key[#key + 1] = slot
				end
			end
		end)
		if not ok then
			return {}, ""
		end
		return set, table.concat(key, "|")
	end

	local myCapacity = 0
	local function styleFor(cat, display, name)
		if toggleOn("ARLootMissing") and missingSlots[cat] then
			local extra = ""
			if cat == "Backpack" then
				extra = " (" .. capacityOf(name) .. " slots)"
			end
			return "missing:" .. cat,
				{
					name = "NEED " .. cat:upper() .. ": " .. display .. extra,
					color = MISSING_COLOR,
					fill = 0.35,
					range = math.max(state.lootRange, 1500),
				}
		end
		if cat == "Ammo" then
			local def = itemDb and itemDb[name]
			local cal = type(def) == "table" and def.Caliber
			local fits = type(def) == "table" and fitsMyGuns(name, def)
			if cal then
				display = display .. " (" .. cal .. ")"
			end
			if fits and toggleOn("ARSmartAmmo") then
				return "myammo",
					{
						name = display .. " [For my gun]",
						color = Color3.fromRGB(255, 255, 140),
						fill = 0.5,
						range = state.lootRange,
					}
			end
			if not toggleOn("ARLootAmmo") then
				return nil
			end
		end
		if cat == "Backpack" then
			local cap = capacityOf(name)
			if toggleOn("ARSmartBackpack") and cap <= myCapacity then
				return nil
			end
			display = display .. " (" .. cap .. " slots)"
		end
		if toggleOn("ARLootQuest") and questNeeds(cat) then
			return "quest:" .. cat,
				{
					name = "QUEST: " .. display,
					color = QUEST_COLOR,
					fill = 0.25,
					range = math.max(state.lootRange, 2500),
				}
		end
		local info = LOOT_CATS[cat]
		if info and toggleOn(info.toggle) then
			return "normal:" .. cat,
				{
					name = display .. " [" .. info.label .. "]",
					color = info.color,
					fill = 0.6,
					range = state.lootRange,
				}
		end
		return nil
	end

	local function scanLoot()
		if not ESP or not entityRegistry then
			return
		end
		local seen = {}
		local cap = currentBackpackCapacity()
		if cap ~= myCapacity then
			myCapacity = cap
			clearLoot()
		end
		local cals, calKey = currentCalibers()
		if calKey ~= myCaliberKey then
			myCalibers, myCaliberKey = cals, calKey
			clearLoot()
		end
		local missing, mKey = currentMissing()
		if mKey ~= missingKey then
			missingSlots, missingKey = missing, mKey
			clearLoot()
		end
		refreshGroundAmounts()
		for _, ent in entityRegistry do
			if type(ent) == "table" and (ent.Type == "Loot Node" or ent.Type == "Loot Group") then
				local interactables = rawget(ent, "Interactables")
				if type(interactables) == "table" then
					for itemId, it in interactables do
						local model = type(it) == "table" and rawget(it, "Adornee")
						if typeof(model) == "Instance" and model.Parent then
							local name = itemOf(it)
							if name then
								local cat, display = categoryOf(name)
								local key, style
								if not isEmptyAmmo(cat, itemId) then
									key, style = styleFor(cat, display, name)
								end
								if key then
									seen[model] = true
									local rec = lootEntries[model]
									if rec and rec.key ~= key then
										dropLoot(model)
										rec = nil
									end
									if not rec then
										local ok, e = pcall(function()
											return ESP:Add({
												Model = model,
												Name = style.name,
												Color = style.color,
												ESPType = "Highlight",
												FillTransparency = style.fill,
												OutlineTransparency = 0,
												MaxDistance = style.range,
											})
										end)
										if ok and e then
											lootEntries[model] = { entry = e, key = key }
										end
									end
								end
							end
						end
					end
				end
			end
		end
		for m in lootEntries do
			if not seen[m] then
				dropLoot(m)
			end
		end
	end

	local function rescan()
		clearLoot()
		scanLoot()
	end
	G.AR2_LOOT_DEBUG = function()
		local n = 0
		for _ in lootEntries do
			n += 1
		end
		return {
			calibers = myCaliberKey,
			guns = table.concat(myGuns, ","),
			db = itemDb ~= nil,
			registry = entityRegistry ~= nil,
			framework = framework() ~= nil,
			capacity = myCapacity,
			entries = n,
		}
	end

	local questBox = TabEsp:AddRightGroupbox("Quest ESP")
	questBox:AddToggle("ARLootQuest", { Text = "Quest item ESP", Default = true, Callback = rescan })
	questBox:AddLabel(
		"Gold, long range. Shows only the primary, backpack and melee you still need - each type disappears once the quest counts it.",
		true
	)

	questBox:AddDivider()
	questBox:AddToggle("ARLootMissing", { Text = "Show gear I'm missing", Default = true, Callback = rescan })
	questBox:AddLabel(
		"Cyan. If your primary, secondary, backpack or melee slot is empty, every item for that slot shows until you equip one.",
		true
	)

	local lootBox = TabEsp:AddRightGroupbox("Loot ESP")
	lootBox:AddToggle("ARLootPrimary", { Text = "Primary weapons", Default = false, Callback = rescan })
	lootBox:AddToggle("ARLootSecondary", { Text = "Secondary weapons", Default = false, Callback = rescan })
	lootBox:AddToggle("ARLootBackpack", { Text = "Backpacks", Default = false, Callback = rescan })
	lootBox:AddToggle("ARSmartBackpack", { Text = "Only bigger backpacks", Default = true, Callback = rescan })
	lootBox:AddLabel("Hides backpacks that don't hold more than the one you're wearing.", true)
	lootBox:AddToggle("ARLootMelee", { Text = "Melee weapons", Default = false, Callback = rescan })
	lootBox:AddToggle("ARLootFood", { Text = "Food & drink", Default = false, Callback = rescan })
	lootBox:AddToggle("ARSmartAmmo", { Text = "Ammo for my guns", Default = true, Callback = rescan })
	lootBox:AddLabel(
		"Loose ammo matching your primary/secondary caliber, plus magazines made for those exact guns. Empty mags are skipped.",
		true
	)
	lootBox:AddToggle("ARLootAmmo", { Text = "All ammo", Default = false, Callback = rescan })
	lootBox:AddToggle("ARLootOther", { Text = "Everything else", Default = false, Callback = rescan })
	lootBox:AddSlider("ARLootRange", {
		Text = "Loot range",
		Default = 1000,
		Min = 50,
		Max = 1500,
		Rounding = 0,
		Callback = function(v)
			state.lootRange = v
			rescan()
		end,
	})
	if not entityRegistry then
		lootBox:AddLabel("Loot ESP unavailable: could not reach the game's loot registry.", true)
	end

	local sendInteractUse
	for _, f in getgc(false) do
		if type(f) == "function" and islclosure(f) and debug.info(f, "n") == "sendInteractUse" then
			sendInteractUse = f
			break
		end
	end

	local lootCooldown = setmetatable({}, { __mode = "k" })
	local function autoLootStep()
		if not sendInteractUse or not entityRegistry or not toggleOn("ARAutoLoot") then
			return
		end
		local char = LocalPlayer.Character
		local hrp = char and char:FindFirstChild("HumanoidRootPart")
		if not hrp then
			return
		end
		local radius = state.lootRadius
		local now = os.clock()
		refreshGroundAmounts()
		for _, ent in entityRegistry do
			if type(ent) == "table" and (ent.Type == "Loot Node" or ent.Type == "Loot Group") then
				local interactables = rawget(ent, "Interactables")
				if type(interactables) == "table" then
					for itemId, it in interactables do
						local model = type(it) == "table" and rawget(it, "Adornee")
						if
							typeof(model) == "Instance"
							and model.Parent
							and (lootCooldown[it] or 0) < now
							and (model:GetPivot().Position - hrp.Position).Magnitude <= radius
						then
							local name = itemOf(it)
							if name then
								local cat, display = categoryOf(name)
								local worth = true
								if cat == "Primary" or cat == "Secondary" or cat == "Melee" then
									worth = missingSlots[cat] == true or (toggleOn("ARLootQuest") and questNeeds(cat))
								elseif cat == "Backpack" then
									worth = capacityOf(name) > myCapacity
								end
								if worth and not isEmptyAmmo(cat, itemId) and styleFor(cat, display, name) then
									lootCooldown[it] = now + 3
									pcall(sendInteractUse, it)
									task.wait(0.25)
								end
							end
						end
					end
				end
			end
		end
	end

	local lootActions = TabEsp:AddLeftGroupbox("Auto loot")
	lootActions:AddToggle("ARAutoLoot", { Text = "Auto loot nearby", Default = false })
	lootActions:AddSlider("ARLootRadius", {
		Text = "Pickup radius",
		Default = 10,
		Min = 4,
		Max = 14,
		Rounding = 0,
		Callback = function(v)
			state.lootRadius = v
		end,
	})
	lootActions:AddLabel(
		"Picks up items you walk near - only what your Quest ESP and Loot ESP filters show. You never move; it just presses pickup for you.",
		true
	)
	if not sendInteractUse then
		lootActions:AddLabel("Auto loot unavailable: pickup function not found.", true)
	end

	task.spawn(function()
		while G.AR2_LIB == Library do
			pcall(autoLootStep)
			task.wait(0.4)
		end
	end)

	local corpseEntries = {}
	local corpsesFolder = workspace:FindFirstChild("Corpses")
	local function addCorpse(m)
		removeEntry(corpseEntries, m)
		if not ESP or not toggleOn("ARCorpseEsp") or not m:IsA("Model") then
			return
		end
		if m:GetAttribute("InteractId") == nil then
			return
		end
		local who = m:GetAttribute("UseText")
		local ok, e = pcall(function()
			return ESP:Add({
				Model = m,
				Name = "Corpse" .. (type(who) == "string" and who ~= "" and (": " .. who) or ""),
				Color = Color3.fromRGB(190, 110, 255),
				ESPType = "Highlight",
				FillTransparency = 0.6,
				OutlineTransparency = 0,
				MaxDistance = 2000,
			})
		end)
		if ok and e then
			corpseEntries[m] = e
		end
	end
	local function refreshCorpses()
		for m in corpseEntries do
			removeEntry(corpseEntries, m)
		end
		if corpsesFolder then
			for _, m in corpsesFolder:GetChildren() do
				addCorpse(m)
			end
		end
	end
	espBox:AddToggle("ARCorpseEsp", { Text = "Lootable corpse ESP", Default = true, Callback = refreshCorpses })
	espBox:AddLabel("Purple = dead player's body you can loot.", true)
	if corpsesFolder then
		conns[#conns + 1] = corpsesFolder.ChildAdded:Connect(function(m)
			task.wait(0.5)
			addCorpse(m)
		end)
		conns[#conns + 1] = corpsesFolder.ChildRemoved:Connect(function(m)
			removeEntry(corpseEntries, m)
		end)
	end
	refreshCorpses()

	local function wantItem(name, amount)
		local cat, display = categoryOf(name)
		if cat == "Ammo" and type(amount) == "number" and amount <= 0 then
			return false
		end
		if cat == "Primary" or cat == "Secondary" or cat == "Melee" then
			if not (missingSlots[cat] or (toggleOn("ARLootQuest") and questNeeds(cat))) then
				return false
			end
		elseif cat == "Backpack" then
			if capacityOf(name) <= myCapacity then
				return false
			end
		end
		return styleFor(cat, display, name) ~= nil
	end

	local lootedCorpses = {}
	local function corpseLootStep()
		if not toggleOn("ARAutoLoot") or not toggleOn("ARAutoLootCorpses") or not corpsesFolder then
			return
		end
		local fw = framework()
		local char = LocalPlayer.Character
		local hrp = char and char:FindFirstChild("HumanoidRootPart")
		if not (fw and hrp) then
			return
		end
		local now = os.clock()
		local target, targetId
		for _, m in corpsesFolder:GetChildren() do
			local id = m:GetAttribute("InteractId")
			local root = m:FindFirstChild("HumanoidRootPart") or m:FindFirstChild("UpperTorso")
			if
				id
				and root
				and (lootedCorpses[id] or 0) < now
				and (root.Position - hrp.Position).Magnitude <= math.max(state.lootRadius, 8)
			then
				target, targetId = m, id
				break
			end
		end
		if not target then
			return
		end
		lootedCorpses[targetId] = now + 20
		local Network = fw.Libraries.Network
		local inv = fw.Classes.Players.get().Character.Inventory
		local function findContainer()
			for _, c in inv.Containers do
				if c.Type == "Corpse" then
					return c
				end
			end
			return nil
		end
		local container = findContainer()
		if not container then
			Network:Send("Client Interacted", targetId, false)
			local t0 = os.clock()
			repeat
				task.wait(0.2)
				container = findContainer()
			until container or os.clock() - t0 > 3
		end
		if not container then
			return
		end
		local picks = {}
		for _, occ in container.Occupants do
			local ok, name, amount, id = pcall(function()
				return occ.Name, occ.Amount, occ.Id
			end)
			if ok and name and id and wantItem(name, amount) then
				picks[#picks + 1] = id
			end
		end
		for _, id in picks do
			Network:Send("Inventory Pickup Item", id, container.Id)
			task.wait(0.3)
		end
	end

	lootActions:AddToggle("ARAutoLootCorpses", { Text = "Also loot corpses", Default = true })
	lootActions:AddLabel(
		"Opens bodies you walk up to and takes what your filters want (quest items, missing gear, bigger bags, your ammo, food if on).",
		true
	)
	task.spawn(function()
		while G.AR2_LIB == Library do
			pcall(corpseLootStep)
			task.wait(0.6)
		end
	end)

	local vehicleEntries = {}
	local vehiclesFolder = workspace:FindFirstChild("Vehicles")
	local function addVehicle(m)
		removeEntry(vehicleEntries, m)
		if not ESP or not toggleOn("ARVehicleEsp") or not m:IsA("Model") then
			return
		end
		local ok, e = pcall(function()
			return ESP:Add({
				Model = m,
				Name = m.Name,
				Color = Color3.fromRGB(255, 140, 0),
				ESPType = "Highlight",
				FillTransparency = 0.7,
				OutlineTransparency = 0,
				MaxDistance = 3000,
			})
		end)
		if ok and e then
			vehicleEntries[m] = e
		end
	end
	local function refreshVehicles()
		for m in vehicleEntries do
			removeEntry(vehicleEntries, m)
		end
		if vehiclesFolder then
			for _, m in vehiclesFolder:GetChildren() do
				addVehicle(m)
			end
		end
	end
	lootBox:AddDivider()
	lootBox:AddToggle("ARVehicleEsp", { Text = "Vehicles", Default = false, Callback = refreshVehicles })
	if vehiclesFolder then
		conns[#conns + 1] = vehiclesFolder.ChildAdded:Connect(function(m)
			task.wait(0.5)
			addVehicle(m)
		end)
		conns[#conns + 1] = vehiclesFolder.ChildRemoved:Connect(function(m)
			removeEntry(vehicleEntries, m)
		end)
	end

	task.spawn(function()
		while G.AR2_LIB == Library do
			pcall(scanLoot)
			task.wait(1.5)
		end
	end)

	local Framework = framework()

	local aim = { on = false, zombies = true, players = true, visibleOnly = true, showFov = true, fov = 200 }
	local bulletConfig = {}
	pcall(function()
		local cast = debug.getupvalue(G.AR2_FIRE_ORIG or Framework.Libraries.Bullets.Fire, 4)
		local cfg = debug.getupvalue(cast, 1)
		if type(cfg) == "table" then
			bulletConfig = cfg
		end
	end)
	local function projectileGravity()
		local g = tonumber(bulletConfig.ProjectileGravity) or -31.392
		return math.abs(g) * 2
	end
	local function maxShotDistance()
		return tonumber(bulletConfig.ShotMaxDistance) or 2000
	end
	local UIS = game:GetService("UserInputService")
	local RunService = game:GetService("RunService")
	local aimRay = RaycastParams.new()
	aimRay.FilterType = Enum.RaycastFilterType.Exclude
	aimRay.IgnoreWater = true

	local function muzzleSpeed(item)
		local speed = 2000
		pcall(function()
			item = item or Framework.Classes.Players.get().Character.EquippedItem
			local mv = item and item.FireConfig and item.FireConfig.MuzzleVelocity
			if type(mv) == "number" and mv > 0 then
				speed = mv * (tonumber(bulletConfig.MuzzleVelocityMod) or 1)
			end
		end)
		return speed
	end

	local function candidates()
		local list = {}
		if aim.zombies and zombiesFolder then
			for _, m in zombiesFolder:GetChildren() do
				local part = m:FindFirstChild("Head") or m:FindFirstChild("UpperTorso")
				if part then
					list[#list + 1] = part
				end
			end
		end
		if aim.players and charsFolder then
			for _, m in charsFolder:GetChildren() do
				if m ~= LocalPlayer.Character and charOwner(m) ~= LocalPlayer then
					local part = m:FindFirstChild("Head")
						or m:FindFirstChild("UpperTorso")
						or m:FindFirstChild("HumanoidRootPart")
					if part then
						list[#list + 1] = part
					end
				end
			end
		end
		return list
	end

	local function isClear(from, part)
		aimRay.FilterDescendantsInstances = { workspace.CurrentCamera, LocalPlayer.Character }
		local hit = workspace:Raycast(from, part.Position - from, aimRay)
		return hit == nil or hit.Instance:IsDescendantOf(part.Parent)
	end

	local function pickAimTarget(from)
		local cam = workspace.CurrentCamera
		local mouse = UIS:GetMouseLocation()
		local best, bestDist = nil, aim.fov
		local range = maxShotDistance()
		for _, part in candidates() do
			local sp, onScreen = cam:WorldToViewportPoint(part.Position)
			if onScreen and (part.Position - from).Magnitude <= range then
				local d = (Vector2.new(sp.X, sp.Y) - mouse).Magnitude
				if d < bestDist and (not aim.visibleOnly or isClear(from, part)) then
					best, bestDist = part, d
				end
			end
		end
		return best
	end

	local function solveDirection(origin, part, item)
		local speed = muzzleSpeed(item)
		local gravity = projectileGravity()
		local root = part.Parent and part.Parent:FindFirstChild("HumanoidRootPart")
		local vel = root and root.AssemblyLinearVelocity or Vector3.zero
		vel = Vector3.new(vel.X, math.clamp(vel.Y, -20, 20), vel.Z)
		local t = (part.Position - origin).Magnitude / speed
		local aimPos = part.Position
		for _ = 1, 5 do
			local future = part.Position + vel * t
			aimPos = future + Vector3.new(0, 0.5 * gravity * t * t, 0)
			local horizontal = (future - origin) * Vector3.new(1, 0, 1)
			local dir = (aimPos - origin).Unit
			local flat = math.max((dir * Vector3.new(1, 0, 1)).Magnitude, 1e-3)
			t = horizontal.Magnitude / (speed * flat)
		end
		return (aimPos - origin).Unit
	end

	G.AR2_FIRE_HANDLER = function(args)
		if not aim.on then
			return
		end
		local origin, dir = args[5], args[6]
		if typeof(origin) ~= "Vector3" or typeof(dir) ~= "Vector3" then
			return
		end
		local target = pickAimTarget(origin)
		if target then
			args[6] = solveDirection(origin, target, type(args[4]) == "table" and args[4] or nil)
		end
	end

	local hookStatus = "not installed"
	pcall(function()
		local Bullets = Framework and Framework.Libraries.Bullets
		local fire = Bullets and Bullets.Fire
		if type(fire) ~= "function" then
			hookStatus = "Bullets.Fire not found"
			return
		end
		if G.AR2_FIRE_ORIG then
			hookStatus = "active"
			return
		end
		if isfunctionhooked and isfunctionhooked(fire) and restorefunction then
			restorefunction(fire)
		end
		local orig
		orig = hookfunction(fire, function(...)
			local args = table.pack(...)
			local handler = G.AR2_FIRE_HANDLER
			if handler then
				pcall(handler, args)
			end
			return orig(table.unpack(args, 1, args.n))
		end)
		G.AR2_FIRE_ORIG = orig
		hookStatus = "active"
	end)

	G.AR2_WEAPON_MODS = G.AR2_WEAPON_MODS or { noSpread = false, noRecoil = false }
	local mods = G.AR2_WEAPON_MODS
	mods.noSpread, mods.noRecoil = false, false

	local function zeroed(v)
		local t = typeof(v)
		if t == "number" then
			return 0
		elseif t == "Vector2" then
			return Vector2.zero
		elseif t == "Vector3" then
			return Vector3.zero
		elseif t == "table" then
			local copy = {}
			for k, x in v do
				copy[k] = zeroed(x)
			end
			return copy
		end
		return v
	end

	local modStatus = "not installed"
	pcall(function()
		local fire = G.AR2_FIRE_ORIG or Framework.Libraries.Bullets.Fire
		if not G.AR2_SPREAD_ORIG then
			local spread = debug.getupvalue(fire, 1)
			if type(spread) == "function" and debug.info(spread, "n") == "getSpredAngle" then
				local orig
				orig = hookfunction(spread, function(...)
					if G.AR2_WEAPON_MODS and G.AR2_WEAPON_MODS.noSpread then
						return 0
					end
					return orig(...)
				end)
				G.AR2_SPREAD_ORIG = orig
			end
		end
		if not G.AR2_RECOIL_ORIG then
			local impulse = debug.getupvalue(fire, 6)
			if type(impulse) == "function" and debug.info(impulse, "n") == "getFireImpulse" then
				local orig
				orig = hookfunction(impulse, function(...)
					local out = table.pack(orig(...))
					if G.AR2_WEAPON_MODS and G.AR2_WEAPON_MODS.noRecoil then
						for i = 1, out.n do
							out[i] = zeroed(out[i])
						end
					end
					return table.unpack(out, 1, out.n)
				end)
				G.AR2_RECOIL_ORIG = orig
			end
		end
		modStatus = (G.AR2_SPREAD_ORIG and "spread OK" or "spread MISSING")
			.. ", "
			.. (G.AR2_RECOIL_ORIG and "recoil OK" or "recoil MISSING")
	end)

	local fovCircle
	pcall(function()
		fovCircle = Drawing.new("Circle")
		fovCircle.Thickness = 1
		fovCircle.NumSides = 64
		fovCircle.Filled = false
		fovCircle.Transparency = 1
		fovCircle.Color = Color3.fromRGB(255, 255, 255)
		fovCircle.Visible = false
	end)
	conns[#conns + 1] = RunService.RenderStepped:Connect(function()
		if fovCircle then
			fovCircle.Visible = aim.on and aim.showFov
			fovCircle.Radius = aim.fov
			fovCircle.Position = UIS:GetMouseLocation()
		end
	end)

	local TabCombat = Window:AddTab("Combat")
	local aimBox = TabCombat:AddLeftGroupbox("Silent aim")
	aimBox:AddToggle("ARSilent", {
		Text = "Silent aim",
		Default = false,
		Callback = function(v)
			aim.on = v
		end,
	})
	aimBox:AddToggle("ARAimZombies", {
		Text = "Target zombies",
		Default = true,
		Callback = function(v)
			aim.zombies = v
		end,
	})
	aimBox:AddToggle("ARAimPlayers", {
		Text = "Target players",
		Default = true,
		Callback = function(v)
			aim.players = v
		end,
	})
	aimBox:AddToggle("ARAimVisible", {
		Text = "Visible targets only",
		Default = true,
		Callback = function(v)
			aim.visibleOnly = v
		end,
	})
	aimBox:AddToggle("ARAimFov", {
		Text = "Show FOV circle",
		Default = true,
		Callback = function(v)
			aim.showFov = v
		end,
	})
	aimBox:AddSlider("ARAimFovSize", {
		Text = "FOV radius",
		Default = 200,
		Min = 25,
		Max = 800,
		Rounding = 0,
		Callback = function(v)
			aim.fov = v
		end,
	})
	local gunBox = TabCombat:AddRightGroupbox("Gun mods")
	gunBox:AddToggle("ARNoSpread", {
		Text = "No spread",
		Default = false,
		Callback = function(v)
			mods.noSpread = v
		end,
	})
	gunBox:AddToggle("ARNoRecoil", {
		Text = "No recoil",
		Default = false,
		Callback = function(v)
			mods.noRecoil = v
		end,
	})
	gunBox:AddLabel("No spread also makes silent aim pinpoint at long range. Hooks: " .. modStatus, true)

	local infoBox = TabCombat:AddRightGroupbox("How it works")
	infoBox:AddLabel(
		"Shots curve to the target nearest your cursor inside the FOV circle: head on zombies and players. Bullet drop and movement are compensated.",
		true
	)
	infoBox:AddDivider()
	infoBox:AddLabel("Shot hook: " .. hookStatus, true)

	addChangelogTab(Window, INFO[1], Library)

	if zombiesFolder then
		conns[#conns + 1] = zombiesFolder.ChildAdded:Connect(function(m)
			task.wait(0.2)
			addZombie(m)
		end)
		conns[#conns + 1] = zombiesFolder.ChildRemoved:Connect(function(m)
			removeEntry(zombieEntries, m)
		end)
	end
	if charsFolder then
		conns[#conns + 1] = charsFolder.ChildAdded:Connect(function(m)
			task.wait(1.5)
			if m.Parent then
				addPlayer(m)
			end
		end)
		conns[#conns + 1] = LocalPlayer.CharacterAdded:Connect(function(m)
			removeEntry(playerEntries, m)
		end)
		conns[#conns + 1] = charsFolder.ChildRemoved:Connect(function(m)
			removeEntry(playerEntries, m)
		end)
	end
	refreshZombies()
	refreshPlayers()

	local function watchPlayerLink(p)
		if p == LocalPlayer then
			return
		end
		conns[#conns + 1] = p.CharacterAdded:Connect(function(m)
			task.wait(0.5)
			if playerEntries[m] or (charsFolder and m.Parent == charsFolder) then
				addPlayer(m)
			end
		end)
	end
	for _, p in Players:GetPlayers() do
		watchPlayerLink(p)
	end
	conns[#conns + 1] = Players.PlayerAdded:Connect(watchPlayerLink)

	task.spawn(function()
		while G.AR2_LIB == Library do
			for m in unnamedPlayers do
				if m.Parent and charOwner(m) then
					addPlayer(m)
				end
			end
			task.wait(2)
		end
	end)

	G.AR2_CLEANUP = function()
		for _, c in conns do
			pcall(function()
				c:Disconnect()
			end)
		end
		table.clear(conns)
		for m in zombieEntries do
			removeEntry(zombieEntries, m)
		end
		for m in playerEntries do
			removeEntry(playerEntries, m)
		end
		clearLoot()
		for m in vehicleEntries do
			removeEntry(vehicleEntries, m)
		end
		for m in corpseEntries do
			removeEntry(corpseEntries, m)
		end
		G.AR2_FIRE_HANDLER = nil
		if G.AR2_WEAPON_MODS then
			G.AR2_WEAPON_MODS.noSpread = false
			G.AR2_WEAPON_MODS.noRecoil = false
		end
		if fovCircle then
			pcall(function()
				fovCircle:Remove()
			end)
		end
	end
	Library:OnUnload(function()
		if G.AR2_CLEANUP then
			G.AR2_CLEANUP()
			G.AR2_CLEANUP = nil
		end
	end)
end

local function runMM2()
	local Players = game:GetService("Players")
	local RunService = game:GetService("RunService")
	local TweenService = game:GetService("TweenService")
	local LocalPlayer = Players.LocalPlayer
	local G = getgenv()
	local INFO = HUNT_ISLAND_PLACES[MM2_PLACE]

	if G.MM2_CLEANUP then
		pcall(G.MM2_CLEANUP)
		G.MM2_CLEANUP = nil
	end
	if G.MM2_LIB then
		pcall(function()
			G.MM2_LIB:Unload()
		end)
		G.MM2_LIB = nil
	end

	local conns = {}
	local state = { collect = false }
	local Library =
		loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/main/Library.lua"))()
	G.MM2_LIB = Library

	local Window = Library:CreateWindow({
		Title = "MM2 Coins",
		Footer = "Murder Mystery 2 - island " .. INFO[1],
		Center = true,
		AutoShow = true,
		Size = UDim2.fromOffset(600, 380),
	})
	local Tab = Window:AddTab("Main")

	local questBox = Tab:AddLeftGroupbox("Event quest")
	local progressLabel = questBox:AddLabel("Coins: -", true)
	local statusLabel = questBox:AddLabel("Status: idle", true)
	local refreshBadge = addBadgeLabel(questBox, INFO[3])
	questBox:AddDivider()
	addReturnToHub(Library, questBox, conns)

	local function setStatus(s)
		statusLabel:SetText("Status: " .. s)
	end

	local function questLabel()
		local pg = LocalPlayer:FindFirstChildOfClass("PlayerGui")
		local cp = pg and pg:FindFirstChild("CrossPlatform")
		local r = cp and cp:FindFirstChild("Roblox20")
		local ok, label = pcall(function()
			return r.Container.Main.MainQuest.Container.Challenge.Progress.ProgressLabel
		end)
		return ok and label or nil
	end

	local boundLabel
	local function updateProgress()
		local label = questLabel()
		if label and label ~= boundLabel then
			boundLabel = label
			conns[#conns + 1] = label:GetPropertyChangedSignal("Text"):Connect(updateProgress)
		end
		local text = label and label.Text or "-"
		progressLabel:SetText("Coins: " .. text)
		local a, b = tostring(text):match("(%d+)%s*/%s*(%d+)")
		if a and tonumber(a) >= tonumber(b) then
			refreshBadge()
		end
	end
	updateProgress()

	local unreachable = setmetatable({}, { __mode = "k" })

	local function coinContainer()
		for _, child in workspace:GetChildren() do
			local cc = child:FindFirstChild("CoinContainer")
			if cc then
				return cc
			end
		end
		return nil
	end

	local function nextCoin(from)
		local cc = coinContainer()
		if not cc then
			return nil
		end
		local best, bestDist
		for _, c in cc:GetChildren() do
			if c:IsA("BasePart") and not c:GetAttribute("Collected") and not unreachable[c] then
				local d = (c.Position - from).Magnitude
				if not bestDist or d < bestDist then
					best, bestDist = c, d
				end
			end
		end
		return best
	end

	local function isDead()
		return LocalPlayer:GetAttribute("Alive") == false
	end

	local function stillWanted(coin)
		return state.collect and not isDead() and coin.Parent ~= nil and not coin:GetAttribute("Collected")
	end

	task.spawn(function()
		while G.MM2_LIB == Library do
			if state.collect then
				local char = LocalPlayer.Character
				local hrp = char and char:FindFirstChild("HumanoidRootPart")
				if not hrp then
					setStatus("waiting for character")
				elseif isDead() then
					setStatus("killed - waiting for the next round")
				else
					local coin = nextCoin(hrp.Position)
					if coin then
						setStatus("teleporting to coins")
						hrp.AssemblyLinearVelocity = Vector3.zero
						hrp.CFrame = CFrame.new(coin.Position)
						local t0 = os.clock()
						repeat
							task.wait(0.05)
						until not stillWanted(coin) or os.clock() - t0 > 0.8
						if stillWanted(coin) then
							unreachable[coin] = true
						end
					else
						setStatus(coinContainer() and "no coins left this round" or "waiting for a round")
					end
				end
			end
			task.wait(0.1)
		end
	end)

	local farmBox = Tab:AddRightGroupbox("Auto collect")
	farmBox:AddToggle("MMCollect", {
		Text = "Auto collect coins",
		Default = false,
		Callback = function(v)
			state.collect = v
			if not v then
				setStatus("idle")
			end
		end,
	})
	farmBox:AddLabel(
		"Teleports straight onto the closest coin, then the next closest. Risky - it can get you flagged. Stops when you get killed, since ghosts can't collect coins.",
		true
	)

	addChangelogTab(Window, INFO[1], Library)

	G.MM2_CLEANUP = function()
		state.collect = false
		for _, c in conns do
			pcall(function()
				c:Disconnect()
			end)
		end
		table.clear(conns)
	end
	Library:OnUnload(function()
		if G.MM2_CLEANUP then
			G.MM2_CLEANUP()
			G.MM2_CLEANUP = nil
		end
	end)
end

local function runLT2()
	local Players = game:GetService("Players")
	local LocalPlayer = Players.LocalPlayer
	local G = getgenv()
	local INFO = HUNT_ISLAND_PLACES[LT2_PLACE]

	if G.LT2_CLEANUP then
		pcall(G.LT2_CLEANUP)
		G.LT2_CLEANUP = nil
	end
	if G.LT2_LIB then
		pcall(function()
			G.LT2_LIB:Unload()
		end)
		G.LT2_LIB = nil
	end

	local conns = {}
	local ESP = loadMSESP()
	local Library =
		loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/main/Library.lua"))()
	G.LT2_LIB = Library

	local Window = Library:CreateWindow({
		Title = "Geck's Wood",
		Footer = "Lumber Tycoon 2 - island " .. INFO[1],
		Center = true,
		AutoShow = true,
		Size = UDim2.fromOffset(600, 380),
	})
	local Tab = Window:AddTab("Main")

	local function woodBox()
		local r2q = workspace:FindFirstChild("R2Q")
		return r2q and r2q:FindFirstChild("WoodBox")
	end

	local function logModels()
		local folder = workspace:FindFirstChild("LogModels")
		return folder and folder:GetChildren() or {}
	end

	local function logOwner(m)
		local ow = m:FindFirstChild("Owner")
		return ow and ow.Value
	end

	local function logPart(m)
		return m:FindFirstChild("WoodSection", true) or m:FindFirstChildWhichIsA("BasePart", true)
	end

	local function nearestLog(from)
		local best, bestDist
		for _, m in logModels() do
			local owner = logOwner(m)
			local part = logPart(m)
			if part and (owner == nil or owner == LocalPlayer) then
				local d = (part.Position - from).Magnitude
				if not bestDist or d < bestDist then
					best, bestDist = part, d
				end
			end
		end
		return best
	end

	local function myRoot()
		local char = LocalPlayer.Character
		return char and char:FindFirstChild("HumanoidRootPart"), char
	end

	local questBox = Tab:AddLeftGroupbox("Help Geck")
	questBox:AddLabel(
		"Geck just wants wood in his WoodBox - any type. Your client can only move a log while you're really dragging it, so:",
		true
	)
	questBox:AddLabel("1. Teleport to a log.", true)
	questBox:AddLabel("2. Click and hold it to drag.", true)
	questBox:AddLabel("3. While holding it, teleport to the WoodBox and let go.", true)
	questBox:AddDivider()
	addBadgeLabel(questBox, INFO[3])
	addReturnToHub(Library, questBox, conns)

	local tpBox = Tab:AddRightGroupbox("Teleports")
	tpBox:AddButton({
		Text = "Teleport to nearest log",
		Func = function()
			local hrp, char = myRoot()
			if not hrp then
				return
			end
			local part = nearestLog(hrp.Position)
			if not part then
				Library:Notify("No free or owned logs found - chop a tree first.", 4)
				return
			end
			char:PivotTo(CFrame.new(part.Position + Vector3.new(0, 3, 4), part.Position))
		end,
	})
	tpBox:AddButton({
		Text = "Teleport to WoodBox",
		Func = function()
			local hrp, char = myRoot()
			local box = woodBox()
			if not (hrp and box) then
				return
			end
			local p = box:GetPivot().Position
			char:PivotTo(CFrame.new(p + Vector3.new(0, 4, 6), p))
		end,
	})
	tpBox:AddLabel("Free logs are unowned wood anyone can take; dragging one makes it yours.", true)

	local logEntries = {}
	local boxEntry
	local function removeEntry(map, key)
		local e = map[key]
		if e then
			pcall(function()
				e:Destroy()
			end)
			map[key] = nil
		end
	end

	local function refreshLogEsp()
		if not ESP then
			return
		end
		local on = Library.Toggles.LTLogEsp and Library.Toggles.LTLogEsp.Value
		local seen = {}
		for _, m in logModels() do
			local owner = logOwner(m)
			local mine = owner == LocalPlayer
			if on and logPart(m) and (owner == nil or mine) then
				seen[m] = true
				local key = mine and "mine" or "free"
				local rec = logEntries[m]
				if rec and rec.key ~= key then
					removeEntry(logEntries, m)
					rec = nil
				end
				if not rec then
					local ok, e = pcall(function()
						return ESP:Add({
							Model = m,
							Name = mine and "Your log" or "Free log",
							Color = mine and Color3.fromRGB(80, 200, 255) or Color3.fromRGB(120, 255, 120),
							ESPType = "Highlight",
							FillTransparency = 0.5,
							OutlineTransparency = 0,
							MaxDistance = 3000,
						})
					end)
					if ok and e then
						logEntries[m] = {
							entry = e,
							key = key,
							Destroy = function(self)
								self.entry:Destroy()
							end,
						}
					end
				end
			end
		end
		for m in logEntries do
			if not seen[m] then
				removeEntry(logEntries, m)
			end
		end
		local box = woodBox()
		local wantBox = Library.Toggles.LTBoxEsp and Library.Toggles.LTBoxEsp.Value
		if wantBox and box and not boxEntry then
			local ok, e = pcall(function()
				return ESP:Add({
					Model = box,
					Name = "Geck's WoodBox",
					Color = Color3.fromRGB(255, 200, 40),
					ESPType = "Highlight",
					FillTransparency = 0.6,
					OutlineTransparency = 0,
					MaxDistance = 5000,
				})
			end)
			if ok then
				boxEntry = e
			end
		elseif not wantBox and boxEntry then
			pcall(function()
				boxEntry:Destroy()
			end)
			boxEntry = nil
		end
	end

	local espBox = Tab:AddRightGroupbox("ESP")
	espBox:AddToggle("LTLogEsp", { Text = "Log ESP", Default = true, Callback = refreshLogEsp })
	espBox:AddToggle("LTBoxEsp", { Text = "WoodBox ESP", Default = true, Callback = refreshLogEsp })
	espBox:AddLabel("Green = free log, blue = your log, gold = Geck's WoodBox.", true)

	task.spawn(function()
		while G.LT2_LIB == Library do
			pcall(refreshLogEsp)
			task.wait(1.5)
		end
	end)

	addChangelogTab(Window, INFO[1], Library)

	G.LT2_CLEANUP = function()
		for _, c in conns do
			pcall(function()
				c:Disconnect()
			end)
		end
		table.clear(conns)
		for m in logEntries do
			removeEntry(logEntries, m)
		end
		if boxEntry then
			pcall(function()
				boxEntry:Destroy()
			end)
			boxEntry = nil
		end
	end
	Library:OnUnload(function()
		if G.LT2_CLEANUP then
			G.LT2_CLEANUP()
			G.LT2_CLEANUP = nil
		end
	end)
end

local function runGenericIsland(info)
	local G = getgenv()
	if G.HGEN_LIB then
		pcall(function()
			G.HGEN_LIB:Unload()
		end)
		G.HGEN_LIB = nil
	end
	local conns = {}
	local Library =
		loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/main/Library.lua"))()
	G.HGEN_LIB = Library
	local Window = Library:CreateWindow({
		Title = "The Hunt",
		Footer = info[2] .. " - island " .. info[1],
		Center = true,
		AutoShow = true,
		Size = UDim2.fromOffset(560, 300),
	})
	local Tab = Window:AddTab("Main")
	addChangelogTab(Window, info[1], Library)
	local box = Tab:AddLeftGroupbox("Island " .. info[1])
	box:AddLabel(info[2], true)
	box:AddLabel("No automation for this game yet - complete the badge normally.", true)
	addBadgeLabel(box, info[3])
	box:AddDivider()
	addReturnToHub(Library, box, conns)
	Library:OnUnload(function()
		for _, c in conns do
			pcall(function()
				c:Disconnect()
			end)
		end
	end)
end

local ok, err = pcall(function()
	local G = getgenv()
	if G.HUNT_TP_POPUP_CONN then
		pcall(function()
			G.HUNT_TP_POPUP_CONN:Disconnect()
		end)
	end
	G.HUNT_TP_POPUP_CONN = game:GetService("TeleportService").TeleportInitFailed:Connect(function(player)
		if player ~= game:GetService("Players").LocalPlayer then
			return
		end
		for _, delay in { 0.1, 0.5, 1.5 } do
			task.delay(delay, function()
				pcall(function()
					game:GetService("GuiService"):ClearError()
				end)
			end)
		end
	end)
	if G.HGEN_LIB then
		pcall(function()
			G.HGEN_LIB:Unload()
		end)
		G.HGEN_LIB = nil
	end
	if game.PlaceId == HUB_PLACE then
		runHub()
	elseif game.PlaceId == HEIGHTS_PLACE then
		runHeights()
	elseif BRICKBATTLE_PLACES[game.PlaceId] then
		runBrickBattle()
	elseif game.PlaceId == NDS_PLACE then
		runNDS()
	elseif game.PlaceId == BASEWARS_PLACE then
		runBaseWars()
	elseif game.PlaceId == AR2_PLACE then
		runAR2()
	elseif game.PlaceId == MM2_PLACE then
		runMM2()
	elseif game.PlaceId == LT2_PLACE then
		runLT2()
	elseif HUNT_ISLAND_PLACES[game.PlaceId] then
		runGenericIsland(HUNT_ISLAND_PLACES[game.PlaceId])
	end
end)
if not ok then
	warn("[Hunt20] " .. tostring(err))
end
