plugin material LuxrenderScatter name:"LR Scatter" classID:#(0x1c417a6f, 0x4b235d82) extends:Standard replaceUI:true version:2
(
	include "luxmax\\fn_common.ms"
	include "luxmax\\mtl_logo.ms"
	
	function GetTextureMaps =
	(
		texturemaps = #(this.kdTexture, this.emissionTexture)
		return texturemaps
	)
	
	function GetLuxRenderString =
	(
		str = stringstream ""
		
		format "MakeNamedMaterial \"%\"\r\n" this.name to:str
		
		luxWriteString "type" "scatter" str
		
		if this.kdTexture != undefined then
			format "\t\"texture Kd\" [\"%\"]\r\n" this.kdTexture.name to:str
		else
			luxWriteColor "Kd"  this.kdColor str

		if this.gTexture != undefined then
			format "\t\"texture g\" [\"%\"]\r\n" (this.gTexture.name + "_scale") to:str
		else
			luxWriteFloat "g"  this.g str

		if (this.bumpmapTexture != undefined and this.useBumpmap == true)then
			format "\t\"texture bumpmap\" [\"%\"]\r\n" (this.bumpmapTexture.name + "_scale") to:str
		
		return str as string
	)
	
	parameters main rollout:params
	(
		kdColor type:#color default:[90,90,90] ui:mkdColor 
		kdTexture type:#textureMap ui:mkdTexture
		g type:#float ui:mg default:0
		gTexture type:#textureMap ui:mgTexture
		on kdColor set val do delegate.diffuse_color = val	
	)
	
	rollout params "Scatter Parameters"
	(
		label lb1 "Diffuse . . . . . . . . ."  align:#left across:3
		colorpicker mkdColor "" align:#left width:80 height:16
		mapbutton mkdTexture"None" width:110 height:16 align:#right
		
		label lbg "Assymetry. . . . . . . . . ." across:3 align:#left
		spinner mg " " range:[-1,1,0] width:50 align:#left fieldwidth:65
		mapbutton mgTexture "T" width:110 height:16 align:#right
		
		on params open do
		(
			mental_ray_Preferences.mrExtensionsActive = false
		)
	)
	
	include "luxmax\\mtl_common.ms"
)