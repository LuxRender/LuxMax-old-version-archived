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
		
		uroughness type:#float default:0.1 ui:spn_exponentu
		vroughness type:#float default:0.1 ui:spn_exponentv
		--spinner spn_exponentv "V-roughness" width:88  range:[0.000,1.000,0.001] type:#float align:#left enabled:true scale:0.001 default:0.001
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
			spinner spn_exponentu "" width:68  range:[0.000,1.000,0.001] type:#float align:#left enabled:true scale:0.001 default:0.001
			mapbutton b_exponentuTexture "None" width:120 height:18 align:#right enabled:true
			label lb_exponentv "V-Exponent . . . . . . " across:3 enabled:true
			spinner spn_exponentv ""  width:68 range:[0.000,1.000,0.001] type:#float align:#left enabled:true scale:0.001 default:0.001
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
		iorActive type:#boolean default:false ui:chk_ior
		ior type:#float ui:spn_ior default:1.0
		iorTexture type:#textureMap ui:m_IOR
		iorstring type:#string default:"yesior"
		iorint type:#integer default:0
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

	rollout paramsIOR "IOR" width:312 height:64
	(
		checkbox chk_ior "enable architectural mode" pos:[23,7] width:200 height:15 
		--label lb_Transmission "1.0 for Architectural glass . . . . ." pos:[8,0] width:140 height:13 across:3
		spinner spn_ior "IOR:" pos:[16,24] width:100 height:16 range:[1,50,1.5]
		mapButton m_IOR "T" pos:[176,24] width:128 height:20
 
		on chk_ior changed state do
		(
			if (chk_ior.checked)then
			(
				iorActive = true
				iorstring = "yesior"
				iorint = 1
			)
			else
			(
				iorActive = false
				iorstring = "noior"
				iorint = 0
			)
		--iorActive
		)
	)
	
	rollout paramsBump "Bump Map"
	(
		spinner spn_bump "Bumpmap:" range:[0,1,0] pos:[38,8] width:110
		mapbutton m_Bumpmap "T" width:128 height:20 pos:[180,8]
	)
	
	on chk_ior changed s do
		(
			chk_ior.state = s
		--	iorActive = true
			--mbumpmapTexture.enabled = s
		)
	on params open do
		(
			chk_ior.enabled = iorActive.state
			iorActive = true
		)
	
)

-- // Area Light

plugin material LuxrenderLight name:"LR Light" classID:#(0x23131fb9, 0x5134a570) extends:Standard replaceUI:true version:1
( 
	parameters main rollout:paramsEm
	(
		AreaLightSourceMap type:#textureMap ui:m_emissionTexture
		
	)
	
	rollout paramsEm "Light" width:160 height:104
	(
		mapButton m_emissionTexture "T" pos:[-69,7] width:300 height:20
		
	)
	on paramsEm open do
	(
		AreaLightSourceMap = LuxrenderBlackbody()
		
	)
	
	on create do
	(
		--AreaLightSourceMap = LuxrenderBlackbody()-- name:""
		--AreaLightSourceMap = LuxrenderBlackbody ()
		--edt1.text = "Default"
	)
)

--// RoughGlass

/* plugin material LuxrenderRoughGlass name:"LR RoughGlass" classID:#(0x24fa894, 0x727a5aca) extends:Standard replaceUI:true version:1
( 
	parameters main rollout:params
	(
		Kr type:#color default:[100,100,100] ui:mroughReflection
		KrTexture type:#textureMap ui:mReflectionTexture
		
		Ktcolor type:#color default:[255,255,255] ui:mTransmission
		KtTexture type:#textureMap ui:mTransmissionTexture

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

	rollout params "RoughGlass Parameters"
	(
		group "RoughGlass Parameters"
		(
			label lb_Transmission "Transmission . . . . ." align:#left across:3
			colorpicker mTransmission "" height:18
			mapbutton mTransmissionTexture"None" width:120 height:18 align:#right
			label lb_Reflection "mReflection . . . . . . . " align:#left across:3
			colorpicker mroughReflection "" height:18
			--colorpicker mkdColor "Diffuse: " across:2
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
		on mTransmission changed new_col do
		(
			Ktcolor = mTransmission.color
			print ("ktcolor =" + mTransmission.color as string)
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
) */

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
		
		uexponent type:#float ui:spn_exponentu  default:0.001
		vexponent type:#float ui:spn_exponentv  default:0.001
		
	)

	
	rollout params "Metal Parameters"
	(
		dropdownlist mname "Name:"  items:#("Aluminium", "Amorphous carbon", "Gold", "Copper")
		
		group "Advanced Parameters"
		(
			label lb_exponentu "U-Exponent . . . . . . " across:3 enabled:true
			spinner spn_exponentu "" width:68  range:[0.000,1,0.001] type:#float align:#left enabled:true scale:0.001
			mapbutton spn_exponentuTexture "None" width:120 height:18 align:#right enabled:false
			label lb_exponentv "V-Exponent . . . . . . " across:3 enabled:true
			spinner spn_exponentv ""  width:68 range:[0.000,1,0.001] type:#float align:#left enabled:true scale:0.001
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

--plugin material LuxRenderBoundVolume name:"LR BoundVolume" classID:#(0x24171fb3, 0x5934a470) extends:Standard replaceUI:true version:1
-- ( 
-- 	parameters main rollout:luxvolrol
-- 	(
 		--AreaLightSourceMap type:#textureMap ui:m_emissionTexture
-- 		Scatteringx type:#float ui:spn11
-- 		Scatteringy type:#float ui:spn12
-- 		Scatteringz type:#float ui:spn13
-- 		Absorption type:#float ui: spn17
-- 	)
 	
-- 	rollout luxvolrol "Scattering" width:336 height:264
-- 	(
-- 		spinner spn11 "scatx" pos:[144,8] width:144 height:16 range:[0,100,0.1] type:#float
-- 		spinner spn12 "scaty" pos:[144,32] width:144 height:16 range:[0,100,0.1] type:#float
-- 		spinner spn13 "scatz" pos:[144,56] width:144 height:16 range:[0,100,0.1] type:#float
-- 		spinner spn17 "Absorption:" pos:[144,80] width:144 height:16 range:[0,100,0.1] type:#float
-- 		spinner spn22 "Stepsize :" pos:[144,104] width:144 height:16 range:[0,100,0.1] type:#float
-- 		colorPicker cp1 "sigma_a" pos:[8,8] width:104 height:40
-- 		colorPicker cp2 "sigma_s" pos:[8,80] width:104 height:40 color:(color 0 0 155)
-- 	)
 	
-- 	on create do
-- 	(
 		
-- 	)
 --)

 plugin material LuxrenderMirror name:"LR Mirror" classID:#(0x35fa878, 0x324a4aca) extends:Standard replaceUI:true version:1
( 
	parameters main rollout:luxmirrrol
 	(
		mirror_film type:#float ui:spn23
		mirror_index type:#float ui:spn24 default:1.0
 		--mirrorkdColor type:#color default:[90,90,90] ui:cp100
		
		
 	)
	
	rollout luxmirrrol "Settings:" width:336 height:264
	(
		--colorPicker cp100 "mirror_kr" pos:[8,8] width:104 height:40 color:(color 0 0 0)
		spinner spn23 "Film :" pos:[48,64] width:144 height:16 range:[0,100,0.1] type:#float
		spinner spn24 "Film Index :" pos:[48,88] width:144 height:16 range:[0,100,0.1] type:#float
		--spinner spn13 "" pos:[40,112] width:152 height:16 range:[0,1,0.01] type:#float
		
	)
	
)

/* --// Custom
* 
* plugin material LuxrenderCustom name:"LR Custom" classID:#(0x7edf4aa5, 0xbc70695)extends:Standard replaceUI:true version:1
* (
* 	fn updateData =
* 	(
* 		materialparams = lv_params.items
* 		numparams = lv_params.items.count
* 	)
* 	
* 	parameters main rollout:params
* 	(
* 		materialtype type:#integer ui:ddl_type default:1
* 		numparams type:#integer default:0
* 		materialparams type:#stringTab tabSizeVariable:true 
* 	)
* 	
* 	rollout params "Material Parameters"
* 	(
* 		label lb_type "Material Type:" align:#left
* 		dropdownlist ddl_type "" width:201 align:#left items:#("Matte", "Matte Translucent", "Glossy", "Metal", "Shiny Metal", "Mirror", "Glass", "Rough Glass") across:2
* 		button btn_preset " Apply Preset" width:95 align:#right height:20 enabled:false
* 		label lb_1 "Param type:" across:3 align:#left
* 		label lb_2 " Param name:" align:#left
* 		label lb_3 "Param Value:" align:#left
* 		dropdownlist ddl_v1 align:#left across:3 width:100 items:#("float", "color","texture", "bool", "string")
* 		dropdownlist edtname_v1 align:#left width:100 items:#("Kd", "Ks","Kr", "Ka", "Kt", "d", "sigma", "bumpmap", "ior", "cauchyb", "name")
* 		edittext edtvalue_v1 align:#left width:100 height:20
* 		listbox lv_params ""
* 		button btn_add "Add" width:70 height:20 across:4 align:#left
* 		button btn_edt "Edit" width:70 height:20 align:#left
* 		button btn_rem "Remove" width:70 height:20 align:#left
* 		button btn_import "Import LBM" width:70 height:20 align:#left enabled:false
* 		
* 		label lb_space1 ""
* 
* 		group " Disclaimer " (
* 		label lb_Warning1 "This material is provided for advanced users of Lux Render." align:#left
* 		label lb_Warning2 "Error is the parameters can cause crash or unexpected results." align:#left
* 		label lb_Warning3 "Read the documentation located at:" align:#left
* 		label lb_Warning4 "http://www.luxrender.net/wiki/index.php/LuxRender_Materials"
* 		)
* 		
* 		on btn_add pressed do
* 		(
* 			if (ddl_v1.selection > 0) do
* 			(
* 				tmp = lv_params.items
* 				str = stringstream ""
* 				format "\"% %\" [%]" ddl_v1.selected edtname_v1.text edtvalue_v1.text to:str
* 				append tmp str
* 				lv_params.items = tmp
* 				updateData()
* 			)
* 		)
* 		
* 		on btn_rem pressed do
* 		(
* 			if (lv_params.selection > 0) do
* 			(
* 				i = lv_params.selection
* 				tmp = lv_params.items
* 				deleteItem tmp i
* 				lv_params.items = tmp
* 				updateData()
* 			)
* 		)
* 		
* 		on lv_params selected sel do
* 		(
* 			if (sel > 0) do
* 			(
* 				ddl_v1.selection = args[1] as integer
* 				edtname_v1.selection = args[2] as integer
* 				edtvalue_v1.text = args[3]
* 			)
* 		)
* 		
* 		on btn_edt pressed do
* 		(
* 			i = lv_params.selection
* 			tmp = lv_params.items
* 			str = stringstream ""
* 			format "\"% %\" [%]" ddl_v1.selected edtname_v1.text edtvalue_v1.text to:str
* 			tmp[i] = str
* 			lv_params.items = tmp
* 			updateData()
* 		)
* 		
* 		on params open do
* 		(
* 			lv_params.items = materialparams as array
* 		)
* 	)
* )
*/

/* --LuxMatte with preview
* plugin material LuxrenderMattewpreview name:"LR Matte with preview" classID:#(0x61608384, 0x4d818a72) extends:Standard replaceUI:true version:1
* ( 
* 	parameters main rollout:params
* 	(
* 		kdColor type:#color default:[90,90,90] ui:mkdColor
* 		kdTexture type:#textureMap ui:mkdTexture
* 
* 		usetranslucency type:#boolean ui:usetrans
* 		krColor type:#color default:[90,90,90] ui:mkrColor
* 		krTexture type:#textureMap ui:mkrTexture
* 		ktColor type:#color default:[90,90,90] ui:mktColor
* 		ktTexture type:#textureMap ui:mktTexture
* 		
* 		useSigma type:#boolean ui:museSigma
* 		sigma type:#float ui:msigma
* 		sigmaTexture type:#textureMap ui:msigmaTexture
* 		
* 		useBumpmap type:#boolean ui:museBumpmap
* 		bumpmap type:#float ui:mbumpmap
* 		bumpmapTexture type:#textureMap ui:mbumpmapTexture
* 		
* 		emission type:#boolean ui:memission
* 		emissionTexture type:#textureMap ui:memissionTexture
* 		
* 		useSubdivision type:#boolean ui:museSubdivision
* 		subdivision type:#integer ui:mSubdivision
* 		isSharpen type:#boolean ui:mSharpenBounds
* 		isSmooth type:#boolean ui:mSmooth
* 		
* 		useDisplacement type:#boolean ui:museDisplacement
* 		displacement type:#float ui:mdisplacement
* 		displacementTexture type:#textureMap ui:mdisplacementTexture
* 	)
* 	
* 	rollout params "Matte Parameters"
* 	(
* 				group "Preview"
* 		(
* 			bitmap BitmapImage pos:[20,30]  bitmap:(bitmap 110 110)
* 			checkbox pr_hq "High Quality" pos:[145,100] 
* 			button mat_prev_mat "Preview" pos:[145,125] 
* 			progressbar doit_prog color:red
* 		)
* 		-- Basic matte parameters
* 		group "Basic Parameters" (
* 			label lb_diffuse "Diffuse . . . . . . . . ." align:#left across:3
* 			colorpicker mkdColor "" across:2 height:18 
* 			mapbutton mkdTexture"None" width:120 height:18 align:#right
* 		)
* 	
* 		group "Advanced Parameters"
* 		(
* 			-- Oren-Nayar parameters
* 			checkbox museSigma "Sigma . . . . . . ." across:3
* 			spinner msigma "" range:[0,100,0] width:68 align:#left
* 			mapbutton msigmaTexture "T" width:120 height:18 align:#right
* 
* 			-- Bumpmap parameters
* 			checkbox museBumpmap "Bumpmap . . . ." across:3
* 			spinner mbumpmap "" scale:0.01 range:[0,1,0] width:68 align:#left
* 			mapbutton mbumpmapTexture "T" width:120 height:18 align:#right
* 	
* 			-- Emission paramters
* 			checkbox memission "Emission Texture . . . . . . . . ." across:2 enabled:false
* 			mapbutton memissionTexture "T" width:120 height:18 align:#right
* 		)
* 		
* 		on museSigma changed s do
* 		(
* 			msigma.enabled = s
* 			msigmaTexture.enabled = s
* 		)
* 		on museBumpmap changed s do
* 		(
* 			mbumpmap.enabled = s
* 			mbumpmapTexture.enabled = s
* 		)
* 		on memission changed s do
* 		(
* 			memissionTexture.enabled = s
* 		)
* 		group "Translucency Parameters"
* 		(
* 			checkbox usetrans "Translucency"
* 			label lb_reflection "Reflection . . . . . . ." align:#left across:3
* 			colorpicker mkrColor "" height:18 
* 			mapbutton mkrTexture"None" width:120 height:18 align:#right
* 			label lb_transmission "Transmission . . . . ." align:#left across:3
* 			colorpicker mktColor "" height:18 
* 			mapbutton mktTexture"None" width:120 height:18 align:#right
* 		)
* 		on usetrans changed s do
* 		(
* 			mkrColor.enabled = s
* 			mkrTexture.enabled = s
* 			mktColor.enabled = s
* 			mktTexture.enabled = s
* 			lb_reflection.enabled = s
* 			lb_transmission.enabled = s
* 			
* 			if (s == true) then
* 			(
* 				lb_diffuse.enabled = false
* 				mkdColor.enabled = false
* 				mkdTexture.enabled = false	
* 			)
* 			else
* 			(
* 				lb_diffuse.enabled = true
* 				mkdColor.enabled = true
* 				mkdTexture.enabled = true	
* 			)
* 		)
* 		group "Subdivision Parameters"
* 		(
* 			checkbox museSubdivision "Subdivision . . ." across:3 enabled:true
* 			spinner msubdivision "" scale:1 range:[0,12,0] type:#integer width:68 align:#left
* 			label lb0 ""
* 			checkbox mSharpenBounds "Sharpen Bounds" enabled:false
* 			checkbox mSmooth "Smooth" enabled:false
* 		)
* 		on museSubdivision changed s do
* 		(
* 			msubdivision.enabled = s
* 			mSharpenBounds.enabled = s
* 			mSmooth.enabled = s
* 		)
* 		group "Displacement Map Parameters"
* 		(
* 			checkbox museDisplacement "Displacement . ." across:3  enabled:true
* 			spinner mdisplacement "" scale:0.1 range:[-10,10,0] width:68 align:#left
* 			mapbutton mDisplacementTexture "T" width:120 height:18 align:#right
* 		)
* 		on museDisplacement changed s do
* 		(
* 			mdisplacement.enabled = s
* 			mDisplacementTexture.enabled = s
* 		)
* 		
* 		fn preview_scene_matte = 
* (
* out_name = "C:\\Users\\hedphelym\\Desktop\\Luxrender\\sphere_preview.lxs"
* out_file = createfile out_name
* Format "LookAt 0.0 -3.0 0.5 0.0 -2.0 0.5 0.0 0.0 1.0\nCamera \"perspective\" \"float fov\" [22.5]\n\n" to:out_file
* Format "Film \"fleximage\"\n \"integer xresolution\" [110]\n\"integer yresolution\" [110]\n\"integer displayinterval\" [3]\n" to:out_file
* Format "\"integer ldr_writeinterval\" [3600]\n\"string tonemapper\" [\"reinhard\"]\n\"integer haltspp\" [1]\n" to:out_file
* Format "\"integer reject_warmup\" [64]\n\"bool write_tonemapped_tga\" [\"false\"]\n\"bool write_untonemapped_exr\" [\"false\"]\n" to:out_file
* Format "\"bool write_tonemapped_exr\" [\"false\"]\n\"bool write_untonemapped_igi\" [\"false\"]\n\"bool write_tonemapped_igi\" [\"false\"]\n\n" to:out_file
* Format "Sampler \"lowdiscrepancy\" \"string pixelsampler\" [\"hilbert\"] \"integer pixelsamples\" [2]\n\n" to:out_file
* Format "WorldBegin\n\nAttributeBegin\nTransform [0.5 0.0 0.0 0.0  0.0 0.5 0.0 0.0  0.0 0.0 0.5 0.0  0.0 0.0 0.5 1.0]\n\n" to:out_file
* Format "TransformBegin\nScale 1 1 1\n" to:out_file
* If usetrans.checked then 
* Format "Material \"mattetranslucent\"\n\"color Kr\" [% % %]\n\"color Kt\" [% % %]\n" (mkrColor.color.r*1/255) (mkrColor.color.g*1/255) (mkrColor.color.b*1/255)  (mktColor.color.r*1/255) (mktColor.color.g*1/255) (mktColor.color.b*1/255) to:out_file
* else 
* Format "Material \"matte\"\n\"color Kd\" [% % %]\n"(mkdColor.color.r*1/255) (mkdColor.color.g*1/255) (mkdColor.color.b*1/255) to:out_file
* Format "TransformEnd\nShape \"sphere\" \"float radius\" [1.0]\nAttributeEnd\nAttributeBegin\n" to:out_file
* Format "Transform [5.0 0.0 0.0 0.0  0.0 5.0 0.0 0.0  0.0 0.0 5.0 0.0  0.0 0.0 0.0 1.0]\nTexture \"checks\" \"color\" \"checkerboard\"\n" to:out_file
* Format "\"integer dimension\" [2] \"string aamode\" [\"supersample\"] \"color tex1\" [0.9 0.9 0.9] \"color tex2\" [0.0 0.0 0.0]\n\"string mapping\" [\"uv\"] \"float uscale\" [36.8] \"float vscale\" [36.0]\n" to:out_file
* Format "Material \"matte\" \"texture Kd\" [\"checks\"]\nShape \"loopsubdiv\" \"integer nlevels\" [3] \"bool dmnormalsmooth\" [\"true\"] \"bool dmsharpboundary\" [\"false\"]\n" to:out_file
* Format "\"integer indices\" [ 0 1 2 0 2 3 1 0 4 1 4 5 5 4 6 5 6 7 ]\n" to:out_file
* Format "\"point P\" [ 1.000000 1.000000 0.000000 -1.000000 1.000000 0.000000 -1.000000 -1.000000 0.000000 1.000000 -1.000000 0.000000 1.000000 3.000000 0.000000 -1.000000 3.000000 0.000000 1.000000 3.000000 2.000000 -1.000000 3.000000 2.000000\n" to:out_file
* Format "] \"normal N\" [ 0.000000 0.000000 1.000000 0.000000 0.000000 1.000000 0.000000 0.000000 1.000000 0.000000 0.000000 1.000000 0.000000 -0.707083 0.707083 0.000000 -0.707083 0.707083 0.000000 -1.000000 0.000000 0.000000 -1.000000 0.000000\n" to:out_file
* Format "] \"float uv\" [ 0.333334 0.000000 0.333334 0.333334 0.000000 0.333334 0.000000 0.000000 0.666667 0.000000 0.666667 0.333333 1.000000 0.000000 1.000000 0.333333 ]" to:out_file
* Format "AttributeEnd\n\nAttributeBegin\n" to:out_file
* Format "Transform [1.0 0.0 0.0 0.0  0.0 1.0 0.0 0.0  0.0 0.0 1.0 0.0  1.0 -4.0 1.0 1.0]" to:out_file
* Format "Texture \"pL\" \"color\" \"blackbody\" \"float temperature\" [6500.0]\nLightSource \"point\" \"texture L\" [\"pL\"]\nAttributeEnd\nWorldEnd" to:out_file
* close out_file
* gc()
* )
* 
* on mat_prev_mat pressed do 
* (
* preview_scene_matte()
* out_nam = "C:\\Users\\hedphelym\\Desktop\\Luxrender\\render.bat"
* out_bat = createfile out_nam
* Format "C:\Users\hedphelym\Desktop\Luxrender\luxconsole.exe sphere_preview.lxs" to:out_bat
* close out_bat
* shelllaunch "C:\Users\hedphelym\Desktop\Luxrender\render.bat" ""
* sleep 6
* BitmapImage.filename = "C:\\Users\\hedphelym\\Desktop\\Luxrender\\luxout.png"
* )
* 		
* 		on params open do
* 		(
* 			msigma.enabled = museSigma.state
* 			msigmaTexture.enabled = museSigma.state
* 			
* 			mbumpmap.enabled = museBumpmap.state
* 			mbumpmapTexture.enabled = museBumpmap.state
* 			
* 			memissionTexture.enabled = memission.state
* 			
* 			msubdivision.enabled = museSubdivision.state
* 			mSharpenBounds.enabled = museSubdivision.state
* 			mSmooth.enabled = museSubdivision.state
* 			
* 			mdisplacement.enabled = museDisplacement.state
* 			mDisplacementTexture.enabled = museDisplacement.state
* 			
* 			lb_reflection.enabled = usetrans.state
* 			lb_transmission.enabled = usetrans.state
* 			mkrColor.enabled = usetrans.state
* 			mkrTexture.enabled = usetrans.state
* 			mktColor.enabled = usetrans.state
* 			mktTexture.enabled = usetrans.state
* 			
* 			if (usetrans.state == true) then
* 			(
* 				lb_diffuse.enabled = false
* 				mkdColor.enabled = false
* 				mkdTexture.enabled = false
* 			)
* 		)
* 	)
* )
*/

--// Car Paintm

plugin material LuxrenderCarPaint name:"LR Car Paint" classID:#(0x4d900917, 0x6546d259) extends:Standard replaceUI:true version:1
( 
	parameters main rollout:params
	(
		paintname type:#integer ui:mname default:1
		useka type:#boolean default:false ui:museabsorption
		kacolor type:#color default:[90,90,90] ui:mAbsorption
		katexture type:#textureMap ui:mAbsorptionTexture
		kadepth type:#float ui:mDepth default:4
		
		useBumpmap type:#boolean ui:museBumpmap
		bumpmap type:#float ui:mbumpmap
		bumpmapTexture type:#textureMap ui:mbumpmapTexture
		
		useSubdivision type:#boolean ui:museSubdivision
		Subdivision type:#float ui:mSubdivision
		isSharpen type:#boolean ui:mSharpenBounds
		isSmooth type:#boolean ui:mSmooth
		
		useDisplacement type:#boolean ui:museDisplacement
		displacement type:#float ui:mdisplacement
		displacementTexture type:#textureMap ui:mdisplacementTexture
	)

	
	rollout params "Car Paint Parameters"
	(
		dropdownlist mname "Name:"  items:#("Blue Matte", "Blue", "White", "2k Acrylack", "BMW 339", "Opel Titan", "Polaris Silber", "Ford F8")
		group "Basic Parameters" (
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
--plugin material LuxrenderCarPaint name:"LR Car Paint" classID:#(0x4d900917, 0x6546d259) extends:Standard replaceUI:true version:1
plugin material LuxTest name:"LR Rough Glass" classID:#(0x3686056d, 0x66e575a8) extends:Standard replaceUI:true version:1
(
parameters main rollout:luxrough
 	(
		transmissioncolor type:#color default:[100,100,100] ui:mTransmission
		roughreflectioncolor type:#color default:[100,100,100] ui:mroughReflection
		uroughness type:#float default:0.001 ui:spn_exponentu
		vroughness type:#float default:0.001  ui:spn_exponentv
		ior type:#float default:1.5 ui:spn_index
		cauchyb type:#float default:0.0 ui:spn_cauchyb
		
		useTransmissionmap type:#boolean ui:mUseTransmissionMap
		useReflectionmap type:#boolean ui:mUseReflectionMap
		
		TransmissionTexture type:#textureMap ui:mTransmissionTexture
		ReflectionTexture type:#textureMap ui:mReflectionTexture
 	)
	
	rollout luxrough "Settings:" width:336 height:264
	(
		colorpicker mTransmission "Transmission color:" height:18
		checkbox mUseTransmissionMap "Transmission Texture . . . . ." across:2 enabled:true
		mapbutton mTransmissionTexture "None" width:120 height:18 align:#right enabled:false
		
		colorpicker mroughreflection "RoughReflection color:" height:18
		checkbox mUseReflectionMap "Transmission Texture . . . . ." across:2 enabled:true
		mapbutton mReflectionTexture "T" width:120 height:18 align:#right enabled:false
		
		spinner spn_exponentu "U-roughness" width:88  range:[0.000,1.000,0.001] type:#float align:#left enabled:true scale:0.001 default:0.001
		spinner spn_exponentv "V-roughness" width:88  range:[0.000,1.000,0.001] type:#float align:#left enabled:true scale:0.001 default:0.001
		spinner spn_index "IOR:" width:68  range:[0.0,100.0,0.1] type:#float align:#left enabled:true --default:1.5
		spinner spn_cauchyb "cauchyb" width:68  range:[0.0,100.0,0.1] type:#float align:#left enabled:true default:0.0
	)
	
	on useTransmissionmap changed s do
	(
		useTransmissionmap.enabled = s
	)
	
		on mUseReflectionMap changed s do
	(
		mUseReflectionMap.enabled = s
	)
)

--MatteTranslucent
plugin material LuxMatteTrans name:"LR MatteTranslucent" classID:#(0x40755a6a, 0x4f0109c6) extends:Standard replaceUI:true version:1
(
parameters main rollout:paramsEm
	(
		--AreaLightSourceMap type:#textureMap ui:m_emissionTexture
		
		diffusecolor type:#color default:[100,100,100] ui:mDiffuse
		transmitivitycolor type:#color default:[100,100,100] ui:mTransmission
		sigma type:#float default:1.5 ui:spn_sigma
		
	
	)
	
	rollout paramsEm "settings" width:160 height:104
	(
		--mapButton m_emissionTexture "T" pos:[-69,7] width:300 height:20
		colorpicker mDiffuse "diffuse color:" height:18
		colorpicker mTransmission "Transmission color:" height:18
		spinner spn_sigma "sigma" width:68  range:[0.0,100.0,0.1] type:#float align:#left enabled:true default:0.0
		
	)
	on paramsEm open do
	(
		--AreaLightSourceMap = LuxrenderBlackbody()
		
	)
)


	/* plugin material LuxMix name:"LR Mix" classID:#(0x166c0818, 0x1c027268) extends:Standard replaceUI:true version:1
	(
		parameters main rollout:main
		(
			--TransmissionTexture type:#textureMap ui:mTransmissionTexture
			namedmaterial1 type:#textureMap ui:mnamedmaterial1
			namedmaterial2 type:#textureMap ui:mnamedmaterial2
			mixmat type:#float ui:spn_mix default:0.5
			
		)
		rollout main "Settings" width:160 height:104
		(
			mapButton mnamedmaterial1 "T" pos:[13,7] width:120 height:18 enabled:true
			spinner spn_mix "Mix amount:" pos:[46,30] width:68 height:16 enabled:true range:[0,1,0.1] type:#float default:0.5
			mapButton mnamedmaterial2 "T" pos:[13,51] width:120 height:18 enabled:false
			
			on mnamedmaterial1 picked texmap do
			(
			--picked
				
				mtlBrowser.browseFrom #scene #mats
				
			)
			
			on mnamedmaterial2 picked texmap do
			(
				mtlBrowser.browseFrom #scene #mats
				
			)
			
		)
		
	) */