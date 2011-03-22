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