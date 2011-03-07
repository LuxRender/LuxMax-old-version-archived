plugin material LuxrenderGlass name:"LR Glass" classID:#(0x1416e9d, 0x5f7312b0)extends:Standard replaceUI:true version:2

(
	include "luxmax\\fn_common.ms"
	
	function GetTextureMaps =
	(
		texturemaps = #(this.krTexture, thisktTexture, this.indexTexture, this.filmTexture, this.filmindexTexture, this.bumpmapTexture, this.emissionTexture)
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
		
		if this.indexTexture != undefined then
			format "\t\"texture index\" [\"%\"]\n" this.indexTexture.name to:str
		else
			luxWriteFloat "index"  this.index str
		
		if this.usefilm == true then
		(	
			(	
			if this.filmTexture != undefined then
				format "\t\"texture film\" [\"%\"]\n" this.filmTexture.name to:str
			else
				luxWriteFloat "film"  this.film str
			)
			(	
			if this.filmindexTexture != undefined then
				format "\t\"texture filmindex\" [\"%\"]\n" this.filmindexTexture.name to:str
			else
				luxWriteFloat "filmindex"  this.filmindex str
			)
		)

		If this.isdispersion == true then
		(
		luxWriteFloat "cauchyb"  this.cauchyb str
 		)
		
		
		if this.usebumpmap == true then
		(	
		if this.bumpmapTexture != undefined then
			format "\t\"texture bumpmap\" [\"%\"]\n" this.bumpmapTexture.name to:str
		else
			luxWriteFloat "bumpmap"  this.bumpmap str
		)
		
		luxWriteBool "architectural" this.isarchitectural str
		luxWriteString "type" "glass" str
		
		return str as string
	)
	
	parameters main rollout:params
	(
		krColor type:#color default:[90,90,90] ui:mkrColor 
		krTexture type:#textureMap ui:mkrTexture
		ktColor type:#color default:[90,90,90] ui:mktColor 
		ktTexture type:#textureMap ui:mktTexture
		index type:#float ui:mindex
		indexTexture type:#textureMap ui:mindexTexture
		isarchitectural type:#boolean ui:marchitectural
		isdispersion type:#boolean ui:mdispersion
		cauchyb type:#float ui:mcauchyb
		usefilm type:#boolean ui:musefilm
		film type:#float ui:mfilm 
		filmtexture type:#textureMap ui:mfilmtexture
		filmindex type:#float ui:mfilmindex
		filmindextexture type:#textureMap ui:mfilmindextexture
		
		
		
	)
	
	rollout params "Glass Parameters"
	(
		label lbreflection"Reflection . . . . . . . . ."  align:#left across:3
		colorpicker mkrColor "" align:#left width:80 height:16
		mapbutton mkrTexture"None" width:110 height:16 align:#right

		label lbtransmission "Transmission . . . . . . . . ."  align:#left across:3
		colorpicker mktColor "" align:#left width:80 height:16
		mapbutton mktTexture"None" width:110 height:16 align:#right
		
		label lbindex "IOR. . . . . . . . . . . ." align:#left across:3
		spinner mindex ""scale:0.001 range:[1,6,1.5] width:50 align:#left fieldwidth:65
		mapbutton mindexTexture "" width:110 height:16 align:#right
		
		
		checkbox marchitectural "Use Architectural" align:#left across:1
		
		checkbox mdispersion "Use Dispersion" align:#left across:2
		spinner mcauchyb "cauchy b"scale:0.001 range:[0,1,0.2] width:50 align:#right fieldwidth:65
		
		checkbox musefilm "Use Thin Film Coating" align:#left across:1
		label lbfillm "Film Thickness in nm" align:#left across:3
		spinner mfilm ""scale:0.01 range:[1,1500,200] width:50 align:#left fieldwidth:65
		mapbutton mfilmTexture "" width:110 height:16 align:#right
		label lbfillmindex "Film IOR" align:#left across:3
		spinner mfilmindex ""scale:0.001 range:[1,6,1.5] width:50 align:#left fieldwidth:65
		mapbutton mfilmindexTexture "" width:110 height:16 align:#right
		
		
		on mdispersion changed s do
		(
		mcauchyb.enabled = s
		)			
		
		on musefilm changed s do
		(
		mfilm.enabled = s
		mfilmtexture.enabled = s
		mfilmindex.enabled = s
		mfilmindextexture.enabled = s
		)
		
		
		on params open do
		(
			mental_ray_Preferences.mrExtensionsActive = false
			mfilm.enabled = musefilm.state
			mfilmtexture.enabled = musefilm.state
			mfilmindex.enabled = musefilm.state
			mfilmindextexture.enabled = musefilm.state
			mcauchyb.enabled = mdispersion.state
		)
	)
	
	include "luxmax\\mtl_common.ms"
)