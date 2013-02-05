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

plugin TextureMap LuxrenderMixMap name:"LR MixMap" classID:#(0x3a7331ff, 0x7396260f) extends:Bitmaptexture replaceUI:true version:1

(
	include "luxmax\\fn_common.ms"
	
	function GetTextureMaps =
	(
		texturemaps = #(this.map1, this.map2)
		
		if (this.mixvalueTexture != undefined) then
		(
			floatScale = LuxrenderFloatScale()
			floatScale.name = (this.mixvalueTexture.name + "_scale")
			floatScale.floattex1 = this.mixvalue
			floatScale.maptex2 = this.mixvalueTexture
			append texturemaps floatScale
		)
		
		return texturemaps
	)
	
	function GetLuxRenderString =
	(
		str = stringstream ""

			format "Texture \"%\"" this.name to:str
		
		    if this.type == 1 then
				(format "\"float\"" to:str)
			else
				(format "\"color\"" to:str)
			
		    format "\"mix\"" to:str
			
			if this.mixvalueTexture != undefined then
				format "\t\"texture amount\" [\"%\"]" (this.mixvalueTexture.name + "_scale") to:str
			else
				luxWriteFloat "amount"  this.mixvalue str
			
			if this.map1 != undefined then
				format "\t\"texture tex1\" [\"%\"]\n" this.map1.name to:str
			else
				luxWriteColor "tex1"  this.map1value str
			
			if this.map2 != undefined then
				format "\t\"texture tex2\" [\"%\"]\n" this.map2.name to:str
			else
				luxWriteColor "tex2"  this.map2value str
			
			return str as string
		
	)
	
	parameters main rollout:paramsEm
	(
		map1value type:#color ui:mmap1value
		map1 type:#textureMap ui: mmap1
		map2value type:#color ui:mmap2value
		map2 type:#textureMap ui: mmap2
		
		mixvalue type:#float ui:mmixvalue default:0.5
		mixvalueTexture type:#textureMap ui:mmixvalueTexture
		
		type type:#integer default:1 ui:mtype
	)
	rollout paramsEm "Mix Parameters" width:160 height:64
	(
		label lbmap1 "Color 1 . . . . . "across:4 align:#left
		colorpicker mmap1value ""  align:#left
		label lbmap12 "Texture 1 . . . . " align:#left
		mapButton mmap1 "Texture 1" width:80 height:16 align:#right
		label lbmap2 "Color 2 . . . . ." across:4 align:#left
		colorpicker mmap2value "" align:#left
		label lbmap22 "Texture 2 . . . . . . " align:#left
		mapButton mmap2 "Texture 2" width:80 height:16 align:#right
		
		label lbmixvalue "Mix amount . . . . ." across:3 align:#left
		spinner mmixvalue "" range:[0, 1, 0.5] type:#float width:50 fieldwidth:65 align:#left
		mapbutton mmixvalueTexture "" width:110 height:16 align:#right
		
		dropdownlist mtype "Filter type:" items:#("float", "color") width:140 align:#left across:2
	)
)