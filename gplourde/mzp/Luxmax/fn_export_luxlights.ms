fn lux_export_luxPortal obj =
(
	str = stringstream ""
		
	p0 = ([-(obj.mr_Sky_Portal.width / 2), -(obj.mr_Sky_Portal.length / 2), 0])
	p1 = ([(obj.mr_Sky_Portal.width / 2), -(obj.mr_Sky_Portal.length / 2), 0])
	p2 = ([-(obj.mr_Sky_Portal.width / 2), (obj.mr_Sky_Portal.length / 2), 0])
	p3 = ([(obj.mr_Sky_Portal.width / 2), (obj.mr_Sky_Portal.length / 2), 0])
	
	points = #(p0, p1, p2, p3)
	
	r1 = obj.transform.row1
	r2 = obj.transform.row2
	r3 = obj.transform.row3
	r4 = obj.transform.row4
			
	format "\tTransform [% % % 0.0 % % % 0.0 % % % 0.0 % % % 1.0]\n" r1.x r1.y r1.z r2.x r2.y r2.z r3.x r3.y r3.z (r4.x * luxScaleUnit()) (r4.y * luxScaleUnit()) (r4.z * luxScaleUnit())to:str

	format "\tPortalShape \"mesh\"\n" to:str
	format "\t\"integer triindices\" [2 3 1 0 2 1]\n" to:str
	format "\t\"point P\" [" to:str
	for p in points do
	(
		format "% % % " (p.x * luxScaleUnit()) (p.y * luxScaleUnit()) (p.z * luxScaleUnit()) to:str
	)
	format "]\n" to:str
	format "\t\"normal N\" [0 0 -1 0 0 -1 0 0 -1 0 0 -1 ]\n" to:str
	
	return (str as string)
)

fn lux_export_luxAreaLight obj =
(
	numlightsource += 1
	
	str = stringstream ""
		
	p0 = ([-(obj.mr_Sky_Portal.width / 2), -(obj.mr_Sky_Portal.length / 2), 0])
	p1 = ([(obj.mr_Sky_Portal.width / 2), -(obj.mr_Sky_Portal.length / 2), 0])
	p2 = ([-(obj.mr_Sky_Portal.width / 2), (obj.mr_Sky_Portal.length / 2), 0])
	p3 = ([(obj.mr_Sky_Portal.width / 2), (obj.mr_Sky_Portal.length / 2), 0])
	
	points = #(p0, p1, p2, p3)
	
	r1 = obj.transform.row1
	r2 = obj.transform.row2
	r3 = obj.transform.row3
	r4 = obj.transform.row4
			
	format "\tTransform [% % % 0.0 % % % 0.0 % % % 0.0 % % % 1.0]\n" r1.x r1.y r1.z r2.x r2.y r2.z r3.x r3.y r3.z (r4.x * luxScaleUnit()) (r4.y * luxScaleUnit()) (r4.z * luxScaleUnit())to:str
	
	format "AttributeBegin #%\n" obj.name to:str
	
	if (obj.exterior != undefined) do
		luxWriteName "Exterior" obj.exterior.name str
	
	format "LightGroup \"%\"\n" obj.lightgroup to:str
	format "AreaLightSource \"area\"\n" to:str
	luxWriteFloat "gain" obj.gain str
	luxWriteFloat "importance" obj.importance str
	luxWriteColor "L" obj.color str

	format "Shape \"trianglemesh\"\n" to:str
	format "\t\"integer indices\" [2 3 1 0 2 1]\n" to:str
	format "\t\"point P\" [" to:str
	for p in points do
	(
		format "% % % " (p.x * luxScaleUnit()) (p.y * luxScaleUnit()) (p.z * luxScaleUnit()) to:str
	)
	format "]\n" to:str
	format "AttributeEnd # %\n\n" obj.name to:str
	
	return (str as string)
)

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
			luxPortal: (format "%\n" (lux_export_luxPortal lt) to:str)
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
			luxPortal: (format "%\n" (lux_export_luxPortal lt) to:str)
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
			luxPortal: (format "%\n" (lux_export_luxPortal lt) to:str)
		)
	)
	
	format "AttributeEnd # %\n\n" obj.name to:str

	return str as string
)