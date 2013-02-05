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
		
plugin material LuxrenderMatte name:"LR Matte" classID:#(0x61108483, 0x4d218a72) extends:Standard replaceUI:true version:2
(
	include "luxmax\\fn_common.ms"
	include "luxmax\\mtl_logo.ms"
	
	function GetTextureMaps =
	(
		texturemaps = #(this.kdTexture, this.emissionTexture)
		
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
		
		if (this.sigmaTexture != undefined) then
		(
			floatScale = (luxCreateScaleFloatMap this.sigmaTexture this.sigma)
			append texturemaps floatScale
		)
		
		return texturemaps
		
	)
	
	function GetLuxRenderString =
	(
		str = stringstream ""
		
		format "MakeNamedMaterial \"%\"\r\n" this.name to:str
		
		if this.kdTexture != undefined then
			format "\t\"texture Kd\" [\"%\"]\r\n" this.kdTexture.name to:str
		else
			luxWriteColor "Kd"  this.kdColor str

		if this.sigmaTexture != undefined then
			format "\t\"texture sigma\" [\"%\"]\r\n" (this.sigmaTexture.name + "_scale") to:str
		else
			luxWriteFloat "sigma"  this.sigma str

		if (this.bumpmapTexture != undefined and this.useBumpmap == true)then
			format "\t\"texture bumpmap\" [\"%\"]\r\n" (this.bumpmapTexture.name + "_scale") to:str
		
		luxWriteString "type" "matte" str
		
		return str as string
	)
	
	parameters main rollout:params
	(
		kdColor type:#color default:[90,90,90] ui:mkdColor 
		kdTexture type:#textureMap ui:mkdTexture
		sigma type:#float ui:msigma default:0
		sigmaTexture type:#textureMap ui:msigmaTexture
		on kdColor set val do delegate.diffuse_color = val
	)
	
	rollout params "Matte Parameters"
	(
		label lb1 "Diffuse . . . . . . . . ."  align:#left across:3
		colorpicker mkdColor "" align:#left width:80 height:16
		mapbutton mkdTexture"None" width:110 height:16 align:#right
		
		
		
		label lbsigma "Sigma . . . . . . . . . ." across:3 align:#left
		spinner msigma " " range:[0,90,0] width:50 align:#left fieldwidth:65
		mapbutton msigmaTexture "T" width:110 height:16 align:#right
		
		on params open do
		(
			mental_ray_Preferences.mrExtensionsActive = false
		)
	)
	
	include "luxmax\\mtl_common.ms"
)