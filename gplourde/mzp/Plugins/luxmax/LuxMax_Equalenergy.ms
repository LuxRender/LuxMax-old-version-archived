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

plugin TextureMap LuxrenderEqualEnergy name:"LR Equal Energy" classID:#(0x7a0a50ef, 0x55967bcd) extends:Bitmaptexture replaceUI:true version:1
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
		
		
		format "Texture \"%\" \"color\" \"equalenergy\"\n" this.name to:str
		luxWriteFloat "energy"  this.energy str
 
		return str as string
	)
	
	
	
	
	
parameters main rollout:rlequalenergy
(
	energy type:#float ui:menergy default:1
)	
	
rollout rlequalenergy "Equal Energy Texture Parameter" width:314 height:399
(

	spinner menergy "Energy" range:[0,1,1] scale:0.001 align:#center 
	
)
	
	
	
)