( -- // Exporter functions
	--// Main export function
	function luxWriteLxs p_camera =
	(
		numlightsource = 0
		
		_P =  ((getLuxValue "btn_outputpath") + "\\" + getSceneName())
		
		lxs =	(_P + "_" + GetFrame() + ".lxs")
		lxm =	(_P + "\\" + GetFrame() + "\\" + "LuxRender-Materials.lxm")
		lxo =	(_P + "\\" + GetFrame() + "\\" + "LuxRender-Geometry.lxo")
		
		makeDir (getFilenamePath lxs)
		makeDir (getFilenamePath lxo)
		
		if (GetLuxValue "chk_lxm") then (export_lxm lxm)
		if (GetLuxValue "chk_lxo") then (export_lxo lxo)

		str = stringstream ""
		
		(
			format "# Main Scene File\n" to:str

			-- Camera
			writeCamera p_camera str
			
			-- Renderer
			format "%" (lux_Renderer.GetLuxRenderString()) to:str
			
			-- Sampler
			format "%" (lux_Sampler.GetLuxRenderString()) to:str

			-- Accelerator
			format "%" (lux_Accelerator.GetLuxRenderString()) to:str
			
			-- SurfaceIntegrator
			format "%" (lux_SurfaceIntegrator.GetLuxRenderString()) to:str
				
			-- Volume Integrator
			format "%" (lux_VolumeIntegrator.GetLuxRenderString()) to:str
				
			-- Pixel Filter
			format "%" (lux_Filter.GetLuxRenderString()) to:str
			
			-- Film
			format "%" (lux_Film.GetLuxRenderString()) to:str
			
			format "\nWorldBegin\n\n" to:str
			
			( --// Write Light sources
				--// Use environment map if available
				if (environmentMap != undefined and environmentMap.bitmap != undefined) then
				(
					format "# Enviromentmap\n" to:str
					format "AttributeBegin\n" to:str
					format "Rotate 90.0 0 0 1\n" to:str
					format "Scale 1 1 1\n" to:str
					format "LightGroup \"environment\"\n" to:str 
					format "LightSource \"infinite\"\n" to:str
					format "\"string mapping\" [\"angular\"]\n" to:str 
					format "\"string mapname\" [\"%\"]\n" (fixWindowsPath environmentmap.bitmap.filename) to:str
					format "\"float gamma\" [1.0]\n" to:str
					format "\"float envgain\" [1.0]\n" to:str
					format "AttributeEnd\n\n" to:str
					numlightsource += 1
				)

				--// Export each lights
				for lt in lights do
				(
					case (classof lt) of
					(
						Omnilight:					(format "%\n" (lux_export_omni lt) to:str)
						miAreaLightomni:			(format "%\n" (lux_export_omni lt) to:str)
						mr_Sky_Portal:			(format "%\n" (lux_export_mrSkyPortal lt) to:str)
						targetSpot:				(format "%\n" (lux_export_spot lt) to:str)
						freeSpot:					(format "%\n" (lux_export_spot lt) to:str)
						Directionallight:			(format "%\n" (lux_export_direct lt) to:str)
						TargetDirectionallight:	(format "%\n" (lux_export_direct lt) to:str)
						miAreaLight:				(format "%\n" (lux_export_spot lt) to:str)
					)
				)
				
				if (numlightsource < 1) then
				(
					format "AttributeBegin #default\n" to:str
					format "LightGroup \"default\"\n" to:str
					format "LightSource \"sunsky\"\n" to:str
					luxWriteFloat "turbidity" 2 str 
					luxWriteFloat "gain" 1.4 str
					format "AttributeEnd # default\n\n" to:str
				)
			)
			
			format "Include \"%\"\n" (getSceneName() + "/" + GetFrame() + "/" + "LuxRender-Materials.lxm") to:str
			format "Include \"%\"\n" (getSceneName() + "/" + GetFrame() + "/" + "LuxRender-Geometry.lxo") to:str
			
			format "\nWorldEnd" to:str
			
			if (GetLuxValue "chk_lxs") then
			(
				F_lxs = openfile lxs mode:"w"
				format "%\n" (str as string) to:F_lxs
				close F_lxs
			)
			
			return true
		)
	)
)