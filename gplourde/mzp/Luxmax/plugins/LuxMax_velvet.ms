plugin material LuxRenderVelvet name:"LR Velvet" classID:#(0x117d5192, 0x3fb83645) extends:Standard replaceUI:true version:2

(
	include "luxmax\\fn_common.ms"
	include "luxmax\\mtl_logo.ms"
	
	function GetTextureMaps =
	(
		texturemaps = #(this.kdTexture, thisp1Texture, this.p2Texture, this.p3Texture, this.thicknessTexture, this.bumpmapTexture, this.emissionTexture)
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
			format "\t\"texture p1\" [\"%\"]\n" this.p1Texture.name to:str
			)	
		    else
			(	
			luxWriteFloat "p1"  this.p1 str
			)
		if this.p2Texture != undefined then
			(	
			format "\t\"texture p2\" [\"%\"]\n" this.p2Texture.name to:str
			)	
		    else
			(	
			luxWriteFloat "p2"  this.p2 str
			)
		if this.p3Texture != undefined then
			(	
			format "\t\"texture p3\" [\"%\"]\n" this.p3Texture.name to:str
			)	
		    else
			(	
			luxWriteFloat "p3"  this.p1 str
			)
		if this.thicknessTexture != undefined then
			(	
			format "\t\"texture thickness\" [\"%\"]\n" this.thicknessTexture.name to:str
			)	
		    else
			(	
			luxWriteFloat "thickness"  this.thickness str
			)
			
		)
		
		if this.usebumpmap == true then
		(	
		if this.bumpmapTexture != undefined then
			format "\t\"texture bumpmap\" [\"%\"]\n" this.bumpmapTexture.name to:str
		else
			luxWriteFloat "bumpmap"  this.bumpmap str
		)
		
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