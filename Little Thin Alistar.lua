myHero=GetMyHero()
if myHero.charName ~= "Alistar" then return end

local AUTOUPDATE = true
local version = "0.05"
local UPDATE_HOST = "raw.github.com"
local UPDATE_PATH = "/Pushkan/BoL/master/Little Thin Alistar.lua".."?rand="..math.random(1,10000)
local UPDATE_FILE_PATH = SCRIPT_PATH.."Little Thin Alistar.lua"
local UPDATE_URL = "https://"..UPDATE_HOST..UPDATE_PATH
function AutoupdaterMsg(msg) print("<font color=\"#6699ff\"><b>Little Thin Alistar:</b></font> <font color=\"#FFFFFF\">"..msg..".</font>") end
if AUTOUPDATE then
local ServerData = GetWebResult(UPDATE_HOST, "/Pushkan/BoL/master/ver/Little Thin Alistar.version")
if ServerData then
ServerVersion = type(tonumber(ServerData)) == "number" and tonumber(ServerData) or nil
if ServerVersion then
if tonumber(version) < ServerVersion then
AutoupdaterMsg("New version available" ..ServerVersion)
AutoupdaterMsg("Updating, please don't press F9")
DelayAction(function() DownloadFile(UPDATE_URL, UPDATE_FILE_PATH, function () AutoupdaterMsg("Successfully updated. ("..version.." => "..ServerVersion.."), press F9 twice to load the updated version.") end) end, 3)
else
AutoupdaterMsg("You have got the latest version ("..ServerVersion..")")
end
end
else
AutoupdaterMsg("Error downloading version info")
end
end

local autor = "Pushkan"
local scriptname = "Little Thin Alistar"
local wRange = 650
function OnLoad()
get_table()
AMen = scriptConfig("Little Thin Alistar", "LTA")
		ts = TargetSelector(TARGET_LESS_CAST_PRIORITY, 1400, DAMAGE_MAGIC)
        ts.name = "Target "
        AMen:addTS(ts)
AMen:addParam("Combo","Combo", SCRIPT_PARAM_ONKEYDOWN, false, 32)
AMen:addSubMenu("[Use Ult on]", "H")
                AMen.H:addParam("r", "Root", SCRIPT_PARAM_ONOFF, true)
				AMen.H:addParam("s", "Stun", SCRIPT_PARAM_ONOFF, true)
				AMen.H:addParam("t", "Taunt", SCRIPT_PARAM_ONOFF, true)
				AMen.H:addParam("f", "Fear", SCRIPT_PARAM_ONOFF, true)
				AMen.H:addParam("c", "Charm", SCRIPT_PARAM_ONOFF, true)
				AMen.H:addParam("su", "Supress", SCRIPT_PARAM_ONOFF, true)
				AMen.H:addParam("sl", "Slow", SCRIPT_PARAM_ONOFF, false)
end
function OnTick()
	ts:update()
	Target = ts.target
	QReady = (myHero:CanUseSpell(_Q) == READY)
	WReady = (myHero:CanUseSpell(_W) == READY)
	EReady = (myHero:CanUseSpell(_E) == READY)
	RReady = (myHero:CanUseSpell(_R) == READY)

Combo()
end
function Combo()
	if AMen.Combo and Target ~= nil then
		if QReady and WReady and GetDistance(Target)<=wRange then
			Packet("S_CAST", {spellId = _W, targetNetworkId = Target.networkID}):send()
		end
		if QReady and GetDistance(Target)<=600 then
			Packet("S_CAST", {spellId = _Q}):send()
		end
	end
end
function OnGainBuff(unit, buff)
    if unit == nil or buff == nil then return end
    if unit.isMe and buff then
	if (buff.type == 11 and AMen.H.r) or (buff.type == 10 and AMen.H.sl) or (buff.type == 8 and AMen.H.t) or (buff.type == 21 and AMen.H.f) or (buff.type == 22 and AMen.H.c) or (buff.type == 24 and AMen.H.su) then 
		if RReady then
       Packet("S_CAST", {spellId = _R}):send()
		end
        end
	end
end 
function get_table()
	mytypes={}
	mytypes["11"] = true
	mytypes["5"] = true
	mytypes["8"] = true
	mytypes["21"] = true
	mytypes["22"] = true
	mytypes["24"] = true
end
function OnDraw()
if WReady and not myHero.dead then
	DrawCircle3D(myHero.x, myHero.y, myHero.z, 650, 1, ARGB(70,23,190,23))
	end
end
