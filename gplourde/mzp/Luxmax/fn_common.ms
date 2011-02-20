--// Generic functions to outpuf luxrender types
function luxWriteString key val f = (if (val != undefined) then format "\t\"string %\" [\"%\"]\n" key val to:f else (format "warning: writing value key:% val:%\n" key val to:listener))
function luxWriteBool key val f = (if (val != undefined) then format "\t\"bool %\" [\"%\"]\n" key val to:f  else (format "warning: writing value key:% val:%\n" key val to:listener))
function luxWriteInteger key val f = (if (val != undefined) then format "\t\"integer %\" [%]\n" key val to:f else (format "warning: writing value key:% val:%\n" key val to:listener))
function luxWriteFloat key val f = (if (val != undefined) then format "\t\"float %\" [%]\n" key val to:f else (format "warning: writing value key:% val:%\n" key val to:listener))
function luxWritePoint key val f = (if (val != undefined) then format "\t\"point %\" [% % %]\n" key val.x val.y val.z to:f else (format "warning: writing value key:% val:%\n" key val to:listener))
function luxWriteColor key val f = (if (val != undefined) then format "\t\"color %\" [% % %]\n" key val.red val.green val.blue to:f else (format "warning: writing value key:% val:%\n" key val to:listener))

(--// Generic UI Saving Functions

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
	
	--// change \ for /
	function fixWindowsPath str =
	(
		for i = 1 to str.count do (if (str[i] == "\\") then str[i] = "/")
		return str
	)
)