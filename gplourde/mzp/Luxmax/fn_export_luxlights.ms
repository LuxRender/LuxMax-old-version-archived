fn lux_export_luxsky obj =
(
	types = #("sun","sky","sunsky")
	
	numlightsource += 1
	str = stringstream ""
	
	format "AttributeBegin #%\n" obj.name to:str
	
	if (obj.exterior != undefined) do
		luxWriteName "Exterior" obj.exterior.name str
	
	format "LightGroup \"%\"\n" obj.lightgroup to:str
	
	format "LightSource \"%\"\n" types[obj.type] to:str
	
	luxWriteFloat "gain" obj.gain str
	luxWriteFloat "importance" obj.importance str
	luxWriteInteger "nsamples" obj.nsamples str
	
	luxWriteFloat "turbidity" obj.turbidity str
	luxWriteFloat "horizonbrightness" obj.horizonbrightness str 
	luxWriteFloat "horizonsize" obj.horizonsize str 
	luxWriteFloat "sunhalobrightness" obj.sunhalobrightness str 
	luxWriteFloat "sunhalosize" obj.sunhalosize str 
	luxWriteFloat "backscattering" obj.backscattering str
	
	vec_dir = ([0, 0, 1] * obj.transform)
	vec_dir = vec_dir - obj.position
	vec_dir = normalize vec_dir
	
	format "\"vector sundir\" [% % %]\n" vec_dir.x vec_dir.y vec_dir.z to:str
	
	for lt in lights do
	(
		case (classof lt) of
		(
			mr_Sky_Portal:			(format "%\n" (lux_export_mrSkyPortal lt) to:str)
		)
	)
				
	format "AttributeEnd # %\n\n" obj.name to:str

	return str as string
)

fn lux_export_luxsun obj =
(
	-- Obsolete
)

fn lux_export_luxdistant obj =
(
	numlightsource += 1
	str = stringstream ""
	
	format "AttributeBegin #%\n" obj.name to:str
	
	if (obj.exterior != undefined) do
		luxWriteName "Exterior" obj.exterior.name str
	
	format "LightGroup \"%\"\n" obj.lightgroup to:str
	format "LightSource \"distant\"\n" to:str
	luxWriteFloat "gain" obj.gain str
	luxWriteFloat "importance" obj.importance str
	luxWriteColor "L" obj.color str
	
	format "\"point from\" [0.000000000000000 0.000000000000000 0.000000000000000]" to:str
	format "\"point to\" [0.000000000000000 0.000000000000000 -1.000000000000000]" to:str
	
	for lt in lights do
	(
		case (classof lt) of
		(
			mr_Sky_Portal: (format "%\n" (lux_export_mrSkyPortal lt) to:str)
		)
	)
	
	format "AttributeEnd # %\n\n" obj.name to:str

	return str as string
)

fn lux_export_luxinfinite obj =
(
	types = #("latlong", "angular", "vcross")
	
	numlightsource += 1
	str = stringstream ""
	
	format "AttributeBegin #%\n" obj.name to:str
	
	if (obj.exterior != undefined) do
		luxWriteName "Exterior" obj.exterior.name str
	
	--multiply type:#boolean ui:m_multiply default:false
	
	format "LightGroup \"%\"\n" obj.lightgroup to:str
	format "LightSource \"infinite\"\n" to:str
	luxWriteFloat "gain" obj.gain str
	luxWriteFloat "importance" obj.importance str
	
	if (CheckLuxRenderCompat obj.mapname == false) or obj.multiply == true then
		luxWriteColor "L" obj.color str
	
	if (CheckLuxRenderCompat obj.mapname == true) then
	(
		if (classof obj.mapname == LuxrenderImageMap) then
		(
			format "\t\"string mapping\" [\"%\"]\r\n" types[obj.maptype] to:str 
			format "\t\"string mapname\" [\"%\"]\r\n" (fixWindowsPath obj.mapname.filename) to:str
		)
	)
	
	for lt in lights do
	(
		case (classof lt) of
		(
			mr_Sky_Portal: (format "%\n" (lux_export_mrSkyPortal lt) to:str)
		)
	)
	
	format "AttributeEnd # %\n\n" obj.name to:str

	return str as string
)