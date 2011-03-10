plugin material LuxRenderMirror name:"LR Mirror" classID:#(0x20cc696b, 0x4e990f20) extends:Standard replaceUI:true version:2

(
	include "luxmax\\fn_common.ms"
	include "luxmax\\mtl_logo.ms"
	
	function GetTextureMaps =
	(
		texturemaps = #(this.krTexture, thisksTexture, this.filmTexture, this.filmindexTexture, this.bumpmapTexture, this.emissionTexture)
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
		
		if this.usebumpmap == true then
		(	
		if this.bumpmapTexture != undefined then
			format "\t\"texture bumpmap\" [\"%\"]\n" this.bumpmapTexture.name to:str
		else
			luxWriteFloat "bumpmap"  this.bumpmap str
		)
		
		luxWriteString "type" "mirror" str
		
		return str as string
	)
	
	parameters main rollout:params
	(
		krColor type:#color default:[90,90,90] ui:mkrColor 
		krTexture type:#textureMap ui:mkrTexture
		usefilm type:#boolean ui:musefilm
		film type:#float ui:mfilm 
		filmtexture type:#textureMap ui:mfilmtexture
		filmindex type:#float ui:mfilmindex
		filmindextexture type:#textureMap ui:mfilmindextexture
		
		
		
	)
	
	rollout params "Mirror Parameters"
	(
		label lbreflection"Reflection . . . . . . . . ."  align:#left across:3
		colorpicker mkrColor "" align:#left width:80 height:16
		mapbutton mkrTexture"None" width:110 height:16 align:#right
		
		checkbox musefilm "Use Thin Film Coating" align:#left across:1
		label lbfillm "Film Thickness in nm" align:#left across:3
		spinner mfilm ""scale:0.01 range:[1,1500,200] width:50 align:#left fieldwidth:65
		mapbutton mfilmTexture "" width:110 height:16 align:#right
		label lbfillmindex "Film IOR" align:#left across:3
		spinner mfilmindex ""scale:0.001 range:[1,6,1.5] width:50 align:#left fieldwidth:65
		mapbutton mfilmindexTexture "" width:110 height:16 align:#right
		
		
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
		)
	)
	
	include "luxmax\\mtl_common.ms"
)