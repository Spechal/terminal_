--[[
	terminal core framework
	3/30/2017
	hexadecival
	
	@servs
	@vars
	@init
	@load
	@console
	@command
	@input
	@loop
	@program
	@taskbar
--]]

--@servs
local run = game:GetService("RunService")
local step = run.RenderStepped
local contextserv = game:GetService("ContextActionService")
local inpserv = game:GetService("UserInputService")
local storage = game:GetService("ReplicatedStorage")

--@vars
local plr = game.Players.LocalPlayer
local ui = plr.PlayerGui.ui
local note = nil

--@init
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
end

--@load
local load = {}
do
	local loadtext = {
		"Modules",
		"UI",
		"CLI",
		"Themes",
		"Presets",
		"User"
	}
	local curtext = 1
	local t0 = tick()
	local loadspeed = 0.1
	local loadui = ui.load
	local loading = false
	load.start = function()
		t0 = tick()
		curtext = 1
		loading = true
	end
	load.update = function()
		loadui.Visible = loading
		loadui.update.Text = "Loading "..loadtext[curtext]
		if loading then
			loadui.rot.Rotation = loadui.rot.Rotation+1
			if tick()-t0 > loadspeed then
				if loadtext[curtext+1] ~= nil then
					curtext = curtext+1
				else
					loading = false
				end
				t0 = tick()
			end
		end
	end
end

--@console
local console = {
	text={},
	typing=false,
	mousedown=false
}
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
	console.add = function(t)
		console.text[#console.text+1] = t
	end
	console.update = function()
		if not ui.input:IsFocused() and not console.mousedown or console.typing then
			if note ~= nil then
				if not note:IsFocused() then
					ui.input:CaptureFocus()	
				end
			else
				ui.input:CaptureFocus()					
			end
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
--cprocessor
local cpros = {}
do
	cpros.ram = {}
	cpros.library = {
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
		--help
		["help.program"] = function()
			local s = [[
				/==PROGRAM BASICS==/
				/==========================================================/
				
				programs are .exe files in your bin folder, they are used
				to carry out many tasks, programs can be ran by writing
				run [PROGRAM_NAME] into the console, example: chat.run will
				run the chatsys program.

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
						
				/==========================================================/
			]]
			console.add(s)			
		end,
		help = function()
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
				color --> changes color scheme of the terminal
				cat [FILENAME] --> reads a text file
				reboot --> restarts the system
				cls/clear --> clears text on screen
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
			console.typing = true
			ui.input:CaptureFocus()	
			local key = input.KeyCode
			if key == Enum.KeyCode.Return then
				table.insert(console.text,ui.input.Text)
				cpros.run(ui.input.Text)	
				ui.input.Text = ""				
			end
		elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
			console.typing = false
			mousedown = true		
		end
	end)
	inpserv.InputEnded:Connect(function(input,gp)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			mousedown = false		
		end
	end)
end

--@program
local program = {}
do
	local bestindex = 2
	local notestext = ""
	program.start = {
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
	program.new = function(name)
		if not ui.desktop:FindFirstChild(name) then
			local window
			window = storage.programs[name]:Clone()
			window.Parent = ui.desktop
			window.Position = UDim2.new(0,math.random(100,400),0,math.random(100,400))
			if program.start[window.Name] then
				program.start[window.Name](window)
			end
			window.close.MouseButton1Down:connect(function()
				if program.stop[window.Name] then
					program.stop[window.Name](window)
				end
				window:Destroy()
			end)
		end
	end
end

--@taskbar
do
	local taskbar = ui.desktop.taskbar
	for i, v in pairs(taskbar:GetChildren()) do
		v.MouseButton1Down:connect(function()
			program.new(v.Name)
		end)
	end
end

load.start()

--@loop
while step:wait() do
	console.update()
	load.update()
end