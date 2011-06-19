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

plugin TextureMap LuxrenderGaussian name:"LR Gaussian" classID:#(0x78541503, 0x25d68cd) extends:Bitmaptexture replaceUI:true version:1
(
	include "luxmax\\fn_common.ms"
	
	function GetTextureMaps =
	(
		texturemaps = #()
		return texturemaps
	)
		
		
	function GetLuxRenderString =
	(
		str = stringstream ""
		
		
		format "Texture \"%\" \"color\" \"gaussian\"\n" this.name to:str
		luxWriteFloat "wavelength"  this.slwlength str
		luxWriteFloat "width"  this.width str
		luxWriteFloat "energy"  this.energy str
 
		return str as string
	)
	
	
	
	
	
parameters main rollout:rlgaussian	
(
	slwlength type:#integer ui:mslwlength default:500
	spwlength type:#integer ui:mspwlength default:500
	width type:#integer ui:mwidth default:20
	energy type:#float ui:menergy default:1
)	
	
rollout rlgaussian "Gaussian Parameters" width:314 height:399
(
	bitmap bmp1 "Bitmap" width:320 height:85 fileName:"luxmax\\res\\wavelength.png" align:#center across:1
	slider mslwlength "Wavelength" range:[380,720,1] width:320 height:44 align:#center across:1 
	spinner mspwlength "" range:[380,720,1] align:#left across:1 
	spinner mwidth "Width" range:[20,300,1] align:#left across:2
	spinner menergy "Energy" range:[0,1,1] scale:0.001 align:#right 
	
	
	
	on mslwlength changed val do mspwlength.value = val
	on mspwlength changed val do mslwlength.value = val

	

)
	
	
	
)