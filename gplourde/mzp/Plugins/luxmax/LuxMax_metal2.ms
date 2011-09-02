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

plugin material LuxrenderMetal2 name:"LR Metal2" classID:#(0x22c677f3, 0x3ae402d6) extends:Standard replaceUI:true version:2
(
	include "luxmax\\fn_common.ms"
	include "luxmax\\mtl_logo.ms"
	
	function GetTextureMaps =
	(
		texturemaps = #(this.emissionTexture, this.fresnelcolorTexture)
		
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
		
		luxWriteString "type" "metal2" str
		
		if this.fresnelcolorTexture != undefined then 
		format "\t\"texture fresnel\" [\"%\"]\r\n" this.fresnelcolorTexture.name to:str
		
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
		
		if (this.bumpmapTexture != undefined and this.useBumpmap == true)then
			format "\t\"texture bumpmap\" [\"%\"]\r\n" (this.bumpmapTexture.name + "_scale") to:str
		
		
		
		return str as string
	)
	
	parameters main rollout:params
	(
		fresnelcolorTexture type:#textureMap ui:mfresnelcolorTexture
		useanisotropy type:#boolean ui:museanisotropy
		roughness type:#float ui:mroughness default:0.0001
		roughnessTexture type:#textureMap ui:mroughnessTexture
		uroughness type:#float ui:muroughness default:0.0001
		uroughnessTexture type:#textureMap ui:muroughnessTexture
		vroughness type:#float ui:mvroughness default:0.0001
		vroughnessTexture type:#textureMap ui:mvroughnessTexture

		on roughness set val do 
		(
			if val < 0.1 then
			delegate.Specular_Level =  100
			if val >= 0.1 then
			delegate.Specular_Level =  10 / val
		)		
	)
	
	rollout params "Metal Parameters"
	(
		
		label lbfresnel "Choose Fresnel Texture" across:2 align:#left
		mapbutton mfresnelcolorTexture "None" width:110 height:16 align:#right
		
		label lbroughness "Roughness. . . . . . ." across:3 align:#left
		spinner mroughness " " range:[0.0001,1,0.1] width:50 align:#left fieldwidth:65 enabled:true scale:0.0001
		mapbutton mroughnessTexture "None" width:110 height:16 align:#right
		
		checkbox museanisotropy "Use Anisotropic Roughness" across:1 align:#left
		
		label lbu "u-roughness . . . . . . . " across:3 align:#left
		spinner muroughness " "  range:[0.0001,1,0.1] width:50 align:#left fieldwidth:65 scale:0.0001
		mapbutton muroughnessTexture "None" width:110 height:16 align:#right
		label lbv "v-roughness . . . . . . . " across:3 align:#left
		spinner mvroughness " " range:[0.0001,1,0.1]  width:50 align:#left fieldwidth:65 scale:0.0001
		mapbutton mvroughnessTexture "None" width:110 height:16 align:#right
		
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
			mental_ray_Preferences.mrExtensionsActive = false
			lbu.enabled = museanisotropy.state
			lbv.enabled = museanisotropy.state
			muroughness.enabled = museanisotropy.state
			muroughnessTexture.enabled = museanisotropy.state
			mvroughness.enabled = museanisotropy.state
			mvroughnessTexture.enabled = museanisotropy.state
			delegate.glossiness =  30
		)
	)
	
	include "luxmax\\mtl_common.ms"
)