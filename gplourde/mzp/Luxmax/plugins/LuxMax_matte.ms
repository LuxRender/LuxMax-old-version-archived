-- Luxrender Materials plug-ins for 3dsmax
	
--//Matte
		
plugin material LuxrenderMatte name:"LR Matte" classID:#(0x61108483, 0x4d218a72) extends:Standard replaceUI:true version:2
(
	include "luxmax\\fn_common.ms"
	include "luxmax\\mtl_logo.ms"
	
	function GetTextureMaps =
	(
		texturemaps = #(this.kdTexture, this.sigmaTexture, this.emissionTexture)
		
		--// Bumpmap support
		if (this.bumpmapTexture != undefined and this.useBumpmap == true) then
		(
			floatScale = LuxrenderFloatScale()
			floatScale.name = (this.bumpmapTexture.name + "_scale")
			floatScale.floattex1 = this.bumpmap
			floatScale.maptex2 = this.bumpmapTexture
			append texturemaps floatScale
		)
		
		if (this.sigmaTexture != undefined) then
		(
			floatScale = LuxrenderFloatScale()
			floatScale.name = (this.sigmaTexture.name + "_scale")
			floatScale.floattex1 = this.sigma
			floatScale.maptex2 = this.sigmaTexture
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