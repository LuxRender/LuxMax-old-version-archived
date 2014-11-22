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

plugin modifier lux_deferred name:"LuxMax Deferred loading" classID:#(135525,758481) extends:Bend replaceUI:true version:1
(
	parameters main rollout:params
	(
	)
	rollout params "Luxmax Deferred loading"
	(
		
		label lbl_size "Shape boundingbox:" align:#left
		label lbl_size_spacer "" align:#left
		label lbl_size1 "" align:#left
		label lbl_size2 "" align:#left
		label lbl_size3 "" align:#left
		label lbl_size4 "" align:#left
		label lbl_size5 "" align:#left
		label lbl_size6 "" align:#left

		on params open do
		(
			local BBobj = $
			local bbobjbb = nodeGetBoundingBox BBobj BBobj.transform
			--refresh BB data..
			--nodeGetBoundingBox $ $.transform
			print (nodeGetBoundingBox BBobj BBobj.transform)
			lbl_size1.text = bbobjbb[1][1] as string
			lbl_size2.text = bbobjbb[1][2] as string
			lbl_size3.text = bbobjbb[1][3] as string
			
			lbl_size4.text = bbobjbb[2][1] as string
			lbl_size5.text = bbobjbb[2][2] as string
			lbl_size6.text = bbobjbb[2][3] as string
			
		)
	)
	
	
)