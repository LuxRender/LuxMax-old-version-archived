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

plugin material LuxrenderGlossy name:"LR Glossy" classID:#(0x6eee3747, 0x278b3ac2) extends:Standard replaceUI:true version:2
(
	include "luxmax\\fn_common.ms"
	include "luxmax\\mtl_logo.ms"
	
	function GetTextureMaps =
	(
		texturemaps = #(this.kdTexture, this.ksTexture, this.kaTexture, this.emissionTexture)
		
		if (this.bumpmapTexture != undefined and this.useBumpmap == true) then
		(
			floatScale = (luxCreateScaleFloatMap this.bumpmapTexture this.bumpmap)
			append texturemaps floatScale
		)
		
		if (this.displacementTexture != undefined and this.useDisplacement == true) then
		(
			floatScale = (luxCreateScaleFloatMap this.displacementTexture this.displacement)
			append texturemaps floatScale
		)
				
		if (this.roughnessTexture != undefined and this.useanisotropy != true) then
		(
			floatScale = LuxrenderFloatScale()
			floatScale.name = (this.roughnessTexture.name + "_scale")
			floatScale.floattex1 = this.roughness
			floatScale.maptex2 = this.roughnessTexture
			append texturemaps floatScale
		)
		
		if (this.uroughnessTexture != undefined and this.useanisotropy == true) then
		(
			floatScale = LuxrenderFloatScale()
			floatScale.name = (this.uroughnessTexture.name + "_scale")
			floatScale.floattex1 = this.uroughness
			floatScale.maptex2 = this.uroughnessTexture
			append texturemaps floatScale
		)
		
		if (this.vroughnessTexture != undefined and this.useanisotropy == true) then
		(
			floatScale = LuxrenderFloatScale()
			floatScale.name = (this.vroughnessTexture.name + "_scale")
			floatScale.floattex1 = this.vroughness
			floatScale.maptex2 = this.vroughnessTexture
			append texturemaps floatScale
		)
		
		return texturemaps
	)
	
	function GetLuxRenderString =
	(
		str = stringstream ""
		
		format "MakeNamedMaterial \"%\"\n" this.name to:str
		
		if this.kdTexture != undefined then
			format "\t\"texture Kd\" [\"%\"]\n" this.kdTexture.name to:str
		else
			luxWriteColor "Kd"  this.kdColor str

		if this.ksTexture != undefined then
			format "\t\"texture Ks\" [\"%\"]\n" this.ksTexture.name to:str
		else
		(
			if this.usespecularior == true then
			(
			luxWriteFloat "index"	this.floatindex str
			format "\t\"color Ks\"  [1.0 1.0 1.0]\n" to:str
			)
			else
			luxWriteColor "Ks"  this.ksColor str
		)
		
		if this.useanisotropy == true then
		(
			if this.uroughnessTexture != undefined then
			format "\t\"texture uroughness\" [\"%\"]\n" (this.uroughnessTexture.name + "_scale") to:str
			else
			luxWriteFloat "uroughness"  this.uroughness str
		
			if this.vroughnessTexture != undefined then
			format "\t\"texture vroughness\" [\"%\"]\n" (this.vroughnessTexture.name + "_scale") to:str
			else
			luxWriteFloat "vroughness"  this.vroughness str
			
		)
		else
		(
			if this.roughnessTexture != undefined then
			(format "\t\"texture uroughness\" [\"%\"]\n" (this.roughnessTexture.name + "_scale") to:str)
			else
			(luxWriteFloat "uroughness"  this.roughness str)
		
			if this.roughnessTexture != undefined then
			(format "\t\"texture vroughness\" [\"%\"]\n" (this.roughnessTexture.name + "_scale") to:str)
			else
			(luxWriteFloat "vroughness"  this.roughness str)
			
		)
		
		if this.useabsorption == true then
		(	
		if this.kaTexture != undefined then
		(
			format "\t\"texture Ka\" [\"%\"]\n" this.kaTexture.name to:str
		)
			else
		(
		luxWriteColor "Ka"  this.kaColor str
		)
		luxWriteFloat "d"  this.dfloat str
		)
		
		if (this.bumpmapTexture != undefined and this.useBumpmap == true)then
			format "\t\"texture bumpmap\" [\"%\"]\r\n" (this.bumpmapTexture.name + "_scale") to:str
		
		luxWriteBool "multibounce" this.usemultibounce str
		luxWriteString "type" "glossy" str
		
		return str as string
	)
	
	parameters main rollout:params
	(
		kdColor type:#color default:[90,90,90] ui:mkdColor 
		kdTexture type:#textureMap ui:mkdTexture
		ksColor type:#color ui:mksColor default:[30,30,30]
		ksTexture type:#textureMap ui:mksTexture
		usespecularior type:#boolean ui:musespecularior
		floatindex type:#float  ui:mfloatindex default:1.000
		roughness type:#float ui:mroughness default:0.0001
		roughnessTexture type:#textureMap ui:mroughnessTexture
		uroughness type:#float ui:muroughness default:0.0001
		uroughnessTexture type:#textureMap ui:muroughnessTexture
		vroughness type:#float ui:mvroughness default:0.0001
		vroughnessTexture type:#textureMap ui:mvroughnessTexture
		useanisotropy type:#boolean ui:museanisotropy
		usemultibounce type:#boolean ui:musemultibounce
		useabsorption type:#boolean ui:museabsorption
		kaColor type:#color default:[90,90,90] ui:mkaColor 
		kaTexture type:#textureMap ui:mkaTexture
		dfloat type:#float ui:mdfloat
        on kdColor set val do delegate.diffuse_color = val	
        on ksColor set val do delegate.Specular_color = val
		on kdTexture set val do delegate.diffusemap = val
			
		on roughness set val do 
		(
			if val < 0.1 then
			delegate.Specular_Level =  100
			if val >= 0.1 then
			delegate.Specular_Level =  10 / val
		)

		
			
		
	)
	
	rollout params "Glossy Parameters"
	(
		label lb1 "Diffuse . . . . . . . . ."  align:#left across:3
		colorpicker mkdColor "" align:#left width:80 height:16
		mapbutton mkdTexture"None" width:110 height:16 align:#right
		
		label lbspecular "Specular . . . . . . . . . ." across:3 align:#left
		colorpicker mksColor "" align:#left width:80 height:16
		mapbutton mksTexture "None" width:110 height:16 align:#right
		
		checkbox musespecularior "Use Ior Specular" across:2 align:#left
		spinner mfloatindex "" scale:0.001 range:[1,6,1.5] width:50 fieldwidth:65 align:#left
		dropdownlist ddl_specularior "Ior presets:" width:200 height:16 across:1 align:#right 
		
		label lbroughness "Roughness. . . . . . ." across:3 align:#left
		spinner mroughness " " scale:0.0001 range:[0.0001,1,0.1] width:50 align:#left fieldwidth:65
		mapbutton mroughnessTexture "None" width:110 height:16 align:#right
		
		checkbox museanisotropy "Use Anisotropic Roughness" across:1 align:#left
		
		label lbu "u-roughness . . . . . . . " across:3 align:#left
		spinner muroughness " " scale:0.0001 range:[0.0001,1,0.1] width:50 align:#left fieldwidth:65
		mapbutton muroughnessTexture "None" width:110 height:16 align:#right
		label lbv "v-roughness . . . . . . . " across:3 align:#left
		spinner mvroughness " " scale:0.0001 range:[0.0001,1,0.1] width:50 align:#left fieldwidth:65
		mapbutton mvroughnessTexture "None" width:110 height:16 align:#right
		
		checkbox musemultibounce "Surface Asperity, use multibounce" across:1 align:#left
		
		checkbox museabsorption "Use Absorption" across:1 align:#left
		label lbabsorptioncolor "Absorption Color . . . . . . . ." across:3 align:#left
		colorpicker mkaColor "" align:#left width:80 height:16
		mapbutton mkaTexture"None" width:110 height:16 align:#right
		label labsorptiondepth "Absorption Depth . . . . . . ." across:3 align:#left
		spinner mdfloat "" scale:0.001 range:[0,15,0.15] width:50 align:#left fieldwidth:65
		
		on musespecularior changed s do
		(
			ddl_specularior.enabled = s
			mfloatindex.enabled = s
		)
	
		on ddl_specularior selected val do
		(
			ior_presets = luxGetIORPresets()
			if ior_presets[val].value == undefined do return false
			mfloatindex.value = ior_presets[val].value
		)
		
		on museanisotropy changed s do
		(	
		    lbu.enabled = s
			lbv.enabled = s
			muroughness.enabled = s
			muroughnessTexture.enabled = s
			mvroughness.enabled = s
			mvroughnessTexture.enabled = s
		)	
		
		on museabsorption changed s do
		(
			labsorptiondepth.enabled = s
			lbabsorptioncolor.enabled = s
			mkacolor.enabled = s
			mkaTexture.enabled = s
			mdfloat.enabled = s
		)	
		
		on params open do
		(
			items = #()
			
			for o in (luxGetIORPresets()) do
			(
				append items o.name
			)
			ddl_specularior.items = items
			ddl_specularior.enabled = musespecularior.state
			mfloatindex.enabled = musespecularior.state
			
			mental_ray_Preferences.mrExtensionsActive = false
			lbabsorptioncolor.enabled = museabsorption.state
			mkacolor.enabled = museabsorption.state
			mkaTexture.enabled = museabsorption.state
			mdfloat.enabled = museabsorption.state
			lbu.enabled = museanisotropy.state
			lbv.enabled = museanisotropy.state
			muroughness.enabled = museanisotropy.state
			muroughnessTexture.enabled = museanisotropy.state
			mvroughness.enabled = museanisotropy.state
			mvroughnessTexture.enabled = museanisotropy.state
			labsorptiondepth.enabled = museabsorption.state
		)
	)
	
	include "luxmax\\mtl_common.ms"
)