( -- // Exporter functions
	--// Get the current scene name minus the file extension
	function getSceneName =
	(
		n = getFilenameFile maxFileName
		return n
	)

	--// Main export function
	function luxWriteLxs p_camera =
	(
		lxs = ((getLuxValue "btn_outputpath") + "\\" + getSceneName() + ".lxs")
			
		--// if chk_lxs is false just dump the lxs data in a null
		if (GetLuxValue "chk_lxs") then
		(
			makeDir (getFilenamePath lxs)
			f = openfile lxs mode:"w"
		)
		else
			f = stringstream ""
		
		(
			format "# Main Scene File\n" to:f

			-- Camera
			writeCamera p_camera f
			
			-- Renderer
			format "%" (lux_Renderer.GetLuxRenderString()) to:f
			
			-- Sampler
			format "%" (lux_Sampler.GetLuxRenderString()) to:f

			-- Accelerator
			format "%" (lux_Accelerator.GetLuxRenderString()) to:f
			
			-- SurfaceIntegrator
			format "%" (lux_SurfaceIntegrator.GetLuxRenderString()) to:f
				
			-- Volume Integrator
			format "%" (lux_VolumeIntegrator.GetLuxRenderString()) to:f
				
			-- Pixel Filter
			format "%" (lux_Filter.GetLuxRenderString()) to:f
			
			-- Film
			format "%" (lux_Film.GetLuxRenderString()) to:f

			format "\nWorldBegin\n\n" to:f
			
			( --// Write Light sources
				--// Use environment map if available
				if (environmentMap != undefined and environmentMap.bitmap != undefined) then
				(
					format "# Enviromentmap\n" to:f
					format "AttributeBegin\n" to:f
					format "Rotate 90.0 0 0 1\n" to:f
					format "Scale 1 1 1\n" to:f
					format "LightGroup \"environment\"\n" to:f 
					format "LightSource \"infinite\"\n" to:f 
					format "\"string mapping\" [\"angular\"]\n" to:f 
					format "\"string mapname\" [\"%\"]\n" (fixWindowsPath environmentmap.bitmap.filename) to:f 
					format "\"float gamma\" [1.0]\n" to:f
					format "\"float envgain\" [1.0]\n" to:f
					format "AttributeEnd\n\n" to:f 
				)
				--// Create a defaul lights if none in the scene
				else if (lights.count < 1) then
				(
					format "AttributeBegin #default\n" to:f 	
					format "LightGroup \"default\"\n" to:f
					format "LightSource \"sky\"\n" to:f
					luxWriteFloat "gain" 1.4 f
					format "AttributeEnd # default\n\n" to:f 	
				)
				--// Export each lights
				for lt in lights do
				(
					case (classof lt) of
					(
						Omnilight:
						(
							format "AttributeBegin # %\n" lt.name to:f 	
							format "LightGroup \"%\"\n" lt.name to:f
							format "LightSource \"point\"\n" to:f
							luxWriteFloat "gain" lt.multiplier f
							luxWriteColor "L" lt.color f
							luxWritePoint "from" lt.position f
							format "AttributeEnd # %\n\n" lt.name to:f 	
						)		
					)
				)
			)
		
			( --// Geometry
				for obj in geometry do
				(
					makeDir ((getFilenamePath lxs) + "/" + (getFilenameFile lxs))
					n = ((getFilenamePath lxs) + (getFilenameFile lxs) + "/" + obj.name + ".ply")
					
					--// Skip if ply export is disabled
					if (GetLuxValue "chk_ply") then
					(
						if (LMX_ExportPLY != undefined) then
							LMX_ExportPLY obj n false
						else
						(
							ply_export obj n 100.0
						)
					)
					
					n = ("./" + (getFilenameFile lxs) + "/" + obj.name + ".ply")
					
					format "\nAttributeBegin\n" to:f
					
					r1 = obj.transform.row1
					r2 = obj.transform.row2
					r3 = obj.transform.row3
					r4 = obj.transform.row4
					
					format "\tTransform [% % % 0.0 % % % 0.0 % % % 0.0 % % % 1.0]\n" r1.x r1.y r1.z r2.x r2.y r2.z r3.x r3.y r3.z (r4.x / 100.0) (r4.y / 100.0) (r4.z / 100.0)to:f

					--// Write default material if none on the object
					if (obj.material == undefined) then
					(
						format "MakeNamedMaterial \"Wirecolor\"\n" to:f
						luxWriteString "type" "matte" f
						luxWriteColor "Kd" (obj.wirecolor / 255) f
						format "NamedMaterial \"Wirecolor\"\n" to:f
					)
					--// Check if its a LuxRender Material
					else if (CheckLuxRenderCompat obj.material == true) then
					(
						format "%" (obj.material.GetLuxRenderString()) to:f
					)
					else
					(
						WriteShaders obj  f
					)
					
					if (classof obj.material == LuxrenderPortal) then
						format "PortalShape \"plymesh\" \"string filename\" [\"%\"]" n to:f
					else
						format "Shape \"plymesh\" \"string filename\" [\"%\"]" n to:f
					
					format "\nAttributeEnd\n" to:f
				)
			)
			
			format "\nWorldEnd\n" to:f
			close f
			return true
		)
	)
)