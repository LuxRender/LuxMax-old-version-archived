--// change \ for /
function fixWindowsPath str =
(
	for i = 1 to str.count do (if (str[i] == "\\") then str[i] = "/")
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
	_centimeters =  100 * units.SystemScale
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
	format "LookAt % % % % % % % % %\n" (pos.x/ luxScaleUnit()) (pos.y/ luxScaleUnit()) (pos.z / luxScaleUnit()) (look.x / luxScaleUnit()) (look.y / luxScaleUnit()) (look.z / luxScaleUnit()) up.x up.y up.z to:strout
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
	CollectSettings(lux_Dimmensions)
	CollectSettings(lux_LuxRenderEnginePresets)
	CollectSettings(lux_LuxRenderEngineConfiguration)
	CollectSettings(lux_external)
	CollectSettings(lux_Renderer)
	CollectSettings(lux_Sampler)
	CollectSettings(SamplerRollouts[(GetLuxValue "ddl_sampler")])
	CollectSettings(lux_SurfaceIntegrator)
	CollectSettings(SurfaceIntegratorsRollouts[(GetLuxValue "ddl_surface")])
	CollectSettings(lux_VolumeIntegrator)
	CollectSettings(lux_Filter)
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
		format "Transform [% % % 0.0 % % % 0.0 % % % 0.0 % % % 1.0]\r\n" row1.x row1.y row1.z row2.x row2.y row2.z row3.x row3.y row3.z (row4.x / luxScaleUnit()) (row4.y / luxScaleUnit()) (row4.z / luxScaleUnit())to:strout
	)
)