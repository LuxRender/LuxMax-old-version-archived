/*
***** BEGIN GPL LICENSE BLOCK *****

--------------------------------------------------------------------------
LuxMax Autodesk� 3ds Max� to Luxrender exporter
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

plugin material LuxrenderNull name:"LR Null" classID:#(0x604a23b3, 0x20a0550e) extends:Standard replaceUI:true version:2
(
	include "luxmax\\fn_common.ms"
	include "luxmax\\mtl_logo.ms"
	
	function GetTextureMaps =
	(
		texturemaps = #(this.emissionTexture)
		return texturemaps
	)
	
	function GetLuxRenderString =
	(
		str = stringstream ""
		
		format "MakeNamedMaterial \"%\"\r\n" this.name to:str
		
		luxWriteString "type" "null" str
		
		return str as string
	)
	
	parameters main rollout:params
	(
	)
	
	rollout params "There are not any Parameters in Null Material"
	(
		on params open do
		(
			mental_ray_Preferences.mrExtensionsActive = false
		)
	)
	
	include "luxmax\\mtl_common.ms"
)