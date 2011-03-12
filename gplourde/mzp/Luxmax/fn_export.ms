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
			format "# Main Scene File\r\n" to:str

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
			
			format "\r\nWorldBegin\r\n\r\n" to:str
			
			( --// Write Light sources
				--// Use environment map if available
				if (environmentMap != undefined and environmentMap.bitmap != undefined) then
				(
					format "# Enviromentmap\r\n" to:str
					format "AttributeBegin\r\n" to:str
					format "Rotate 90.0 0 0 1\r\n" to:str
					format "Scale 1 1 1\r\n" to:str
					format "LightGroup \"environment\"\r\n" to:str 
					format "LightSource \"infinite\"\r\n" to:str
					format "\"string mapping\" [\"angular\"]\r\n" to:str 
					format "\"string mapname\" [\"%\"]\r\n" (fixWindowsPath environmentmap.bitmap.filename) to:str
					format "\"float gamma\" [1.0]\r\n" to:str
					format "\"float envgain\" [1.0]\r\n" to:str
					format "AttributeEnd\r\n\r\n" to:str
					numlightsource += 1
				)

				--// Export each lights
				for lt in lights do
				(
					case (classof lt) of
					(
						Omnilight:					(format "%\r\n" (lux_export_omni lt) to:str)
						miAreaLightomni:			(format "%\r\n" (lux_export_omni lt) to:str)
						targetSpot:				(format "%\r\n" (lux_export_spot lt) to:str)
						freeSpot:					(format "%\r\n" (lux_export_spot lt) to:str)
						Directionallight:			(format "%\r\n" (lux_export_direct lt) to:str)
						TargetDirectionallight:	(format "%\r\n" (lux_export_direct lt) to:str)
						miAreaLight:				(format "%\r\n" (lux_export_spot lt) to:str)
						LuxSky:						(format "%\r\n" (lux_export_luxsky lt) to:str)
						LuxSun:						(format "%\r\n" (lux_export_luxsun lt) to:str)
					)
				)
				
				if (numlightsource < 1) then
				(
					format "AttributeBegin #default\r\n" to:str
					format "LightGroup \"default\"\r\n" to:str
					format "LightSource \"sunsky\"\r\n" to:str
					luxWriteFloat "turbidity" 2 str 
					luxWriteFloat "gain" 1.4 str
					format "AttributeEnd # default\r\n\r\n" to:str
				)
			)
			
			format "Include \"%\"\r\n" (getSceneName() + "/" + GetFrame() + "/" + "LuxRender-Materials.lxm") to:str
			format "Include \"%\"\r\n" (getSceneName() + "/" + GetFrame() + "/" + "LuxRender-Geometry.lxo") to:str
			
			format "\r\nWorldEnd" to:str
			
			if (GetLuxValue "chk_lxs") then
			(
				F_lxs = dotNetObject "System.IO.StreamWriter" lxs
				F_lxs.Write (str as string)
				F_lxs.Close()
			)
			
			return true
		)
	)
)