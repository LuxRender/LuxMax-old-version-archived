function export_lxo doMotionblur lxo =
(
	files = getFiles ((getFilenamePath lxo)  + "\\*.ply")
	for f in files do
	(
		deleteFile f
	)
	
	str = stringstream ""
	meshes = #()
	instances = undefined 
	
	for obj in geometry do
	(
		instanceMgr.GetInstances obj &instances
		
		if (obj.ishidden) then continue
		if ((findItem meshes obj) > 0) then continue
		
		--// Export ply files
		--// Skip if ply export is disabled
		if (GetLuxValue "chk_ply") then
		(	
			--// Ply filename
			n = ((getFilenamePath lxo) + "\\" + obj.name + ".ply")
		
			if (GetLuxValue "chk_scriptply") then (ply_export_script obj n 100) --// Force exort with script exporter
			
			else
			(
				--// If the c++ expoter is present, use it
				if (ply_export != undefined) then
				(
					try (ply_export obj n false 100)
					catch (ply_export_script obj n 100) --// Some mesh with weird normals do not export for some reason so fall back to the script export for those
				)
				--// No c++ exporter so use the script
				else (ply_export_script obj n 100)
			)
			
			join meshes instances
		)
		
		--// Relative path to the ply
		n = (getSceneName() + "/" + GetFrame() + "/" + obj.name + ".ply")
		
		format "ObjectBegin  \"%\"\r\n" obj.name to:str
		format "\tShape \"plymesh\" \"string filename\" [\"%\"]\r\n" n to:str
		format "ObjectEnd # \"%\"\r\n" obj.name to:str
		
		for iobj in instances do
		(
			emissive = false
			
			if (iobj.ishidden) then continue
			
			format "\r\nAttributeBegin # \"%\"\r\n" iobj.name to:str
			r1 = iobj.transform.row1
			r2 = iobj.transform.row2
			r3 = iobj.transform.row3
			r4 = iobj.transform.row4
			
			format "\tTransform [% % % 0.0 % % % 0.0 % % % 0.0 % % % 1.0]\r\n" r1.x r1.y r1.z r2.x r2.y r2.z r3.x r3.y r3.z (r4.x / 100.0) (r4.y / 100.0) (r4.z / 100.0)to:str

			--// Write default material if none on the object
			if (iobj.material == undefined) then
			(
				format "\tMakeNamedMaterial \"Wirecolor\"\r\n" to:str
				luxWriteString "type" "matte" str
				luxWriteColor "Kd" iobj.wirecolor str
				format "\tNamedMaterial \"Wirecolor\"\r\n" to:str
			)
			--// Write material name
			else
			(		
				format "\tNamedMaterial \"%\"\r\n"iobj.material.name to:str
				
				_m = iobj.material
				
				if (CheckLuxRenderCompat _m == true) then
				(
					if (_m.interior != undefined) do format "\r\nInterior  \"%\"\r\n" _m.interior.name to:str
					if (_m.exterior != undefined) do format "\r\nExterior  \"%\"\r\n" _m.exterior.name to:str
				)
				
				if (CheckLuxRenderCompat _m == true and _m.useEmission == true) then
				(	
					emissive = true
					numlightsource += 1
							
					format "\tLightGroup \"%\"\r\n" _m.arealightgroup to:str

					format "\tAreaLightSource \"area\"\r\n" to:str
					
					if (_m.emissionTexture != undefined) then
						format "\t\t\"texture L\" [\"%\"]\r\n" _m.emissionTexture.name to:str
					else
						LuxWriteColor "L" _m.emissionColor str
					
					format "\t\t\"float power\" [%]\r\n" _m.power to:str
					format "\t\t\"float efficacy\" [%]\r\n" _m.efficacy to:str
					format "\t\t\"float gain\" [%]\r\n" _m.gain to:str
				)
			)
			
			if (doMotionblur == true and iobj.isAnimated == true and emissive == false) then
			(
				currentFrame = (slidertime.frame) as integer
				nextFrame = (slidertime.frame + 1)  as integer 
				duration = (nextFrame - currentFrame) / framerate as float
				
				
				format "\tTransformBegin #\r\n" to:str
				format "\tIdentity #\r\n" to:str
				
				at time nextFrame
				(
					r1 = iobj.transform.row1
					r2 = iobj.transform.row2
					r3 = iobj.transform.row3
					r4 = iobj.transform.row4
				)
				
				format "\tTransform [% % % 0.0 % % % 0.0 % % % 0.0 % % % 1.0]\r\n" r1.x r1.y r1.z r2.x r2.y r2.z r3.x r3.y r3.z (r4.x / 100.0) (r4.y / 100.0) (r4.z / 100.0)to:str
				format "\tCoordinateSystem \"%\"\r\n" (obj.name + "_motion_" + currentFrame as string) to:str
				format "\tTransformEnd #\r\n" to:str
				format "\tMotionInstance \"%\" % % \"%\" \r\n" obj.name 0.0 duration (obj.name + "_motion_" + currentFrame as string) to:str
			)
			else
			(
				if ((GetLuxValue "ddl_renderer") > 1 or emissive == true) then
					format "\tShape \"plymesh\" \"string filename\" [\"%\"]\r\n" n to:str
				else
					format "\tObjectInstance \"%\"\r\n" obj.name to:str
			)
		
			format "AttributeEnd # \"\"\r\n\r\n" to:str
		)
	)
	
	f = dotNetObject "System.IO.StreamWriter" lxo
	f.Write (str as string)
	f.Close()
)