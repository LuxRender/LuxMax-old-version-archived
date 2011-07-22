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

plugin light luxPortal name:"LR Portal" classID:#(0x2120176, 0x5d21b0d2) extends:mr_Sky_Portal replaceUI:true version:1 category:"LuxRender"
(
	parameters pblock0 rollout:params0
	(

	)
	
	rollout params0 "Parameters"
	(
		spinner mwidth "Width:" type:#worldunits range:[0,99999999,100]
		spinner mlength "Length:" type:#worldunits range:[0,99999999,100]
		
		on mwidth changed val do delegate.light_width = val
		on mlength changed val do delegate.light_length = val
			
		on params0 open do
		(
			mwidth.value = delegate.light_width
			mlength.value = delegate.light_length
		)
	)
	tool create
	(
		on mousePoint click do
		case click of
		(
			1: coordsys grid (nodeTM.translation = gridPoint)
		)
		on mouseMove click do
		(
			case click of
			(
				2: (
					delegate.width = abs(gridDist.x * 2)
					delegate.length = abs(gridDist.y * 2)
					params0.mwidth.value = abs(gridDist.x * 2)
					params0.mlength.value  = abs(gridDist.y * 2)
					)
				3: (#stop)
			)
		)
	)
)