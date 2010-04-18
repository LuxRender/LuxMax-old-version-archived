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
		kdcolor type:#color default:[90,90,90] ui:mDiffuse
		kdtexture type:#textureMap ui:mDiffuseTexture
		kscolor type:#color default:[90,90,90] ui:mSpec
		kstexture type:#textureMap ui:mSpecTexture
		useka type:#boolean default:false ui:museabsorption
		kacolor type:#color default:[90,90,90] ui:mAbsorption
		katexture type:#textureMap ui:mAbsorptionTexture
		kadepth type:#float ui:mDepth default:0.15
		
		useior type:#boolean ui:chk_ior
		ior type:#float ui:spn_ior
		iorTexture type:#textureMap ui:m_IOR
		
		uroughness type:#float default:50 ui:spn_exponentu
		vroughness type:#float default:50 ui:spn_exponentv
		uroughnesstexture type:#textureMap ui:b_exponentuTexture
		vroughnesstexture type:#textureMap ui:b_exponentvTexture
		
		useBumpmap type:#boolean ui:museBumpmap
		bumpmap type:#float ui:mbumpmap
		bumpmapTexture type:#textureMap ui:mbumpmapTexture
		
		emission type:#boolean ui:memission
		emissionTexture type:#textureMap ui:memissionTexture
		
		useSubdivision type:#boolean ui:museSubdivision
		Subdivision type:#float ui:mSubdivision
		isSharpen type:#boolean ui:mSharpenBounds
		isSmooth type:#boolean ui:mSmooth
		
		useDisplacement type:#boolean ui:museDisplacement
		displacement type:#float ui:mdisplacement
		displacementTexture type:#textureMap ui:mdisplacementTexture
	)

	
	rollout params "Glossy Parameters"
	(
		group "Basic Parameters" (
			label lb_diffuse "Diffuse . . . . . . . . . " align:#left across:3
			colorpicker mDiffuse "" align:#left height:18
			mapbutton mDiffuseTexture"None" width:120 height:18 align:#right
			label useSpecular "Specular . . . . . . . ." across:3 align:#left
			colorpicker mSpec ""  align:#left height:18
			mapbutton mSpecTexture"None" width:120 height:18 align:#right
			checkbox museabsorption "Absorption . . . ." align:#left across:3
			colorpicker mAbsorption "" align:#left height:18 enabled:false
			mapbutton mAbsorptionTexture "None" width:120 height:18 align:#right enabled:false
			label lb_depth "Absorption Depth . . . . . . . . . . . . . . . . . . . . ." align:#left across:2
			spinner mDepth "" width:60 align:#right range:[0,15,0.15] scale:0.01
		)
		on museabsorption changed s do
		(
			mAbsorption.enabled = s
			mAbsorptionTexture.enabled = s
		)
		group "Advanced Parameters"
		(
			checkbox chk_ior "IOR . . . . . . . . " across:3
			spinner spn_ior "" width:68 range:[1,50,1.5] align:#left
			mapbutton m_IOR "T" width:120 height:20 align:#right
		
			label lb_exponentu "U-Exponent . . . . . . " across:3 enabled:true
			spinner spn_exponentu "" width:68  range:[1,1000000,50] align:#left enabled:true
			mapbutton b_exponentuTexture "None" width:120 height:18 align:#right enabled:true
			label lb_exponentv "V-Exponent . . . . . . " across:3 enabled:true
			spinner spn_exponentv ""  width:68 range:[1,1000000,50] align:#left enabled:true
			mapbutton b_exponentvTexture "None" width:120 height:18 align:#right enabled:true

			-- Bumpmap parameters
			checkbox museBumpmap "Bumpmap . . . ." across:3 enabled:true
			spinner mbumpmap "" scale:0.01 range:[0,1,0] width:68 align:#left
			mapbutton mbumpmapTexture "T" width:120 height:18 align:#right
			
			-- Emission paramters
			checkbox memission "Emission Texture . . . . . . . . . . " across:2 enabled:false
			mapbutton memissionTexture "T" width:120 height:18 align:#right
		)
		on chk_ior changed s do
		(
			spn_ior.enabled = s
			m_IOR.enabled = s
		)
		on museBumpmap changed s do
		(
			mbumpmap.enabled = s
			mbumpmapTexture.enabled = s
		)
		on memission changed s do
		(
			memissionTexture.enabled = s
		)
		group "Subdivision Parameters"
		(
			checkbox museSubdivision "Subdivision . . ." across:3 enabled:true
			spinner msubdivision "" scale:1 range:[0,12,0] type:#integer width:50 align:#left
			label lb0 ""
			checkbox mSharpenBounds "Sharpen Bounds"
			checkbox mSmooth "Smooth"
		)
		on museSubdivision changed s do
		(
			msubdivision.enabled = s
			mSharpenBounds.enabled = s
			mSmooth.enabled = s
		)
		group "Displacement Map Parameters"
		(
			checkbox museDisplacement "Displacement . ." across:3  enabled:true
			spinner mdisplacement "" scale:0.1 range:[-10,10,0] width:50 align:#left
			mapbutton mDisplacementTexture "T" width:120 height:18 align:#right
		)
		on museDisplacement changed s do
		(
			mdisplacement.enabled = s
			mDisplacementTexture.enabled = s
		)
		on params open do
		(
			mAbsorption.enabled = museabsorption.state
			mAbsorptionTexture.enabled = museabsorption.state
			spn_ior.enabled = chk_ior.state
			m_ior.enabled = chk_ior.state
			
			mbumpmap.enabled = museBumpmap.state
			mbumpmapTexture.enabled = museBumpmap.state
			
			memissionTexture.enabled = memission.state
			
			msubdivision.enabled = museSubdivision.state
			mSharpenBounds.enabled = museSubdivision.state
			mSmooth.enabled = museSubdivision.state
			
			mdisplacement.enabled = museDisplacement.state
			mDisplacementTexture.enabled = museDisplacement.state
		)
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

--// RoughGlass

plugin material LuxrenderRoughGlass name:"LR RoughGlass" classID:#(0x24fa894, 0x727a5aca) extends:Standard replaceUI:true version:1
( 
	parameters main rollout:params
	(
		Kt type:#color default:[255,255,255] ui:mTransmission
		KtTexture type:#textureMap ui:mTransmissionTexture
		Kr type:#color default:[255,255,255] ui:mReflection
		KrTexture type:#textureMap ui:mReflectionTexture

		usecauchyb type:#boolean ui:useCauchyb
		cauchyb type:#float ui:mcauchyb
		cauchybTexture type:#textureMap ui:mcauchybTexture
		
		useior type:#boolean ui:chk_ior
		ior type:#float ui:spn_ior
		iorTexture type:#textureMap ui:m_IOR
		
		useBumpmap type:#boolean ui:museBumpmap
		bumpmap type:#float ui:mbumpmap
		bumpmapTexture type:#textureMap ui:mbumpmapTexture
		
		emission type:#boolean ui:memission
		emissionTexture type:#textureMap ui:memissionTexture
		
		useSubdivision type:#boolean ui:museSubdivision
		Subdivision type:#float ui:mSubdivision
		isSharpen type:#boolean ui:mSharpenBounds
		isSmooth type:#boolean ui:mSmooth
		
		useDisplacement type:#boolean ui:museDisplacement
		displacement type:#float ui:mdisplacement
		displacementTexture type:#textureMap ui:mdisplacementTexture
	)

	rollout params "Glass Parameters"
	(
		group "Glass Parameters"
		(
			label lb_Transmission "Transmission . . . . ." align:#left across:3
			colorpicker mTransmission "" height:18
			mapbutton mTransmissionTexture"None" width:120 height:18 align:#right
			label lb_Reflection "Reflection . . . . . . . " align:#left across:3
			colorpicker mReflection "" height:18
			mapbutton mReflectionTexture"None" width:120 height:18 align:#right
		)
		group "Dispersive Refraction"
		(
			checkbox useCauchyb "Dispersive Refraction"
			label lb_cauchyb "Cauchyb . . . . . . . " across:3 align:#left
			spinner mcauchyb ""  width:68 scale:0.001 range:[0, 1, 0.02] align:#left
		)
		group "Advanced Parameters"
		(
			mapbutton mcauchybTexture "None" width:120 height:18 align:#right
			checkbox chk_ior "IOR . . . . . . . . " across:3
			spinner spn_ior "" width:68 range:[1,50,1.5] align:#left
			mapbutton m_IOR "T" width:120 height:20 align:#right
			
			label lb_exponentu "U-Exponent . . . . . . " across:3 enabled:false
			spinner spn_exponentu "" width:68  range:[1,1000000,50] align:#left enabled:false
			mapbutton spn_exponentuTexture "None" width:120 height:18 align:#right enabled:false
			label lb_exponentv "V-Exponent . . . . . . " across:3 enabled:false
			spinner spn_exponentv ""  width:68 range:[1,1000000,50] align:#left enabled:false
			mapbutton spn_exponentvTexture "None" width:120 height:18 align:#right enabled:false

			-- Bumpmap parameters
			checkbox museBumpmap "Bumpmap . . . ." across:3 enabled:true
			spinner mbumpmap "" scale:0.01 range:[0,1,0] width:68 align:#left
			mapbutton mbumpmapTexture "T" width:120 height:18 align:#right

			-- Emission paramters
			checkbox memission "Emission Texture . . . . . . . . . . " across:2 enabled:false
			mapbutton memissionTexture "T" width:120 height:18 align:#right
		)
		on chk_ior changed s do
		(
			spn_ior.enabled = s
			m_IOR.enabled = s
		)
		on museBumpmap changed s do
		(
			mbumpmap.enabled = s
			mbumpmapTexture.enabled = s
		)
		on memission changed s do
		(
			memissionTexture.enabled = s
		)			
		group "Subdivision Parameters"
		(
			checkbox museSubdivision "Subdivision . . ." across:3 enabled:true
			spinner msubdivision "" scale:1 range:[0,12,0] type:#integer width:50 align:#left  enabled:false
			label lb0 ""
			checkbox mSharpenBounds "Sharpen Bounds" enabled:false
			checkbox mSmooth "Smooth" enabled:false
		)
		on museSubdivision changed s do
		(
			msubdivision.enabled = s
			mSharpenBounds.enabled = s
			mSmooth.enabled = s
		)
		group "Displacement Map Parameters"
		(
			checkbox museDisplacement "Displacement . ." across:3  enabled:true
			spinner mdisplacement "" scale:0.1 range:[-10,10,0] width:50 align:#left
			mapbutton mDisplacementTexture "T" width:120 height:18 align:#right
		)
		on museDisplacement changed s do
		(
			mdisplacement.enabled = s
			mDisplacementTexture.enabled = s
		)
		on params open do
		(
			spn_ior.enabled = chk_ior.state
			m_ior.enabled = chk_ior.state
			
			mbumpmap.enabled = museBumpmap.state
			mbumpmapTexture.enabled = museBumpmap.state
			
			memissionTexture.enabled = memission.state
			
			msubdivision.enabled = museSubdivision.state
			mSharpenBounds.enabled = museSubdivision.state
			mSmooth.enabled = museSubdivision.state
			
			mdisplacement.enabled = museDisplacement.state
			mDisplacementTexture.enabled = museDisplacement.state
		)
	)
)

--// Metal

plugin material LuxrenderMetal name:"LR Metal" classID:#(0x26705ce9, 0x4c088767) extends:Standard replaceUI:true version:1
( 
	parameters main rollout:params
	(
		metalname type:#integer ui:mname default:1
		
		useBumpmap type:#boolean ui:museBumpmap
		bumpmap type:#float ui:mbumpmap
		bumpmapTexture type:#textureMap ui:mbumpmapTexture
		
		emission type:#boolean ui:memission
		emissionTexture type:#textureMap ui:memissionTexture
		
		useSubdivision type:#boolean ui:museSubdivision
		Subdivision type:#float ui:mSubdivision
		isSharpen type:#boolean ui:mSharpenBounds
		isSmooth type:#boolean ui:mSmooth
		
		useDisplacement type:#boolean ui:museDisplacement
		displacement type:#float ui:mdisplacement
		displacementTexture type:#textureMap ui:mdisplacementTexture
	)

	
	rollout params "Metal Parameters"
	(
		dropdownlist mname "Name:"  items:#("Aluminium", "Amorphous carbon", "Gold", "Copper")
		
		group "Advanced Parameters"
		(
			label lb_exponentu "U-Exponent . . . . . . " across:3 enabled:false
			spinner spn_exponentu "" width:68  range:[1,1000000,50] align:#left enabled:false
			mapbutton spn_exponentuTexture "None" width:120 height:18 align:#right enabled:false
			label lb_exponentv "V-Exponent . . . . . . " across:3 enabled:false
			spinner spn_exponentv ""  width:68 range:[1,1000000,50] align:#left enabled:false
			mapbutton spn_exponentvTexture "None" width:120 height:18 align:#right enabled:false

			-- Bumpmap parameters
			checkbox museBumpmap "Bumpmap . . . ." across:3 enabled:false
			spinner mbumpmap "" scale:0.01 range:[0,1,0] width:68 align:#left
			mapbutton mbumpmapTexture "T" width:120 height:18 align:#right

			-- Emission paramters
			checkbox memission "Emission Texture . . . . . . . . . . " across:2 enabled:false
			mapbutton memissionTexture "T" width:120 height:18 align:#right
		)
		on museBumpmap changed s do
		(
			mbumpmap.enabled = s
			mbumpmapTexture.enabled = s
		)
		on memission changed s do
		(
			memissionTexture.enabled = s
		)			
		group "Subdivision Parameters"
		(
			checkbox museSubdivision "Subdivision . . ." across:3 enabled:true
			spinner msubdivision "" scale:1 range:[0,12,0] type:#integer width:50 align:#left  enabled:false
			label lb0 ""
			checkbox mSharpenBounds "Sharpen Bounds" enabled:false
			checkbox mSmooth "Smooth" enabled:false
		)
		on museSubdivision changed s do
		(
			msubdivision.enabled = s
			mSharpenBounds.enabled = s
			mSmooth.enabled = s
		)
		group "Displacement Map Parameters"
		(
			checkbox museDisplacement "Displacement . ." across:3  enabled:true
			spinner mdisplacement "" scale:0.1 range:[-10,10,0] width:50 align:#left
			mapbutton mDisplacementTexture "T" width:120 height:18 align:#right
		)
		on museDisplacement changed s do
		(
			mdisplacement.enabled = s
			mDisplacementTexture.enabled = s
		)
		on params open do
		(
			mbumpmap.enabled = museBumpmap.state
			mbumpmapTexture.enabled = museBumpmap.state
			
			memissionTexture.enabled = memission.state
			
			msubdivision.enabled = museSubdivision.state
			mSharpenBounds.enabled = museSubdivision.state
			mSmooth.enabled = museSubdivision.state
			
			mdisplacement.enabled = museDisplacement.state
			mDisplacementTexture.enabled = museDisplacement.state
		)
	)
)

plugin material LuxRenderBoundVolume name:"LR BoundVolume" classID:#(0x24171fb3, 0x5934a470) extends:Standard replaceUI:true version:1
 ( 
 	parameters main rollout:luxvolrol
 	(
 		--AreaLightSourceMap type:#textureMap ui:m_emissionTexture
 		Scatteringx type:#float ui:spn11
 		Scatteringy type:#float ui:spn12
 		Scatteringz type:#float ui:spn13
 		Absorption type:#float ui: spn17
 	)
 	
 	rollout luxvolrol "Scattering" width:336 height:264
 	(
 		spinner spn11 "scatx" pos:[144,8] width:144 height:16 range:[0,100,0.1] type:#float
 		spinner spn12 "scaty" pos:[144,32] width:144 height:16 range:[0,100,0.1] type:#float
 		spinner spn13 "scatz" pos:[144,56] width:144 height:16 range:[0,100,0.1] type:#float
 		spinner spn17 "Absorption:" pos:[144,80] width:144 height:16 range:[0,100,0.1] type:#float
 		spinner spn22 "Stepsize :" pos:[144,104] width:144 height:16 range:[0,100,0.1] type:#float
 		colorPicker cp1 "sigma_a" pos:[8,8] width:104 height:40
 		colorPicker cp2 "sigma_s" pos:[8,80] width:104 height:40 color:(color 0 0 155)
 	)
 	
 	on create do
 	(
 		
 	)
 )



