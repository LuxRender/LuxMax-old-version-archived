fn lux_export_luxsky obj =
(
	numlightsource += 1
	str = stringstream ""
	
	format "AttributeBegin #%\n" obj.name to:str
	format "LightGroup \"%\"\n" obj.name to:str
	format "LightSource \"sky\"\n" to:str
	luxWriteFloat "turbidity" obj.turbidity str 
	luxWriteFloat "gain" obj.gain str
	luxWriteInteger "nsamples" obj.nsamples str

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
	numlightsource += 1
	str = stringstream ""
	
	format "AttributeBegin #%\n" obj.name to:str
	format "LightGroup \"%\"\n" obj.name to:str
	format "LightSource \"sun\"\n" to:str
	luxWriteFloat "gain" obj.gain str
	luxWriteInteger "nsamples" obj.nsamples str
	luxWriteFloat "relsize" obj.relsize str
	
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
	numlightsource += 1
	str = stringstream ""
	
	format "AttributeBegin #%\n" obj.name to:str
	
	if (obj.exterior != undefined) do
		luxWriteName "Exterior" obj.exterior.name str
	
	format "LightGroup \"%\"\n" obj.lightgroup to:str
	format "LightSource \"infinite\"\n" to:str
	luxWriteFloat "gain" obj.gain str
	luxWriteFloat "importance" obj.importance str
	luxWriteColor "L" obj.color str
	
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