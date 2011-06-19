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

plugin TextureMap Luxrenderfrequency name:"LR Frequency" classID:#(0x5f633fab, 0x40085f86) extends:Bitmaptexture replaceUI:true version:1
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
		
		
		format "Texture \"%\" \"color\" \"frequency\"\n" this.name to:str
		luxWriteFloat "freq"  this.freq str
		luxWriteFloat "phase"  this.phase str
		luxWriteFloat "energy"  this.energy str
 
		return str as string
	)
	
	
	
	
	
parameters main rollout:rlfrequency
(
	freq type:#float ui:mfreq default:0.01
	phase type:#float ui:mphase default:0.500
	energy type:#float ui:menergy default:1
)	
	
rollout rlfrequency "Frequency Parameters" width:314 height:399
(
	spinner mfreq "Frequency" range:[0.01,100,0.01] scale:0.01 align:#left across:3 
	spinner mphase "Phase" range:[0,1,0.5] scale:0.001 align:#center
	spinner menergy "Energy" range:[0,1,1] scale:0.001 align:#right 

)
	
	
	
)