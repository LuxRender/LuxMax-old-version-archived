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

Plugin material LuxRenderGlass2 name:"LR Glass2" classID:#(0x1a82153d,0x7175d56)extends:standard replaceUI:true version:2
(
	include "luxmax\\fn_common.ms"
	include "luxmax\\mtl_logo.ms"
	
	function GetTextureMaps =
	(
		texturemaps = #()
		return texturemaps
	)
	
	function GetLuxRenderString =
	(
		str = stringstream ""
		format "#BEGIN Glass2 Material: %\n" this.name to:str
		format "MakeNamedMaterial \"%\"\n" this.name to:str
		luxWriteBool "architectural" this.isarchitectural str
		luxWriteBool "dispersion" this.isdispersion str
		luxWriteString "type" "glass2" str
		format "#END Glass2 Material: %\n" this.name to:str
		return str as string
	)
	
	parameters main rollout:paramsEm
	(
		isarchitectural type:#boolean ui:marchitectural
		isdispersion type:#boolean ui:mdispersion
	)
	
	rollout paramsEm "settings"
	(
		checkbox marchitectural "Architectural"
		checkbox mdispersion "Dispersion"
	
	
	on paramsEm open do
	(
		delegate.opacity = 50
	)
	)
	include "luxmax\\mtl_common.ms"
)