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

plugin material LuxrenderCarpaint name:"LR Carpaint" classID:#(0x164f1487, 0x3d067c86) extends:Standard replaceUI:true version:2
(
	include "luxmax\\fn_common.ms"
	include "luxmax\\mtl_logo.ms"
	
	function GetTextureMaps =
	(
		texturemaps = #(this.kdTexture, this.ks1Texture, this.ks2Texture, this.ks2Texture, this.kaTexture, this.emissionTexture)
		
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
		
		if (this.R1Texture != undefined) then
		(
			floatScale = LuxrenderFloatScale()
			floatScale.name = (this.R1Texture.name + "_scale")
			floatScale.floattex1 = this.R1
			floatScale.maptex2 = this.R1Texture
			append texturemaps floatScale
		)
		
		if (this.R2Texture != undefined) then
		(
			floatScale = LuxrenderFloatScale()
			floatScale.name = (this.R2Texture.name + "_scale")
			floatScale.floattex1 = this.R2
			floatScale.maptex2 = this.R2Texture
			append texturemaps floatScale
		)
		
		if (this.R3Texture != undefined) then
		(
			floatScale = LuxrenderFloatScale()
			floatScale.name = (this.R3Texture.name + "_scale")
			floatScale.floattex1 = this.R3
			floatScale.maptex2 = this.R3Texture
			append texturemaps floatScale
		)
		
		if (this.M1Texture != undefined) then
		(
			floatScale = LuxrenderFloatScale()
			floatScale.name = (this.M1Texture.name + "_scale")
			floatScale.floattex1 = this.M1
			floatScale.maptex2 = this.M1Texture
			append texturemaps floatScale
		)
		
		if (this.M2Texture != undefined) then
		(
			floatScale = LuxrenderFloatScale()
			floatScale.name = (this.M2Texture.name + "_scale")
			floatScale.floattex1 = this.M2
			floatScale.maptex2 = this.M2Texture
			append texturemaps floatScale
		)
		
		if (this.M3Texture != undefined) then
		(
			floatScale = LuxrenderFloatScale()
			floatScale.name = (this.M3Texture.name + "_scale")
			floatScale.floattex1 = this.M3
			floatScale.maptex2 = this.M3Texture
			append texturemaps floatScale
		)

		
		return texturemaps
	)
	
	function GetLuxRenderString =
	(
		str = stringstream ""
		
		format "MakeNamedMaterial \"%\"\n" this.name to:str
		
		if (this.usecarpaintpreset != true) do
		(
		
		if this.kdTexture != undefined then
			format "\t\"texture Kd\" [\"%\"]\n" this.kdTexture.name to:str
		else
			luxWriteColor "Kd"  this.kdColor str

		if this.ks1Texture != undefined then
			format "\t\"texture Ks1\" [\"%\"]\n" this.ks1Texture.name to:str
		else
			luxWriteColor "Ks1"  this.ks1Color str
		
		if this.ks2Texture != undefined then
			format "\t\"texture Ks2\" [\"%\"]\n" this.ks2Texture.name to:str
		else
			luxWriteColor "Ks2"  this.ks2Color str
		
		if this.ks3Texture != undefined then
			format "\t\"texture Ks3\" [\"%\"]\n" this.ks3Texture.name to:str
		else
			luxWriteColor "Ks3"  this.ks3Color str
		
		if this.R1Texture != undefined then
			format "\t\"texture R1\" [\"%\"]\r\n" (this.R1Texture.name + "_scale") to:str
		else
			luxWriteFloat "R1"  this.R1 str
		
		if this.R2Texture != undefined then
			format "\t\"texture R2\" [\"%\"]\r\n" (this.R2Texture.name + "_scale") to:str
		else
			luxWriteFloat "R2"  this.R2 str
				
		if this.R3Texture != undefined then
			format "\t\"texture R3\" [\"%\"]\r\n" (this.R3Texture.name + "_scale") to:str
		else
			luxWriteFloat "R3"  this.R3 str
		
		if this.M1Texture != undefined then
			format "\t\"texture M1\" [\"%\"]\r\n" (this.M1Texture.name + "_scale") to:str
		else
			luxWriteFloat "M1"  this.M1 str
		
		if this.M2Texture != undefined then
			format "\t\"texture M2\" [\"%\"]\r\n" (this.M2Texture.name + "_scale") to:str
		else
			luxWriteFloat "M2"  this.M2 str
				
		if this.M3Texture != undefined then
			format "\t\"texture M3\" [\"%\"]\r\n" (this.M3Texture.name + "_scale") to:str
		else
			luxWriteFloat "M3"  this.M3 str
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
	
		luxWriteString "type" "carpaint" str
		
		if (this.usecarpaintpreset == true) do
		(
		if      (this.preset == 1)do
				(
					luxWriteString "name" "ford f8" str
				)
				if (this.preset == 2)do
				(
					luxWriteString "name" "polaris silber" str
				)				
				if (this.preset == 3)do
				(
					luxWriteString "name" "opel titan" str
				)
				if (this.preset == 4)do
				(
					luxWriteString "name" "bmw339" str
				)
				if (this.preset == 5)do
				(
					luxWriteString "name" "2k acrylack" str
				)
				if (this.preset == 6)do
				(
					luxWriteString "name" "white" str
				)
				if (this.preset == 7)do
				(
					luxWriteString "name" "blue" str
				)
				if (this.preset == 8)do
				(
					luxWriteString "name" "blue matte" str
				)
			)
		return str as string
	)
	
	parameters main rollout:params
	(
		preset type:#integer ui:mname default:1
		kdColor type:#color default:[90,90,90] ui:mkdColor 
		kdTexture type:#textureMap ui:mkdTexture
		ks1Color type:#color ui:mks1Color default:[30,30,30]
		ks1Texture type:#textureMap ui:mks1Texture
		ks2Color type:#color ui:mks2Color default:[30,30,30]
		ks2Texture type:#textureMap ui:mks2Texture
		ks3Color type:#color ui:mks3Color default:[30,30,30]
		ks3Texture type:#textureMap ui:mks3Texture
		R1 type:#float ui:mR1 default:1
		R1Texture type:#textureMap ui:mR1Texture
		R2 type:#float ui:mR2 default:1
		R2Texture type:#textureMap ui:mR2Texture
		R3 type:#float ui:mR3 default:1
		R3Texture type:#textureMap ui:mR3Texture
		M1 type:#float ui:mM1 default:1
		M1Texture type:#textureMap ui:mM1Texture
		M2 type:#float ui:mM2 default:1
		M2Texture type:#textureMap ui:mM2Texture
		M3 type:#float ui:mM3 default:1
		M3Texture type:#textureMap ui:mM3Texture
		usecarpaintpreset type:#boolean ui:musecarpaintpreset
		useabsorption type:#boolean ui:museabsorption
		kaColor type:#color default:[90,90,90] ui:mkaColor 
		kaTexture type:#textureMap ui:mkaTexture
		dfloat type:#float ui:mdfloat 
		on kdColor set val do delegate.diffuse_color = val	
		on ks1Color set val do delegate.Specular_color = val
		on kdTexture set val do delegate.diffusemap = val
	)
	
	rollout params "Carpaint Parameters"
	(
		checkbox musecarpaintpreset "Use Preset:" across:2 align:#right
		--label lbcarpaintselect "Select Preset:" align:#right
		dropdownList mname "" items:#("ford f8", "polaris silber", "opel titan", "bmw339", "2k acrylack", "white", "blue", "blue matte") align:#right
		
		group "Custom Properties"
		(
			
		label lb1 "Diffuse . . . . . . . . ."  align:#left across:3 default:#enabled 
		colorpicker mkdColor "" align:#left width:80 height:16
		mapbutton mkdTexture"None" width:110 height:16 align:#right
		
		label lbspecular1 "Specular1 . . . . . . . . . ." across:3 align:#left
		colorpicker mks1Color "" align:#left width:80 height:16
		mapbutton mks1Texture "None" width:110 height:16 align:#right
		
		label lbspecular2 "Specular2 . . . . . . . . . ." across:3 align:#left
		colorpicker mks2Color "" align:#left width:80 height:16
		mapbutton mks2Texture "None" width:110 height:16 align:#right
		
		label lbspecular3 "Specular3 . . . . . . . . . ." across:3 align:#left
		colorpicker mks3Color "" align:#left width:80 height:16
		mapbutton mks3Texture "None" width:110 height:16 align:#right
		
		label lbR1 "R1 . . . . . . . . . ." across:3 align:#left
		spinner mR1 " "scale:0.001 range:[0.000,1.000,1.000] width:50 align:#left fieldwidth:65
		mapbutton mR1Texture "T" width:110 height:16 align:#right
		
		label lbR2 "R2 . . . . . . . . . ." across:3 align:#left
		spinner mR2 " "scale:0.001 range:[0.000,1.000,1.000] width:50 align:#left fieldwidth:65
		mapbutton mR2Texture "T" width:110 height:16 align:#right
		
		label lbR3 "R3 . . . . . . . . . ." across:3 align:#left
		spinner mR3 " "scale:0.001 range:[0.000,1.000,1.000] width:50 align:#left fieldwidth:65
		mapbutton mR3Texture "T" width:110 height:16 align:#right
		
		label lbM1 "M1 . . . . . . . . . ." across:3 align:#left
		spinner mM1 " "scale:0.001 range:[0.000,1.000,1.000] width:50 align:#left fieldwidth:65
		mapbutton mM1Texture "T" width:110 height:16 align:#right
		
		label lbM2 "M2 . . . . . . . . . ." across:3 align:#left
		spinner mM2 " "scale:0.001 range:[0.000,1.000,1.000] width:50 align:#left fieldwidth:65
		mapbutton mM2Texture "T" width:110 height:16 align:#right
		
		label lbM3 "M3 . . . . . . . . . ." across:3 align:#left
		spinner mM3 " "scale:0.001 range:[0.000,1.000,1.000] width:50 align:#left fieldwidth:65
		mapbutton mM3Texture "T" width:110 height:16 align:#right
		)
		
		checkbox museabsorption "Use Absorption" across:1 align:#left
		
		group "Absorption"
		(
		label lbabsorptioncolor "Absorption Color . . . . . . . ." across:3 align:#left
		colorpicker mkaColor "" align:#left width:80 height:16
		mapbutton mkaTexture"None" width:110 height:16 align:#right
		label labsorptiondepth "Absorption Depth . . . . . . ." across:3 align:#left
		spinner mdfloat "" scale:0.001 range:[0,15,0.15] width:50 align:#left fieldwidth:65
		)
		--on mname selected i do
		--(format "You selected '%'!\n" mname.items[i])
		
		on musecarpaintpreset changed s do
		(
			mname.enabled = s
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
			mental_ray_Preferences.mrExtensionsActive = false
			mname.enabled = musecarpaintpreset.state
			lbabsorptioncolor.enabled = museabsorption.state
			mkacolor.enabled = museabsorption.state
			mkaTexture.enabled = museabsorption.state
			mdfloat.enabled = museabsorption.state
			labsorptiondepth.enabled = museabsorption.state
		)
	)
	
	include "luxmax\\mtl_common.ms"
)