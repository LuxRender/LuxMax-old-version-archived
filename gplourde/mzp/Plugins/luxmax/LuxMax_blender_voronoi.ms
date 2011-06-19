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

plugin TextureMap LuxrenderBlenderVoronoi name:"LR Blender Voronoi" classID:#(0x591413be, 0x184011e6) extends:Bitmaptexture replaceUI:true version:1
(
	include "luxmax\\fn_common.ms"
	
	function GetTextureMaps = 
	(
		texturemaps = #(this.tex1, this.tex2)
		return texturemaps
	)
	
	function GetLuxRenderString =
	(
		str = stringstream ""
		
		format "Texture \"%:amount\" \"float\" \"blender_voronoi\"\n" this.name to:str
		
		distmetric = #("actual_distance", "minkovsky", "minkovsky_four", "minkovsky_half", "chebychev", "manhattan", "distance_squared")
		luxWriteString "distmetric" distmetric[this.distmetric] str
		
		luxWriteFloat "minkovsky_exp" this.minkovsky_exp str
		luxWriteFloat "outscale" this.outscale str
		luxWriteFloat "noisesize" this.noisesize str
		luxWriteFloat "nabla" this.nabla str
		
		luxWriteFloat "w1" this.w1 str
		luxWriteFloat "w2" this.w2 str
		luxWriteFloat "w3" this.w3 str
		luxWriteFloat "w4" this.w4 str
		
		
		luxWriteFloat "bright" this.bright str
		luxWriteFloat "contrast" this.contrast str
		
		
		format "\t\"vector scale\" [% % %]\n" this.xs this.ys this.zs to:str
		format "\t\"vector rotate\" [% % %]\n" this.xr this.yr this.zr to:str
		format "\t\"vector translate\" [% % %]\n" this.xt this.yt this.zt to:str
		
		
		coordinates = #("local", "global", "local_normal", "global_normal", "uv")
		luxWriteString "coordinates" coordinates[this.coordinates] str
		
		format "Texture \"%\"" this.name to:str
		
		
		if this.type == 1 then
				(format "\t\"float\"" to:str)
			else
				(format "\t\"color\"" to:str)
		
		format "\t\"mix\"" to:str
		format "\t\"texture amount\" [\"%:amount\"]" this.name to:str
		
				
		if this.Tex1 != undefined then
				format "\t\"texture tex1\" [\"%\"]\n" this.Tex1.name to:str
			else
				luxWriteColor "tex1"  this.Color1 str
			
		if this.Tex2 != undefined then
				format "\t\"texture tex2\" [\"%\"]\n" this.Tex2.name to:str
			else
				luxWriteColor "tex2"  this.Color2 str
		
		

		return str as string
	)
	
	parameters main rollout:params
	(
		Color1 type:#color ui:mColor1 default:[255,255,255]
		Tex1 type:#textureMap ui: mTex1
		Color2 type:#color ui:mColor2 default:[0,0,0]
		Tex2 type:#textureMap ui: mTex2
		
		distmetric type:#integer default:1 ui:mdistmetric 
		
		minkovsky_exp type:#float ui:mminkovsky_exp default:2.5
		outscale type:#float ui:moutscale default:1
		noisesize type:#float ui:mnoisesize default:0.025
		nabla type:#float ui:mnabla default:0.025
		
		w1 type:#float ui:mw1 default:1
		w2 type:#float ui:mw2 default:0
		w3 type:#float ui:mw3 default:0
		w4 type:#float ui:mw4 default:0
		
		bright type:#float ui:mbright default:1
		contrast type:#float ui:mcontrast default:1
		
		
	)
		
	rollout params "Blender Voronoi"
	(
		group "Colors or Textures"
		(
		label lb1 "Color1 . . . . . . . . ."  align:#left across:3 default:#enabled 
		colorpicker mColor1 "" align:#left width:80 height:16
		mapbutton mTex1 "Tex1" width:110 height:16 align:#right
		label lb2 "Color2 . . . . . . . . ."  align:#left across:3 default:#enabled 
		colorpicker mColor2 "" align:#left width:80 height:16
		mapbutton mTex2 "Tex2" width:110 height:16 align:#right
		)
		dropdownlist mdistmetric "Distance Metric" items:#("actual_distance", "minkovsky", "minkovsky_four", "minkovsky_half", "2k acrylack", "chebychev", "manhattan", "distance_squared") align:#center across:1
		group "General Parameters"
		(
		spinner mminkovsky_exp "minkovsky exp:" type:#float range:[0.001,10,2.5] fieldwidth:65 across:2 align:#left
		spinner moutscale "outscale:" type:#float range:[0.01,10,1] fieldwidth:65 align:#right
		spinner mnoisesize "noise size:" type:#float range:[0,2,0.025] fieldwidth:65 across:2 align:#left
		spinner mnabla "nabla:" type:#float range:[0.001,0.1,0.025] fieldwidth:65 align:#right
		)
		group "Weight Parameters"
		(
		spinner mw1 "w1:" type:#float range:[-2,2,1] fieldwidth:65 across:2 align:#left
		spinner mw2 "w2:" type:#float range:[-2,2,0] fieldwidth:65 align:#right
		spinner mw3 "w3:" type:#float range:[-2,2,0] fieldwidth:65 across:2 align:#left
		spinner mw4 "w4:" type:#float range:[-2,2,0] fieldwidth:65 align:#right
		)
		group "Level"
		(
		spinner mbright "bright:" type:#float range:[-2,2,1] fieldwidth:65 across:2 align:#left
		spinner mcontrast "contrast:" type:#float range:[-2,2,0] fieldwidth:65 align:#right
		)
		
		
	)
	

	include "luxmax\\texture_common.ms"
)
