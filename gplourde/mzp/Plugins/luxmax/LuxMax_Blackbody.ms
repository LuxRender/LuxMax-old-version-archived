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

plugin TextureMap LuxrenderBlackbody name:"LR Blackbody" classID:#(0x111b42bf, 0x63ee250a) extends:Bitmaptexture replaceUI:true version:1
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

		format "Texture \"%\" \"color\" \"blackbody\"\r\n" this.name to:str
		luxWriteFloat "temperature" this.temperature str

		return str as string
	)
	
	parameters main rollout:params
	(
		temperature type:#float default:6500 ui:mTemp
	)
	rollout params "Blackbody Parameters"
	(
		label lblmTemp  "Temp. (Kelvin) . . . . . . . . . . . . . . . . . . . . ." across:2 align:#left
		spinner mTemp " " range:[1000,10000,6500] fieldwidth:65 align:#right
	)
)