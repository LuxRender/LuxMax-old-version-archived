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

		
		return str as string
	)
	
	parameters main rollout:params
	(
		useMattemat type:#boolean ui:museMatteMat
		MatteDifColor type:#color default:[90,90,90] ui:mMatteDifColor
	)
	
rollout params "SLG Material Parameters"
	(
--LIGHT MATERIAL
	group "Light Material"
	(	
	checkbox museLightMat "" align:#left across:2
	spinner mPower "Power" scale:0.01 range:[0,1,0] width:50 fieldwidth:40  align:#right
	label lbLight "Light Color . . . . . . ."  align:#left across:3
	colorpicker mLightColor "" align:#left width:80 height:16 across:2
	mapbutton mLigthTexture "" width:110 height:16 align:#right
	)
--EXIT PORTAL MATERIAL
	group "Exit Portal Material"   
	(	
	checkbox useExitPortalMat "" align:#left across:1
	)
--GLASS MATERIAL AND ARCH
	group "Glass Material" 
	(	
	checkbox museGlassMat "" align:#left across:3
	checkbox museArchGlassMat "Architectural" align:#left across:1
	checkbox museGlassCaustics "Caustics" align:#right
	spinner mindex " "scale:0.001 range:[1,6,1.5] width:50 align:#left fieldwidth:40 across:2
	dropdownlist ddl_ior "" width:200 height:16 align:#right 
	label lbtransmission "Transmission . . . . . . ."  align:#left across:3
	colorpicker mGlassTransColor "" align:#left width:80 height:16 
	mapbutton mGlassTransTexture "" width:110 height:16 align:#right
	label lbGlassreflection "Reflection . . . . . . ."  align:#left across:3
	colorpicker mGlassReflColor "" align:#left width:80 height:16 
	mapbutton mGlassReflTexture "" width:110 height:16 align:#right	
	)
	
--MATTE MATERIAL
	group "Matte Material"
	(	
	checkbox museMatteMat "" align:#left across:1
	label lbMatteDif "Difuse Color . . . . . . ."  align:#left across:3
	colorpicker mMatteDifColor "" align:#left width:80 height:16 across:2
	mapbutton mMatteDifTexture "" width:110 height:16 align:#right	
	label lbMatteBump "Bump Texture . . . . . . . . . . . . . . . . ."  align:#left across:2
	mapbutton mMatteBumpTexture "" width:110 height:16 align:#right	
	)	
	
--MIRROR MATERIAL
	group "Mirror Material"
	(	
	checkbox museMirrorMat "" align:#left across:2
	checkbox museMirrorCaustics "Caustics" align:#right
	label lbmirrorreflection "Reflection . . . . . . ."  align:#left across:3
	colorpicker mMirrorReflColor "" align:#left width:80 height:16 
	mapbutton mMirrorReflTexture "" width:110 height:16 align:#right	
	)	
	
--METAL MATERIAL
	group "Metal Material"
	(
	checkbox museMetalMat "" align:#left across:3
	spinner mMetalGloss "Gloss" scale:0.001 range:[0,0.999,0.5] width:50 align:#center fieldwidth:40	
	checkbox museMetalCaustics "Caustics" align:#right
	label lbmetalreflection "Reflection . . . . . . ."  align:#left across:3
	colorpicker mMetalReflColor "" align:#left width:80 height:16 
	mapbutton mMetalReflTexture "" width:110 height:16 align:#right
	label lbMetalBump "Bump Texture . . . . . . . . . . . . . . . . ."  align:#left across:2
	mapbutton mMetalBumpTexture "" width:110 height:16 align:#right					
	)
	
--MATTEMETAL MATERIAL
	group "MatteMetal Material"
	(
	checkbox mMatteMetalMat "" align:#left across:1
	spinner mMatteMetalGloss "Gloss" scale:0.001 range:[0,0.999,0.5] width:50 align:#left fieldwidth:40 across:3
	spinner mMatteMetalRefl "Reflect" scale:0.001 range:[0,0.999,0.5] width:50 align:#right fieldwidth:40
	checkbox museMatteMetalCaustics "Caustics" align:#right
	label lbMatteMetalDif "Difuse Color . . . . . . ."  align:#left across:3
	colorpicker mMatteMetalDifColor "" align:#left width:80 height:16 across:2
	mapbutton mMatteMetalDifTexture "" width:110 height:16 align:#right
	label lbMattemetalreflection "Reflection . . . . . . ."  align:#left across:3
	colorpicker mMatteMetalReflColor "" align:#left width:80 height:16 
	mapbutton mMatteMetalReflTexture "" width:110 height:16 align:#right	
	label lbMatteMetalBump "Bump Texture . . . . . . . . . . . . . . . . ."  align:#left across:2
	mapbutton mMatteMetalBumpTexture "" width:110 height:16 align:#right			
	)

--MATTEMIRROR MATERIAL
	group "MatteMirror Material"
	(
	checkbox museMatteMirrorMat "" align:#left across:3
	spinner mMatteMirrorRefl "Reflect" scale:0.001 range:[0,0.999,0.5] width:50 align:#right fieldwidth:40
	checkbox museMatteMirrorCaustics "Caustics" align:#right
	label lbMatteMirrorlDif "Difuse Color . . . . . . ."  align:#left across:3
	colorpicker mMatteMirrorDifColor "" align:#left width:80 height:16 across:2
	mapbutton mMatteMirrorDifTexture "" width:110 height:16 align:#right
	label lbMatteMirrorreflection "Reflection . . . . . . ."  align:#left across:3
	colorpicker mMatteMirrorReflColor "" align:#left width:80 height:16 
	mapbutton mMatteMirrorReflTexture "" width:110 height:16 align:#right	
	label lbMatteMirrorBump "Bump Texture . . . . . . . . . . . . . . . . ."  align:#left across:2
	mapbutton mMatteMirrorBumpTexture "" width:110 height:16 align:#right		
	)
	
--ALLOY MATERIAL
	group "Alloy Material"
	(
	checkbox useAlloyMat "" align:#left across:1
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