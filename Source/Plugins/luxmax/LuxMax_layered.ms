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

Plugin material LuxrenderLayered name:"LR Layered" classID:#(0x6a1d474c, 0x67350f49) extends:standard replaceUI:true version:2
(
	include "luxmax\\fn_common.ms"
	include "luxmax\\mtl_logo.ms"
	
	function GetTextureMaps =
	(
		texturemaps = #()
		
        if (this.opacity1Texture != undefined) then
		(
			floatScale = (luxCreateScaleFloatMap this.opacity1Texture this.opacity1)
			append texturemaps floatScale
		)
		
		if (this.opacity2Texture != undefined) then
		(
			floatScale = (luxCreateScaleFloatMap this.opacity2Texture this.opacity2)
			append texturemaps floatScale
		)
		
		if (this.opacity3Texture != undefined) then
		(
			floatScale = (luxCreateScaleFloatMap this.opacity3Texture this.opacity3)
			append texturemaps floatScale
		)
		
		if (this.opacity4Texture != undefined) then
		(
			floatScale = (luxCreateScaleFloatMap this.opacity4Texture this.opacity4)
			append texturemaps floatScale
		)
		
		if (this.material1 != undefined) then
		(
			join texturemaps (this.material1.GetTextureMaps())
		)
		
		if (this.material2 != undefined) then
		(
			join texturemaps (this.material2.GetTextureMaps())
		)
		
		if (this.material3 != undefined) then
		(
			join texturemaps (this.material3.GetTextureMaps())
		)
		
		if (this.material4 != undefined) then
		(
			join texturemaps (this.material4.GetTextureMaps())
		)
		
		return texturemaps
	)
	
	function GetLuxRenderString =
	(
		str = stringstream ""
			
			format "#BEGIN Layered Material: %\n" this.name to:str
			if (this.material1 != undefined) then (format "%\n" (this.material1.GetLuxRenderString()) to:str)	
			if (this.material2 != undefined) then (format "%\n" (this.material2.GetLuxRenderString()) to:str)
			if (this.material3 != undefined) then (format "%\n" (this.material3.GetLuxRenderString()) to:str)
			if (this.material4 != undefined) then (format "%\n" (this.material4.GetLuxRenderString()) to:str)	
				
			format "MakeNamedMaterial \"%\"\n" this.name to:str
			if (this.material1 != undefined) then (luxWriteString "namedmaterial1" this.material1.name str)
			if (this.material2 != undefined) then (luxWriteString "namedmaterial2" this.material2.name str)
			if (this.material3 != undefined) then (luxWriteString "namedmaterial3" this.material3.name str)
			if (this.material4 != undefined) then (luxWriteString "namedmaterial4" this.material4.name str)

			if (this.material1 != undefined) then 
			(	
			if this.opacity1Texture != undefined then
			(format "\t\"texture opacity1\" [\"%\"]\n" (this.opacity1Texture.name + "_scale") to:str)
			else
			(luxWriteFloat "opacity1"  this.opacity1 str)
			)
			
			if (this.material2 != undefined) then 
			(	
			if this.opacity2Texture != undefined then
			(format "\t\"texture opacity2\" [\"%\"]\n" (this.opacity2Texture.name + "_scale") to:str)
			else
			(luxWriteFloat "opacity2"  this.opacity2 str)
			)

			if (this.material3 != undefined) then 
			(	
			if this.opacity3Texture != undefined then
			(format "\t\"texture opacity3\" [\"%\"]\n" (this.opacity3Texture.name + "_scale") to:str)
			else
			(luxWriteFloat "opacity3"  this.opacity3 str)
			)
			
			if (this.material4 != undefined) then 
			(	
			if this.opacity4Texture != undefined then
			(format "\t\"texture opacity4\" [\"%\"]\n" (this.opacity4Texture.name + "_scale") to:str)
			else
			(luxWriteFloat "opacity4"  this.opacity4 str)
			)
			
			luxWriteString "type" "layered" str
			format "#END Layered Material: %\n" this.name to:str


		return str as string
	)
	
	parameters main rollout:paramsEm
	(
		material1 type:#material ui: mmaterial1
		material2 type:#material ui: mmaterial2
		material3 type:#material ui: mmaterial3
		material4 type:#material ui: mmaterial4
		
		opacity1 type:#float ui:mopacity1 default:1
		opacity1Texture type:#textureMap ui:mopacity1Texture
		opacity2 type:#float ui:mopacity2 default:1
		opacity2Texture type:#textureMap ui:mopacity2Texture
		opacity3 type:#float ui:mopacity3 default:1
		opacity3Texture type:#textureMap ui:mopacity3Texture
		opacity4 type:#float ui:mopacity4 default:1
		opacity4Texture type:#textureMap ui:mopacity4Texture
	)
	
	rollout paramsEm "Mix Parameters" width:160 height:64
	(
		label lbmaterial1 "Material 1 . . . . . . . . . . . . . . . . . . ." across:2 align:#left
		materialButton mmaterial1 "" width:110 height:16 align:#right
		label lbopacity1 "Opacity1 . . . . ." across:3 align:#left
		spinner mopacity1 "" range:[0, 1, 0.5] type:#float width:50 fieldwidth:65 align:#left
		mapbutton mopacity1Texture "" width:110 height:16 align:#right
		
		label lbmaterial2 "Material 2 . . . . . . . . . . . . . . . . . . ." across:2 align:#left
		materialButton mmaterial2 "" width:110 height:16 align:#right
		label lbopacity2 "Opacity2 . . . . ." across:3 align:#left
		spinner mopacity2 "" range:[0, 1, 0.5] type:#float width:50 fieldwidth:65 align:#left
		mapbutton mopacity2Texture "" width:110 height:16 align:#right
		
		label lbmaterial3 "Material 3 . . . . . . . . . . . . . . . . . . ." across:2 align:#left
		materialButton mmaterial3 "" width:110 height:16 align:#right
		label lbopacity3 "Opacity3 . . . . ." across:3 align:#left
		spinner mopacity3 "" range:[0, 1, 0.5] type:#float width:50 fieldwidth:65 align:#left
		mapbutton mopacity3Texture "" width:110 height:16 align:#right
		
		label lbmaterial4 "Material 4 . . . . . . . . . . . . . . . . . . ." across:2 align:#left
		materialButton mmaterial4 "" width:110 height:16 align:#right
		label lbopacity4 "Opacity4 . . . . ." across:3 align:#left
		spinner mopacity4 "" range:[0, 1, 0.5] type:#float width:50 fieldwidth:65 align:#left
		mapbutton mopacity4Texture "" width:110 height:16 align:#right
		
	)
	include "luxmax\\mtl_common.ms"
)
