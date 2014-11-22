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

plugin TextureMap LuxrenderColorScale name:"LR Color Scale" classID:#(0x310d8e68, 0x2721a267) extends:Bitmaptexture replaceUI:true version:1
(
	include "luxmax\\fn_common.ms"
	
	function GetTextureMaps =
	(
		texturemaps = #(this.maptex1, this.maptex2)
		return texturemaps
	)
	
	function GetLuxRenderString =
	(
		str = stringstream ""

		format "Texture \"%\" \"color\" \"scale\"\n" this.name to:str
		
		if (this.maptex1 != undefined) then
			format "\t \"texture tex1\" [\"%\"]\n" this.maptex1.name to:str
		else
			luxWriteColor "tex1" this.colortex1 str
		
		if (this.maptex2 != undefined) then
			format "\t \"texture tex2\" [\"%\"]\n" this.maptex2.name to:str
		else		
			luxWriteColor "tex2" this.colortex2 str

		return str as string
	)
	
	parameters main rollout:params
	(
		colortex1 type:#color ui:tex1Scale
		colortex2 type:#color ui:tex2Scale
		
		maptex1 type:#texturemap ui:tex1Texture
		maptex2 type:#texturemap ui:tex2Texture
	)
	rollout params "ImageMap Parameters"
	(
		-- tex1 parameters
		label lbTex1 "Texture 1 . . . . . . ."  align:#left across:3
		colorpicker tex1Scale " " width:80 height:16 align:#left
		mapbutton tex1Texture "T" width:110 height:16 align:#right
		
		-- tex2 parameters
		label lbTex2 "Texture 2 . . . . . . ."  align:#left across:3
		colorpicker  tex2Scale " " width:80 height:16 align:#left
		mapbutton tex2Texture "T" width:110 height:16 align:#right		
	)
)