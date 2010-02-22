-- Luxrender Materials plug-ins for 3dsmax

--// Matte

plugin material LuxrenderMatte name:"LR Matte" classID:#(0x61108483, 0x4d218a72) extends:Standard replaceUI:true version:1
( 
	parameters main rollout:params
	(
		kdColor type:#color default:[90,90,90] ui:mkdColor
		kdTexture type:#textureMap ui:mkdTexture
		
		useSigma type:#boolean ui:museSigma
		sigma type:#float ui:msigma
		sigmaTexture type:#textureMap ui:msigmaTexture
		
		useBumpmap type:#boolean ui:museBumpmap
		bumpmap type:#float ui:mbumpmap
		bumpmapTexture type:#textureMap ui:mbumpmapTexture
		
		emission type:#boolean ui:memission
		emissionTexture type:#textureMap ui:memissionTexture
	)
	
	rollout params "Matte Parameters"
	(
		-- Basic matte parameters
		group "Basic Parameters" (
			colorpicker mkdColor "Diffuse: " across:2
			mapbutton mkdTexture"None" width:128 height:16 align:#right
		)
	
		group "Advanced Parameters"
		(
			-- Oren-Nayar parameters
			checkbox museSigma "Sigma ..........." across:3
			spinner msigma "" range:[0,100,0] width:50 align:#left
			mapbutton msigmaTexture "T" width:128 height:16 align:#right
			on museSigma changed s do
			(
				msigma.enabled = s
				msigmaTexture.enabled = s
			)

			-- Bumpmap parameters
			checkbox museBumpmap "Bumpmap ......." across:3
			spinner mbumpmap "" scale:0.01 range:[0,1,0] width:50 align:#left
			mapbutton mbumpmapTexture "T" width:128 height:16 align:#right
			on museBumpmap changed s do
			(
				mbumpmap.enabled = s
				mbumpmapTexture.enabled = s
			)
		
			-- Emission paramters
			checkbox memission "Emission Texture ..............." across:2
			mapbutton memissionTexture "T" width:128 height:16 align:#right
			on memission changed s do
			(
				memissionTexture.enabled = s
			)
		)
		
		group "Subdivision Parameters"
		(
		)
		
		group "Displacement Parameters"
		(
		)
		on params open do
		(
			msigma.enabled = museSigma.state
			msigmaTexture.enabled = museSigma.state
			
			mbumpmap.enabled = museBumpmap.state
			mbumpmapTexture.enabled = museBumpmap.state
			
			memissionTexture.enabled = memission.state
		)
	)
)

--// Glossy

plugin material LuxrenderGlossy name:"LR Glossy" classID:#(0xfe1ebdc, 0x3b7b37e6) extends:Standard replaceUI:true version:1
( 
	parameters main rollout:params
	(
		Kd type:#color default:[90,90,90] ui:mDiffuse
		KdTexture type:#textureMap ui:mDiffuseTexture
		Ks type:#color default:[90,90,90] ui:mSpec
		KsTexture type:#textureMap ui:mSpecTexture
		Ka type:#color default:[90,90,90] ui:mAbsorption
		KaTexture type:#textureMap ui:mAbsorptionTexture
	)

	parameters main rollout:paramsIOR
	(
		iorActive type:#boolean ui:chk_ior
		ior type:#float ui:spn_ior
		iorTexture type:#textureMap ui:m_IOR
	)

	parameters main rollout:paramsBump
	(
		bumpmap type:#float ui:spn_bump
		bumpmapMap type:#textureMap ui:m_Bumpmap
	)
	
	rollout params "Glossy Parameters"
	(
		colorpicker mDiffuse "Diffuse: " pos:[31,8]
		mapbutton mDiffuseTexture"None" width:128 height:20 pos:[180,8]
		colorpicker mSpec "Specular: " pos:[24,32]
		mapbutton mSpecTexture"None" width:128 height:20 pos:[180,32]
		colorpicker mAbsorption "Absorption: " pos:[13,56]
		mapbutton mAbsorptionTexture "None" width:128 height:20 pos:[180,56]
		spinner mDepth "Depth:" pos:[196,82] width:112
	)

	rollout paramsIOR "IOR"
	(
		checkbox chk_ior
		spinner spn_ior "IOR:" range:[1,50,1.5] pos:[48,8] width:100
		mapbutton m_IOR "T" width:128 height:20 pos:[180,8]
	)
	
	rollout paramsExponent "Exponent"
	(
		spinner spn_exponentu "U-Exponent:" range:[1,1000000,50] pos:[48,10] width:100
		mapbutton spn_exponentuTexture"None" width:128 height:20 pos:[180,8]
		spinner spn_exponentuv"V-Exponent:" range:[1,1000000,50] pos:[48,34] width:100
		mapbutton spn_exponentvTexture"None" width:128 height:20 pos:[180,32]
	)
	
	rollout paramsBump "Bump Map"
	(
		spinner spn_bump "Bumpmap:" range:[0,1,0] pos:[38,8] width:110
		mapbutton m_Bumpmap "T" width:128 height:20 pos:[180,8]
	)
)

--// Glass

plugin material LuxrenderGlass name:"LR Glass" classID:#(0x1416e9d, 0x5f7312b0)extends:Standard replaceUI:true version:1
( 
	parameters main rollout:params
	(
		Kt type:#color default:[255,255,255] ui:mTransmission
		KtTexture type:#textureMap ui:mTransmissionTexture
		Kr type:#color default:[255,255,255] ui:mReflection
		KrTexture type:#textureMap ui:mReflectionTexture
	)

	parameters main rollout:paramsIOR
	(
		iorActive type:#boolean ui:chk_ior
		ior type:#float ui:spn_ior
		iorTexture type:#textureMap ui:m_IOR
	)

	parameters main rollout:paramsBump
	(
		bumpmap type:#float ui:spn_bump
		bumpmapMap type:#textureMap ui:m_Bumpmap
	)
	
	rollout params "Glass Parameters"
	(
		colorpicker mTransmission "Transmission: " pos:[11,8]
		mapbutton mTransmissionTexture"None" width:128 height:20 pos:[180,8]
		colorpicker mReflection "Reflection: " pos:[24,32]
		mapbutton mReflectionTexture"None" width:128 height:20 pos:[180,32]
	)

	rollout paramsIOR "IOR"
	(
		checkbox chk_ior
		spinner spn_ior "IOR:" range:[1,50,1.5] pos:[48,8] width:100
		mapbutton m_IOR "T" width:128 height:20 pos:[180,8]
	)
	
	rollout paramsBump "Bump Map"
	(
		spinner spn_bump "Bumpmap:" range:[0,1,0] pos:[38,8] width:110
		mapbutton m_Bumpmap "T" width:128 height:20 pos:[180,8]
	)
)

-- // Area Light

plugin material LuxrenderLight name:"LR Light" classID:#(0x23131fb9, 0x5134a570) extends:Standard replaceUI:true version:1
( 
	parameters main rollout:paramsEm
	(
		AreaLightSourceMap type:#textureMap ui:m_emissionTexture
	)
	
	rollout paramsEm "Light"
	(
		mapbutton m_emissionTexture "T" width:300 height:20 align:#center
	)
	
	on create do
	(
		AreaLightSourceMap = LuxrenderBlackbody name:""
	)
)