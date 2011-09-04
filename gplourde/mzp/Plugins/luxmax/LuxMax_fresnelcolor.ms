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

plugin TextureMap Luxrenderfresnelcolor name:"LR Fresnelcolor" classID:#(0x17cc1e94, 0x471a6a5d) extends:Bitmaptexture replaceUI:true version:1
(
	include "luxmax\\fn_common.ms"
	
	function GetTextureMaps =
	(
		texturemaps = #(this.tex)
		return texturemaps
	)
		
		
	function GetLuxRenderString =
	(
		str = stringstream ""
		format "Texture \"%\" \"fresnel\" \"fresnelcolor\"" this.name to:str
		if this.Tex != undefined then
				format "\t\"texture Kr\" [\"%\"]\n" this.Tex.name to:str
			else
				luxWriteColor "Kr"  this.Color str
		
		return str as string
	)
	
	
	
	
	
parameters main rollout:rlfrequency
(
	Color type:#color ui:mColor default:[70,70,70]
	Tex type:#textureMap ui: mTex
)	
	
rollout rlfrequency "Frequency Parameters" width:314 height:399
(
	label lb1 "Color. . . . . . . . ."  align:#left across:3 default:#enabled 
	colorpicker mColor "" align:#left width:80 height:16
	mapbutton mTex "Texture" width:110 height:16 align:#right
)
	
	
	
)