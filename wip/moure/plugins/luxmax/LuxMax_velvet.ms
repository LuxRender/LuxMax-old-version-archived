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

plugin material LuxRenderVelvet name:"LR Velvet" classID:#(0x117d5192, 0x3fb83645) extends:Standard replaceUI:true version:2

(
	include "luxmax\\fn_common.ms"
	include "luxmax\\mtl_logo.ms"
	
	function GetTextureMaps =
	(
		texturemaps = #(this.kdTexture, thisp1Texture, this.p2Texture, this.p3Texture, this.thicknessTexture, this.bumpmapTexture, this.emissionTexture)
		
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
		
		if (this.p1Texture != undefined) then
		(
			floatScale = LuxrenderFloatScale()
			floatScale.name = (this.p1Texture.name + "_scale")
			floatScale.floattex1 = this.p1
			floatScale.maptex2 = this.p1Texture
			append texturemaps floatScale
		)
		
		if (this.p2Texture != undefined) then
		(
			floatScale = LuxrenderFloatScale()
			floatScale.name = (this.p2Texture.name + "_scale")
			floatScale.floattex1 = this.p2
			floatScale.maptex2 = this.p2Texture
			append texturemaps floatScale
		)
		
		if (this.p3Texture != undefined) then
		(
			floatScale = LuxrenderFloatScale()
			floatScale.name = (this.p3Texture.name + "_scale")
			floatScale.floattex1 = this.p3
			floatScale.maptex2 = this.p3Texture
			append texturemaps floatScale
		)
		
		if (this.thicknessTexture != undefined) then
		(
			floatScale = LuxrenderFloatScale()
			floatScale.name = (this.thicknessTexture.name + "_scale")
			floatScale.floattex1 = this.thickness
			floatScale.maptex2 = this.thicknessTexture
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
		
		if this.advance == true then
		(	
		if this.p1Texture != undefined then
			(	
			format "\t\"texture p1\" [\"%\"]\n" (this.p1Texture.name + "_scale") to:str
			)	
		    else
			(	
			luxWriteFloat "p1"  this.p1 str
			)
		if this.p2Texture != undefined then
			(	
			format "\t\"texture p2\" [\"%\"]\n" (this.p2Texture.name + "_scale") to:str
			)	
		    else
			(	
			luxWriteFloat "p2"  this.p2 str
			)
		if this.p3Texture != undefined then
			(	
			format "\t\"texture p3\" [\"%\"]\n" (this.p3Texture.name + "_scale") to:str
			)	
		    else
			(	
			luxWriteFloat "p3"  this.p1 str
			)
		if this.thicknessTexture != undefined then
			(	
			format "\t\"texture thickness\" [\"%\"]\n" (this.thicknessTexture.name + "_scale") to:str
			)	
		    else
			(	
			luxWriteFloat "thickness"  this.thickness str
			)
			
		)
		
		if (this.bumpmapTexture != undefined and this.useBumpmap == true)then
			format "\t\"texture bumpmap\" [\"%\"]\r\n" (this.bumpmapTexture.name + "_scale") to:str
		
		luxWriteString "type" "velvet" str
		
		return str as string
	)
	
	parameters main rollout:params
	(
		kdColor type:#color default:[90,90,90] ui:mkdColor 
		kdTexture type:#textureMap ui:mkdTexture
		p1 type:#float ui:mp1 default:-2.00
		p1Texture type:#textureMap ui:mp1Texture
		p2 type:#float ui:mp2 default:20
		p2Texture type:#textureMap ui:mp2Texture
		p3 type:#float ui:mp3 default:2.00
		p3Texture type:#textureMap ui:mp3Texture
		thickness type:#float ui:mthickness
		thicknessTexture type:#textureMap ui:mthicknessTexture
		advance type:#boolean ui:madvance
		on kdColor set val do delegate.diffuse_color = val
	)
	
	rollout params "Velvet Parameters"
	(
	    label lb1 "Diffuse . . . . . . . . ."  align:#left across:3
		colorpicker mkdColor "" align:#left width:80 height:16
		mapbutton mkdTexture"None" width:110 height:16 align:#right
		
		checkbox madvance "Advanced Parameters" align:#left  across:1
		
		label lbp1 "P1" align:#left across:3
		spinner mp1 ""scale:0.01 range:[-100,100,-2.00] width:50 align:#left fieldwidth:65
		mapbutton mp1Texture "" width:110 height:16 align:#right
		
		label lbp2 "P2" align:#left across:3
		spinner mp2 ""scale:0.01 range:[-100,100,20] width:50 align:#left fieldwidth:65
		mapbutton mp2Texture "" width:110 height:16 align:#right
		
		label lbp3 "P3" align:#left across:3
		spinner mp3 ""scale:0.01 range:[-100,100,2] width:50 align:#left fieldwidth:65
		mapbutton mp3Texture "" width:110 height:16 align:#right
		
		label lbthickness "Thickness" align:#left across:3
		spinner mthickness ""scale:0.001 range:[0,1,0.1] width:50 align:#left fieldwidth:65
		mapbutton mthicknessTexture "" width:110 height:16 align:#right
		
		on madvance changed s do
		(
			mp1.enabled = s
			mp2.enabled = s
			mp3.enabled = s
			mthickness.enabled = s
		)			
		
		on params open do
		(
			mental_ray_Preferences.mrExtensionsActive = false
			mp1.enabled = madvance.state
			mp2.enabled = madvance.state
			mp3.enabled = madvance.state
			mthickness.enabled = madvance.state
		)
	)
	
	include "luxmax\\mtl_common.ms"
)