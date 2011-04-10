struct LuxMax
(
	-- Get a value from the LuxMax saved settings
	function GetLuxMaxSetting grp key =
	(
		LuxMaxConfigFile = (GetDir #plugcfg + "\\luxmaxSettings.ini")
		
		if (not (doesFileExist LuxMaxConfigFile)) then
			return undefined
		
		GetINISetting LuxMaxConfigFile grp key
	),
	-- Set a value to the LuxMax settings
	function SetLuxMaxSetting grp key val =
	(
		LuxMaxConfigFile = (GetDir #plugcfg + "\\luxmaxSettings.ini")
		if (not (doesFileExist LuxMaxConfigFile)) then
		(
			F_lxs = dotNetObject "System.IO.StreamWriter" LuxMaxConfigFile
			F_lxs.Close()
		)
		setINISetting LuxMaxConfigFile grp key val
	)
)

global luxmaxcfg = LuxMax()
