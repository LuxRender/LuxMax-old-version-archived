( --// Filter
	
	rollout lux_Filter_triangle "triangle"
	(
		group "Advanced"
		(
			checkbox  filter_triangle_advanced "Advanced"
			spinner filter_triangle_x "X Width:" range:[-9999,9999, 2.0] type:#float across:2
			spinner filter_triangle_y "Y Width:" range:[-9999,9999, 2.0] type:#float
		)
		
		function GetLuxRenderString =
		(
			str = stringstream ""
			format "\nPixelFilter \"triangle\"\n" to:str
			
			if (filter_triangle_advanced.state == true) then
			(
				format "\t\"float xwidth\" [%]\n" filter_triangle_x.value to:str
				format "\t\"float ywidth\" [%]\n" filter_triangle_y.value to:str
			)
			return (str as string)
		)
		
		on lux_Filter_triangle open do (GetControlParams(lux_Filter_triangle))
	)
	rollout lux_Filter_sinc "sinc"
	(
		group "Advanced"
		(
			checkbox  filter_sinc_advanced "Advanced"
			spinner filter_sinc_x "X Width:" range:[-9999,9999, 2.0] type:#float across:2
			spinner filter_sinc_y "Y Width:" range:[-9999,9999, 2.0] type:#float
			spinner filter_sinc_tau "Tau:" range:[-9999,9999, 3.0] type:#float across:2
		)
		
		function GetLuxRenderString =
		(
			str = stringstream ""
			format "\nPixelFilter \"sinc\"\n" to:str
			--format "\"bool supersample\" [\"true\"]\n" to:str
			
			if (filter_sinc_advanced.state == true) then
			(
				format "\t\"float xwidth\" [%]\n" filter_sinc_x.value to:str
				format "\t\"float ywidth\" [%]\n" filter_sinc_y.value to:str
				format "\t\"float tau\" [%]\n" filter_sinc_tau.value to:str
			)
			return (str as string)
		)
		
		on lux_Filter_sinc open do (GetControlParams(lux_Filter_sinc))
	)
	rollout lux_Filter_mitchell "mitchell"
	(
		group "Advanced"
		(
			checkbox  filter_mitchell_advanced "Advanced"
			spinner filter_mitchell_x "X Width:" range:[-9999,9999, 2.0] type:#float across:2
			spinner filter_mitchell_y "Y Width:" range:[-9999,9999, 2.0] type:#float
			spinner filter_mitchell_b "B:" range:[-9999,9999, 0.33] type:#float across:2
			spinner filter_mitchell_c "C:" range:[-9999,9999, 0.33] type:#float
		)
		
		function GetLuxRenderString =
		(
			str = stringstream ""
			format "\nPixelFilter \"mitchell\"\n" to:str
			--format "\"bool supersample\" [\"true\"]\n" to:str
			
			if (filter_mitchell_advanced.state == true) then
			(
				format "\t\"float xwidth\" [%]\n" filter_mitchell_x.value to:str
				format "\t\"float ywidth\" [%]\n" filter_mitchell_y.value to:str
				format "\t\"float B\" [%]\n" filter_mitchell_b.value to:str
				format "\t\"float C\" [%]\n" filter_mitchell_c.value to:str
			)
			return (str as string)
		)
		
		on lux_Filter_mitchell open do (GetControlParams(lux_Filter_mitchell))
	)
	rollout lux_Filter_gaussian "gaussian"
	(
		group "Advanced"
		(
			checkbox  filter_gaussian_advanced "Advanced"
			spinner filter_gaussian_x "X Width:" range:[-9999,9999, 2.0] type:#float across:2
			spinner filter_gaussian_y "Y Width:" range:[-9999,9999, 2.0] type:#float
			spinner filter_gaussian_alpha "Alpha:" range:[-9999,9999, 3.0] type:#float across:2
		)
		
		function GetLuxRenderString =
		(
			str = stringstream ""
			format "\nPixelFilter \"gaussian\"\n" to:str
			--format "\"bool supersample\" [\"true\"]\n" to:str
			
			if (filter_gaussian_advanced.state == true) then
			(
				format "\t\"float xwidth\" [%]\n" filter_gaussian_x.value to:str
				format "\t\"float ywidth\" [%]\n" filter_gaussian_y.value to:str
				format "\t\"float alpha\" [%]\n" filter_gaussian_alpha.value to:str
			)
			return (str as string)
		)
		
		on lux_Filter_gaussian open do (GetControlParams(lux_Filter_gaussian))
	)
	rollout lux_Filter_box "box"
	(
		group "Advanced"
		(
			checkbox  filter_box_advanced "Advanced"
			spinner filter_box_x "X Width:" range:[-9999,9999, 2.0] type:#float across:2
			spinner filter_box_y "Y Width:" range:[-9999,9999, 2.0] type:#float
		)
		
		function GetLuxRenderString =
		(
			str = stringstream ""
			format "\nPixelFilter \"box\"\n" to:str
			--format "\"bool supersample\" [\"true\"]\n" to:str
			
			if (filter_box_advanced.state == true) then
			(
				format "\t\"float xwidth\" [%]\n" filter_gaussian_x.value to:str
				format "\t\"float ywidth\" [%]\n" filter_gaussian_y.value to:str
			)
			return (str as string)
		)
		
		on lux_Filter_box open do (GetControlParams(lux_Filter_box))
	)
	
	FilltersRollouts = #(lux_Filter_triangle, lux_Filter_sinc, lux_Filter_mitchell, lux_Filter_gaussian, lux_Filter_box)
)