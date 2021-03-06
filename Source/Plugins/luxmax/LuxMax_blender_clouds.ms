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

plugin TextureMap LuxrenderBlenderClouds name:"LR Blender Clouds" classID:#(0x7b42c92, 0x6e5841d3) extends:Bitmaptexture replaceUI:true version:1
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
		
		format "Texture \"%:amount\" \"float\" \"blender_clouds\"\n" this.name to:str
		
		ntype = #("default", "color")
		luxWriteString "type" ntype[this.ntype] str
		
		noisetype = #("soft_noise", "hard_noise")
		luxWriteString "noisetype" noisetype[this.noisetype] str
		
		luxWriteFloat "noisesize" this.noisesize str
		luxwriteInteger "noisedepth" this.noisedepth str
		
		noisebasis = #("blender_original", "original_perlin", "improved_perlin","voronoi_f1" , "voronoi_f2", "voronoi_f3", "voronoi_f4", "voronoi_f2f1", "voronoi_crackle", "cell_noise")
		luxWriteString "noisebasis" noisebasis[this.noisebasis] str
		
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
		
		ntype type:#integer default:1 ui:mntype 
		noisetype type:#integer default:1 ui:mnoisetype 
		
		noisesize type:#float ui:mnoisesize default:0.25
		noisedepth type:#float ui:mnoisedepth default:2
		
		noisebasis type:#integer default:1 ui:mnoisebasis 
		
		bright type:#float ui:mbright default:1
		contrast type:#float ui:mcontrast default:1
		
		
	)
		
	rollout params "Blender Clouds"
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
		group "Noise Parameters"
		(
		dropdownlist mntype "Type" items:#("default", "color") align:#left across:2
		dropdownlist mnoisetype "Noise Type" items:#("soft_noise", "hard_noise") align:#right
		spinner mnoisedepth "Noise depth:" type:#integer range:[0,6,2] fieldwidth:65 across:2 align:#left
		spinner mnoisesize "Noise size:" type:#float range:[0,10,0.25] fieldwidth:65   align:#right
		dropdownlist mnoisebasis "Noise Basis" items:#("blender_original", "original_perlin", "improved_perlin","voronoi_f1" , "voronoi_f2", "voronoi_f3", "voronoi_f4", "voronoi_f2f1", "voronoi_crackle", "cell_noise") align:#right
		)

		group "Level"
		(
		spinner mbright "bright:" type:#float range:[-2,2,1] fieldwidth:65 across:2 align:#left
		spinner mcontrast "contrast:" type:#float range:[-2,2,0] fieldwidth:65 align:#right
		)
		
		
	)
	

	include "luxmax\\texture_common.ms"
)
