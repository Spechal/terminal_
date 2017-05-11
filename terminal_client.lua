--[[
	terminal core framework
	3/30/2017
	hexadecival
	
	not all @'s are included because I'm lazy
	
	@servs
	@vars
	@tabs
	@init
	@netf
	@event
	@loadF
	@netmap
	@filesystem
	@taskmanager
	@console
	@command
	@input
	@loop
	@program
	@taskbar
	@topbar
--]]

repeat wait() until game.StarterGui:FindFirstChild("ui")

--@servs
local run = game:GetService("RunService")
local step = run.RenderStepped
local contextserv = game:GetService("ContextActionService")
local inpserv = game:GetService("UserInputService")
local storage = game:GetService("ReplicatedStorage")
local internet = workspace.internet
local webhook = require(storage.hookAPI)
--local hook = webhook.new("306521414779928577","C1hP_o1dHpY8WgXhQ9EWGGpogDHA0qXddIhnN-CAKoZguknQcbu6uMg0D-twCjFQRcJu") 
--local hook = webhook.new("306432732391800832","Xz5dWYnAkJgI7JJNVXpZnFI50hmZkj_fQrdpQgTtfK-HeZE3RLZFswd9TIypygIfMD1B") 
--local hook = webhook.new("307100758623387650","zdEARiioIk3r6H0ygyEGbTE8QyB2pXoKEmCMiQC90IxA3Jt6Xl35Ei_Frfe3sI-WEWhg") 

--@vars
local plr = game.Players.LocalPlayer
repeat wait() until plr.PlayerGui:FindFirstChild("ui")
local ui = plr.PlayerGui.ui
local note = nil
local mypc = nil
local myip = nil
local curdir = nil
local curip = nil
local curpc = nil
local ramused = 0
local ram = 0
local maxram = 1024		
local ghz = 5.0
local trace = 0
local console_unfocused = true
local ps = {}
local targets = {}
local offended = false

function ipv6()
	local s = ""
	local c = {1,2,3,4,5,6,7,8,9,"A","B","C","D","E","F"}
	for i = 1, 4 do
		s = s .. c[math.random(1,#c)]
	end
	return s
end

--@tabs
local cpros = {}
local program = {}
local taskbar = {}
local topbar = {}
local console = {
	text={},
	typing=false,
	mousedown=false
}
local filesystem = {}
local netmap = {}
local load = {}
local event = {}
local network = {}

--@net
local net = {event=storage.event}
do
	net.event.OnClientEvent:connect(function(f,...)
		print("client event : "..plr.Name.." : "..f)
		net[f](...)
	end)
end

--@init
local ffc = function(a,b)
	return a:FindFirstChild(b)
end
do
	if plr.Character then
		plr.Character:Destroy()
	end
	plr.CharacterAdded:connect(function(c)
		c:Destroy()
	end)
	game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All,false)
	game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All,false)
	game:GetService("StarterGui"):SetCore("TopbarEnabled", false)
	net.init = function(mpc,mip)
		mypc = mpc
		myip = mip
		curdir = mypc
		curpc = mypc
		curip = myip
	end
	net.relay_target = function(v,tr)
		targets[v] = tr
	end
	net.event:FireServer("init",plr)
end

--@event
event.__index = event
do
	function event.new()
		return setmetatable({t={}},event)
	end
	function event:fire()
		for _, v in pairs (self.t) do
			v()
		end
	end
	function event:connect(f)
		self.t[#self.t+1] = f
	end
end

--@load
do
	local loadtext = {
		"Kernel",
		"Modules",
		"UI",
		"CLI",
		"Themes",
		"Presets",
		"User"
	}
	local curtext = 1
	local t0 = tick()
	local loadspeed = 0.5
	local loadui = ui.load
	local loading = false
	load.start = function()
		ui.crash.Visible = false
		ui.boot.Visible = false
		t0 = tick()
		curtext = 1
		loading = true
		repeat wait() until mypc ~= nil
	end
	load.reboot = function()
		trace = 0
		ui.trace.Size = UDim2.new()
		cpros.run("kill all")
		wait(0.5)
		for i = 1, 8 do
			wait()
			ui.desktop.console.Visible = not ui.desktop.console.Visible
		end
		ui.desktop.console.Visible = false
		wait(0.5)
		for i = 1, 8 do
			wait()
			ui.desktop.taskbar.Visible = not ui.desktop.taskbar.Visible
		end
		ui.desktop.taskbar.Visible = false
		ui.desktop.topbar.Visible = false
		wait(0.5)
		ui.boot.Visible = true
		wait(5)
		curdir = mypc
		curpc = mypc
		curip = myip
		load.start()		
	end
	load.crash = function()
		trace = 0
		ui.trace.Size = UDim2.new()
		cpros.run("kill all")
		wait(0.5)
		for i = 1, 8 do
			wait()
			ui.desktop.console.Visible = not ui.desktop.console.Visible
		end
		ui.desktop.console.Visible = false
		wait(0.5)
		for i = 1, 8 do
			wait()
			ui.desktop.taskbar.Visible = not ui.desktop.taskbar.Visible
		end
		ui.desktop.taskbar.Visible = false
		ui.desktop.topbar.Visible = false
		wait(0.5)
		ui.crash.Visible = true
		wait(5)
		curdir = mypc
		curpc = mypc
		curip = myip
		load.start()
	end
	load.update = function()
		loadui.Visible = loading
		loadui.update.Text = "Loading "..loadtext[curtext]
		if loading then
			loadui.rot.Rotation = loadui.rot.Rotation+2
			if tick()-t0 > loadspeed then
				if loadtext[curtext+1] ~= nil then
					curtext = curtext+1
				else
					ui.desktop.taskbar.Visible = false
					ui.desktop.console.Visible = false
					ui.desktop.topbar.Visible = false
					spawn(function()
						for i = 1, #loadtext do
							console.add("loading "..loadtext[i])
						end
						console.add("initializing CLI")
						wait(0.5)
						for i = 1, 8 do
							wait()
							ui.desktop.console.Visible = not ui.desktop.console.Visible
						end
						ui.desktop.console.Visible = true
						console.add("initializing UI")
						wait(0.5)
						for i = 1, 8 do
							wait()
							ui.desktop.taskbar.Visible = not ui.desktop.taskbar.Visible
						end
						ui.desktop.taskbar.Visible = true
						ui.desktop.topbar.Visible = true
						console.add("EpsilonOS started")
						network.connect("127.0.0.1")
						local t = {
							"logging in as localhost",
							plr.Name.." logged in.",
							"Welcome to EpsilonOS! ~ type [help] for help."
						}
						for i = 1, #t do
							wait()
							console.add(t[i])
						end
					end)
					loading = false
				end
				t0 = tick()
			end
		end
	end
end

--@formatting
local typedata = {
	cracker={
		image="rbxassetid://741905298",
		download=true,
		run=true,
		delete=true,
		suffix=".exe"
	},
	sshexploit={
		image="rbxassetid://741905298",
		download=true,
		run=true,
		delete=true,
		suffix=".exe"
	},
	ftpexploit={
		image="rbxassetid://741905298",
		download=true,
		run=true,
		delete=true,
		suffix=".exe"
	},
	text={
		image="rbxassetid://744882769",
		download=true,
		run=true,
		delete=true,
		suffix=".txt"
	},
	exe={
		image="rbxassetid://741905298",
		download=true,
		run=true,
		delete=true,
		suffix=".exe"
	},
	sys={
		image="rbxassetid://744882769",
		download=false,
		run=false,
		delete=false,
		suffix=".dll"
	}
}
function formatbyte(s)
	if s < 1024 then
		return s.." MB"
	else
		return string.sub(s,1,1).."."..string.sub(s,2,2).." GB"
	end
end
function formatver(s)
	if math.floor(s) == s then
		return math.floor(s)..".0"
	else
		return string.sub(s,1,3)
	end
end
function formatdata(v)
	if ffc(v,"type") then
		return v.Name..typedata[v.type.Value].suffix
	else
		return v.Name	
	end
end

--@is
local is = {}
do
	is.hacking = function()
		return #mypc.sys.taskmanager.scheduler:GetChildren() > 0 and true or offended or false
	end
	is.root = function()
		if ffc(curpc.sys.root,mypc.Name) == nil then
			return false
		else
			return true
		end
	end
	is.ssh = function()
		if ffc(curpc.sys.ssh,mypc.Name) == nil and ffc(curpc.sys.root,mypc.Name) == nil then
			return false
		else
			return true
		end
	end
	is.ftp = function()
		if ffc(curpc.sys.ftp,mypc.Name) == nil and ffc(curpc.sys.root,mypc.Name) == nil then
			return false
		else
			return true
		end	
	end
end

--@network
do
	network.connect = function(target)
		console.add("connecting to "..target)
		if target == "127.0.0.1" then
			target = myip.Name
		end
		if ffc(internet.ips,target) then
			if curpc ~= curip.Value then
				offended = false
			end
			curip = internet.ips[target]
			curpc = curip.Value
			curdir = curpc
			if ffc(mypc.sys,"nmap") then
				if not ffc(mypc.sys.nmap.db,target) then
					local ip = Instance.new("ObjectValue",mypc.sys.nmap.db)
					ip.Name = target
					ip.Value = curpc
				end
			end
			console.add("connected to "..curpc.Name.." @"..target)
		else
			console.add("connection failed")
		end		
	end
	network.disconnect = function()
		console.add("disconnected")
		offended = false
		curip = myip
		curpc = mypc
		curdir = mypc		
	end
end

--@netmap
do
	local Line
	local npos = {}
	netmap.start = function()
		for _, v in pairs (internet.ips:GetChildren()) do
			if v.Value.sys:FindFirstChild("iplist") then
				if not ffc(mypc.sys.nmap.db,v.Name) then
					local ip = Instance.new("ObjectValue",mypc.sys.nmap.db)
					ip.Name = v.Name
					ip.Value = v.Value
				end
			end
		end
	end
	netmap.update = function()	
		local function DrawLine(Start, End, Width)
			local Start_O, End_O = Start, End
			if (Start.X > End.X) then
				End = Start_O
				Start = End_O
			end
			local Line = Instance.new("Frame");
			local XSize = (End-Start).magnitude;
			local XDistance = (End.X-Start.X);
			local YDistance = (End.Y-Start.Y);
			local DesiredAngle = math.atan2(YDistance,XDistance);
			local YPositionOffset = YDistance/2;
			local XOffset = (1 - math.cos(DesiredAngle)) * (XSize/2)
			Line.Rotation = math.deg(DesiredAngle);
			Line.BorderSizePixel = 0;
			Line.Size = UDim2.new(0,XSize,0,Width);
			Line.Position = UDim2.new(0,Start.X-XOffset,0,Start.Y + YPositionOffset);
			Line.ZIndex = 100
			Line.Parent = script.Parent
			return Line;
		end
		for _, v in pairs(mypc.sys.nmap.db:GetChildren()) do
			if not ffc(ui.desktop.nmap.map,v.Name) then
				if not npos[v] then
					while true do
						local kill = true
						npos[v] = UDim2.new(0,math.random(20,580),0,math.random(20,260))
						for _, vv in pairs (ui.desktop.nmap.map:GetChildren()) do
							if vv.Name ~= "Frame" then
								if (Vector2.new(vv.Position.X.Offset,vv.Position.Y.Offset)-Vector2.new(npos[v].X.Offset,npos[v].Y.Offset)).magnitude < 15 then
									kill = false
								end
							end
						end
						if kill then
							break
						end
					end
				end
				local node = storage.node:Clone()
				node.Name = v.Name
				node.Parent = ui.desktop.nmap.map
				node.Position = npos[v]
				node.BackgroundColor3 = v.Value.sys:FindFirstChild("tracer") and Color3.fromRGB(85, 0, 0) or v.Value.sys:FindFirstChild("iplist") and Color3.fromRGB(0, 85, 255) or Color3.fromRGB(0, 255, 0)
				node.MouseEnter:connect(function()
					ui.desktop.nmap.bar.info.Text = v.Value.Name .. " @".. v.Name 
				end)
				node.MouseButton1Down:connect(function()
					network.connect(v.Name)
				end)
				node.MouseButton2Down:connect(function()
					--network.bounce(v.Name)
				end)
			end 
		end
		pcall(function()
			if Line then
				Line:Destroy()
			end
			local frame = ui.desktop.nmap.map
			local p1 = Vector2.new(frame[myip.Name].Position.X.Offset,frame[myip.Name].Position.Y.Offset)
			local p2 = Vector2.new(frame[curip.Name].Position.X.Offset,frame[curip.Name].Position.Y.Offset)			 
			Line = DrawLine(p1,p2,2)
			Line.BackgroundColor3 = Color3.fromRGB(255,255,0)
			Line.Parent = frame
		end)
	end
end

--@iplist
local iplist = {}
do
	iplist.start = function()
		local index = 0
		for _, v in pairs (internet.ips:GetChildren()) do
			if v.Value.sys:FindFirstChild("iplist") then
				index = index + 35
				local file = storage.ipb:Clone()
				file.Parent = ui.desktop.database.list
				file.info.Text = v.Name .." - "..v.Value.Name
				file.MouseButton1Down:connect(function()
					network.connect(v.Name)
				end)
			end
		end
		ui.desktop.database.list.CanvasSize = UDim2.new(0,0,0,index)
	end
end

--@filesystem
do
	filesystem.update = function()
		ui.desktop.filesystem.name.logo.Text = "FileSystem @"..curdir.Name
		local explorer = ui.desktop.filesystem.scroll
		local index = 0
		explorer:ClearAllChildren()
		if is.ssh() or is.ftp() then
			storage.DLCLayout:Clone().Parent = explorer
			if curdir.Parent ~= internet.machines then
				index = index + 35
				local file = storage.folder:Clone()
				file.Name = "a"
				file.Parent = explorer
				file.info.Text = "<"
				file.space.Visible = false
				file.MouseButton1Down:connect(function()
					curdir = curdir.Parent
				end)
			end
			for _, v in pairs (curdir:GetChildren()) do
				index = index + 35
				if v:IsA("Folder") then
					local file = storage.folder:Clone()
					file.Parent = explorer
					local tsize = 0
					for _, vv in pairs (v:GetChildren()) do
						if not vv:IsA("Folder") and ffc(vv,"size") then
							tsize = tsize + vv.size.Value
						end
					end
					file.space.Text = formatbyte(tsize)
					file.info.Text = ">"..v.Name
					file.MouseButton1Down:connect(function()
						curdir = v
					end)
				else
					local data = typedata[v.type.Value]
					local file = storage.file:Clone()
					file.Parent = explorer
					if is.ftp() and curpc ~= mypc then
						file.download.Visible = data.download
					else
						file.download.Visible = false
					end
					if is.ssh() then
						file.run.Visible = data.run
					else
						file.run.Visible = false					
					end
					if is.ssh() then
						file.delete.Visible = data.delete
					else
						file.delete.Visible = false
					end
					file.type.Visible = true
					file.type.Image = data.image
					file.type.lvl.Text = ffc(v,"lvl") and formatver(v.lvl.Value) or ""
					file.info.Text = v.Name..data.suffix
					if ffc(v,"size") then
						file.space.Visible = true
						file.space.Text = formatbyte(v.size.Value)
					else					
						file.space.Visible = false
					end
					file.run.MouseButton1Down:connect(function()
						program.new(v.Name)
					end)	
					file.download.MouseButton1Down:connect(function()
						if curpc ~= mypc then
							net.event:FireServer("download",file,mypc)
						end
					end)
				end	
			end
			explorer.CanvasSize = UDim2.new(0,0,0,index)
		else
			storage.no_acces:Clone().Parent = explorer
		end
	end
end

--@exploit
local exploit = {}
do
	exploit.ssh = function()
		for _, v in pairs (mypc.bin:GetChildren()) do
			if ffc(v,"type") then
				if v.type.Value == "sshexploit" then
					return v
				end
			end
		end
		return false
	end
	exploit.ftp = function()
		for _, v in pairs (mypc.bin:GetChildren()) do
			if ffc(v,"type") then
				if v.type.Value == "ftpexploit" then
					return v
				end
			end
		end
		return false
	end
	exploit.crack = function()
		for _, v in pairs (mypc.bin:GetChildren()) do
			if ffc(v,"type") then
				if v.type.Value == "cracker" then
					return v
				end
			end
		end
		return false
	end
end

--@task
local task = {}
local notif = {}
local taskends = {
	["crack"] = function(t)
		console.add("Access Key : "..t.Value)
	end
}
do
	task.update = function()
		for _, v in pairs (mypc.sys.taskmanager.scheduler:GetChildren()) do
			pcall(function()
				if not notif[v] then
					notif[v] = 0
				end
				--net.event:FireServer("dotask",ghz/#mypc.sys.taskmanager.scheduler:GetChildren(),v)
				local divided = ghz/#mypc.sys.taskmanager.scheduler:GetChildren()
				if curpc == v.at.Value then
					v.progress.Value = v.progress.Value + (v.increment.Value*divided)/60
				else
					console.add(v.msg.Value.." failed")
					net.event:FireServer("stoptask",v)	
					v:Destroy()		
				end
				if v.progress.Value >= 25 and notif[v] < 25 then
					console.add(v.msg.Value.." 25% complete")
					notif[v] = v.progress.Value
				elseif v.progress.Value >= 50 and notif[v] < 50 then
					console.add(v.msg.Value.." 50% complete")
					notif[v] = v.progress.Value 
				elseif v.progress.Value >= 75 and notif[v] < 75 then
					console.add(v.msg.Value.." 75% complete")
					notif[v] = v.progress.Value
				end
				if v.progress.Value >= 100 then
					console.add(v.msg.Value.." complete")
					if taskends[v.Name] == nil then
						net.event:FireServer("killtask",v)
					elseif targets[v] ~= nil then
						taskends[v.Name](targets[v])
						net.event:FireServer("stoptask",v)							
					end		
					v:Destroy()
				end
			end)
		end		
	end
end

--@taskmanager
local taskmanager = {}
do

	taskmanager.update = function()
		local explorer = ui.desktop.taskmanager.scroll
		local index = 0
		explorer:ClearAllChildren()
		storage.DLCLayout:Clone().Parent = explorer
		ui.desktop.taskmanager.cpu.Text = "Tasks Running : "..#mypc.sys.taskmanager.scheduler:GetChildren()
		ui.desktop.taskmanager.ghz.Text = "CPU Allocation Per Program : "..formatver(ghz/#mypc.sys.taskmanager.scheduler:GetChildren()).." Ghz"
		for _, v in pairs (mypc.sys.taskmanager.scheduler:GetChildren()) do
			pcall(function()
				index = index + 35
				local file = storage.task:Clone()
				file.Parent = explorer
				file.info.Text = v.msg.Value
				file.bar.Size = UDim2.new(v.progress.Value/100,0,1,0)
			end)
		end
		explorer.CanvasSize = UDim2.new(0,0,0,index)
	end
end

--@console
do
	local t0 = tick()
	local consoleui = ui.desktop.console
	local underscore = " "
	console.format = function()
		if string.len(consoleui.text.Text) > 1300 or #console.text > 40 then
			table.remove(console.text,1)
		end
		local t = ""
		for i, v in pairs (console.text) do
			t = t.."\n"..v
		end
		return t.."\n"
	end
	local wd = 0
	console.add = function(t)
		console.text[#console.text+1] = t
		--spawn(function() wd=wd+0.5 wait(wd) wd=wd-0.5 hook:post({username = ">TERMINAL_",	content = "```css\n"..t.."```"}) end)
	end
	console.update = function()
		if not console_unfocused then
			ui.input:CaptureFocus()					
		else
			ui.input:ReleaseFocus()				
		end	
		if tick()-t0 >= 0.1 then
			if underscore == "_" then
				underscore = ""
			else
				underscore = "_"
			end
			t0 = tick()
		end
		consoleui.text.Text = console:format()..">"..ui.input.Text..underscore
	end
end

--@command
do
	cpros.ram = {}
	cpros.library = {
		--connect to an ip
		connect=function(target)
			network.connect(target)
		end,
		--disconnect
		dc=function()
			network.disconnect()
		end,
		disconnect=function()
			network.disconnect()
		end,
		--change text color
		color=function(c1,c2,c3)
			if tonumber(c1) and tonumber(c2) and tonumber(c3) then
				ui.desktop.console.text.TextColor3 = Color3.new(c1/255,c2/255,c3/255)
--				function colorshit(a)
--					for _, b in pairs (a:GetChildren()) do
--						if b:IsA("TextLabel") or b:IsA("TextBox") or b:IsA("TextButton") then
--							b.TextColor3 = Color3.new(c1/255,c2/255,c3/255)
--						end
--						colorshit(b)
--					end
--				end
--				colorshit(ui)
			else
				console.add([[syntax error
					usage: color r g b
					example: color 0 255 0
				]])
			end
		end,
		--clear text
		clear=function()
			console.text = {}
		end,
		cls=function()
			console.text = {}
		end,
		--dlc
		["dlc"] = function()
			console.add("emo faked xD")
		end,
		["DLC"] = function()
			console.add("the faker is still at large")
		end,
		--ps
		["ps"] = function()
			console.add("running processes :")
			for i, v in pairs (mypc.sys.taskmanager.scheduler:GetChildren()) do
				local t = math.random(100,999)
				ps[t] = v
				console.add("NAME   :   PID")
				console.add(v.msg.Value.." : "..t)
			end
		end,
		--scp
		["scp"] = function(f)
			if curpc ~= mypc and is.ftp() then
				if ffc(curdir,f) then
					console.add("download "..f.." @"..curpc.Name.." initiated")
					net.event:FireServer("newtask",mypc.sys.taskmanager.scheduler,"download",curpc,5,{curdir[f],curpc},"download "..f.." @"..curpc.Name)					
				end
			else
				console.add("you do not have ftp rights on this machine")
			end
		end,
		--rm
		["rm"] = function(n)
			if ffc(curdir,n) and is.ssh() then
				if curdir[n].type.Value ~= "sys" then
					console.add("delete "..n.." @"..curpc.Name.." initiated")
					net.event:FireServer("newtask",mypc.sys.taskmanager.scheduler,"delete",curpc,3,{curdir[n],curpc},"delete "..n.." @"..curpc.Name)
				end
			elseif n == "all" or n == "*" and is.ssh() then
				for _, v in pairs (curdir:GetChildren()) do
					if v.type.Value ~= "sys" then
						console.add("delete "..v.Name.." @"..curpc.Name.." initiated")
						net.event:FireServer("newtask",mypc.sys.taskmanager.scheduler,"delete",curpc,3,{v,curpc},"delete "..v.Name.." @"..curpc.Name)					
					end					
				end
			end
		end,
		--help
		["help.rights"] = function()
			cpros.run("cls")
			local s = [[
				/==RIGHT BASICS==/
				/==========================================================/
								
				every machine on the internet follows certian protocols in
				order to perform tasks, in order to make use of some commands
				you will need 
				
				SSH (Secure Shell Protocol) - used for remote control of a
				machine, e.g execute/stop/delete programs and run commands.
				
				FTP (File Transfser Protocol) - used for file sharing,
				e.g download/upload files.
				
				Root (Superuser) - the superuser privlege allows all actions
				to be carried out by the user.

				/==RIGHT COMMANDS==/
				/==========================================================/
				
				login [USERNAME] [KEY] --> logins as [USERNAME] using [KEY]
				
				Possible Usernames:
				
				ssh
				ftp
				root
				
				/==========================================================/
			]]
			console.add(s)				
		end,
		["login"] = function(a,p)
			if curpc.sys[a].key.Value == p then
				console.add("successfuly logged in as "..a.." using key: "..p)
				net.event:FireServer("newlog",mypc,"localhost became "..a.." @"..curpc.Name)
				net.event:FireServer("newlog",curpc,myip.Name.." became "..a)
				net.event:FireServer("giveright",mypc,curpc,a)
			else
				console.add("access denied")
			end
		end,
		["help.program"] = function()
			cpros.run("cls")
			local s = [[
				/==PROGRAM BASICS==/
				/==========================================================/
								
				programs are .exe files in your bin folder, they are used
				to carry out many tasks, programs can be ran by writing
				[PROGRAM_NAME] into the console, example: chat will
				run the chatsys program, simple as that.

				epsilon uses an efficient node tree system to handle
				the execution of programs, different functions of a
				program can be accessed along it's tree, example:
				
					chat>
						>chat.info
						>chat.join
						>chat.send
				
				a running program will use up your RAM, this can lead
				to the system running out of memory, to prevent this
				the kill [PROGRAM_NAME] command may be used to stop
				the program.

				/==PROGRAM COMMANDS==/
				/==========================================================/
				
				[PROGRAM_NAME] --> starts a program present in the /bin/ folder
				kill [PROGRAM_NAME] --> stops a program if executing
				ps --> lists all currently running programs 
				
				/==========================================================/
			]]
			console.add(s)			
		end,
		rainbow = function()
			cpros.ram.stoprainbow = not cpros.ram.stoprainbow
			spawn(function()
				repeat wait() cpros.run("color "..math.random(0,255).." "..math.random(0,255).." "..math.random(0,255)) until cpros.ram.stoprainbow == false
			end)
		end,
		kill = function(n,s)
			if program.ram[n] then
				program.kill(n)
			elseif n == "*" or n == "all" then
				for i, _ in pairs (program.ram) do
					program.kill(i)
				end
			elseif n == "pid" then
				s = tonumber(s)
				if ps[s] then
					console.add(ps[s].msg.Value.." terminated")
					net.event:FireServer("stoptask",ps[s])	
					ps[s]:Destroy()
				else
					console.add("invalid pid")
				end
			else
				console.add("invalid pname")
			end
		end,
		cd = function(s)
			if ffc(curdir,s) and (is.ssh() or is.ftp()) then
				if curdir[s]:IsA("Folder") then
					curdir = curdir[s]
					console.add("current directory set as "..s)
				end
			elseif string.sub(s,1,1) == "." and curdir.Parent ~= internet.machines then
				curdir = curdir.Parent
				console.add("current directory set as "..curdir.Name)
			end	
		end,
		ls = function()
			if is.ssh() or is.ftp() then
				console.add("files in "..curdir.Name.." : ")	
				for _, v in pairs (curdir:GetChildren()) do
					console.add(formatdata(v)) 
				end
			end
		end,
		bruteforce = function()
			if not is.root() and curpc and mypc ~= nil and exploit.crack() then
				console.add("bruteforce sequence initiated")				
				net.event:FireServer("newtask",mypc.sys.taskmanager.scheduler,"crack",curpc,exploit.crack().lvl.Value/2,curpc.sys.root.key,"bruteforce @"..curpc.Name,plr)
			else
				console.add("no bruteforcing program to run")
			end
		end,
		sshcrack = function()
			if not is.root() and curpc and mypc ~= nil and exploit.ssh() then
				console.add("shell crack attempt initiated")				
				net.event:FireServer("newtask",mypc.sys.taskmanager.scheduler,"crack",curpc,exploit.ssh().lvl.Value,curpc.sys.ssh.key,"ssh exploit @"..curpc.Name,plr)
			else
				console.add("no ssh exploit to run")
			end
		end,
		ftpworm = function()
			if not is.root() and curpc and mypc ~= nil and exploit.ftp() then
				console.add("transfer backdoor worm initiated")				
				net.event:FireServer("newtask",mypc.sys.taskmanager.scheduler,"crack",curpc,exploit.ftp().lvl.Value,curpc.sys.ftp.key,"ftp exploit @"..curpc.Name,plr)
			else
				console.add("no ftp exploit to run")
			end
		end,
		reboot = function()
			load.reboot()
		end,
		shutdown = function()
			game:GetService("TeleportService"):Teleport(676754313)
		end,
		help = function()
			cpros.run("cls")
			local s = [[
				/==BASIC COMMANDS==/														
				/==========================================================/
				
				connect [IP] --> connects to IP
				
				disconnect/dc --> disconnects from current network
				
				login [KEY] --> login as admin to current system using KEY
				
				rm [TARGET] --> deletes file in current directory
				
				rm * --> deletes all files in current directory
				
				cd [DIR] --> sets DIR as current directory
				
				cd .. --> navigates out of current directory
				
				scp [FILENAME] --> downloads FILENAME to your system
				
				ls --> lists all files in current directory
				
				ps --> lists all running proccesses and programs
				
				color --> changes color scheme of the terminal
				
				cat [FILENAME] --> reads a text file
				
				reboot --> restarts the system
				
				shutdown --> shuts down the system
				
				cls/clear --> clears text on screen
				
				/==========================================================/
				some commands require rights on a system to execute.
				type "help.program" to see help on using programs
				type "help.rights" to see help on user rights
			]]
			console.add(s)
		end
	}
	cpros.run = function(text)
		local cmd = ""
		local args = {}
		--parse command
		local i = 1
		for s in string.gmatch(text,"[^%s]+") do
			if i == 1 then
				cmd = s
			else
				args[#args+1] = s
			end
			i = i + 1
		end
		--pattern magic
		local filename = nil 
		local fullname = cmd 
		if cmd:match(".+%.") then
			filename = string.sub(cmd:match(".+%."),1,#cmd:match(".+%.")-1)
		end
		--run command
		if cpros.library[cmd] then
			pcall(function()cpros.library[cmd](unpack(args))end)
		elseif ffc(mypc.bin,cmd) or ffc(mypc.sys,cmd) then
			pcall(function()program.new(cmd)end)
		else
			console.add("unrecognized command: "..cmd)
		end
	end
end

--@input
do
	inpserv.InputBegan:Connect(function(input,gp)
		local notefocused = false
		if note ~= nil then
			if note:IsFocused() then
				notefocused = true
			end
		end
		if input.UserInputType == Enum.UserInputType.Keyboard and not notefocused then
			ui.input:CaptureFocus()								
			console_unfocused = false
			local key = input.KeyCode
			if key == Enum.KeyCode.Return then
				local ctext = ui.input.Text
				console.add(ctext)
				ui.input.Text = ""
				cpros.run(ctext)	
			end
		elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
			console_unfocused = true		
		end
	end)
end

--@browser
local browser = {}
do
	local init = {
		
	}
	browser.update = function()
	end
end

--@program
do
	local bestindex = 2
	local notestext = ""
	program.ram = {}
	program.usage = {
		filesystem=256,
		taskmanager=64,
		chat=64,
		customize=64,
		notes=64,
		nmap=512,
		browser=64,
		database=32
	}
	program.start = {
		nmap=netmap.start,
		database=iplist.start,
		filesystem = function(window)

		end,
		notes = function(window)
			note = window.scroll.box
			window.scroll.box.Text = notestext			
		end
	}
	program.stop = {
		notes = function(window)
			notestext = window.scroll.box.Text 
		end
	}
	program.loop = {
		filesystem=filesystem.update,
		taskmanager=taskmanager.update,
		nmap=netmap.update,
		browser=browser.update
	}
	program.new = function(name)
		if ffc(mypc.bin,name) or ffc(mypc.sys,name) then
			if not ui.desktop:FindFirstChild(name) then
				if ram+program.usage[name] <= maxram then
					ram = ram + program.usage[name]
					local window
					window = storage.programs[name]:Clone()
					window.Parent = ui.desktop
					window.Position = UDim2.new(0,math.random(100,600),0,math.random(100,600))
					program.ram[window.Name] = true
					if program.start[window.Name] then
						program.start[window.Name](window)
					end
					window.close.MouseButton1Down:connect(function()
						program.kill(name)
					end)
					console.add(name.." started")
				else
					console.add("insufficient memory")					
				end
			else
				console.add(name.." already executing")
			end
		else
			console.add(name.." not found")
		end
	end
	program.kill = function(name)
		local window = ui.desktop[name]
		ram = ram - program.usage[name]
		if program.stop[window.Name] then
			program.stop[window.Name](window)
		end
		program.ram[window.Name] = false
		window:Destroy()
		console.add(name.." terminated")
	end
	program.update = function()
		for i, v in pairs (program.loop) do
			if program.ram[i] then
				v()
			end
		end
	end
end

--@taskbar
do
	taskbar.init = function()
		for i, v in pairs (ui.desktop.taskbar:GetChildren()) do
			v.MouseButton1Down:connect(function()
				program.new(v.Name)
			end)
		end
	end
end

--@dynmusic
local music = {}
do
	local musicobj = ui.music
	local volumetarget = 0
	local curid = nil
	local increment = 0.005
	local playing = false
	music.set = function(id)
		if curid ~= "rbxassetid://"..id then
			curid = "rbxassetid://"..id
			delay(5,function()
				musicobj.SoundId = "rbxassetid://"..id
				volumetarget = 1	
				playing = false		
			end)
			volumetarget = 0
		end
	end
	music.update = function()
		if musicobj.Volume < volumetarget then
			musicobj.Volume = musicobj.Volume+increment
		elseif musicobj.Volume > volumetarget then
			musicobj.Volume = musicobj.Volume-increment			
		end
		if not playing then
			playing = true
			musicobj:Play()
		end
		if trace > 0 then
			music.set(678526827) --el tigr3		
		else
			music.set(716561629) --stratus
		end
	end
end

--@tracer
local tracer = {}
do
	tracer.update = function()
		if curpc.sys:FindFirstChild("tracer") and curpc ~= mypc and is.hacking() then
			offended = true
			trace = trace + curpc.sys.tracer.Value
		else
			trace = 0
		end
		if trace >= 100 then
			load.crash()
		end
	end
end

--@topbar
do
	topbar.update = function()
		ui.trace.Size = UDim2.new(1,0,(trace/90),0)
		ui.trace.Position = UDim2.new(0,0,0,-36)
		local ctime = tick()
		local secs = ctime % 60
		local mins = math.floor((ctime % 3600) / 60)
		local hrs = math.floor((ctime % (3600*24)) / (3600*24))
		local days = {31,28,31,30,31,30,31,31,30,31,30,31}
		local year = math.floor(ctime/60/60/24/365.25+1970)
		local day = math.ceil(ctime/60/60/24%365.25)
		local month = 0
		for i, d in pairs(days) do
		    if day > d then
		        day = day - d
		    else
		        month = i
		        break
		    end
		end 
		if day < 10 then 
			day = "0"..tostring(day)
		end
		local function lerp(a, b, t)
   			return a * (1-t) + (b*t)
		end
		ramused = math.floor(lerp(ramused,ram,0.1))
		ui.desktop.topbar.Text = hrs..":"..mins..":"..math.floor(secs).." | "..month.."/".. day .."/"..(year+25).." | memory usage: "..ramused.."/"..maxram.." mb".." | "..myip.Value.Name.." @"..myip.Name
	end
end

load.start()
taskbar.init()

--@loop
while step:wait() do
	pcall(function()
		topbar.update()
		program.update()
		console.update()
		tracer.update()
		task.update()
		load.update()
		music.update()
	end)
end