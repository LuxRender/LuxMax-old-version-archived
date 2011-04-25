--// change \ for /
function fixWindowsPath str =
(
	for i = 1 to str.count do (if (str[i] == "\\") then str[i] = "/")
	return str
)

function fixWindowsPathReverse str =
(
	for i = 1 to str.count do (if (str[i] == "/") then str[i] = "\\")
	return str
)

--// change , for .
function FormatFloat n =
(
	str = n as string
	for i = 1 to str.count do (if (str[i] == ",") then str[i] = ".")
	return str
)

--// Given value in meters
function luxScaleUnit = 
(
	_inches = 0.0254 * units.SystemScale
	_feet = 0.3048 * units.SystemScale
	_miles =  1609.344 * units.SystemScale
	_millimeters =  0.001 * units.SystemScale
	_centimeters =  0.01 * units.SystemScale
	_kilometers =  1000 * units.SystemScale
	
	_u = units.SystemType
	
	ws = 1
	
	if _u == #Inches then ws = _inches
	else if _u == #Feet then ws = _feet
	else if _u == #Miles then ws = _miles
	else if _u == #Millimeters then ws = _millimeters
	else if _u == #Centimeters then ws = _centimeters
	else if _u == #Kilometers then ws = _kilometers
	
	return ws
)

--// Generic functions to outpuf luxrender types
function luxWriteString key val f = (if (val != undefined) then format "\t\"string %\" [\"%\"]\r\n" key val to:f else (format "warning: writing value key:% val:%\r\n" key val to:listener))
function luxWriteBool key val f = (if (val != undefined) then format "\t\"bool %\" [\"%\"]\r\n" key val to:f  else (format "warning: writing value key:% val:%\r\n" key val to:listener))
function luxWriteInteger key val f = (if (val != undefined) then format "\t\"integer %\" [%]\r\n" key val to:f else (format "warning: writing value key:% val:%\r\n" key val to:listener))
function luxWriteFloat key val f =
(
	if (val != undefined) then
	(
		format "\t\"float %\" [%]\r\n" key (FormatFloat val) to:f
	)
	else
	(
		(format "warning: writing value key:% val:%\r\n" key val to:listener)
	)
)
function luxWritePoint key val f = (if (val != undefined) then format "\t\"point %\" [% % %]\r\n" key val.x val.y val.z to:f else (format "warning: writing value key:% val:%\r\n" key val to:listener))
function luxWriteColor key val f = (if (val != undefined) then format "\t\"color %\" [% % %]\r\n" key (val.red / 255) (val.green / 255) (val.blue / 255) to:f else (format "warning: writing value key:% val:%\r\n" key val to:listener))
function luxWriteName key val strout = (format "% \"%\"\r\n" key val to:strout)
function luxWriteEmptyLine strout = (format "\r\n" to:strout)
function luxWriteLookAt tm strout =
(
	--// Generate camera look at
	pos = tm.row4
	up = normalize tm.row2
	look = (tm.row4 + -(normalize tm.row3))
	format "LookAt % % % % % % % % %\n" (pos.x * luxScaleUnit()) (pos.y * luxScaleUnit()) (pos.z * luxScaleUnit()) (look.x * luxScaleUnit()) (look.y * luxScaleUnit()) (look.z * luxScaleUnit()) up.x up.y up.z to:strout
)
	
function GetFrame =
(
	str = "000000"
	_T = (slidertime.frame as integer) as string
	str = replace str (7 - _T.count) (_T.count) _T
	return str
)

--// Get the current scene name minus the file extension
function getSceneName =
(
	if (maxFileName.count > 0) then
		return (getFilenameFile maxFileName)

	return "untitled"
)

function GetLuxParam name =
(
	if (luxMax_Settings == undefined) do return undefined
	
	for o in luxMax_Settings do
	(
		if o != undefined and o[2] == name then
		(
			return o
		)
	)
	return undefined
)
function GetLuxValue name =
(
	if (luxMax_Settings == undefined) do return undefined
	
	for o in luxMax_Settings do
	(
		if o != undefined and o[2] == name then
		(
			return o[3]
		)
	)
	return undefined
)
function GetLuxString name =
(
	if (luxMax_Settings == undefined) do return undefined
	
	for o in luxMax_Settings do
	(
		if o != undefined and o[2] == name then
		(
			return o[4]
		)
	)
	return undefined
)
function CollectSettings mrollout =
(
	try 
	(
		for i = 1 to mrollout.controls.Count do
		(
			c = filterString (mrollout.controls[i] as string) ":"
			
			param = #(c[1], (ToLower(c[2])), undefined, undefined)		
			
			if (GetLuxValue (c[2]) != undefined) then
			(
				param = GetLuxParam (c[2])
			)

			controlClass = classof mrollout.controls[i]
			
			if (controlClass == GroupEndControl or controlClass == GroupStartControl) do continue
			
			case of
			(
				(controlClass == ComboBoxControl) :
				(
					param[3] = mrollout.controls[i].selection
					param[4] = mrollout.controls[i].selected
				)
				(controlClass == SpinnerControl) : param[3] = mrollout.controls[i].value
				(controlClass == CheckBoxControl) : param[3] = mrollout.controls[i].state
				(controlClass == ButtonControl) : param[3] = mrollout.controls[i].text
				(controlClass == EditTextControl) : param[3] = mrollout.controls[i].text
			)
			
			append luxMax_Settings param
		)
	) catch ()
)
function GetControlParams mrollout =
(
	for o in mrollout.Controls do
	(
		c = filterString (o as string) ":"
		controlClass = classof o
		
		param = GetLuxParam (c[2])

		if (controlClass == GroupEndControl or controlClass == GroupStartControl) do continue
		
		if param != undefined then
		(
			case of
			(
				(controlClass == ComboBoxControl) :
				(
					o.selection = param[3]
					if (o.selection > 0) then
						o.selected = param[4]
				)
				(controlClass == SpinnerControl) : o.value = param[3]
				(controlClass == CheckBoxControl) : o.state = param[3]
				(controlClass == ButtonControl) : o.text = param[3]
				(controlClass == EditTextControl) : o.text = param[3]
			)
		)
	)
)
function SaveSettings =
(
	--// Check if we are still in the same scene that we start with. Do not save if we are in a new scene.
	if (luxMax_Scene != (getFilenameFile maxFileName)) then return false
	
	luxMax_Settings = #()
	CollectSettings(lux_LuxRenderEngineConfiguration)
	CollectSettings(lux_Dimmensions)
	CollectSettings(lux_LuxRenderEnginePresets)
	CollectSettings(lux_LuxRenderEngineConfiguration)
	CollectSettings(lux_external)
	CollectSettings(lux_Renderer)
	CollectSettings(lux_Sampler)
	if ((GetLuxValue "ddl_sampler") != undefined) then
		CollectSettings(SamplerRollouts[(GetLuxValue "ddl_sampler")])
	CollectSettings(lux_SurfaceIntegrator)
	if ((GetLuxValue "ddl_surface") != undefined) then
		CollectSettings(SurfaceIntegratorsRollouts[(GetLuxValue "ddl_surface")])
	CollectSettings(lux_VolumeIntegrator)
	CollectSettings(lux_Filter)
	if ((GetLuxValue "ddl_filter") != undefined) then
		CollectSettings(FilltersRollouts[(GetLuxValue "ddl_filter")])
	CollectSettings(lux_Accelerator)
	CollectSettings(lux_LuxRenderNetwork)
	CollectSettings(lux_Output)
	
	CollectSettings(lux_Film)
)
--// Check if the component is compatible with luxrender
function CheckLuxRenderCompat obj =
(
	try
	(
		obj.GetLuxRenderString()
		return true
	)
	catch
	(	
		return false
	)
)

function luxCreateScaleFloatMap inTexMap val =
(
	floatScale = LuxrenderFloatScale()
	floatScale.name = (inTexMap.name + "_scale")
	floatScale.floattex1 = val
	floatScale.maptex2 = inTexMap
	return floatScale
)
--// write lux transform (matrix, time, stringstream)
function luxWriteTransform &tm t strout =
(
	at time (t as integer)
	(
		row1 = tm.row1
		row2 = tm.row2
		row3 = tm.row3
		row4 = tm.row4
		format "Transform [% % % 0.0 % % % 0.0 % % % 0.0 % % % 1.0]\r\n" row1.x row1.y row1.z row2.x row2.y row2.z row3.x row3.y row3.z (row4.x * luxScaleUnit()) (row4.y * luxScaleUnit()) (row4.z * luxScaleUnit())to:strout
	)
)

struct  ior_preset (name, value)

function luxGetIORPresets =
(
	ior_presets = #(
		(ior_preset name:"Select IOR preset" value:undefined),
		(ior_preset name:"{Common Liquids}" value:undefined),
		(ior_preset name:". Acetone" value:1.36),
		(ior_preset name:". Alcohol, ethyl" value:1.36),
		(ior_preset name:". Alcohol, methyl" value:1.329),
		(ior_preset name:". Beer" value:1.345),
		(ior_preset name:". Benzene" value:1.501),
		(ior_preset name:". Carbon tetrachloride" value:1.000132),
		(ior_preset name:". Carbon disulfide" value:1.00045),
		(ior_preset name:". Carbonated Beverages" value:1.34),
		(ior_preset name:". Chlorine (liq)" value:1.385),
		(ior_preset name:". Cranberry Juice (25%)" value:1.351),
		(ior_preset name:". Glycerin" value:1.473),
		(ior_preset name:". Honey, 13% water content" value:1.504),
		(ior_preset name:". Honey, 17% water content" value:1.494),
		(ior_preset name:". Honey, 21% water content" value:1.484),
		(ior_preset name:". Ice" value:1.309),
		(ior_preset name:". Milk" value:1.35),
		(ior_preset name:". Oil, Clove" value:1.535),
		(ior_preset name:". Oil, Lemon" value:1.481),
		(ior_preset name:". Oil, Neroli" value:1.482),
		(ior_preset name:". Oil, Orange" value:1.473),
		(ior_preset name:". Oil, Safflower" value:1.466),
		(ior_preset name:". Oil, vegetable (50° C)" value:1.47),
		(ior_preset name:". Oil of Wintergreen" value:1.536),
		(ior_preset name:". Rum, White" value:1.361),
		(ior_preset name:". Shampoo" value:1.362),
		(ior_preset name:". Sugar Solution 30%" value:1.38),
		(ior_preset name:". Sugar Solution 80%" value:1.49),
		(ior_preset name:". Turpentine" value:1.472),
		(ior_preset name:". Vodka" value:1.363),
		(ior_preset name:". Water (0° C)" value:1.33346),
		(ior_preset name:". Water (100° C)" value:1.31766),
		(ior_preset name:". Water (20° C)" value:1.33283),
		(ior_preset name:". Whisky" value:1.356),
		

		(ior_preset name:"{Gases}" value:undefined),
		(ior_preset name:".  Vacuum" value:1.0),
		(ior_preset name:".  Air STP" value:1.0002926),
		(ior_preset name:".  Air STP" value:1.000293),
		(ior_preset name:".  Helium" value:1.000036),
		(ior_preset name:".  Hydrogen" value:1.000132),
		(ior_preset name:".  Carbon dioxide" value:1.00045),
		
		
		(ior_preset name:"{Common Transparent}" value:undefined),
		(ior_preset name:".  Eye, Aqueous humor" value:1.33),
		(ior_preset name:".  Eye, Cornea" value:1.38),
		(ior_preset name:".  Eye, Lens" value:1.41),
		(ior_preset name:".  Eye, Vitreous humor" value:1.34),
		(ior_preset name:".  Glass, Arsenic Trisulfide" value:2.04),
		(ior_preset name:".  Glass, Crown (common)" value:1.52 ),
		(ior_preset name:".  Glass, Flint, 29% lead" value:1.569),
		(ior_preset name:".  Glass, Flint, 55% lead" value:1.669),
		(ior_preset name:".  Glass, Flint, 71% lead" value:1.805),
		(ior_preset name:".  Glass, Fused Silica" value:1.459),
		(ior_preset name:".  Glass, Pyrex" value:1.474),
		(ior_preset name:".  Lucite" value:1.495 ),
		(ior_preset name:".  Nylon" value:1.53),
		(ior_preset name:".  Obsidian" value:1.50),
		(ior_preset name:".  Plastic" value:1.460),
		(ior_preset name:".  Plexiglas" value:1.488),
		(ior_preset name:".  Salt" value:1.516),
		
		
		(ior_preset name:"{Gemstones}" value:undefined),
		(ior_preset name:".  Agate" value:1.544),
		(ior_preset name:".  Alexandrite" value:1.746),
		(ior_preset name:".  Almandine" value:1.75),
		(ior_preset name:".  Amber" value:1.539),
		(ior_preset name:".  Amethyst" value:1.532),
		(ior_preset name:".  Ammolite" value:1.52),
		(ior_preset name:".  Andalusite" value:1.629),
		(ior_preset name:".  Apatite" value:1.632),
		(ior_preset name:".  Aquamarine" value:1.567),
		(ior_preset name:".  Axenite" value:1.674),
		(ior_preset name:".  Beryl" value:1.57),
		(ior_preset name:".  Beryl, Red" value:1.570),
		(ior_preset name:".  Chalcedony" value:1.544),
		(ior_preset name:".  Chrome Tourmaline" value:1.61),
		(ior_preset name:".  Citrine" value:1.532),
		(ior_preset name:".  Clinohumite" value:1.625),
		(ior_preset name:".  Coral" value:1.486),
		(ior_preset name:".  Crystal" value:2.000),
		(ior_preset name:".  Crysoberyl, Catseye" value:1.746),
		(ior_preset name:".  Danburite" value:1.627),
		(ior_preset name:".  Diamond" value:2.417),
		(ior_preset name:".  Emerald" value:1.560),
		(ior_preset name:".  Emerald Catseye" value:1.560),
		(ior_preset name:".  Flourite" value:1.434),
		(ior_preset name:".  Garnet, Grossular" value:1.72),
		(ior_preset name:".  Garnet, Andradite" value:1.88),
		(ior_preset name:".  Garnet, Demantiod" value:1.880),
		(ior_preset name:".  Garnet, Mandarin" value:1.790),
		(ior_preset name:".  Garnet, Pyrope" value:1.73),
		(ior_preset name:".  Garnet, Rhodolite" value:1.740),
		(ior_preset name:".  Garnet, Tsavorite" value:1.739),
		(ior_preset name:".  Garnet, Uvarovite" value:1.74),
		(ior_preset name:".  Hauyn" value:1.490),
		(ior_preset name:".  Iolite" value:1.522),
		(ior_preset name:".  Jade, Jadeite" value:1.64),
		(ior_preset name:".  Jade, Nephrite" value:1.600),
		(ior_preset name:".  Jet" value:1.660 ),
		(ior_preset name:".  Kunzite" value:1.660),
		(ior_preset name:".  Labradorite" value:1.560),
		(ior_preset name:".  Lapis Lazuli" value:1.50 ),
		(ior_preset name:".  Moonstone" value:1.518 ),
		(ior_preset name:".  Morganite" value:1.585 ),
		(ior_preset name:".  Obsidian" value:1.50 ),
		(ior_preset name:".  Opal, Black" value:1.440 ),
		(ior_preset name:".  Opal, Fire" value:1.430 ),
		(ior_preset name:".  Opal, White" value:1.440 ),
		(ior_preset name:".  Oregon Sunstone" value:1.560 ),
		(ior_preset name:".  Padparadja" value:1.760 ),
		(ior_preset name:".  Pearl" value:1.53 ),
		(ior_preset name:".  Peridot" value:1.635 ),
		(ior_preset name:".  Quartz" value:1.544 ),
		(ior_preset name:".  Ruby" value:1.757 ),
		(ior_preset name:".  Sapphire" value:1.757 ),
		(ior_preset name:".  Sapphire, Star" value:1.760 ),
		(ior_preset name:".  Spessarite" value:1.79 ),
		(ior_preset name:".  Spinel" value:1.712 ),
		(ior_preset name:".  Spinel, Blue" value:1.712 ),
		(ior_preset name:".  Spinel, Red" value:1.708 ),
		(ior_preset name:".  Star Ruby" value:1.76 ),
		(ior_preset name:".  Tanzanite" value:1.690 ),
		(ior_preset name:".  Topaz" value:1.607 ),
		(ior_preset name:".  Topaz, Imperial" value:1.605 ),
		(ior_preset name:".  Tourmaline" value:1.603 ),
		(ior_preset name:".  Tourmaline, Blue" value:1.61),
		(ior_preset name:".  Tourmaline, Catseye" value:1.61 ),
		(ior_preset name:".  Tourmaline, Green" value:1.61 ),
		(ior_preset name:".  Tourmaline, Paraiba" value:1.61 ),
		(ior_preset name:".  Tourmaline, Red" value:1.61 ),
		(ior_preset name:".  Zircon" value:1.777 ),
		(ior_preset name:".  Zirconia, Cubic" value:2.173 ),
		
		(ior_preset name:"{Other}" value:undefined),
		(ior_preset name:".  Pyrex" value:1.47),
		(ior_preset name:".  Ruby" value:1.76),
		(ior_preset name:".  Water ice" value:1.31),
		(ior_preset name:".  Cryolite" value:1.388),
		(ior_preset name:".  Acetone" value:1.36),
		(ior_preset name:".  Ethanol" value:1.36),
		(ior_preset name:".  Teflon" value:1.35),
		(ior_preset name:".  Glycerol" value:1.4729),
		(ior_preset name:".  Acrylic glass" value:1.49),
		(ior_preset name:".  Rock salt" value:1.516),
		(ior_preset name:".  Crown glass (pure)" value:1.5),
		(ior_preset name:".  Salt (NaCl)" value:1.544),
		(ior_preset name:".  Polycarbonate" value:1.584),
		(ior_preset name:".  PMMA" value:1.4893),
		(ior_preset name:".  PETg" value:1.57),
		(ior_preset name:".  PET" value:1.575),
		(ior_preset name:".  Flint glass (pure)" value:1.6),
		(ior_preset name:".  Crown glass (impure)" value:1.485),
		(ior_preset name:".  Fused Quartz" value:1.46),
		(ior_preset name:".  Bromine" value:1.661),
		(ior_preset name:".  Flint glass (impure)" value:1.523),
		(ior_preset name:".  Cubic zirconia" value:2.15),
		(ior_preset name:".  Moissanite" value:2.419),
		(ior_preset name:".  Cinnabar (Mercury sulfide)" value:2.65),
		(ior_preset name:".  Gallium(III) prosphide" value:3.02),
		(ior_preset name:".  Gallium(III) arsenide" value:3.5),
		(ior_preset name:".  Silicon" value:3.927)
	)
	return ior_presets
)

struct  lampspectrum_preset (name, value)

function luxGetLampspectrumPresets =
(
	lampspectrum_presets = #(
		(lampspectrum_preset name:"Select lampspectrum preset" value:undefined),
		(lampspectrum_preset name:"{Natural Daylight}" value:undefined),
		(lampspectrum_preset name:". Daylight" value:"Daylight"),
		(lampspectrum_preset name:"{Incandescent}" value:undefined),
		(lampspectrum_preset name:". Paraffin Candle Flame" value:"Candle"),
		(lampspectrum_preset name:". Generic 7W Incandescent Lamp" value:"Incandescent1"),
		(lampspectrum_preset name:". PHILIPS Argenta 200W Incandescent Lamp" value:"Incandescent2"),
		(lampspectrum_preset name:". Welsbach Gas Mantle (modern, without Thorium)" value:"Welsbach"),
		(lampspectrum_preset name:". Incandescent Anti-Insect Lamp" value:"AntiInsect"),
		(lampspectrum_preset name:"{Fluorescent/Compact Fluorescent}" value:undefined),
		(lampspectrum_preset name:". PHILIPS [TL-D 30W/55] Regular Daylight Fluorescent" value:"FLD2"),
		(lampspectrum_preset name:". Sylvania [F4T5 4W] Regular Warm White Florescent" value:"FL37K"),
		(lampspectrum_preset name:". OSRAM [DULUXSTAR 21 W/827] Regular Compact Triphosphor Fluorescent" value:"CFL27K"),
		(lampspectrum_preset name:". Cold Cathode Warm White CFL Triphosphor Fluorescent" value:"CFL4K"),
		(lampspectrum_preset name:". NARVA [COLOURLUX plus daylight 20W/860] Daylight CFL Triphosphor Fluorescent" value:"CFL6K"),
		(lampspectrum_preset name:". Sylvania [GroLux] Fluorescent Aquarium/Plant Lamp" value:"GroLux"),
		(lampspectrum_preset name:". Laptop LCD Screen" value:"LCDS"),
		(lampspectrum_preset name:". PHILIPS [ActiViva] Natural Triphosphor Fluorescent" value:"FLAV8K"),
		(lampspectrum_preset name:". PHILIPS [ActiViva] Active Triphosphor Fluorescent" value:"FLAV17K"),
		(lampspectrum_preset name:"{High Pressure Mercury}" value:undefined),
		(lampspectrum_preset name:". OSRAM [HQA 80W] Clear HPM Lamp" value:"HPM2"),
		(lampspectrum_preset name:". PHILIPS [HPL 125W] HPTM Lamp with improved color" value:"HPMFL1"),
		(lampspectrum_preset name:". OSRAM [HQL 80W] HPM Lamp with improved warm deluxe color" value:"HPMFL2"),
		(lampspectrum_preset name:". PHILIPS [ML 160W] Self-Ballasted HPM Vapor Lamp" value:"HPMSB"),
		(lampspectrum_preset name:". NARVA [160W] Self-ballasted HPM Vapor Lamp" value:"HPMSBFL"),
		(lampspectrum_preset name:"{Low/High Pressure Sodium}" value:undefined),
		(lampspectrum_preset name:". Regular High Pressure Sodium Lamp, warmup after 5-7 sec" value:"SS1"),
		(lampspectrum_preset name:". Regular High Pressure Sodium Lamp, warmup after 10-12 sec" value:"SS2"),
		(lampspectrum_preset name:". SOX Low Pressure Sodium Discharge Lamp" value:"LPS"),
		(lampspectrum_preset name:". Medium Pressure Sodium Discharge Lamp, warmup after ~35 sec" value:"MPS"),
		(lampspectrum_preset name:". GE [Lucalox 35W] High Pressure Sodium Lamp" value:"HPS"),
		(lampspectrum_preset name:". PHILIPS [SDW-T 100W] Super High Pressure White Sodium Lamp" value:"SHPS"),
		(lampspectrum_preset name:"{Metal Hailde}" value:undefined),
		(lampspectrum_preset name:". PHILIPS [HPI-T 400W] MH Lamp with Mercury, Sodium, Thallium and Indium iodides" value:"MHN"),
		(lampspectrum_preset name:". OSRAM [HQI-TS 75W/WDL] Metal Halide lamp with Mercury, sodium, Thallium, Indium and tin Iodides" value:"MHWWD"),
		(lampspectrum_preset name:". GE [MVR325IUWM 325 Watt I-Line Mulit-VaporA Metal Hailde - Clear Watt Misera] MH Lamp with Mercury, Sodium and Scandium Iodides" value:"MHSc"),
		(lampspectrum_preset name:". OSRAM [HQI-T 400W/D] MH Lamp with Mercury, Thallium, Dysprosium, Holmium, Thulium and Caesium Iodides" value:"MHD"),
		(lampspectrum_preset name:". PHILIPS Diazo MH Lamp with Mercury, Iron and Cobalt Iodides" value:"FeCo"),
		(lampspectrum_preset name:". Sylvania Diazo MH Lamp with Mercury, Gallium and Lead Iodides" value:"GaPb"),
		(lampspectrum_preset name:". OSRAM [HQI-T 400W/Blau] Blue colored MH Lamp ith Mercury and Indium Iodides" value:"BLAU"),
		(lampspectrum_preset name:". RADIUM [HRI-T 400W/Planta] Plant growing MH Lamp with Mercury, Indium and Sodium Iodides" value:"PLANTA"),
		(lampspectrum_preset name:". OSRAM [HQI-T 400W/Grun] Green colored MH Lamp with Mercury and Thallium Iodides" value:"GURN"),
		(lampspectrum_preset name:"{Diode}" value:undefined),
		(lampspectrum_preset name:". Regular High Brightness Blue LED" value:"LEDB"),
		(lampspectrum_preset name:". Monochromatic emission from a Red Laser Diode" value:"RedLaser"),
		(lampspectrum_preset name:". Monochromatic emission from a Green Laser Diode" value:"GreenLaser"),
		(lampspectrum_preset name:"{Spectral}" value:undefined),
		(lampspectrum_preset name:". PHILIPS Spectral Xenon Lamp - Continuous Xenon low pressure thermionic discharge" value:"Xel"),
		(lampspectrum_preset name:". PHILIPS Spectral Rubidium Lamp - Continuous Rubidium low pressure thermionic discharge" value:"Rb"),
		(lampspectrum_preset name:". PHILIPS Spectral Cadmium Lamp - Continuous Cadmium low pressure thermionic discharge" value:"Cd"),
		(lampspectrum_preset name:". PHILIPS spectral Zinc Lamp - Continuous Zinc low pressure thermionic discharge" value:"Zd"),
		(lampspectrum_preset name:"{Glow Discharge}" value:undefined),
		(lampspectrum_preset name:". Neon glow discharge" value:"Ne"),
		(lampspectrum_preset name:". Neon and Krypton glow discharge and green Phosphor (Night-Lights/Indicators)" value:"NeKrFL"),
		(lampspectrum_preset name:". Neon and Xenon glow discharge and green Phosphor (Night-Lights/Inicators)" value:"NeXeFL1"),
		(lampspectrum_preset name:". Neon and Xenon glow discharge and blue Phosphor (Night-Lights/Indicators)" value:"NeXeFL2"),
		(lampspectrum_preset name:". Argon glow discharge" value:"Ar"),
		(lampspectrum_preset name:". Self-ballasted High Pressure Mercury Vapor Lamp, with yttrium vanadate phosphate fluorescent Phosphors, in glow discharge mode" value:"HPMFL2Glow"),
		(lampspectrum_preset name:"{Molecular}" value:undefined),
		(lampspectrum_preset name:". Butane Gas Flame" value:"Butane"),
		(lampspectrum_preset name:". Alcohol Flame" value:"Alcohol"),
		(lampspectrum_preset name:"{General Fluorescence}" value:undefined),
		(lampspectrum_preset name:". Print quality A5 Xerox paper wrapped around a blacklight Lamp" value:"BLP"),
		(lampspectrum_preset name:". Neon green dye, bombarded with black light" value:"BLNG"),
		(lampspectrum_preset name:". Regular Modern Color TV CRT" value:"TV"),
		(lampspectrum_preset name:"{Various}" value:undefined),
		(lampspectrum_preset name:". Stroboscopic flash. Xenon I, likely II and perhaps III" value:"Xe"),
		(lampspectrum_preset name:". Carbon Arc Spectrum" value:"CarbonArc"),
		(lampspectrum_preset name:". OSRAM [XBO 75W/2] Short Arc Xenon Lamp" value:"HPX"),
		(lampspectrum_preset name:"{Blacklight/Ultraviolet}" value:undefined),
		(lampspectrum_preset name:". Sylvania [G8T5 8W] Germicidal Lamp" value:"LPM2"),
		(lampspectrum_preset name:". Sylvania [F6T5/BLB 8W] Black Light Blue fluorescent" value:"FLBLB"),
		(lampspectrum_preset name:". PHILIPS [HPW 125W] High Pressure Mercury Black Light " value:"FLBLB"),
		(lampspectrum_preset name:". Sylvania [Blacklite 350 F8W/BL350] Black Light fluorescent" value:"FLBL"),
		(lampspectrum_preset name:"{Mercury UV Spectrum}" value:undefined),
		(lampspectrum_preset name:". The near visible UVA Emissions from a high pressure Mercury clear Lamp" value:"UVA"),
		(lampspectrum_preset name:"{Absorption/Mixed Spectra}" value:undefined),
		(lampspectrum_preset name:". High Pressure Mercury Warm Deluxe Light ([1..3]) absorbed through blue Cobalt Glass" value:"HPMFLCobaltGlaa"),
		(lampspectrum_preset name:". Incandescent Light ([1.2.3]) absorbed through blue Cobalt Glass" value:"CobaltGlass"),
		(lampspectrum_preset name:". High Pressure Mercury Warm Deluxe Light ([1.4.3]) Absorbed through ciel dye #42053" value:"HPMFLCL42053"),
		(lampspectrum_preset name:". Incandescent light ([1.2.3]) absorbed through ciel #42053" value:"CL42053"),
		(lampspectrum_preset name:". High Pressure Mercury Warm Deluxe Light ([1.4.2]) absorbed through red glass" value:"HPMFLRedGlass"),
		(lampspectrum_preset name:". Incandescent Light ([1.2.3]) absorbed through red glass" value:"RedGlass"),
		(lampspectrum_preset name:". Incandescent Light ([1.2.3]) absorbed through olive oil" value:"OliveOil")
		


	)
	return lampspectrum_presets
)