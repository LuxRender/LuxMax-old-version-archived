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

plugin light LuxInfinite name:"LR Infinite" classID:#(0x343993e2, 0x54ccb040) extends:SkyLight replaceUI:true version:1 category:"LuxRender"
(
	include "luxmax\\fn_common.ms"
	
	parameters pblock0 rollout:params0
	(
		gain type:#float ui:spn_gain default:1 animatable:false
		importance type:#float ui:spn_importance default:1
		exterior type:#node ui:mExterior
		lightgroup type:#string ui:edt_group default:"default"
	)
	parameters pblock1 rollout:params1
	(
		mapname type:#textureMap ui:m_texturemap
		maptype type:#integer ui:m_mapping default:1
		color type:#color ui:mcolor default:white
		multiply type:#boolean ui:m_multiply default:false
	)	
	rollout params0 "LuxRender Lamps"
	(
		fn volumeFilter obj = ((classof obj) as string == "LuxRenderVolume")
		
		spinner spn_gain "Gain:" width:136 fieldwidth:55 align:#right
		spinner spn_importance "Importance:" width:136 fieldwidth:55 align:#right
		spinner spn_nsamples "Samples:"width:136 type:#integer fieldwidth:55 align:#right

		group "Common"
		(
			label lbl_group "Light Group:" align:#left
			edittext edt_group "" align:#right width:138 text:"default"
			label lbexterior "Exterior:" align:#left
			pickbutton mExterior "none" width:138 height:20 align:#right autoDisplay:true filter:volumeFilter
		)
		
		on mExterior rightclick do
		(
			mExterior.text = "none"
			exterior = undefined
		)
	)
	
	rollout params1 "LuxRender Infinite"
	(
		colorpicker mcolor "Color:" height:18 width:98 align:#right
		
		group "HDRI Map"
		(
			mapbutton m_texturemap "none" height:20 width:135 align:#right
			dropdownlist m_mapping "Map Type:" items:#("Lat Long", "Angular", "Vert Cross")
			checkbox m_multiply "Multiply by color"
		)

		on m_texturemap rightclick do
		(
			m_texturemap.text = "none"
			mapname = undefined
		)
		
		on params create do
		(
			m_filename.text = mapname
		)
	)
)