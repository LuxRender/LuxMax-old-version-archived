(--TONEMAPPING
	
	rollout lux_Tonemapping_reinhard "reinhard"
	(
	spinner reinhard_prescale "Pre:" fieldwidth:40 range:[-999999, 999999, 1] across:3 align:#left
	spinner reinhard_postscale "Post:" fieldwidth:40 range:[-999999, 999999, 1]  align:#left
	spinner reinhard_burn "Burn:" fieldwidth:40 range:[-999999, 999999, 6]  align:#right
	
	function GetLuxRenderString =
		(		
			str = stringstream ""
			
			format "\"string tonemapkernel\" [\"reinhard\"]\n" to:str
			luxWriteFloat "reinhard_prescale" reinhard_prescale.value str
			luxWriteFloat "reinhard_postscale" reinhard_postscale.value str
			luxWriteFloat "reinhard_burn" reinhard_burn.value str
			
			return (str as string)
		)
	
	on lux_Tonemapping_reignhard open do (GetControlParams(lux_Tonemapping_reignhard))
	)
		
	rollout lux_Tonemapping_linear "linear"
	(
	spinner linear_sensitivity "ISO:" fieldwidth:50 across:2 range:[6, 6400, 50] align:#left
	spinner linear_exposure "Exposure time:" fieldwidth:50 range:[0.0005, 60, 1]  align:#right
	spinner linear_fstop "F-Stop:" fieldwidth:50 range:[0.7, 96, 2.8] across:2 align:#left
	spinner linear_gamma "Gamma:" fieldwidth:50 range:[0, 5, 1] align:#right
		
		function GetLuxRenderString =
		(
			str = stringstream ""
			format "\"string tonemapkernel\" [\"linear\"]\n" to:str
			luxWriteFloat "linear_sensitivity" linear_sensitivity.value str
			luxWriteFloat "linear_exposure" linear_exposure.value str
			luxWriteFloat "linear_fstop" linear_fstop.value str
			luxWriteFloat "linear_gamma" linear_gamma.value str

			return (str as string)
		)
		on lux_Tonemapping_linear open do (GetControlParams(lux_Tonemapping_linear))
	)
	
	rollout lux_Tonemapping_autolinear "autolinear"
	(
		label lb_autolinear "autolinear Tonemapper has no settings"
		function GetLuxRenderString =
			(
			str = stringstream ""
			format "\"string tonemapkernel\" [\"autolinear\"]\n"  to:str
			return (str as string)
		)
		on lux_Tonemapping_autolinear open do (GetControlParams(lux_Tonemapping_autolinear))
	)
	
	rollout lux_Tonemapping_maxwhite "maxwhite"
	(
		label lb_maxwhite "maxwhite Tonemapper has no settings"
		function GetLuxRenderString =
			(
			str = stringstream ""
			format "\"string tonemapkernel\" [\"maxwhite\"]\n" to:str
			return (str as string)
		)
		on lux_Tonemapping_maxwhite open do (GetControlParams(lux_Tonemapping_maxwhite))
	)
	
	rollout lux_Tonemapping_contrast "contrast"
	(
		spinner contrast_ywa "contrast_ywa:" fieldwidth:50 across:1 range:[0, 20000, 1] align:#left
		
		function GetLuxRenderString =
			(
			str = stringstream ""
			format "\"string tonemapkernel\" [\"contrast\"]\n" to:str
			luxWriteFloat "contrast_ywa" contrast_ywa.value str
			return (str as string)
		)
		on lux_Tonemapping_contrast open do (GetControlParams(lux_Tonemapping_contrast))
	)

	TonemapperRollouts = #(lux_Tonemapping_reinhard, lux_Tonemapping_linear, lux_Tonemapping_autolinear, lux_Tonemapping_maxwhite, lux_Tonemapping_contrast)
)