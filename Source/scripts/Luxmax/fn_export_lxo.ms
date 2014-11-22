/*
***** BEGIN GPL LICENSE BLOCK *****

--------------------------------------------------------------------------
LuxMax Autodesk® 3ds Max® to Luxrender exporter
--------------------------------------------------------------------------

Authors:
Guillaume Plourde
Konstantinos Mourelas
Stig Atle Steffensen

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, see <http://www.gnu.org/licenses/>.

***** END GPL LICENCE BLOCK *****
*/

--// Export objects to ply
function luxExportPlyProc triobj strname =
(
	if (GetLuxValue "chk_scriptply") then
	( 
		 --// Force exort with script exporter
		ply_export_script triobj strname (luxScaleUnit())
	)
	else
	(
		--// If the c++ expoter is present, use it
		if (ply_export != undefined) then
		(
			try (ply_export triobj strname false (luxScaleUnit()))
			catch (ply_export_script triobj strname (luxScaleUnit())) --// Some mesh with weird normals do not export for some reason so fall back to the script export for those
		)
		--// No c++ exporter so use the script
		else (ply_export_script triobj strname (luxScaleUnit()))
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
		format "\t\"texture L\" [\"%\"]\n" objmaterial.emissionTexture.name to:strout
	else
		LuxWriteColor "L" objmaterial.emissionColor strout
	
	luxWriteFloat "power" objmaterial.power strout 
	luxWriteFloat "efficacy" objmaterial.efficacy strout
	luxWriteFloat "gain" objmaterial.gain strout
	
	if (objmaterial.useies == true) then
	(
	luxwriteString "iesname" objmaterial.iespath strout
	)
	if (objmaterial.useflipz == true) then
	(
	format "\t\"bool flipz\" [\"true\"]\n" to:strout
	)
)


--// Write emission properties of given material
function luxWriteSubdivision objmaterial strout =
(
	subdivscheme = #("none", "microdisplacement", "loop")
	
	try
	(
		if (objmaterial.displacementTexture != undefined and objmaterial.useDisplacement == true)then
			format "\t\"string displacementmap\" [\"%\"]\r\n" (objmaterial.displacementTexture.name + "_scale") to:strout
		
		if (objmaterial.subdivscheme > 1) then
		(			
			luxWriteString "subdivscheme" (subdivscheme[objmaterial.subdivscheme]) strout
			luxWriteInteger "nsubdivlevels" objmaterial.nsubdivlevels strout
			
			luxWriteFloat "dmscale" objmaterial.dmscale strout
			luxWriteFloat "dmoffset" objmaterial.dmoffset strout
			
			luxWriteBool "dmnormalsmooth" objmaterial.dmnormalsmooth strout
			luxWriteBool "dmsharpboundary" objmaterial.dmnormalsmooth strout
		)
	) catch ()
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
						deferred = false
			for mods in obj.modifiers do
			(
				if (classof mods == lux_deferred )then
				(
					deferred = true
				)
				
			)
			
			if (deferred)then
			(
				format "ObjectBegin  \"%\"\n" obj.name to:str
				   
				format "Shape \"deferred\" \"string filename\" [\"%\"]\n" n to:str
				format "\"string shapename\" [\"plymesh\"]\n" to:str
				--   "float shapebbox" [-1.33691 -1.07026 -0.518882  1.33691 0.947649 1.01478]
				tempbb = nodeGetBoundingBox obj obj.transform
				format "\"float shapebbox\" [% % % % % %]\n" tempbb[1][1] tempbb[1][2] tempbb[1][3] tempbb[2][1] tempbb[2][2] tempbb[2][3] to:str
				luxWriteSubdivision obj.material str
				format "ObjectEnd # \"%\"\n" obj.name to:str
				luxWriteEmptyLine str
			)
			else
			(
				
			format "ObjectBegin  \"%\"\n" obj.name to:str
			format "Shape \"plymesh\" \"string filename\" [\"%\"]\n" n to:str
			luxWriteSubdivision obj.material str
			format "ObjectEnd # \"%\"\n" obj.name to:str
			luxWriteEmptyLine str
			)
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
				luxWriteTransform &iobj.transform nextFrame str
				luxWriteName "CoordinateSystem" (obj.name + "_motion_" + currentFrame as string) str
				luxWriteName "TransformEnd #" "" str
				format "MotionInstance \"%\" % % \"%\" \n" obj.name 0.0 duration (obj.name + "_motion_" + currentFrame as string) to:str
			)
			else
			(
				--// Only sampler renderer support ObjectInstance, use Shapes for hybrid and sppm
				if ((GetLuxValue "ddl_renderer") > 1 or emissive == true) then
				(
					format "Shape \"plymesh\" \"string filename\" [\"%\"]\n" n to:str
					--luxWriteSubdivision obj.material str
				)
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