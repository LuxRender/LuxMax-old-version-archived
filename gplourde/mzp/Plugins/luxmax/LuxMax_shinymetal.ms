plugin material LuxRenderShinyMetal name:"LR Shiny Metal" classID:#(0x24171fb3, 0x5934a470) extends:Standard replaceUI:true version:2

(
	include "luxmax\\fn_common.ms"
	include "luxmax\\mtl_logo.ms"
	
	function GetTextureMaps =
	(
		texturemaps = #(this.krTexture, this.ksTexture, this.emissionTexture)
		
		if (this.bumpmapTexture != undefined and this.useBumpmap == true) then
		(
			floatScale = LuxrenderFloatScale()
			floatScale.name = (this.bumpmapTexture.name + "_scale")
			floatScale.floattex1 = this.bumpmap
			floatScale.maptex2 = this.bumpmapTexture
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
		
		if (this.filmTexture != undefined and this.usefilm == true) then
		(
			floatScale = LuxrenderFloatScale()
			floatScale.name = (this.filmTexture.name + "_scale")
			floatScale.floattex1 = this.film
			floatScale.maptex2 = this.filmTexture
			append texturemaps floatScale
		)
		
		if (this.filmindexTexture != undefined and this.usefilm == true) then
		(
			floatScale = LuxrenderFloatScale()
			floatScale.name = (this.filmindexTexture.name + "_scale")
			floatScale.floattex1 = this.filmindex
			floatScale.maptex2 = this.filmindexTexture
			append texturemaps floatScale
		)
		
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
		
		if this.ksTexture != undefined then
			format "\t\"texture Ks\" [\"%\"]\n" this.ksTexture.name to:str
		else
		(
			if this.usespecularior == true then
			(
			luxWriteFloat "index"	this.floatindex str
			format "\t\"color Ks\"  [1.0 1.0 1.0]\n" to:str
			)
			else
			luxWriteColor "Ks"  this.ksColor str
		)
		
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
		
		
		if this.usefilm == true then
		(	
			(	
			if this.filmTexture != undefined then
				format "\t\"texture film\" [\"%\"]\n" (this.filmTexture.name + "_scale") to:str
			else
				luxWriteFloat "film"  this.film str
			)
			(	
			if this.filmindexTexture != undefined then
				format "\t\"texture filmindex\" [\"%\"]\n" (this.filmindexTexture.name + "_scale") to:str
			else
				luxWriteFloat "filmindex"  this.filmindex str
			)
		)
		
		if (this.bumpmapTexture != undefined and this.useBumpmap == true)then
			format "\t\"texture bumpmap\" [\"%\"]\r\n" (this.bumpmapTexture.name + "_scale") to:str
		
		luxWriteString "type" "shinymetal" str
		
		return str as string
	)
	
	parameters main rollout:params
	(
		krColor type:#color default:[90,90,90] ui:mkrColor 
		krTexture type:#textureMap ui:mkrTexture
		ksColor type:#color ui:mksColor default:[30,30,30]
		ksTexture type:#textureMap ui:mksTexture
		usespecularior type:#boolean ui:musespecularior
		floatindex type:#float  ui:mfloatindex default:1.000
		roughness type:#float ui:mroughness default:0.0001
		roughnessTexture type:#textureMap ui:mroughnessTexture
		uroughness type:#float ui:muroughness default:0.0001
		uroughnessTexture type:#textureMap ui:muroughnessTexture
		vroughness type:#float ui:mvroughness default:0.0001
		vroughnessTexture type:#textureMap ui:mvroughnessTexture
		useanisotropy type:#boolean ui:museanisotropy
		usefilm type:#boolean ui:musefilm
		film type:#float ui:mfilm 
		filmtexture type:#textureMap ui:mfilmtexture
		filmindex type:#float ui:mfilmindex
		filmindextexture type:#textureMap ui:mfilmindextexture
		on krColor set val do delegate.diffuse_color = val	
        on ksColor set val do delegate.Specular_color = val
		on roughness set val do 
		(
			if val < 0.1 then
			delegate.Specular_Level =  100
			if val >= 0.1 then
			delegate.Specular_Level =  10 / val
		)
		
		
		
	)
	
	rollout params "Shiny Metal Parameters"
	(
		label lbreflection"Reflection . . . . . . . . ."  align:#left across:3
		colorpicker mkrColor "" align:#left width:80 height:16
		mapbutton mkrTexture"None" width:110 height:16 align:#right

		label lbspecular "Specular . . . . . . . . . ." across:3 align:#left
		colorpicker mksColor "" align:#left width:80 height:16
		mapbutton mksTexture "None" width:110 height:16 align:#right
		
		checkbox musespecularior "Use Ior Specular" across:2 align:#left
		spinner mfloatindex "" scale:0.001 range:[1,6,1.5] width:50 fieldwidth:65 align:#left
		dropdownlist ddl_specularior "Ior presets:" width:200 height:16 across:1 align:#right 
		
		label lbroughness "Roughness. . . . . . ." across:3 align:#left
		spinner mroughness " " scale:0.0001 range:[0.0001,1,0.1] width:50 align:#left fieldwidth:65
		mapbutton mroughnessTexture "None" width:110 height:16 align:#right
		
		checkbox museanisotropy "Use Anisotropic Roughness" across:1 align:#left
		
		label lbu "u-roughness . . . . . . . " across:3 align:#left
		spinner muroughness " " scale:0.0001 range:[0.0001,1,0.1] width:50 align:#left fieldwidth:65
		mapbutton muroughnessTexture "None" width:110 height:16 align:#right
		label lbv "v-roughness . . . . . . . " across:3 align:#left
		spinner mvroughness " " scale:0.0001 range:[0.0001,1,0.1] width:50 align:#left fieldwidth:65
		mapbutton mvroughnessTexture "None" width:110 height:16 align:#right
		
		checkbox musefilm "Use Thin Film Coating" align:#left across:1
		label lbfillm "Film Thickness in nm" align:#left across:3
		spinner mfilm ""scale:0.01 range:[1,1500,200] width:50 align:#left fieldwidth:65
		mapbutton mfilmTexture "" width:110 height:16 align:#right
		label lbfillmindex "Film IOR" align:#left across:3
		spinner mfilmindex ""scale:0.001 range:[1,6,1.5] width:50 align:#left fieldwidth:65
		mapbutton mfilmindexTexture "" width:110 height:16 align:#right
		dropdownlist ddl_filmior "ior presets:" width:200 height:16 align:#right across:1
		
		on musespecularior changed s do
		(
			ddl_specularior.enabled = s
			mfloatindex.enabled = s
		)
	
		on ddl_specularior selected val do
		(
			ior_presets = luxGetIORPresets()
			if ior_presets[val].value == undefined do return false
			mfloatindex.value = ior_presets[val].value
		)
		
		on ddl_filmior selected val do
		(
			ior_presets = luxGetIORPresets()
			if ior_presets[val].value == undefined do return false
			mfilmindex.value = ior_presets[val].value
		)
		
		on museanisotropy changed s do
		(	
		    lbu.enabled = s
			lbv.enabled = s
			muroughness.enabled = s
			muroughnessTexture.enabled = s
			mvroughness.enabled = s
			mvroughnessTexture.enabled = s
		)	
		
		on musefilm changed s do
		(
		mfilm.enabled = s
		mfilmtexture.enabled = s
		mfilmindex.enabled = s
		mfilmindextexture.enabled = s
		ddl_filmior.enabled = s
		)
		
		
		on params open do
		(
			items = #()
			
			for o in (luxGetIORPresets()) do
			(
				append items o.name
			)
			ddl_filmior.items = items
			ddl_filmior.enabled =  musefilm.state
			ddl_specularior.items = items
			ddl_specularior.enabled = musespecularior.state
			mfloatindex.enabled = musespecularior.state
			mental_ray_Preferences.mrExtensionsActive = false
			lbu.enabled = museanisotropy.state
			lbv.enabled = museanisotropy.state
			muroughness.enabled = museanisotropy.state
			muroughnessTexture.enabled = museanisotropy.state
			mvroughness.enabled = museanisotropy.state
			mvroughnessTexture.enabled = museanisotropy.state
			mfilm.enabled = musefilm.state
			mfilmtexture.enabled = musefilm.state
			mfilmindex.enabled = musefilm.state
			mfilmindextexture.enabled = musefilm.state
			delegate.glossiness =  50
		)
	)
	
	include "luxmax\\mtl_common.ms"
)