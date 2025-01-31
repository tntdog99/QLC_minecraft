function send(text, protocol)
	if text and protocol then
		local file = fs.open("/filenet/temp."..protocol, "w")
			if textutils.serialize(text) then
				file.write(textutils.serialize(text))
				file.close()
			else
				file.write(text)
				file.close()
			end
	elseif text then
		error("No protocol provided")
	elseif protocol then
		error("No text provided")
	end
end




function receive(protocol)
	if protocol then
		local filerec = fs.open("/filenet/temp."..protocol, "w")
		local filerec = fs.open("/filenet/temp."..protocol, "r")
		while true do
			sleep(0.05)
			if fs.getSize("/filenet/temp."..protocol) == 0 then
			else
				local text2 = filerec.readAll()
				if textutils.unserialize(text2) then
					fs.delete("/filenet/temp."..protocol)
				return textutils.unserialize(text2)
			else
					fs.delete("/filenet/temp."..protocol)
				return text2
				end
			end	
		end
	else
	error("No protocol")
	end
end
