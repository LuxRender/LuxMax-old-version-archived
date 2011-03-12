plugin material LuxMatteTrans name:"LR MatteTranslucent" classID:#(0x40755a6a, 0x4f0109c6) extends:Standard replaceUI:true version:2

(
	include "luxmax\\fn_common.ms"
	include "luxmax\\mtl_logo.ms"
	
	function GetTextureMaps =
	(
		texturemaps = #(this.krTexture, thisktTexture, this.sigmaTexture, this.bumpmapTexture, this.emissionTexture)
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

		if this.sigmaTexture != undefined then
			format "\t\"texture sigma\" [\"%\"]\n" this.sigmaTexture.name to:str
		else
			luxWriteFloat "sigma"  this.sigma str
		
		if this.usebumpmap == true then
		(	
		if this.bumpmapTexture != undefined then
			format "\t\"texture bumpmap\" [\"%\"]\n" this.bumpmapTexture.name to:str
		else
			luxWriteFloat "bumpmap"  this.bumpmap str
		)
		
		luxWriteString "type" "mattetranslucent" str
		
		return str as string
	)
	
	parameters main rollout:params
	(
		krColor type:#color default:[90,90,90] ui:mkrColor 
		krTexture type:#textureMap ui:mkrTexture
		ktColor type:#color default:[90,90,90] ui:mktColor 
		ktTexture type:#textureMap ui:mktTexture
		sigma type:#float ui:msigma default:0
		sigmaTexture type:#textureMap ui:msigmaTexture
	)
	
	rollout params "Matte Parameters"
	(
		label lbreflection"Reflection . . . . . . . . ."  align:#left across:3
		colorpicker mkrColor "" align:#left width:80 height:16
		mapbutton mkrTexture"None" width:110 height:16 align:#right

		label lbtransmission "Transmission . . . . . . . . ."  align:#left across:3
		colorpicker mktColor "" align:#left width:80 height:16
		mapbutton mktTexture"None" width:110 height:16 align:#right
		
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