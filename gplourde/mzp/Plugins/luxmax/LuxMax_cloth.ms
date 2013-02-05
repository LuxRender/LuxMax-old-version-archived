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

plugin material LuxCloth name:"LR Cloth" classID:#(0x417d7152, 0x1fb43645) extends:Standard replaceUI:true version:2
(
	include "luxmax\\fn_common.ms"
	include "luxmax\\mtl_logo.ms"
	 
	--you can also spec map it by doing "texture warp_ks" and such, although remember 
	--the shader includes a "weave spec map" already, 
	--so you'd only need that if you were doing stained or dirty cloth or such
	
	function GetTextureMaps =
	(
		texturemaps = #(this.param_texture_weft_Kd, this.param_texture_weft_Ks, this.param_texture_warp_Kd, this.param_texture_warp_Ks)
		
		if (this.param_texture_weft_Kd != undefined) then
		(
			append texturemaps this.param_texture_weft_Kd
		)
		
		if (this.param_texture_weft_Ks != undefined) then
		(
			append texturemaps this.param_texture_weft_Ks
		)
		
		if (this.param_texture_warp_Ks != undefined) then
		(
			append texturemaps this.param_texture_warp_Ks
		)
		
		if (this.param_texture_warp_Kd != undefined) then
		(
			append texturemaps this.param_texture_warp_Kd
		)
		
		return texturemaps
	)
	
	
	function GetLuxRenderString =
	(
		
		str = stringstream ""
		format "MakeNamedMaterial \"%\"\n" this.name to:str
		luxWriteString "type" "cloth" str
		--luxWriteFloat "p1"  this.p1 str
		--luxWriteColor "Kd"  this.kdColor str
		
		if (this.preset_int == 1)do
		(
			luxWriteString "presetname" "denim" str
		)
		
		if (this.preset_int == 2)do
		(
			luxWriteString "presetname" "silk_charmeuse" str
		)
		
		if (this.preset_int == 3)do
		(
			luxWriteString "presetname" "cotton_twill" str
		)
		
		if (this.preset_int == 4)do
		(
			luxWriteString "presetname" "wool_garbardine" str
		)
		
		if (this.preset_int == 5)do
		(
			luxWriteString "presetname" "polyester_lining_cloth" str
		)
		
		if (this.preset_int == 6)do
		(
			luxWriteString "presetname" "silk_shantung" str
		)
		
		if(this.param_texture_warp_Kd != undefined)then
		(
			format "\t\"texture warp_Kd\" [\"%\"]\n" this.param_texture_warp_Kd.name to:str
		)else
		(
			luxWriteColor "warp_Kd" this.color_warp_Kd str
		)
		
		if (this.param_texture_warp_Ks != undefined)then
		(
			format "\t\"texture warp_Ks\" [\"%\"]\n" this.param_texture_warp_Ks.name to:str
		)else
		(
			luxWriteColor "warp_Ks" this.color_warp_Ks str
		)
		
		if (this.param_texture_weft_Kd != undefined)then
		(
			format "\t\"texture weft_Kd\" [\"%\"]\n" this.param_texture_weft_Kd.name to:str
		)else
		(		
			luxWriteColor "weft_Kd" this.color_weft_Kd str
		)		
		
		if (this.param_texture_weft_Ks !=undefined)then
		(
			format "\t\"texture weft_Ks\" [\"%\"]\n" this.param_texture_weft_Ks.name to:str
		)else
		(
			luxWriteColor "weft_Ks" this.color_weft_Ks str
		)
		
		luxWriteFloat "repeat_u"  this.repeat_u str
		luxWriteFloat "repeat_v"  this.repeat_v str
		return str as string
	)
	
	
	parameters pblock1 rollout:params
	(
		color_warp_Kd type:#color animatable:true ui:colorpickerpicker_warp_Kd
		color_warp_Ks type:#color animatable:true ui:colorpickerpicker_warp_Ks
		color_weft_Kd type:#color animatable:true ui:colorpickerpicker_weft_Kd
		color_weft_Ks type:#color animatable:true ui:colorpickerpicker_weft_Ks
		
		texture_warp_Kd type:#textureMap --ui:
		texture_warp_Ks type:#textureMap --ui:mkdTexture
		texture_weft_Kd type:#textureMap --ui:mkdTexture
		texture_weft_Ks type:#textureMap --ui:mkdTexture
		
		repeat_u type:#float default:1 animatable:true ui:spn_repeat_u
		repeat_v type:#float default:1 animatable:true ui:spn_repeat_v
		
		preset_int type:#integer default:1
		
		param_texture_weft_Kd type:#textureMap ui:texture_weft_Kd
		param_texture_weft_Ks type:#textureMap ui:texture_weft_Ks
		param_texture_warp_Kd type:#textureMap ui:texture_warp_Kd
		param_texture_warp_Ks type:#textureMap ui:texture_warp_Ks

	)
	rollout params "Cloth Parameters" width:162 height:72
	(
		dropdownList ddl_preset "Cloth Preset" pos:[13,7] width:136 height:40 items:#("denim", "silk_charmeuse", "cotton_twill", "wool_garbardine", "polyester_lining_cloth", "silk_shantung")
		label ltexture "Set image map types to 'color'." align:#left across:1
		label ltexture2 " " align:#left across:1
		
		label lbl_warp_Kd "Warp diffuse" align:#left across:2
 		mapButton texture_warp_Kd ""  width:160 height:16 across:1 align:#left
		
		label lbl_warp_Ks "Warp specular" align:#left across:2
 		mapButton texture_warp_Ks ""  width:160 height:16 across:1 align:#left
		
		label lbl_weft_Kd "Weft diffuse" align:#left across:2
 		mapButton texture_weft_Kd ""  width:160 height:16 across:1 align:#left
		
		label lbl_weft_Ks "Weft specular" align:#left across:2
 		mapButton texture_weft_Ks ""  width:160 height:16 across:1 align:#left
		
		colorpicker colorpickerpicker_warp_Kd "Warp Diffuse" align:#left width:120 height:16 across:2
		colorpicker colorpickerpicker_weft_Kd "Weft Diffuse" align:#left width:120 height:16 across:2
		colorpicker colorpickerpicker_warp_Ks "Warp Specular" align:#left width:120 height:16 across:2
		colorpicker colorpickerpicker_weft_Ks "Weft Specular" align:#left width:120 height:16 across:2
		
		spinner spn_repeat_u "repeat u" scale:0.001 range:[-1000,1000,1] width:50 align:#left fieldwidth:65 across:2
		spinner spn_repeat_v "repeat v" scale:0.001 range:[-1000,1000,1] width:50 align:#left fieldwidth:65 across:2
		
		on params open do
		(
			ddl_preset.selection = preset_int
		)
		on ddl_preset selected sel do
		(
			this.preset_int = sel
			
			if (preset_int == 1)do
			(
				print "setting Denim preset"
				color_warp_Kd = [(0.0076877 * 255), (0.0096096 * 255) ,(0.014735 * 255)]
				color_warp_Ks = [(0.0076877 * 255), (0.0096096 * 255), (0.014735 * 255)]
				color_weft_Kd = [(0.13774 * 255) ,(0.13133 * 255) ,(0.16336 * 255)]
				color_weft_Ks = [(0.35359 * 255), (0.35359 * 255), (0.35359 * 255)]
				
				repeat_u = 117.0
				repeat_v = 58.5
			)
			if (preset_int == 2)do
			(
				print "setting silk charmeuse preset"
				color_warp_Kd = [(0.065344 * 255), (0.00076876 * 255) ,(0.00051252 * 255)]
				color_warp_Ks = [(0.27408 * 255), (0.048368 * 255), (0.040844 * 255)]
				color_weft_Kd = [(0.065344 * 255) ,(0.00076876 * 255) ,(0.00051252 * 255)]
				color_weft_Ks = [(0.27085 * 255), (0.047292 * 255), (0.040844 * 255)]
				
				repeat_u = 200.0
				repeat_v = 100.5
			)
			
			if (preset_int == 3)do
			(
				print "setting cotton_twill preset"
				color_warp_Kd = [(0.069492 * 255), (0.045238 * 255) ,(0.053414 * 255)]
				color_warp_Ks = [(0.076142 * 255), (0.076142 * 255), (0.076142 * 255)]
				color_weft_Kd = [(0.069492 * 255) ,(0.045238 * 255) ,(0.053414 * 255)]
				color_weft_Ks = [(0.076142 * 255), (0.076142 * 255), (0.076142 * 255)]
				
				repeat_u = 125.0
				repeat_v = 62.5
			)
			
			if (preset_int == 4)do
			(
				print "setting wool_garbardine preset"
				color_warp_Kd = [(0.29531 * 255), (0.045165 * 255), (0.019687 * 255)]
				color_warp_Ks = [(0.33414 * 255), (0.11662 * 255), (0.089103 * 255)]
				color_weft_Kd = [(0.29531 * 255), (0.045165 * 255), (0.019687 * 255)]
				color_weft_Ks = [(0.33414 * 255), (0.11662 * 255), (0.089103 * 255)]
				
				repeat_u = 100.8
				repeat_v = 67.2
			)
			if (preset_int == 5)do
			(
				print "setting polyester_lining_cloth preset"
				color_warp_Kd = [(0.24033* 255), (0.034872* 255), (0.017907* 255)]
				color_warp_Ks = [(0.10686* 255), (0.056992* 255), (0.052382* 255)]
				color_weft_Kd = [(0.24033* 255), (0.034872* 255), (0.017907* 255)]
				color_weft_Ks = [(0.10686* 255), (0.056992* 255), (0.052382* 255)]
				
				repeat_u = 255
				repeat_v = 255
			)
			if (preset_int == 6)do
			(
				print "setting silk_shantung preset"
				color_warp_Kd = [(0.0096037* 255), (0.003146* 255), (0.0029804* 255)]
				color_warp_Ks = [(0.059085* 255), (0.063159* 255), (0.068253* 255)]
				color_weft_Kd = [(0.042223* 255), (0.0044707* 255), (0.0034772* 255)]
				color_weft_Ks = [(0.25977* 255), (0.088627* 255), (0.080477* 255)]
				
				repeat_u = 224
				repeat_v = 168
			)
			
		)
		
		--on texture_weft_Kd picked texmap do
	--	(
		--	texture_weft_Kd.text=classof texmap as string
	--	)
	)
	include "luxmax\\mtl_common.ms"
)