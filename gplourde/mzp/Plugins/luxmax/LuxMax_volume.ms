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

plugin Helper LuxRenderVolume
name:"LR Volume"
classID:#(0x66dad084, 0x48d0bfa0)
category:"LuxRender"
extends:dummy
(

	local meshObj

	parameters pblock rollout:params
	(
		type type:#integer default:1 ui:mtype
		ior type:#float ui:mior default:1.00293
		absorption type:#color ui:mabsorption default:white
		absdepth type:#float ui:mdepth  default:1
		absscale type:#float ui:mscale default:1
		
		scattering type:#color ui:mscattering default:black
		scatteringscale type:#float ui:mscatteringscale default:1.0
		sasymmetryR type:#float ui:masymmetryR default:0
		sasymmetryG type:#float ui:masymmetryG default:0
		sasymmetryB type:#float ui:masymmetryB default:0

	)
		
	rollout params "Volume Parameters"
	(
		dropdownlist mtype "Type:" items:#("clear", "homogeneous")
		spinner mior "ior:" range:[0.0, 25, 1.00293] scale:0.01 fieldwidth:50 align:#right
		colorpicker mabsorption "Absoption:" color:white height:16 width:115 align:#right
		spinner mdepth "Abs. at depth:" type:#worldunits range:[0.00001, 9999999, 1] align:#right fieldwidth:50 
		spinner mscale "Abs. scale:" range:[0.00001, 9999999, 1] align:#right fieldwidth:50
		
		colorpicker mscattering "Scattering:" color:black height:16 width:115 align:#right
		spinner mscatteringscale "Scattering scale:" range:[0.00000, 9999999, 1] align:#right fieldwidth:50
		
		spinner masymmetryR "Asymmetry R:" range:[-1, 1, 0] align:#right fieldwidth:50
		spinner masymmetryG "Asymmetry G:" range:[-1, 1, 0] align:#right fieldwidth:50
		spinner masymmetryB "Asymmetry B:" range:[-1, 1, 0] align:#right fieldwidth:50
		
		function EnableScatter val =
		(
			mscattering.visible = val
			mscatteringscale.visible = val
			masymmetryR.visible = val
			masymmetryG.visible = val
			masymmetryB.visible = val
		)
		
		on params open do
		(
			if (type == 1) then
			(
				EnableScatter false
			)
			else
			(
				EnableScatter true
			)
		)
		
		on mtype selected val do
		(
			if (val == 1) then
			(
				EnableScatter false
			)
			else
			(
				EnableScatter true
			)
		)
	)
	
	on getDisplayMesh do
	(
		if (meshObj == undefined) do
		(
			meshObj = createInstance box length:20 width:20 height:20 mapCoords:false
		)

		meshObj.mesh
	)
	
	tool create
	(
		on mousePoint click do
		(
			nodeTM.translation = gridPoint;#stop
		)
	)
)