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

plugin material LuxrenderRoughGlass name:"LR RoughGlass" classID:#(0x680627ab, 0x374b4cf1)extends:Standard replaceUI:true version:2

(
	include "luxmax\\fn_common.ms"
	include "luxmax\\mtl_logo.ms"
	
	function GetTextureMaps =
	(
		texturemaps = #(this.krTexture, thisktTexture, this.emissionTexture)
		
		if (this.bumpmapTexture != undefined and this.useBumpmap == true) then
		(
			floatScale = LuxrenderFloatScale()
			floatScale.name = (this.bumpmapTexture.name + "_scale")
			floatScale.floattex1 = this.bumpmap
			floatScale.maptex2 = this.bumpmapTexture
			append texturemaps floatScale
		)
		
		if (this.indexTexture != undefined) then
		(
			floatScale = LuxrenderFloatScale()
			floatScale.name = (this.indexTexture.name + "_scale")
			floatScale.floattex1 = this.index
			floatScale.maptex2 = this.indexTexture
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
		
		if this.krTexture != undefined then
			format "\t\"texture Kr\" [\"%\"]\n" this.krTexture.name to:str
		else
			luxWriteColor "Kr"  this.krColor str
		
		if this.ktTexture != undefined then
			format "\t\"texture Kt\" [\"%\"]\n" this.ktTexture.name to:str
		else
			luxWriteColor "Kt"  this.ktColor str
		
		if this.indexTexture != undefined then
			format "\t\"texture index\" [\"%\"]\n" (this.indexTexture.name + "_scale") to:str
		else
			luxWriteFloat "index"  this.index str
		
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

		If this.isdispersion == true then
		(
		luxWriteFloat "cauchyb"  this.cauchyb str
 		)
		
		
		if (this.bumpmapTexture != undefined and this.useBumpmap == true)then
			format "\t\"texture bumpmap\" [\"%\"]\r\n" (this.bumpmapTexture.name + "_scale") to:str
		
		
		luxWriteString "type" "roughglass" str
		
		return str as string
	)
	
	parameters main rollout:params
	(
		krColor type:#color default:[90,90,90] ui:mkrColor 
		krTexture type:#textureMap ui:mkrTexture
		ktColor type:#color default:[90,90,90] ui:mktColor 
		ktTexture type:#textureMap ui:mktTexture
		index type:#float ui:mindex
		indexTexture type:#textureMap ui:mindexTexture
		isdispersion type:#boolean ui:mdispersion
		cauchyb type:#float ui:mcauchyb
		roughness type:#float ui:mroughness default:0.0001
		roughnessTexture type:#textureMap ui:mroughnessTexture
		uroughness type:#float ui:muroughness default:0.0001
		uroughnessTexture type:#textureMap ui:muroughnessTexture
		vroughness type:#float ui:mvroughness default:0.0001
		vroughnessTexture type:#textureMap ui:mvroughnessTexture
		useanisotropy type:#boolean ui:museanisotropy
		on krColor set val do delegate.diffuse_color = val
		on roughness set val do 
		(
			if val < 0.1 then
			delegate.Specular_Level =  100
			if val >= 0.1 then
			delegate.Specular_Level =  10 / val
		)
		
		
		
	)
	
	rollout params "Rough Glass Parameters"
	(
		label lbreflection"Reflection . . . . . . . . ."  align:#left across:3
		colorpicker mkrColor "" align:#left width:80 height:16
		mapbutton mkrTexture"None" width:110 height:16 align:#right

		label lbtransmission "Transmission . . . . . . . . ."  align:#left across:3
		colorpicker mktColor "" align:#left width:80 height:16
		mapbutton mktTexture"None" width:110 height:16 align:#right
		
		label lbindex "IOR. . . . . . . . . . . ." align:#left across:3
		spinner mindex ""scale:0.001 range:[1,6,1.5] width:50 align:#left fieldwidth:65
		mapbutton mindexTexture "" width:110 height:16 align:#right
		dropdownlist ddl_ior "ior presets:" width:200 height:16 align:#right across:1
		
		checkbox mdispersion "Use Dispersion" align:#left across:2
		spinner mcauchyb "cauchy b"scale:0.001 range:[0,1,0.2] width:50 align:#right fieldwidth:65
		
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
		
		on ddl_ior selected val do
		(
			ior_presets = luxGetIORPresets()
			if ior_presets[val].value == undefined do return false
			mindex.value = ior_presets[val].value
		)
		
		on mdispersion changed s do
		(
		mcauchyb.enabled = s
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
		
		
		on params open do
		(
			items = #()
			
			for o in (luxGetIORPresets()) do
			(
				append items o.name
			)
			ddl_ior.items = items
			mental_ray_Preferences.mrExtensionsActive = false
			lbu.enabled = museanisotropy.state
			lbv.enabled = museanisotropy.state
			muroughness.enabled = museanisotropy.state
			muroughnessTexture.enabled = museanisotropy.state
			mvroughness.enabled = museanisotropy.state
			mvroughnessTexture.enabled = museanisotropy.state
			mcauchyb.enabled = mdispersion.state
			delegate.opacity = 80
		)
	)
	
	include "luxmax\\mtl_common.ms"
)