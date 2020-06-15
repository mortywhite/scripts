require "lib.moonloader"
local dlstatus = require("moonloader").download_status
local inicfg = require "inicfg"
local encoding = require "encoding"
encoding.default = "CP1251"
u8 = encoding.UTF8

update_state = false

local script_vers = 2
local script_vers_text = "2.05"

local update_url = "https://raw.githubusercontent.com/mortywhite/scripts/master/update.ini" --ссылка на апдейт
local update_path = getWorkingDirectory() .. "/update.ini" --ну тип апдейт

local script_url = "https://github.com/mortywhite/scripts/blob/master/spizdel.luac?raw=true" -- ссылка на файл который загружаем
local script_path = thisScript().path

function main()
	if not isSampLoaded() or not isSampfuncsLoaded() then return end
	while not isSampAvailable() do wait(100) end
	
	sampRegisterChatCommand("update", update)
	
	downloadUrlToFile(update_url, update_path, function(id, status)
		if status == dlstatus.STATUS_ENDOOWNLOADDATA then
			updateIni = inicfg.load(nil, update_path)
			if tonumber(updateIni.info.vers) > script_vers then
				sampAddChatMessage("Есть обнова: " .. updateIni.info.vers_text, -1)
				update_state = true
			end
			os.remove(update_path)
		end
	end)	
	
	while true do
		wait(0)
		
		if update_state then
			downloadUrlToFile(update_url, update_path, function(id, status)
			if status == dlstatus.STATUS_ENDOOWNLOADDATA then
				sampAddChatMessage("Скрипт загружен!", -1)
				thisScript():reload()
			end
		end)
	end
	
end
end


function update(arg)
	sampShowDialog(1000, "Автообновлениеепта", "пшелнахуй", "Закрыть", "", 0)
end