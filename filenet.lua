function filenet.send(text, protocol)
	if text and protocol then
		local (file..protocol) = fs.open("filenet/temp."..protocol, "w")


	elseif text then
		error("No protocol provided")
	elseif protocol then
		error("No text provided")
	end
end
  
