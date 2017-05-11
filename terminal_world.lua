repeat wait() until game.StarterGui:FindFirstChild("ui")
local WorldInfo = {
	--Personal computer
	{
		Prefix = {
			"John",
			"Jane",
			"Jeff",
			"Yan",
			"Kaden",
			"Andrew",
			"Toby",
			"Wade",
			"Jason",
			"Spencer",
			"Anthony",
			"Zack",
			"Nelson",
			"Keith",
			"Nicole",
			"Arthur",
			"Trusov",
			"Tommy",
			"Muhammad",
			"Ismail",
			"Rashid",
			"Ibrahim",
			"Joel",
			"Braun",
			"Chris",
			"Patrick",
			"Jenny",
			"Mary",
			"Lucy",
			"Kelly",
			"Samantha",
			"Kaila",
			"Clinton",
			"Donald",
			"Trump",
			"Sam",
			"Andrew",
			"Alex",
			"Billy",
			"Bob",
			"Cassidy",
			"Dylan",
			"Eric",
			"Frill",
			"George",
			"Harry",
			"Inn",
			"Joseph",
			"Josh",
			"Kani",
			"Lulu",
			"Marcus",
			"Nan",
			"Orange",
			"Po",
			"Quebec",
			"Rachel",
			"Richard",
			"Sam",
			"Samantha",
			"Toby",
			"Uni",
			"Valerie",
			"Wesley",
			"Xar",
			"Yolin",
			"Zomb",
			"Lilly",
			"Mia",
			"Aimee",
			"Amy",
			"Lucy",
			"Ryleigh",
			"Britney",
			"Kylie",
			"Kenzie",
			"Dakota",
			"Charlotte",
			"Stacy",
			"Jordana",
			"Melissa",
			"Mor"		
		},
		Suffix = {
			"PC"		
		},
		Files = {
			{"sales","text"},
			{"readme","text"},
			{"diary","text"},
			{"bank_details","text",1},
			{"creditcard","text",1},																
			{"crime_wave","exe"},
			{"space_invaders","exe"},
			{"phantom_forces","exe"},
			{"WoG3","exe"},
			{"tvbm","exe"},
			{"cbro","exe"},
			{"jetskirush","exe"},
			{"openoffice","exe"},
			{"macrosoft_office","exe"},
			{"powerpaint","exe"},
			{"pdfviewer","exe"},
			{"word","exe"},
			{"testbuild","exe"},
			{"stockgraph","text"},
			{"info","text"},
			{"crashinfo","text"},
			{"murder_evidence","text",1},
			{"AccessKeys","text",1},
			{"emaildraft","text"},
			{"config","text"},
			{"blueprint","text",1},
			{"junk","text"},
			{"cookies","text"},
			{"notes","text"},
			{"todolist","text"},
			{"portfolio","text"},
			{"chatlogs","text"},
			{"chat","exe"},
			{"faxeddocument","text"},
			{"sales","text"},
			{"family","text"},
			{"shoppinglist","text"},
			{"songs","text"},
			{"artists","text"},
			{"jsontable","text"},
			{"red","exe"},
			{"lightbrute","exe"},
			{"trubrute","exe"}																																																		
		}
	},
	--Company computer
	{
		Prefix = {
			"Uphone",
			"Goggle",
			"Megahard",
			"Nooby's",
			"Decival",
			"Cyex",
			"Axel",
			"Roadblox",
			"Volvo",
			"Stylist",
			"Faker",
			"OpenSource",
			"SourceCode",
			"Realnet",
			"Keksi",
			"KCF",
			"McReynolds",
			"GamingDev",
			"Waffled",
			"Hexagonal",
			"Cyanic",
			"Zakker",
			"Trixus",
			"Null",
			"Logic",
			"CodeBlock",
			"Java",
			"WoG",
			"CrimeWave",
			"Average",
			"Dull",
			"Cool",
			"Ski",
			"OpenSoft",
			"StockGrowth",
			"TechnoMage",
			"AbandonWare",
			"Bit",
			"Boring",
			"Fun",
			"Introversion"
		},
		Suffix = {
			"Studio",
			"Enterprises",
			"Marketing",
			"Telecommunications",
			"Technologies",
			"Games",
			"Software",
			"Hardware",
			"Solutions",
			"Logistics",
			"Corporation",
			"Productions",
			"Recordings",
			"Graphics",
			"Digital",
			"Softworks",
			"Mainframe",
			"Testserver",
			"Filedump"
		},
		Files = {
			{"sales","text"},
			{"readme","text"},
			{"diary","text"},
			{"bank_details","text",1},
			{"creditcard","text",1},																
			{"crime_wave","exe"},
			{"space_invaders","exe"},
			{"phantom_forces","exe"},
			{"WoG3","exe"},
			{"tvbm","exe"},
			{"cbro","exe"},
			{"jetskirush","exe"},
			{"openoffice","exe"},
			{"macrosoft_office","exe"},
			{"powerpaint","exe"},
			{"pdfviewer","exe"},
			{"word","exe"},
			{"testbuild","exe"},
			{"stockgraph","text"},
			{"info","text"},
			{"crashinfo","text"},
			{"config","text"},
			{"emaildraft","text"},
			{"company_secrets","text",1},
			{"new_project","exe",1},
			{"blueprint","text",1},
			{"junk","text"},
			{"cookies","text"},
			{"notes","text"},
			{"todolist","text"},
			{"portfolio","text"},
			{"chatlogs","text"},
			{"chat","exe"},
			{"faxeddocument","text"},
			{"sales","text"},
			{"family","text"},
			{"shoppinglist","text"},
			{"songs","text"},
			{"artists","text"},
			{"jsontable","text"},
			{"lightbrute","exe"},
			{"trubrute","exe"}	
		}
	}
}

function ipv6()
	local s = ""
	local c = {1,2,3,4,5,6,7,8,9,"A","B","C","D","E","F"}
	for i = 1, 4 do
		s = s .. c[math.random(1,#c)]
	end
	return s
end

math.randomseed(math.sin(tick())*tick())

local world = nil
function make_world()
	for i = 1, 250 do
		local ChosenType = WorldInfo[math.random(1,#WorldInfo)]
		local Prefix = ChosenType.Prefix[math.random(1,#ChosenType.Prefix)]
		local Suffix = ChosenType.Suffix[math.random(1,#ChosenType.Suffix)]
		local pc = game.ReplicatedStorage.pc:Clone()
		pc.Parent = workspace.internet.machines
		pc.Name = Prefix .. " " .. Suffix
		for i, v in pairs (pc.bin:GetChildren()) do
			v:Destroy()
		end
		local Blacklist = {}
		for i = 1, math.random(1,16) do
			local aproprifol = {
				["text"] = "home",
				["exe"] = "bin"
			}
			local indice = math.random(1,#ChosenType.Files)
			if not Blacklist[indice] then
				local file = ChosenType.Files[indice]
				local a = Instance.new("BoolValue",pc[aproprifol[file[2]]])
				a.Name = file[1]
				local typee = Instance.new("StringValue",a)
				typee.Name = "type"
				typee.Value = file[2]			
				if file[3] ~= nil then
					local cansell = Instance.new("NumberValue",a)
					cansell.Name = "worth"
					cansell.Value = math.random(1,8)
					a.Name = a.Name .. string.char(math.random(97,122)) .. string.char(math.random(97,122)) .. string.char(math.random(97,122)) .. string.char(math.random(97,122))
				end
			end
			table.insert(Blacklist,indice)
		end
		local myip = ipv6()
		local ip = game.ReplicatedStorage.ip:Clone()
		ip.Parent = workspace.internet.ips 
		ip.Name = myip
		ip.Value = pc
		local tracker = Instance.new("BoolValue",pc.sys)
		tracker.Name = "iplist"
		local typee = Instance.new("StringValue",tracker)
		typee.Name = "type"
		typee.Value = "sys"
		local s = ""
		for i = 1, 8 do
			local a = string.char(math.random(97,122))
			s = s .. a	
		end
		if ChosenType == WorldInfo[2] then
			local tracer = Instance.new("NumberValue",pc.sys)
			tracer.Value = math.random(100,1000)/5000
			tracer.Name = "tracer"
			local typee = Instance.new("StringValue",tracer)
			typee.Name = "type"
			typee.Value = "sys"			
		end
		local key = pc.sys.root.key
		key.Value = s
		local s = ""
		for i = 1, 8 do
			local a = string.char(math.random(97,122))
			s = s .. a	
		end
		local key2 = pc.sys.ssh.key
		key2.Value = s
		local s = ""
		for i = 1, 8 do
			local a = string.char(math.random(97,122))
			s = s .. a	
		end
		local key3 = pc.sys.ftp.key
		key3.Value = s		
		pc:Clone().Parent = game.ReplicatedStorage.world
	end
end

print(script.server_starts.Value)
if script.server_starts.Value <= 0 then
	make_world()
end
script.server_starts.Value = script.server_starts.Value + 1

while wait(300) do
   for i, v in pairs (workspace.internet.machines:GetChildren()) do
		if game.ReplicatedStorage.world:FindFirstChild(v.Name) then
			for ii, vv in pairs (game.ReplicatedStorage.world:FindFirstChild(v.Name):GetChildren()) do
				if not v:FindFirstChild(vv.Name) then
					vv:Clone().Parent = v
				end
			end
		end
	end
end

