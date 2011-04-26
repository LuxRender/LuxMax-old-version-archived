plugin material SLGMaterial name:"SLG Material" classID:#(0x7dcb0657, 0x18c11804)extends:Standard replaceUI:true version:2
(
	include "luxmax\\fn_common.ms"
	
	function GetTextureMaps =
	(
		texturemaps = #()
		return texturemaps
	)
	
	function GetLuxRenderString =
	(
		str = stringstream ""
		
		if this.useMattemat == true then
		(
			format "scene.materials.matte.% = % % %\n" this.name (this.MatteDifColor.r / 255) (this.MatteDifColor.g / 255) (this.MatteDifColor.b / 255) to:str
		)
		
		if this.useLightMat == true then
		(
			--scene.materials.light.whitelight
			format "scene.materials.light.% = % % %\n" this.name (this.LightDifColor.r * this.LightPower / 255) (this.LightDifColor.g * this.LightPower / 255) (this.LightDifColor.b * this.LightPower / 255) to:str
		)
		
		if this.useMirrorMat == true then
		(
			format "scene.materials.mirror.% = % % % 1\n" this.name (this.MirrorReflColor.r / 255) (this.MirrorReflColor.g / 255) (this.MirrorReflColor.b / 255)  to:str
		)
		
		if (this.useGlassMat == true and this.useArchGlassMat != true) then
		(
			format "scene.materials.glass.% = % % % % % % 1 % 1 1\n" this.name (this.GlassTransColor.r / 255) (this.GlassTransColor.g / 255) (this.GlassTransColor.b / 255) (this.GlassReflColor.r / 255) (this.GlassReflColor.g / 255) (this.GlassReflColor.b / 255) this.index to:str
		)
		
		if this.useMatteMirrorMat == true then
		(
			format "scene.materials.mattemirror.% = % % % % % % 1\n" this.name (this.MatteMirrorDifColor.r / 255) (this.MatteMirrorDifColor.g / 255) (this.MatteMirrorDifColor.b / 255) (this.MatteMirrorReflColor.r / 255) (this.MatteMirrorReflColor.g / 255) (this.MatteMirrorReflColor.b / 255) to:str
		)
		
		if this.useMetalMat == true then
		(
			format "scene.materials.metal.% = % % % % 1\n" this.name (this.MetalReflColor.r / 255) (this.MetalReflColor.g / 255) (this.MetalReflColor.b / 255) this.MetalExponent  to:str
		)
		
		if this.useMatteMetalMat == true then
		(
			format "scene.materials.mattemetal.% = % % % % % % % 1\n" this.name (this.MatteMetalDifColor.r / 255) (this.MatteMetalDifColor.g / 255) (this.MatteMetalDifColor.b / 255) (this.MatteMetalReflColor.r / 255) (this.MatteMetalReflColor.g / 255) (this.MatteMetalReflColor.b / 255) this.MatteMetalExponent  to:str
		)
		
		if (this.useGlassMat == true and this.useArchGlassMat == true)  then
		(
			format "scene.materials.archglass.% = % % % % % % 1 1\n" this.name (this.GlassTransColor.r / 255) (this.GlassTransColor.g / 255) (this.GlassTransColor.b / 255) (this.GlassReflColor.r / 255) (this.GlassReflColor.g / 255) (this.GlassReflColor.b / 255) to:str
		)
		
		if this.useAlloyMat == true then
		(
			format "scene.materials.alloy.% = % % % % % % % % 1\n" this.name (this.AlloyDifColor.r / 255) (this.AlloyDifColor.g / 255) (this.AlloyDifColor.b / 255) (this.AlloyReflColor.r / 255) (this.AlloyReflColor.g / 255) (this.AlloyReflColor.b / 255) this.AlloyExponent this.AlloySchlick  to:str
		)
		
		return str as string
	)
	
	parameters main rollout:params
	(
		
		
		bumpscale type:#float ui:mbumpscale default:0
		bumpmap type:#texturemap ui:mbumpmap
		
		useMattemat type:#boolean ui:museMatteMat
		MatteDifColor type:#color default:[90,90,90] ui:mMatteDifColor
		MatteDifTexture type:#texturemap ui:mMatteDifTexture
		
		LightDifColor type:#color default:[254,254,254]ui:mLightColor
		LightPower type:#float ui:mPower default:0
		useLightMat type:#boolean ui:museLightMat
		
		useMirrorMat type:#boolean ui:museMirrorMat
		MirrorReflColor type:#color default:[90,90,90] ui:mMirrorReflColor
		
		useGlassMat type:#boolean ui:museGlassMat
		useArchGlassMat type:#boolean ui:museArchGlassMat
		GlassTransColor type:#color default:[90,90,90] ui:mGlassTransColor
		GlassReflColor type:#color default:[90,90,90] ui:mGlassReflColor
		index type:#float ui:mindex
		
		useMatteMirrorMat type:#boolean ui:museMatteMirrorMat
		MatteMirrorDifColor type:#color default:[90,90,90] ui:mMatteMirrorDifColor
		MatteMirrorReflColor type:#color default:[90,90,90] ui:mMatteMirrorReflColor
		MatteMirrorDifTexture type:#texturemap ui:mMatteMirrorDifTexture
		
		useMetalMat type:#boolean ui:museMetalMat
		MetalReflColor type:#color default:[90,90,90] ui:mMetalReflColor
		MetalExponent type:#integer ui:mMetalExponent default:10
		
		useMatteMetalMat type:#boolean ui:museMatteMetalMat
		MatteMetalDifColor type:#color default:[90,90,90] ui:mMatteMetalDifColor
		MatteMetalReflColor type:#color default:[90,90,90] ui:mMatteMetalReflColor
		MatteMetalExponent type:#integer ui:mMatteMetalExponent default:10
		MatteMetalDifTexture type:#texturemap ui:mMatteMetalDifTexture
		
		useAlloyMat type:#boolean ui:museAlloyMat
		AlloyDifColor type:#color default:[90,90,90] ui:mAlloyDifColor
		AlloyReflColor type:#color default:[90,90,90] ui:mAlloyReflColor
		AlloyExponent type:#integer ui:mAlloyExponent default:10
		AlloySchlick type:#float ui:mAlloySchlick default:0.1
		AlloyDifTexture type:#texturemap ui:mAlloyDifTexture
	)
	
rollout params "SLG Material Parameters"
	(
--GENERAL PARAMETERS
	group "Bump Settings"	
	(
	label lbBump "Bump . . . . . . . . . . . "  align:#left across:3
	spinner mBumpScale "Scale:" scale:0.001 range:[0,100,1] width:50 fieldwidth:40  align:#left
	mapbutton mBumpMap "Bump Map" width:110 height:16 align:#right
	)
--LIGHT MATERIAL and PORTAL
	group "Light Material"
	(	
	checkbox museLightMat "" align:#left across:2
	checkbox museExitPortalMat "Use Portal" align:#right 
	label lbLight "Light Color . . . . . . ."  align:#left across:3
	colorpicker mLightColor "" align:#left width:80 height:16
	spinner mPower "Power" scale:0.01 range:[0,1,0] width:50 fieldwidth:40  align:#right
	)

--GLASS MATERIAL AND ARCH
	group "Glass Material" 
	(	
	checkbox museGlassMat "" align:#left across:2
	checkbox museArchGlassMat "Architectural" align:#right
	spinner mindex "IOR value"scale:0.001 range:[1,6,1.5] width:50 align:#left fieldwidth:40 across:2
	dropdownlist ddl_ior "" width:200 height:16 align:#right 
	label lbtransmission "Transmission . . . . . . ."  align:#left across:3
	colorpicker mGlassTransColor "" align:#left width:80 height:16 
	checkbox museGlassTransCaustics "Transm Caustics" align:#right
	label lbGlassreflection "Reflection . . . . . . . . . . . . . . . . "  align:#left across:3
	colorpicker mGlassReflColor "" align:#left width:80 height:16 
	checkbox museGlassReflCaustics "Reflect Caustics" align:#right
	)
	
--MATTE MATERIAL
	group "Matte Material"
	(	
	checkbox museMatteMat "" align:#left across:1
	label lbMatteDif "Difuse Color . . . . . . ."  align:#left across:3
	colorpicker mMatteDifColor "" align:#left width:80 height:16 across:2
	mapbutton mMatteDifTexture "" width:110 height:16 align:#right	
	)	
	
--MIRROR MATERIAL
	group "Mirror Material"
	(	
	checkbox museMirrorMat "" align:#left across:1
	label lbmirrorreflection "Reflection . . . . . . ."  align:#left across:3
	colorpicker mMirrorReflColor "" align:#left width:80 height:16 
	checkbox museMirrorCaustics "Reflect Caustics" align:#right
	)	
	
--METAL MATERIAL
	group "Metal Material"
	(
	checkbox museMetalMat "" align:#left across:2
	spinner mMetalExponent "Exponent" scale:1 range:[1,10000,10] width:50 align:#right fieldwidth:40	
	label lbmetalreflection "Reflection . . . . . . ."  align:#left across:3
	colorpicker mMetalReflColor "" align:#left width:80 height:16 
	checkbox museMetalCaustics "Reflect Caustics" align:#right
			
	)
	
--MATTEMETAL MATERIAL
	group "MatteMetal Material"
	(
	checkbox museMatteMetalMat "" align:#left across:2
	spinner mMatteMetalExponent "Exponent" scale:1 range:[1,10000,10] width:50 align:#right fieldwidth:40	 align:#left
	
label lbMatteMetalDif "Difuse Color . . . . . . ."  align:#left across:3
	colorpicker mMatteMetalDifColor "" align:#left width:80 height:16 
	mapbutton mMatteMetalDifTexture "" width:110 height:16 align:#right
	label lbMattemetalreflection "Reflection . . . . . . ."  align:#left across:3
	colorpicker mMatteMetalReflColor "" align:#left width:80 height:16 
	checkbox museMatteMetalCaustics "Reflect Caustics" align:#right	
	)

--MATTEMIRROR MATERIAL
	group "MatteMirror Material"
	(
	checkbox museMatteMirrorMat "" align:#left across:1
	
	label lbMatteMirrorlDif "Difuse Color . . . . . . ."  align:#left across:3
	colorpicker mMatteMirrorDifColor "" align:#left width:80 height:16 
	mapbutton mMatteMirrorDifTexture "" width:110 height:16 align:#right
	label lbMatteMirrorreflection "Reflection . . . . . . ."  align:#left across:3
	colorpicker mMatteMirrorReflColor "" align:#left width:80 height:16 
	checkbox museMatteMirrorCaustics "Reflect Caustics" align:#right
	
	)
	
--ALLOY MATERIAL
	group "Alloy Material"
	(
	checkbox museAlloyMat "" align:#left across:3
	spinner mAlloyExponent "Exponent" scale:1 range:[1,10000,10] width:50 align:#left fieldwidth:40	
	spinner mAlloySchlick "Schlick" scale:0.001 range:[0,0.999,0.5] width:50 align:#right fieldwidth:40
	label lbAlloyDif "Difuse Color . . . . . . ."  align:#left across:3
	colorpicker mAlloyDifColor "" align:#left width:80 height:16 
	mapbutton mAlloyDifTexture "" width:110 height:16 align:#right
	label lbAlloyreflection "Reflection . . . . . . ."  align:#left across:3
	colorpicker mAlloyReflColor "" align:#left width:80 height:16 
	checkbox mAlloyCaustics "Reflect Caustics" align:#right
	)
	
	fn updatecheckbox theIndex theState =
	(
	thecheckboxArray = #(museLightMat,museGlassMat,museMatteMat,museMatteMirrorMat,museMetalMat,museMatteMetalMat,museAlloyMat,museMirrorMat)
	if theState then
	for i = 1 to 8 where i != theIndex do thecheckboxArray[i].state = false
	else
		(
	thecheckboxArray[1].state = true
	for i = 2 to 8 do thecheckboxArray[i].state = false
		)
	)
	
	on museLightMat changed state do updatecheckbox 1 state
	on museGlassMat changed state do updatecheckbox 2 state
	on museMatteMat changed state do updatecheckbox 3 state
	on museMatteMirrorMat changed state do updatecheckbox 4 state
	on museMetalMat changed state do updatecheckbox 5 state
	on museMatteMetalMat changed state do updatecheckbox 6 state
	on museAlloyMat changed state do updatecheckbox 7 state
	on museMirrorMat changed state do updatecheckbox 8 state
	
	on ddl_ior selected val do
		(
			ior_presets = luxGetIORPresets()
			if ior_presets[val].value == undefined do return false
			mindex.value = ior_presets[val].value
		)
	
		on params open do
		(
			mental_ray_Preferences.mrExtensionsActive = false
			items = #()
			
			for o in (luxGetIORPresets()) do
			(
				append items o.name
			)
			ddl_ior.items = items
		)

	)
)