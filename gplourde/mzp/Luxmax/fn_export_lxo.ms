--// Export objects to ply
function luxExportPlyProc triobj strname =
(
	if (GetLuxValue "chk_scriptply") then
	(
		 --// Force exort with script exporter
		ply_export_script triobj strname 100
	)
	else
	(
		--// If the c++ expoter is present, use it
		if (ply_export != undefined) then
		(
			try (ply_export triobj strname false 100)
			catch (ply_export_script triobj strname 100) --// Some mesh with weird normals do not export for some reason so fall back to the script export for those
		)
		--// No c++ exporter so use the script
		else (ply_export_script triobj strname 100)
	)
)

--// Write default material for object that dont have one
function luxWriteDefaultMaterial objcolor strout =
(
	luxWriteName "MakeNamedMaterial" "Wirecolor" strout
	luxWriteString "type" "matte" strout
	luxWriteColor "Kd" objcolor strout
	luxWriteName "NamedMaterial" "Wirecolor" strout
)

--// Write emission properties of given material
function luxWriteEmission objmaterial strout =
(
	luxWriteName "LightGroup" objmaterial.arealightgroup strout
	luxWriteName "AreaLightSource" "area" strout
	
	if (objmaterial.emissionTexture != undefined) then
		format "\t\t\"texture L\" [\"%\"]\n" objmaterial.emissionTexture.name to:strout
	else
		LuxWriteColor "L" objmaterial.emissionColor strout
	
	luxWriteFloat "power" objmaterial.power strout
	luxWriteFloat "efficacy" objmaterial.efficacy strout
	luxWriteFloat "gain" objmaterial.gain strout
)

--// Main object export function
function export_lxo doMotionblur lxo =
(
	--// Only export tObjectInstance with defaul sampler, sppm and hybrid do not support it yet
	supportInstances = true
	
	if (GetLuxValue "ddl_renderer") > 1 then supportInstances = false

	--// Cleanup current ply files if the option "export ply" is checked
	if (GetLuxValue "chk_ply") then
	(
		files = getFiles ((getFilenamePath lxo)  + "\\*.ply")
		for f in files do deleteFile f
	)
	
	str = stringstream ""
	format "# Geometry File\n\n" to:str
	
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
			luxExportPlyProc obj n
			join meshes instances
		)
		
		--// Relative path to the ply
		n = (getSceneName() + "/" + GetFrame() + "/" + obj.name + ".ply")
		
		--// Write objects definitions. This is only required if we support instances
		if (supportInstances) then
		(
			format "ObjectBegin  \"%\"\n" obj.name to:str
			format "Shape \"plymesh\" \"string filename\" [\"%\"]\n" n to:str
			format "ObjectEnd # \"%\"\n" obj.name to:str
			luxWriteEmptyLine str
		)
		
		--// Write all instance of this object
		for iobj in instances do
		(
			emissive = false
			
			if (iobj.ishidden) then continue
			
			format "AttributeBegin # \"%\"\n" iobj.name to:str
			
			luxWriteTransform iobj.transform (slidertime.frame) str

			--// Write default material if none on the object
			if (iobj.material == undefined or CheckLuxRenderCompat iobj.material == false) then
			(
				LuxWriteDefaultMaterial iobj.wirecolor str
			)
			--// Write material properties
			else
			(		
				format "NamedMaterial \"%\"\n"iobj.material.name to:str
				
				_m = iobj.material
				
				if (_m.interior != undefined) do
					format "\nInterior  \"%\"\n" _m.interior.name to:str
				if (_m.exterior != undefined) do
					format "\nExterior  \"%\"\n" _m.exterior.name to:str
				
				if (_m.useEmission == true) then
				(	
					emissive = true
					numlightsource += 1
					LuxWriteEmission _m str
				)
			)
			
			--// Do this is we use motionblur on this object
			if (doMotionblur == true and iobj.isAnimated == true and emissive == false) then
			(
				currentFrame = (slidertime.frame) as integer
				nextFrame = (slidertime.frame + 1)  as integer 
				duration = (nextFrame - currentFrame) / framerate as float
				
				luxWriteName "TransformBegin #" "" str
				luxWriteName "Identity #" "" str
				luxWriteTransform iobj.transform nextFrame str
				luxWriteName "CoordinateSystem" (obj.name + "_motion_" + currentFrame as string) str
				luxWriteName "TransformEnd #" str
				format "MotionInstance \"%\" % % \"%\" \n" obj.name 0.0 duration (obj.name + "_motion_" + currentFrame as string) to:str
			)
			else
			(
				--// Only sempler renderer support ObjectInstance, use Shapes for hybrid and sppm
				if ((GetLuxValue "ddl_renderer") > 1 or emissive == true) then
					format "Shape \"plymesh\" \"string filename\" [\"%\"]\n" n to:str
				else
					luxWriteName "ObjectInstance" obj.name str
			)
		
			luxWriteName "AttributeEnd #" "" str
			luxWriteEmptyLine str
		)
	)
	
	f = dotNetObject "System.IO.StreamWriter" lxo
	f.Write (str as string)
	f.Close()
)