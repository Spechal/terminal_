repeat wait() until game.Players.LocalPlayer:FindFirstChild("GameData")

--dirs
local storage = game.ReplicatedStorage.data
local root = game.Players.LocalPlayer.PlayerGui.epsilon

--vars
local usc = ""
local t0 = tick()
local myip, mypc
local cur_ip, cur_pc

--services
local contextserv = game:GetService("ContextActionService")
local inpserv = game:GetService("UserInputService")
local starterGui = game:GetService("StarterGui")

--kill ui
game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All,false)
game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All,false)
starterGui:SetCore("TopbarEnabled", false)



--[[
	
	@Chat
	@Music
	
--]]


























--create pc
do
	mypc = game.ReplicatedStorage.data.pc:Clone()
	mypc.Name = game.Players.LocalPlayer.Name .. " PC"
	mypc.Parent = workspace
	myip = game.ReplicatedStorage.data.ip:Clone()
	myip.Parent = workspace
	myip.Value = mypc
	for i, v in pairs (workspace:GetChildren()) do
		if v:IsA("ObjectValue") and v:FindFirstChild("iplist") then
			if game.Players.LocalPlayer.GameData.hacked.Value:match(v.Value.Name) then
				local admintag = Instance.new("ObjectValue",v.admin)
				admintag.Name = myip.Name			
			end
		end
	end		
end


















function iplist()
	root.terminal.map.list:ClearAllChildren()
	local ii = 0
	for i, v in pairs (workspace:GetChildren()) do
		if v:IsA("ObjectValue") and v:FindFirstChild("iplist") then
			ii = ii + 1
			local node = storage.ipz:Clone()
			node.Position = UDim2.new(0,0,0,30*(ii-1))
			node.Text = v.Name .. " - " .. v.Value.Name
			node.Parent = root.terminal.map.list
			if game.Players.LocalPlayer.GameData.hacked.Value:match(v.Value.Name) then
				node.BackgroundColor3 = Color3.new(0,1/2,0)
			elseif v:FindFirstChild("Tracer") then
				node.BackgroundColor3 = Color3.new(1/2,0,0)				
			end
		end
	end
end



















--buttons
for index, button in pairs (root.terminal.buttons:GetChildren()) do
	button.MouseButton1Down:Connect(function()
		root.terminal.analysis.Visible = false
		root.terminal.explorer.Visible = false
		root.terminal.website.Visible = false
		root.terminal.notes.Visible = false
		root.terminal.chat.Visible = false
		root.terminal.map.Visible = false
		root.terminal[button.Name].Visible = true
	end)
end
















--update website
local buttons = root.terminal.buttons
function update_website()
	local site = cur_ip.Value:FindFirstChild("web")
	buttons.website.Visible = site
	for i, v in pairs (root.terminal.website:GetChildren()) do
		if v.Name ~= "text" then
			if v.Name ~= cur_ip.Name then
				v:Destroy()
			end
		end
	end
	if site then
		if cur_ip.Value.web:FindFirstChild("site") and not root.terminal.website:FindFirstChild(cur_ip.Name) then
			local copy = cur_ip.Value.web.site:Clone()
			copy.Name = cur_ip.Name	
			copy.Parent = root.terminal.website
		end
	end
	if root.terminal.website.Visible and not site then
		root.terminal.website.Visible = false
	end
	if site and site:FindFirstChild("dns") then
		root.terminal.website.text.Text = "www."..site.dns.Value..".net"
	else
		root.terminal.website.text.Text = "unable to resolve domain name"		
	end
end




















--update analysis
function update_analysis()
	local anal = root.terminal.analysis --dat variabl name tho
	anal.firewall.Visible = cur_ip:FindFirstChild("firewall")
	anal.right.Text = "Your rights on the server : "..(isadmin() and "admin" or "guest")
	anal.text.Text = cur_ip.Name .. " - Network Analysis"
end



















local console = {
	text={}
}
do
	console.format = function()
		if string.len(root.terminal.console.text.Text) > 1030 or #console.text > 30 then
			table.remove(console.text,1)
		end
		local t = ""
		for i, v in pairs (console.text) do
			t = t.."\n"..v
		end
		return t.."\n"
	end
	console.add = function(t)
		console.text[#console.text+1] = t
	end
end














--data types
function getdatatype(obj)
	if obj:IsA("StringValue") then
		return ".txt"
	elseif obj:IsA("Folder") then
		return ""
	elseif obj:IsA("BoolValue") then
		return ".exe"
	elseif obj:IsA("ScrollingFrame") then
		return ".xml"
	end
end

--authentication
do
	function isadmin()
		return cur_ip.admin:FindFirstChild(myip.Name)
	end
end
























--firmware framework
local fware = {}
do
	--boot system
	fware.boot = function(safe)
		--delete sys so nobody can connect
		if mypc:FindFirstChild("sys") then
			mypc.sys:Destroy()
		end
		--assign ip
		myip.Name = math.random(128,191).."."..math.random(128,191).."."..math.random(128,191).."."..math.random(128,191)
		local mypass = ""
		for i = 1, 8 do
			local a = string.char(math.random(97,122))
			mypass = mypass .. a	
		end 
		--assign pass
		myip.password.Value = mypass
		--authorize
		local auth = Instance.new("ObjectValue")
		auth.Parent = myip.admin
		auth.Name = myip.Name
		--system repair if necessary
		for i, v in pairs (game.ReplicatedStorage.data.pc:GetChildren()) do
			if not mypc:FindFirstChild(v.Name) then
				v:Clone().Parent = mypc
			end
		end
		--enable crash boot sequence if not safe
		if not safe then
			root.crash.Visible = true
			wait(10)
			root.crash.Visible = false
		end
		--set up console
		console.text = {}
		local t = {
			"initiliazing epsilon...",
			"loading programs",
			"loading ui",
			"login "..game.Players.LocalPlayer.Name,
			"access code : "..mypass,
			"login successful",
			"connecting to "..myip.Name,
			"connection established",
			"epsilon started [v0.3.6]",
			"welcome!",
			"type help to see all possible commands."
		}
		spawn(function()
			for i = 1, #t do
				if i%2 == 0 then
					wait()
				end
				table.insert(console.text,t[i])
			end
		end)		
		cur_ip = myip
		cur_dir = mypc
	end
	--update system
	fware.update = function()
		if not mypc:FindFirstChild("sys") then
			fware.boot(false)
		end
		if not cur_ip.Value:FindFirstChild("sys") then
			console.add("disconnected from "..cur_ip.Name)		
			cur_ip = myip		
			cur_dir = mypc				
		end
	end
end
fware.boot(true)






























--filesystem
local fsys = {}
do
	fsys.delete = function(file)
		spawn(function()
			console.add(" deleting file: "..file.Name.."[0%]")
			local ran = math.random(5,10)
			for i = 1, ran do
				if file and file:IsDescendantOf(cur_ip.Value) then
					console.add(" deleting file: "..file.Name.."["..math.floor(((i/ran)*100)).."%]")
					wait(0.1)
				else
					break
				end
			end
			if file and file:IsDescendantOf(cur_ip.Value) then
				file:Destroy()
			else
				console.add("file deletion proccess [FAILED]")			
			end
		end)
	end
	fsys.download = function(file)
		spawn(function()
			console.add(" downloading file: "..file.Name.."[0%]")
			local ran = math.random(5,40)
			for i = 1, ran do
				if file and file:IsDescendantOf(cur_ip.Value) then
					console.add(" downloading file: "..file.Name.."["..math.floor(((i/ran)*100)).."%]")
					wait(0.1)
				else
					break
				end
			end
			if file and file:IsDescendantOf(cur_ip.Value) then
				local v = file:Clone()
				local t = getdatatype(v)
				if t == ".exe" then
					v.Parent = mypc.bin
				elseif t == ".txt" then
					v.Parent = mypc.home
				elseif t == ".xml" and mypc:FindFirstChild("web") then
					v.Parent = mypc.web
				else
					v.Parent = mypc
				end
			else
				console.add("file download proccess [FAILED]")			
			end
		end)
	end
	fsys.upload = function(file)
		spawn(function()
			console.add(" uploading file: "..file.Name.."[0%]")
			local ran = math.random(5,60)
			for i = 1, ran do
				if file and file:IsDescendantOf(cur_ip.Value) then
					console.add(" uploading file: "..file.Name.."["..math.floor(((i/ran)*100)).."%]")
					wait(0.1)
				else
					break
				end
			end
			if file and file:IsDescendantOf(myip.Value) and cur_ip ~= myip then
				file:Clone().Parent = cur_dir
			else
				console.add("file upload proccess [FAILED]")			
			end
		end)
	end
	fsys.update = function()
		root.terminal.buttons.explorer.Visible = isadmin()
		if root.terminal.explorer.Visible == true and not isadmin() then
			root.terminal.explorer.Visible = false
		end
		root.terminal.warn.Visible = emergency
		root.terminal.explorer.text.Text = cur_ip.Name .. " - " .. cur_dir.Name
		local index = 0
		local list = root.terminal.explorer.list
		list:ClearAllChildren()
		if cur_dir.Parent ~= workspace then
			index = index + 1
			local button = storage.file:Clone()
			button.Position = UDim2.new(0,0,0,-list.CanvasPosition.Y)	
			if cur_dir.Parent.Parent == workspace then
				button.Text = "<"	
			else
				button.Text = "<"..cur_dir.Parent.Name	
			end
			button.MouseButton1Down:Connect(function()
				cur_dir = cur_dir.Parent
			end)
			button.Parent = list
		end
		for _, folder in pairs (cur_dir:GetChildren()) do
			index = index + 1
			local suffix = getdatatype(folder)
			local button = storage.file:Clone()
			button.Position = UDim2.new(0,0,0,30*(index-1)-list.CanvasPosition.Y)
			if folder.Parent.Parent == workspace then
				button.Text = ">/" .. folder.Name .. suffix
			else
				button.Text = ">"..folder.Parent.Name .. "/" .. folder.Name .. suffix	
			end
			button.MouseButton1Down:Connect(function()
				if folder:IsA("Folder") then
					cur_dir = folder
				end
			end)
			button.Parent = list
		end
	end	
end



























--brute force
local bforce={}
do
	bforce.running = false
	bforce.run = function(sl,su,r,sm,rm,rm2,em)
		if not bforce.running then
			bforce.target = cur_ip
			bforce.running = true 
			console.add(sm)
			spawn(function()
				--execute
				for i = 0, math.random(sl,su) do
					if cur_ip == bforce.target then
						wait()
						local s = rm..i..rm2
						for i = 1, 32 do
							local a = string.char(math.random(33,126))
							s = s .. a				
						end
						console.add(s)
					else
						break
					end
				end
				if cur_ip == bforce.target then
					--return results
					console.add(em)
					local passes = {}
					for i = 1, r do
						math.randomseed(math.sin(tick())*tick())
						local s = ""
						for i = 1, 8 do
							local a = string.char(math.random(97,122))
							s = s .. a	
						end
						table.insert(passes,s)			
					end	
					passes[math.random(1,#passes)] = cur_ip.password.Value
					for i, v in pairs (passes) do
						console.add(v)
					end	
				else
					console.add("CONNECTION LOST WHILE BRUTE FORCING.")					
				end
				bforce.running = false
			end)
		end					
	end
end




























--netframework
local netfw={}
do
	netfw.authorize=function()
		local auth = Instance.new("ObjectValue")
		auth.Parent = cur_ip.admin
		auth.Name = myip.Name
		game.Players.LocalPlayer.GameData.hacked.Value = game.Players.LocalPlayer.GameData.hacked.Value .. cur_ip.Value.Name
	end
	netfw.addlog=function(text)
		if cur_ip.Value:FindFirstChild("log") then
			local log = Instance.new("StringValue")
			log.Parent = cur_ip.Value.log
			log.Name = myip.Name.." "..text.." @"..tick()
		end
	end
end


























--cprocessor
local cpros={}
do
	cpros.ram = {}
	cpros.program = {
		--red
		["red.run"] = function()
			local corrupt = [[
			                  Ddh                               
			              Dddy                                
			     DDyhhhhhdRhD                  DhRRRRRdy      
			  DhRRdhhhhhhyD                  DhRRRRRRRRRdD    
			aaaaaaa hREdD                           RRhDdRSDASDRdyhRR    
			hERh                             ER(_)66 SAD SAD    6(_)dE    
			ERRh           a    DyhhhhhhhhhdERRRE^ARRRRER   
			dERRRy     d adddddRREEREEEEEEEEDSDRERREERR__ERER__EEy   
			    DhdRRRRERERREEREEREERERREERREDEERRERERRRRy    
			       DDddREEREREEEREREEEEEEEEEEEEEREERhDDD      
			        DDDyhREEEEEEEEEEREEEEE ddddERRRREEEhyhdhhhhyyD 
			         a   DERdRRERRRERREEhdEERREERRREEdRED  y  D     
			     dad dDRERyRREEERREEd  REEERRRRREddER            
			        dERDERREERdEdD  DEEEEyREy            
			         REDdEd                hE dddadRERhREydEd            
			        hEadEdDEEh              DEEyREd             
			         DERhhERD             RERhRRD             
			          DR as yEh            yEdDEd               
			            dh Dd            dy yy  				
			]]
			local red = [[
			                  Ddh                               
			              Dddy                                
			     DDyhhhhhdRhD                  DhRRRRRdy      
			  DhRRdhhhhhhyD                  DhRRRRRRRRRdD    
			 hREdD                           RRhDdRRRdyhRR    
			hERh                             ER(_)666(_)dE    
			ERRh                 DyhhhhhhhhhdERRRE^d^RRRRER   
			dERRRy           DydREEEEEEEERREEERRRhyyyyRRREd   
			 hERERdyD      yhRERERREEREEREEREEEdy ____ hEEd   
			  ydEEEREddddddRREEREEEEEEEERERREERR__ERER__EEy   
			    DhdRRRRERERREEREEREERERREERREREERRERERRRRy    
			       DDddREEREREEEREREEEEEEEEEEEEEREERhDDD      
			        DDDyhREEEEEEEEEEREEEEEERRRREEEhyhdhhhhyyD 
			       yRERERREEEEEEEEEEEEREEERREERREEEEEERRRREEdh
			       RERRRRRRREREEEEREEEEEEREERREREERRRRREERyRyy
			       yERREERREEEEEEERREEEdEEERREEdREyydRyhhh DD 
			       DERdRRERRRERREEhdEERREERRREEdRED  y  D     
			       DRERyRREEERREEd  REEERRRRREddER            
			        dERDERREERdEdD  DEEERERhREydEd            
			        hERDRRDDy        Dy     REyREy            
			         REDdEd                hERDRRD            
			         ERyhEd                dERDRE             
			         hEdDEEh              DEEyREd             
			         DERhhERD             RERhRRD             
			          DRE yEh            yEdDEd               
			            dh Dd            dy yy  
			]]     
			cpros.run("color 200 0 0")
			spawn(function()
				local f = true
				repeat
					wait()
					if mypc.bin:FindFirstChild("red") or mypc.home:FindFirstChild("red") or mypc.sys:FindFirstChild("red") or mypc.log:FindFirstChild("red") then
						cpros.run("clear")
						console.add(red)
						local victims = {"home","bin","sys","log"}
						if math.random(1,100) == 1 then
							local red = Instance.new("BoolValue")
							red.Name = "red"
							red.Parent = mypc[victims[math.random(1,#victims)]]
						end
					else
						f = false
					end
				until f == false
				cpros.run("clear")
				console.add(corrupt)
				cpros.run("color 255 255 255")
			end)         			
		end,
		--chatsystem
		["chat.rooms"]=function()
			console.add("listing current public chatrooms:")			
			console.add("# pub1")
			console.add("# pub2")
			console.add("# pub3")
		end,
		["chat.run"]=function()
			console.add([[
				ChatSys v4.2a loaded
				
					Welcome to ChatSys! 
					A program designed to securely handle direct messaging.
					ChatSys relays data through on a highly secure mainframe server ;
					This ensures your messages to never be intercepted.
					
					Usage:
						chat.rooms --> lists available public rooms
						chat.join [room_name] --> joins the chat room [room_name]
						chat.send [msg] --> sends [msg] to the current room
			]])
		end,
		["chat.join"]=function(room)
			local cserv = workspace["Public ChatServer"]
			if not cserv:FindFirstChild(room) then
				local folder = Instance.new("Folder",cserv)
				folder.Name = room			
			end
			cpros.ram.curchat = cserv[room]
			console.add(room.." set as current chatroom")
		end,
		["chat.send"]=function(...)
			local args = {...}
			local s = ""
			for i = 1, #args do
				s = s..args[i].." "
			end
			local msgdata = Instance.new("ScrollingFrame")
			msgdata.Name = game.Players.LocalPlayer.Name .. " : " .. s
			msgdata.Parent = cpros.ram.curchat
		end,
		--truebrute
		["trubrute.run"]=function()
			bforce.run(600,800,1,"TruBrute v0.4 initialized, starting sequencer."," ~trubruteseq~ "," ~trubruteseq~ ","sequence complete, key found:")
		end,
		--bruteforcer
		["basicbrute.run"]=function()
			bforce.run(200,400,5,"INITIATING BRUTE FORCE SEQUENCE","battempt # "," ","SEQUENCER COMPLETE, POSSIBLE KEYS RETURNED:")
		end,
		--lightbrute
		["lightbrute.run"]=function()
			bforce.run(100,200,10,"LightBrute v0.5a started, starting fastcrack sequence.","< attempt > "," ","key guesses:")			
		end
	}
	cpros.library = {
		--reboot
		reboot=function(crash)
			if crash == "true" then
				fware.boot(false)
			else
				fware.boot(true)						
			end
		end,
		--connect to network
		connect=function(arg)
			console.add("connecting to "..arg)
			if workspace:FindFirstChild(arg) then
				netfw.addlog("connected")
				console.add("connected to "..workspace[arg].Value.Name.."@"..arg)
				cur_ip = workspace[arg]
				cur_dir = cur_ip.Value
			else
				console.add("failed to connect to "..arg)			
			end
		end,
		--download file
		scp=function(name)
			if isadmin() and cur_ip ~= ip then
				if cur_dir:FindFirstChild(name) then
					fsys.download(cur_dir[name])
				end				
			end
		end,
		--upload file
		upload=function(name)
			if isadmin() and cur_ip ~= ip then
				if mypc:FindFirstChild(name,true) then
					netfw.addlog("downloaded "..name)
					fsys.upload(mypc:FindFirstChild(name,true)[name])
				end				
			end
		end,
		--disconnect from network
		dc=function()
			console.add("disconnected from "..cur_ip.Name)		
			cur_ip = myip		
			cur_dir = mypc		
		end,
		--login to a network
		login=function(key)
			if key == cur_ip.password.Value then
				netfw.addlog("became admin")
				netfw.authorize()
				console.add("successfuly logged in as admin")
			else
				console.add("incorrect access key")
			end
		end,
		--change text color
		color=function(c1,c2,c3)
			if tonumber(c1) and tonumber(c2) and tonumber(c3) then
				--root.terminal.console.text.TextColor3 = Color3.new(c1/255,c2/255,c3/255)
				function colorshit(a)
					for _, b in pairs (a:GetChildren()) do
						if b:IsA("TextLabel") or b:IsA("TextBox") then
							b.TextColor3 = Color3.new(c1/255,c2/255,c3/255)
						end
						colorshit(b)
					end
				end
				colorshit(root.terminal)
			else
				console.add("syntax error")
			end
		end,
		--list directory
		ls=function()
			if isadmin() then
				console.add("files in "..cur_dir.Name..": ")
				for _, v in pairs (cur_dir:GetChildren()) do
					console.add(v.Name)
				end
			end
		end,
		--cd
		cd=function(dir)
			if isadmin() then
				if dir then
					if dir == ".." and cur_dir.Parent ~= workspace then
						cur_dir = cur_dir.Parent
					elseif cur_dir:FindFirstChild(dir) then
						cur_dir = cur_dir[dir]
					end
					console.add(cur_dir.Name.." set as current directory")
				else
					console.add("syntax error")				
				end
			end
		end,
		--rm
		rm=function(arg)
			if isadmin() then			
				if arg == "*" then
					for _, v in pairs (cur_dir:GetChildren()) do
						if cur_dir.Name ~= "log" then
							netfw.addlog("deleted "..v.Name)
						end
						fsys.delete(v)
					end
				elseif cur_dir:FindFirstChild(arg) then
					if cur_dir.Name ~= "log" then
						netfw.addlog("deleted "..arg)
					end
					fsys.delete(cur_dir[arg])
				else
					console.add("could not find "..arg.." in current directory")
				end
			end
		end,
		--clear text
		clear=function()
			console.text = {}
		end,
		--help
		["help.program"] = function()
			local s = [[
				/==PROGRAM BASICS==/
				/==========================================================/
				
				programs are .exe files in your bin folder, they are used
				to carry out many tasks, programs can be ran by writing
				PROGRAM_NAME.run into the console, example: chat.run will
				start up chat
				
				/==========================================================/
			]]
			console.add(s)			
		end,
		help = function()
			local s = [[
				/==BASIC COMMANDS==/
				/==========================================================/
				connect [IP] --> connects to IP
				dc --> disconnects from current network
				login [KEY] --> login as admin to current system using KEY
				rm [TARGET] --> deletes file in current directory
				rm * --> deletes all files in current directory
				cd [DIR] --> sets DIR as current directory
				cd .. --> navigates out of current directory
				scp [FILENAME] --> downloads FILENAME to your system
				ls --> lists all files in current directory
				color --> changes color scheme of the terminal
				cat [FILENAME] --> reads a text file
				reboot --> restarts the system
				/==========================================================/
				some commands require ADMIN rights on a system to execute.
				type "help.program" to see help on using programs
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
			cpros.library[cmd](unpack(args))	
		elseif cpros.program[fullname] and myip.Value.bin:FindFirstChild(filename) then 
			cpros.program[fullname](unpack(args))
		else
			console.add("unrecognized command: "..cmd)
		end
	end
end



























--@Chat
--chatsystem
local chatsys={}
do
	chatsys.update = function() 
		if cpros.ram.curchat then
			root.terminal.chat.text.Text = "CHAT - "..cpros.ram.curchat.Name
			root.terminal.chat.list:ClearAllChildren()
			for _, v in pairs (cpros.ram.curchat:GetChildren()) do
				local node = storage.chat:Clone()
				node.Position = UDim2.new(0,0,0,30*(_-1)-root.terminal.chat.list.CanvasPosition.Y)
				node.Text = v.Name
				node.Parent = root.terminal.chat.list			
			end
		end
	end
end


















--@Music
--dynmusic
local dynmusic = {}
do
	local old
	local new
	dynmusic.set = function(id)
		local continue = false
		if new then
			continue = new.soundId ~= "rbxassetid://"..id
		else
			continue = true
		end
		if continue then
			if new then
				old = new
			end
			new = Instance.new("Sound",root)
			new.SoundId = "rbxassetid://"..id
			new.Volume = 0
			new.Looped = true
			new:Play()
		end
	end
	dynmusic.update = function()
		if old then
			old.Volume = old.Volume - 0.01
			if old.Volume <= 0 then
				old:Destroy()
			end
		end
		if new and new.Volume < 1 then
			new.Volume = new.Volume + 0.01
			if new.Volume >= 1 then
				new.Volume = 1
			end
		end
	end
	dynmusic.gameplay_update = function()
		if not isadmin() then
			dynmusic.set(678773575)
		else
			dynmusic.set(678526827)		
		end
	end
end































local mouse = game.Players.LocalPlayer:GetMouse()
local mousedown = false
local typing = false
inpserv.InputBegan:Connect(function(input,gp)
	if input.UserInputType == Enum.UserInputType.Keyboard and not root.terminal.notes.list.TextBox:IsFocused() then
		typing = true
		root.terminal.input:CaptureFocus()	
		local key = input.KeyCode
		if key == Enum.KeyCode.Return then
			table.insert(console.text,root.terminal.input.Text)
			cpros.run(root.terminal.input.Text)
			root.terminal.input.Text = ""						
		end
	elseif input.UserInputType == Enum.UserInputType.MouseButton1 or root.terminal.notes.list.TextBox:IsFocused() then
		typing = false
		mousedown = true		
	end
end)
inpserv.InputEnded:Connect(function(input,gp)
	if input.UserInputType == Enum.UserInputType.MouseButton1 and not root.terminal.notes.list.TextBox:IsFocused() then
		mousedown = false		
	end
end)


























iplist()





















while game:GetService("RunService").RenderStepped:wait() do
	if not booting then
		dynmusic.update()
		dynmusic.gameplay_update()
		root.terminal.topbar.Visible = not isplaying
		root.terminal.topbar.bc.Text = game.Players.LocalPlayer.GameData.coins.Value .. " BitCredits"
		if not root.terminal.input:IsFocused() and not mousedown or typing then
			root.terminal.input:CaptureFocus()	
		else
			root.terminal.input:ReleaseFocus()				
		end	
		if tick()-t0 >= 0.1 then
			if usc == "_" then
				usc = ""
			else
				usc = "_"
			end
			t0 = tick()
		end
		root.terminal.console.text.Text = console:format()..">"..root.terminal.input.Text..usc
		fsys.update()
		update_analysis()
		update_website()
		chatsys.update()
		fware.update()
	end
end