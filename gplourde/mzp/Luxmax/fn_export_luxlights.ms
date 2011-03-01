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
	format "AttributeEnd # default\n\n" to:str

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
	format "AttributeEnd # default\n\n" to:str

	return str as string
)