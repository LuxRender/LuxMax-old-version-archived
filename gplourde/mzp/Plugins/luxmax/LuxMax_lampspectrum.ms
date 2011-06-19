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

plugin TextureMap LuxrenderLampspectrum name:"LR Lampspectrum" classID:#(0x79817daf, 0x4e6312bc) extends:Bitmaptexture replaceUI:true version:1
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
		
		
		format "Texture \"%\" \"color\" \"lampspectrum\"\n" this.name to:str
		luxwriteString "name" this.lampstring str
		
		return str as string
	)
	
	
	
	
	
parameters main rollout:params
(
	lampstring type:#string 		
)	
	
rollout params "Lampspectrum" width:314 height:399
(
	dropdownlist lbx_lampspectrum "Lampspectrum Presets:" width:320 height:20 align:#center across:1

	on  lbx_lampspectrum selected val do
		(
			lampspectrum_presets = luxGetLampspectrumPresets()
			
			if lampspectrum_presets[val].value == undefined do return false
			lampstring = lampspectrum_presets[val].value
			
		)
	
	on params open do
		(
			items = #()
			
			for o in (luxGetLampspectrumPresets()) do
			(
				append items o.name
			)
			
			lbx_lampspectrum.items = items
		)
	
)



)
