-- Luxrender Materials plug-ins for 3dsmax
	
--//Matte
		
plugin material LuxrenderMatte name:"LR Matte" classID:#(0x61108483, 0x4d218a72) extends:Standard replaceUI:true version:2
(
	include "luxmax\\fn_common.ms"
	
	function GetTextureMaps =
	(
		texturemaps = #(this.kdTexture, this.sigmaTexture, this.bumpmapTexture, this.emissionTexture)
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

		if this.sigmaTexture != undefined then
			format "\t\"texture sigma\" [\"%\"]\n" this.sigmaTexture.name to:str
		else
			luxWriteFloat "sigma"  this.sigma str
		
		if this.bumpmapTexture != undefined then
			format "\t\"texture bumpmap\" [\"%\"]\n" this.bumpmapTexture.name to:str
		else
			luxWriteFloat "bumpmap"  this.bumpmap str
		
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