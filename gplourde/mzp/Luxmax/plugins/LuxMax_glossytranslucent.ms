plugin material LuxrenderGlossyTranslucent name:"LR GlossyTranslucent" classID:#(0x3e7c2acd, 0x31d2f97) extends:Standard replaceUI:true version:2

(
	include "luxmax\\fn_common.ms"
	
	function GetTextureMaps =
	(
		texturemaps = #(this.kdTexture, this.ksTexture, this.ktTexture, this.roughnessTexture, this.uroughnessTexture, this.vroughnessTexture, this.kaTexture, this.bumpmapTexture, this.emissionTexture)
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

		if this.ksTexture != undefined then
			format "\t\"texture ks\" [\"%\"]\n" this.ksTexture.name to:str
		else
			luxWriteColor "Ks"  this.ksColor str
		
		if this.ktTexture != undefined then
			format "\t\"texture kt\" [\"%\"]\n" this.ktTexture.name to:str
		else
			luxWriteColor "Kt"  this.ktColor str
		
		
		
		if this.useanisotropy == true then
		(
			if this.uroughnessTexture != undefined then
			format "\t\"texture uroughness\" [\"%\"]\n" this.uroughnessTexture.name to:str
			else
			luxWriteFloat "uroughness"  this.uroughness str
		
			if this.vroughnessTexture != undefined then
			format "\t\"texture vroughness\" [\"%\"]\n" this.vroughnessTexture.name to:str
			else
			luxWriteFloat "vroughness"  this.vroughness str
			
		)
		else
		(
			if this.roughnessTexture != undefined then
			(format "\t\"texture uroughness\" [\"%\"]\n" this.roughnessTexture.name to:str)
			else
			(luxWriteFloat "uroughness"  this.roughness str)
		
			if this.roughnessTexture != undefined then
			(format "\t\"texture vroughness\" [\"%\"]\n" this.roughnessTexture.name to:str)
			else
			(luxWriteFloat "vroughness"  this.roughness str)
			
		)
		
		if this.useabsorption == true then
		(	
		if this.kaTexture != undefined then
		(
			format "\t\"texture ka\" [\"%\"]\n" this.kaTexture.name to:str
		)
			else
		(
		luxWriteColor "Ka"  this.kaColor str
		)
		luxWriteFloat "d"  this.dfloat str
		)
		
		if this.usebumpmap == true then
		(	
		if this.bumpmapTexture != undefined then
			format "\t\"texture bumpmap\" [\"%\"]\n" this.bumpmapTexture.name to:str
		else
			luxWriteFloat "bumpmap"  this.bumpmap str
		)
	
		luxWriteString "type" "glossytranslucent" str
		
		return str as string
	)
	
	parameters main rollout:params
	(
		kdColor type:#color default:[90,90,90] ui:mkdColor 
		kdTexture type:#textureMap ui:mkdTexture
		ksColor type:#color ui:mksColor default:[30,30,30]
		ksTexture type:#textureMap ui:mksTexture
		ktColor type:#color default:[90,90,90] ui:mktColor 
		ktTexture type:#textureMap ui:mktTexture
		roughness type:#float ui:mroughness
		roughnessTexture type:#textureMap ui:mroughnessTexture
		uroughness type:#float ui:muroughness
		uroughnessTexture type:#textureMap ui:muroughnessTexture
		vroughness type:#float ui:mvroughness
		vroughnessTexture type:#textureMap ui:mvroughnessTexture
		useanisotropy type:#boolean ui:museanisotropy
		useabsorption type:#boolean ui:museabsorption
		kaColor type:#color default:[90,90,90] ui:mkaColor 
		kaTexture type:#textureMap ui:mkaTexture
		dfloat type:#float ui:mdfloat 
		
	)
	
	rollout params "Glossy Parameters"
	(
		label lb1 "Diffuse . . . . . . . . ."  align:#left across:3
		colorpicker mkdColor "" align:#left width:80 height:16
		mapbutton mkdTexture"None" width:110 height:16 align:#right
		
		label lbtransmission "Transmission . . . . . . . . ."  align:#left across:3
		colorpicker mktColor "" align:#left width:80 height:16
		mapbutton mktTexture"None" width:110 height:16 align:#right
		
		label lbspecular "Specular . . . . . . . . . ." across:3 align:#left
		colorpicker mksColor "" align:#left width:80 height:16
		mapbutton mksTexture "None" width:110 height:16 align:#right
		
		label lbroughness "Roughness. . . . . . ." across:3 align:#left
		spinner mroughness " " scale:0.001 range:[0.001,1,0.1] width:50 align:#left fieldwidth:65
		mapbutton mroughnessTexture "None" width:110 height:16 align:#right
		
		checkbox museanisotropy "Use Anisotropic Roughness" across:1 align:#left
		
		label lbu "u-roughness . . . . . . . " across:3 align:#left
		spinner muroughness " " scale:0.001 range:[0.001,1,0.1] width:50 align:#left fieldwidth:65
		mapbutton muroughnessTexture "None" width:110 height:16 align:#right
		label lbv "v-roughness . . . . . . . " across:3 align:#left
		spinner mvroughness " " scale:0.001 range:[0.001,1,0.1] width:50 align:#left fieldwidth:65
		mapbutton mvroughnessTexture "None" width:110 height:16 align:#right
		
		checkbox museabsorption "Use Absorption" across:1 align:#left
		label lbabsorptioncolor "Absorption Color . . . . . . . ." across:3 align:#left
		colorpicker mkaColor "" align:#left width:80 height:16
		mapbutton mkaTexture"None" width:110 height:16 align:#right
		label labsorptiondepth "Absorption Depth . . . . . . ." across:3 align:#left
		spinner mdfloat "" scale:0.001 range:[0,15,0.15] width:50 align:#left fieldwidth:65
		
	
		on museanisotropy changed s do
		(	
		    lbu.enabled = s
			lbv.enabled = s
			muroughness.enabled = s
			muroughnessTexture.enabled = s
			mvroughness.enabled = s
			mvroughnessTexture.enabled = s
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
			lbabsorptioncolor.enabled = museabsorption.state
			mkacolor.enabled = museabsorption.state
			mkaTexture.enabled = museabsorption.state
			mdfloat.enabled = museabsorption.state
			lbu.enabled = museanisotropy.state
			lbv.enabled = museanisotropy.state
			muroughness.enabled = museanisotropy.state
			muroughnessTexture.enabled = museanisotropy.state
			mvroughness.enabled = museanisotropy.state
			mvroughnessTexture.enabled = museanisotropy.state
			labsorptiondepth.enabled = museanisotropy.state
		)
	)
	
	include "luxmax\\mtl_common.ms"
)