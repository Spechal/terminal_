--[[
	terminal core server
	3/30/2017
	hexadecival
	
	@servs
	@net
	@init
	@log
	@rights
	@file
	@connect
--]]

repeat wait() until game.StarterGui:FindFirstChild("ui")

--@servs
local run = game:GetService("RunService")
local step = run.RenderStepped
local contextserv = game:GetService("ContextActionService")
local inpserv = game:GetService("UserInputService")
local storage = game:GetService("ReplicatedStorage")
local internet = workspace.internet

--@network
local net = {event=storage.event}
do
	net.event.OnServerEvent:connect(function(plr,f,...)
		print("server event : "..plr.Name.." : "..f)
		net[f](...)
	end)
end

function ipv6()
	local s = ""
	local c = {1,2,3,4,5,6,7,8,9,"A","B","C","D","E","F"}
	for i = 1, 4 do
		s = s .. c[math.random(1,#c)]
	end
	return s
end

--@init
function init(plr)
	if not workspace.internet.machines:FindFirstChild(plr.Name .. " PC") then
		local mypc = storage.pc:Clone()
		mypc.Parent = internet.machines
		mypc.Name = plr.Name .. " PC"
		local myip = storage.ip:Clone()
		myip.Parent = internet.ips
		myip.Name = ipv6()
		myip.Value = mypc
		local root = Instance.new("ObjectValue",mypc.sys.root)
		root.Name = mypc.Name
		net.event:FireClient(plr,"init",mypc,myip)
	else
		local mypc = workspace.internet.machines:FindFirstChild(plr.Name .. " PC")
		local myip = storage.ip:Clone()
		myip.Parent = internet.ips
		myip.Name = ipv6()
		myip.Value = mypc
		net.event:FireClient(plr,"init",mypc,myip)		
	end
end

--@log
local log = {}
do
	log.new = function(pc,msg)
		local log_ = Instance.new("StringValue")
		log_.Parent = pc.log
		log_.Name = msg.." @"..tick()	
		local typee = Instance.new("StringValue")
		typee.Parent = log_
		typee.Name = "type"
		typee.Value = "text"	
	end
end

--@right
local right = {}
do
	right.new = function(mypc,pc,rgt)
		local right = Instance.new("ObjectValue")
		right.Name = mypc.Name
		right.Parent = pc.sys[rgt]
	end
end

--@task
local task = {}
local ta = {}
do
	task.ends = {
		["delete"] = function(at,t)
			log.new(at,t[2].Name.." deleted "..t[1].Name)
			t[1]:Destroy()
		end,
		["download"] = function(at,t)
			log.new(at,t[2].Name.." downloaded "..t[1].Name)
			t[1]:Clone().Parent = t[2].home
		end
	}
	task.abort = function(v)
		v:Destroy()
	end
	task.stop = function(v)
		task.ends[v.Name](v.at.Value,ta[v])	
		v:Destroy()
	end
	task.exec = function(ghz,v)
		v.progress.Value = v.progress.Value + (v.increment.Value*ghz)/60
	end
	task.new = function(sch,name,at,t,tr,msg,plr)
		local a = Instance.new("ObjectValue",sch)
		a.Name = name
		local att = Instance.new("ObjectValue",a)
		att.Name = "at"
		att.Value = at
		local progress = Instance.new("NumberValue",a)
		progress.Name = "progress"
		progress.Value = 0
		local increment = Instance.new("NumberValue",a)
		increment.Name = "increment"
		increment.Value = t
		ta[a] = tr
		local msgg = Instance.new("StringValue",a)
		msgg.Name = "msg"
		msgg.Value = msg
		if plr then
			net.event:FireClient(plr,"relay_target",a,tr)
		end
	end
end

local ds = game:GetService("DataStoreService"):GetDataStore("Data")

local crap = {
	["String"] = "StringValue",
	["Number"] = "NumberValue"
}

--@load
--game.Players.PlayerAdded:connect(function(plr)
--	local pc = internet.machines:FindFirstChild(plr.Name.." PC")
--	local dt = ds:GetAsysnc(plr.UserId)
--	if pc then
--		function recurseload(a,t)
--			for i, v in pairs (t) do
--				if type(v) == "table" then
--					local thing = Instance.new(crap[type(v)])
--					thing.Parent = a
--					thing.Value = v
--					thing.Name = i
--					recurseload(thing,v)
--				elseif not a:FindFirstChild(i) then
--					local thing = Instance.new(crap[type(v)])
--					thing.Parent = a
--					thing.Value = v
--					thing.Name = i
--				end
--			end
--		end
--		recurseload(pc,dt)
--	end
--end)

--@save
--game.Players.PlayerRemoving:connect(function(plr)
--	
--end)

--@connect
net.giveright = right.new
net.newlog = log.new
net.init = init
net.newtask = task.new
net.killtask = task.stop
net.stoptask = task.abort
net.download = function(file,dest)
	local copy = file:Clone()
	local dest = {
		["exe"] = "bin",
		["cracker"] = "bin",
	}
end