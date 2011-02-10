-- Luxrender Materials plug-ins for 3dsmax
dxshadermanager.SetVisible false
mental_ray_Preferences.mrExtensionsActive =  false
--// Matte
	fn replaceChar str oChar rChar = 
		(
			tStr = ""
			for i=1 to str.count do
			(
				if str[i] == oChar then tStr += rChar
				else tStr += str[i] 
			)
			tStr
		)
		
		
plugin material LuxrenderMatte name:"LR Matte" classID:#(0x61108483, 0x4d218a72) extends:Standard replaceUI:true version:1
( 
	parameters main rollout:params
	(
		kdColor type:#color default:[90,90,90] ui:mkdColor
		kdTexture type:#textureMap ui:mkdTexture
		--useSigma type:#boolean ui:museSigma
		--sigma type:#float ui:msigma
		--sigmaTexture type:#textureMap ui:msigmaTexture
		useBumpmap type:#boolean ui:museBumpmap
		bumpmap type:#float ui:mbumpmap
		bumpmapTexture type:#textureMap ui:mbumpmapTexture
		useEmission type:#boolean ui:museEmission
		emissionTexture type:#textureMap ui:memissionTexture
		useSubdivision type:#boolean ui:museSubdivision
		Subdivision type:#float ui:mSubdivision
		isSharpen type:#boolean ui:mSharpenBounds
		isSmooth type:#boolean ui:mSmooth
		on kdColor set val do delegate.diffuse_color = val
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
			--checkbox museSigma "Sigma ..........." across:3
			--spinner msigma "" range:[0,100,0] width:50 align:#left
		--	mapbutton msigmaTexture "T" width:128 height:16 align:#right
			
			--on museSigma changed s do
			--(
			--	msigma.enabled = s
			--	msigmaTexture.enabled = s
			--)

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
			checkbox museEmission "Emission Texture ..............." across:2
			mapbutton memissionTexture "T" width:128 height:16 align:#right
			on museEmission changed s do
			(
				memissionTexture.enabled = s
			)
			
		)
		
		group "Subdivision Parameters"
		(
			checkbox museSubdivision "Subdivision . . ." across:3 
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
		
		on params open do
		(
			--msigma.enabled = museSigma.state
			--msigmaTexture.enabled = museSigma.state
			
			mbumpmap.enabled = museBumpmap.state
			mbumpmapTexture.enabled = museBumpmap.state
			memissionTexture.enabled = museEmission.state
			
		)
	)
)

--// Glossy

plugin material LuxrenderGlossy name:"LR Glossy" classID:#(0xfe1ebdc, 0x3b7b37e6) extends:Standard replaceUI:true version:1
( 
	parameters main rollout:params
	(
		kdcolor type:#color default:[90,90,90] ui:mDiffuse
		on kdColor set val do delegate.diffuse_color = val
			
		kdtexture type:#textureMap ui:mDiffuseTexture
		kscolor type:#color default:[90,90,90] ui:mSpec
		kstexture type:#textureMap ui:mSpecTexture
		useka type:#boolean default:false ui:museabsorption
		kacolor type:#color default:[90,90,90] ui:mAbsorption
		katexture type:#textureMap ui:mAbsorptionTexture
		kadepth type:#float ui:mDepth default:0.15
		
		uroughness type:#float default:0.1 ui:spn_exponentu
		vroughness type:#float default:0.1 ui:spn_exponentv
		--spinner spn_exponentv "V-roughness" width:88  range:[0.000,1.000,0.001] type:#float align:#left enabled:true scale:0.001 default:0.001
		uroughnesstexture type:#textureMap ui:b_exponentuTexture
		vroughnesstexture type:#textureMap ui:b_exponentvTexture
		
		useBumpmap type:#boolean ui:museBumpmap
		bumpmap type:#float ui:mbumpmap
		bumpmapTexture type:#textureMap ui:mbumpmapTexture
		
		useEmission type:#boolean ui:museEmission
		emissionTexture type:#textureMap ui:memissionTexture
		
		useSubdivision type:#boolean ui:museSubdivision
		Subdivision type:#float ui:mSubdivision
		isSharpen type:#boolean ui:mSharpenBounds
		isSmooth type:#boolean ui:mSmooth
		
		useDisplacement type:#boolean ui:museDisplacement
		displacement type:#float ui:mdisplacement
		displacementTexture type:#textureMap ui:mdisplacementTexture
		
		useGlossylossy type:#boolean ui:museGlossylossy
		
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
			useka = s
			print "useKa"
			print useKa
		)
		group "Advanced Parameters"
		(
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
			checkbox museEmission "Emission Texture ..............." across:2
			mapbutton memissionTexture "T" width:128 height:16 align:#right
			on museEmission changed s do
			(
				memissionTexture.enabled = s
			)
		)
		
		on museBumpmap changed s do
		(
			mbumpmap.enabled = s
			mbumpmapTexture.enabled = s
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
			
			memissionTexture.enabled = museEmission.state
			
			msubdivision.enabled = museSubdivision.state
			mSharpenBounds.enabled = museSubdivision.state
			mSmooth.enabled = museSubdivision.state
			
			mdisplacement.enabled = museDisplacement.state
			mDisplacementTexture.enabled = museDisplacement.state
		)
		group "Glossy Lossy Material"
		(
			checkbox museGlossylossy "Use GlossyLossy" align:#left across:3
		)
		on museGlossylossy s do
		(
			museGlossyLossy.enabled = s
		)
	)
)

--// Glass

plugin material LuxrenderGlass name:"LR Glass" classID:#(0x1416e9d, 0x5f7312b0)extends:Standard replaceUI:true version:1
( 
	parameters main rollout:params
	(
		ktcolor type:#color default:[255,255,255] ui:mktcolor
		on ktcolor set val do delegate.diffuse_color = val
		kttexture type:#textureMap ui:mkttexture
		krcolor type:#color default:[255,255,255] ui:mkrcolor
		krTexture type:#textureMap ui:mkrtexture
		usearchitectural type:#boolean default:false ui:musearchitectural
		ior type:#float ui:spn_ior default:1.5
		iortexture type:#textureMap ui:miortexture
		useBumpmap type:#boolean ui:museBumpmap
		bumpmap type:#float ui:mbumpmap
		bumpmapTexture type:#textureMap ui:mbumpmapTexture
		usedispersive type:#boolean ui:musedispersive
		cauchyb type:#float ui:mcauchyb
	
	)
	
	
	rollout params "Glass Parameters"
	(
	group  "Main Parameters"
	(
		colorpicker mktcolor "Transmission: " pos:[11,20] align:#left height:18
		mapbutton mkttexture"None" width:128 height:20 pos:[180,20] align:#right 
		colorpicker mkrcolor "Reflection: " pos:[11,60] 
		mapbutton mkrtexture"None" width:128 height:20 pos:[180,60]
	)

	group "IOR Parameters"
	(
		spinner spn_ior "IOR:" range:[1,50,1.5] pos:[11,110]  width:68 align:#left default:1.51
		mapButton miortexture "T" width:128 height:20 pos:[180,110] align:#right 
		checkbox musearchitectural "enable architectural mode" align:#left enabled:true
	)
	
	
	on museior changed s do
	(
		spn_ior.enabled = s
		miortexture.enabled = s
		musearchitectural.enabled =s
	)
	
	group "Bump Parameters"
	
	(
	        checkbox museBumpmap "Bump" enabled:true pos:[10,200] align:#left
			spinner mbumpmap "" scale:0.01 range:[0,1,0] pos:[80,200] width:68 align:#left
			mapbutton mbumpmapTexture "T" pos:[180,200]  align:#right height:20 width:128
	)
	
	on museBumpmap changed s do
	(
			mbumpmap.enabled = s
			mbumpmapTexture.enabled = s
	)
	
	group "Dispersive Refraction"
	
	(
		checkbox musedispersive "Use Dispersive Refraction" enabled:true pos:[10,260] align:#left
		spinner mcauchyb "cauchyb value" range:[0,1,0.5] pos:[220,260] align:#right width:68
	)
	
	on musedispersive changed s do
	(
		mcauchyb.enabled = s
	)
	
	on params open do
		(
		mbumpmap.enabled = museBumpmap.state
		mbumpmapTexture.enabled = museBumpmap.state
		mcauchyb.enabled = musedispersive.state
			
		)
		
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
	--on paramsEm open do
	--(
--		AreaLightSourceMap = LuxrenderBlackbody()
--	)
	
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
		nkdatapath type:#string ui:lbl7 default:""
		usenkdata type:#integer default:0
		
		useBumpmap type:#boolean ui:museBumpmap
		bumpmap type:#float ui:mbumpmap
		bumpmapTexture type:#textureMap ui:mbumpmapTexture
		useEmission type:#boolean ui:museEmission
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

	
	rollout params "Metal Parameters" width:260 height:416
	(
		dropdownList mname "Name:" pos:[8,8] width:136 height:40 items:#("Aluminium", "Amorphous carbon", "Gold", "Copper", "NK Data")
		
		GroupBox grp1 "Advanced Parameters" pos:[4,69] width:252 height:112
		label lb_exponentu "U-Exponent . . . . . . " pos:[8,88] width:95 height:13 enabled:true across:3
		spinner spn_exponentu "" pos:[80,88] width:68 height:16 enabled:true range:[0.001,1,0.001] type:#float scale:0.001
		mapButton spn_exponentuTexture "None" pos:[152,88] width:96 height:18 enabled:false  align:#right
		label lb_exponentv "V-Exponent . . . . . . " pos:[8,112] width:94 height:13 enabled:true across:3
		spinner spn_exponentv "" pos:[80,111] width:68 height:16 enabled:true range:[0.001,1,0.001] type:#float scale:0.001
		mapButton spn_exponentvTexture "None" pos:[152,112] width:96 height:18 enabled:false

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
			checkbox museEmission "Emission Texture ..............." across:2
			mapbutton memissionTexture "T" width:128 height:16 align:#right
			on museEmission changed s do
			(
				memissionTexture.enabled = s
			)
		

		GroupBox grp2 "Subdivision Parameters" pos:[4,186] width:154 height:81
		checkbox museSubdivision "Subdivision . . ." pos:[8,200] width:96 height:15 enabled:true across:3
		spinner mSubdivision "" pos:[104,200] width:50 height:16 enabled:false range:[0,1,20] type:#integer scale:1
		label lb0 "" pos:[125,205] width:0 height:13
		checkbox mSharpenBounds "Sharpen Bounds" pos:[13,226] width:103 height:15 enabled:false
		checkbox mSmooth "Smooth" pos:[13,246] width:60 height:15 enabled:false
		GroupBox grp3 "Displacement Map Parameters" pos:[0,272] width:154 height:43
		checkbox museDisplacement "Displacement . ." pos:[13,291] width:100 height:15 enabled:true across:3
		spinner mdisplacement "" pos:[58,291] width:50 height:16 range:[-10,10,0] scale:0.1
		mapButton mdisplacementTexture "T" pos:[28,291] width:120 height:18  align:#right
		label lbl7 "NkData" pos:[8,56] width:144 height:16
		
		on params open do
		(
			mbumpmap.enabled = museBumpmap.state
			mbumpmapTexture.enabled = museBumpmap.state
			
			memissionTexture.enabled = museEmission.state
			
			msubdivision.enabled = museSubdivision.state
			mSharpenBounds.enabled = museSubdivision.state
			mSmooth.enabled = museSubdivision.state
			
			mdisplacement.enabled = museDisplacement.state
			mDisplacementTexture.enabled = museDisplacement.state
			--lbl7.text = nkdatapath
		)
		on mname selected i do
		(
			usenkdata = 0
			
			format "You selected '%'!\n" mname.items[i]
			if (mname.items[i] == "NK Data")then
			(
				--print "NkData selection works!!!!!!"
				
				f = getOpenFileName types:"NkData(*.nk)|*.nk" caption:"Open A NK Data File:" --\ 
				--filename:"c:/test/test.nk"
				if (f != undefined)then
				(
					
					
					nkdatapath = f
					lbl7.text =f as string
					print f
					usenkdata = 1
					print usenkdata as string					
					
					temppath = (f)
					print temppath
					temppathfixed = replaceChar (temppath as string) "\\" "\\\\"
					print temppathfixed
					print "end found nk data"
					nkdatapath = temppathfixed
					print nkdatapathm
				)
				else
				(
					usenkdata = 1
					nkdatapath = "No Nk file selected"
					lbl7.text =nkdatapath as string
				)
			)
			print usenkdata as string
			
		)
		on museBumpmap changed s do
		(
			mbumpmap.enabled = s
			mbumpmapTexture.enabled = s
		)
		on mbumpmapTexture picked texmap do
		(
		bumpmaptexture = kttexture
		)
		on memission changed s do
		(
			memissionTexture.enabled = s
		)
		on museSubdivision changed s do
		(
			msubdivision.enabled = s
			mSharpenBounds.enabled = s
			mSmooth.enabled = s
		)
		on museDisplacement changed s do
		(
			mdisplacement.enabled = s
			mDisplacementTexture.enabled = s
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
		mirror_index type:#float ui:spn24 default:1.5
 		mirrorkdColor type:#color default:[90,90,90] ui:cp100
		
		
 	)
	
	rollout luxmirrrol "Settings:" width:336 height:264
	(
		colorPicker cp100 "mirror_kr" pos:[8,8] width:104 height:40 color:(color 0 0 0)
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
		kdcolor type:#color default:[90,90,90] ui:mDiffuse
		on kdColor set val do delegate.diffuse_color = val
		kdtexture type:#textureMap ui:mDiffuseTexture
		ks1color type:#color default:[90,90,90] ui:mSpec1
		ks1texture type:#textureMap ui:mSpec1Texture
		ks2color type:#color default:[90,90,90] ui:mSpec2
		ks2texture type:#textureMap ui:mSpec2Texture
		ks3color type:#color default:[90,90,90] ui:mSpec3
		ks3texture type:#textureMap ui:mSpec3Texture
		floatR1 type:#float default:1.0 ui:mfloatR1
		floatR1texture type:#textureMap ui:mfloatR1texture
		floatR2 type:#float default:1.0 ui:mfloatR2
		floatR2texture type:#textureMap ui:mfloatR2texture
		floatR3 type:#float default:1.0 ui:mfloatR3
		floatR3texture type:#textureMap ui:mfloatR3texture
		floatM1 type:#float default:1.0 ui:mfloatM1
		floatM1texture type:#textureMap ui:mfloatM1texture
		floatM2 type:#float default:1.0 ui:mfloatM2
		floatM2texture type:#textureMap ui:mfloatM2texture
		floatM3 type:#float default:1.0 ui:mfloatM3
		floatM3texture type:#textureMap ui:mfloatM3texture
		
		
		useka type:#boolean default:false ui:museabsorption
		kacolor type:#color default:[90,90,90] ui:mAbsorption
	--	katexture type:#textureMap ui:mAbsorptionTexture
		kadepth type:#float ui:mDepth default:4
		
		useBumpmap type:#boolean ui:museBumpmap
		bumpmap type:#float ui:mbumpmap
		--bumpmapTexture type:#textureMap ui:mbumpmapTexture
		
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
		
		group "Basic Parameters" (
			label lbDiffuse "Diffuse . . . . . . . . . " align:#left across:3
			colorpicker mDiffuse "" align:#left height:18
			mapbutton mDiffuseTexture"None" width:120 height:18 align:#right
			label lbSpecular1 "Specular1 . . . . . . . ." across:3 align:#left
			colorpicker mSpec1 ""  align:#left height:18
			mapbutton mSpec1Texture"None" width:120 height:18 align:#right
			label lbSpecular2 "Specular2 . . . . . . . ." across:3 align:#left
			colorpicker mSpec2 ""  align:#left height:18
			mapbutton mSpec2Texture"None" width:120 height:18 align:#right
			label lbSpecular3 "Specular3 . . . . . . . ." across:3 align:#left
			colorpicker mSpec3 ""  align:#left height:18
			mapbutton mSpec3Texture"None" width:120 height:18 align:#right
			label lbfloatR1 "FloatR1" across:3 align:#left
			spinner mfloatR1 "" scale:0.01 range:[0,1,0] width:68 align:#left
			mapbutton mfloatR1Texture "T" width:120 height:18 align:#right
			label lbfloatR2 "FloatR2" across:3 align:#left
			spinner mfloatR2 "" scale:0.01 range:[0,1,0] width:68 align:#left
			mapbutton mfloatR2Texture "T" width:120 height:18 align:#right
			label lbfloatR3 "FloatR3" across:3 align:#left
			spinner mfloatR3 "" scale:0.01 range:[0,1,0] width:68 align:#left
			mapbutton mfloatR3Texture "T" width:120 height:18 align:#right
			label lbfloatM1 "FloatM1" across:3 align:#left
			spinner mfloatM1 "" scale:0.01 range:[0,1,0] width:68 align:#left
			mapbutton mfloatM1Texture "T" width:120 height:18 align:#right
			label lbfloatM2 "FloatM2" across:3 align:#left
			spinner mfloatM2 "" scale:0.01 range:[0,1,0] width:68 align:#left
			mapbutton mfloatM2Texture "T" width:120 height:18 align:#right
			label lbfloatM3 "FloatM3" across:3 align:#left
			spinner mfloatM3 "" scale:0.01 range:[0,1,0] width:68 align:#left
			mapbutton mfloatM3Texture "T" width:120 height:18 align:#right
		)

		group "Advanced Parameters"
		(
			--Absorption parameters
			checkbox museabsorption "Absorption . . . ." align:#left across:3
			colorpicker mAbsorption "" align:#left height:18 enabled:false
			--mapbutton mAbsorptionTexture "None" width:120 height:18 align:#right enabled:false
			label lb_depth "Absorption Depth" align:#left across:3
			spinner mDepth "" width:60 align:#right range:[0,15,0.15] scale:0.01
			-- Bumpmap parameters
			checkbox museBumpmap "Bumpmap . . . ." across:3 enabled:false
			spinner mbumpmap "" scale:0.01 range:[0,1,0] width:68 align:#left
			--mapbutton mbumpmapTexture "T" width:120 height:18 align:#right
			
			-- Emission paramters
			checkbox memission "Emission Texture . . . . . . . . . . " across:2 enabled:false
			mapbutton memissionTexture "T" width:120 height:18 align:#right
		)
		on museabsorption changed s do
		(
			mAbsorption.enabled = s
			--mAbsorptionTexture.enabled = s
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
			--mAbsorption.enabled = museabsorption.state
			--mAbsorptionTexture.enabled = museabsorption.state
			
		--	mbumpmap.enabled = museBumpmap.state
		--	mbumpmapTexture.enabled = museBumpmap.state
			
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
		on transmissioncolor set val do delegate.diffuse_color = val
		roughreflectioncolor type:#color default:[100,100,100] ui:mroughReflection
		uroughness type:#float default:0.001 ui:spn_exponentu
		vroughness type:#float default:0.001  ui:spn_exponentv
		ior type:#float default:1.5 ui:spn_index
		cauchyb type:#float default:0.0 ui:spn_cauchyb
		--useTransmissionmap type:#boolean ui:mUseTransmissionMap
		--useReflectionmap type:#boolean ui:mUseReflectionMap
		kttexture type:#textureMap ui:mTransmissionTexture
		krtexture type:#textureMap ui:mReflectionTexture
 	)
	
	rollout luxrough "Settings:" width:336 height:264
	(
		colorPicker mTransmission "Transmission color:" pos:[13,7] width:134 height:18
		--checkbox mUseTransmissionMap "Transmission Texture . . . . ." across:2 
		mapButton mTransmissionTexture "None" pos:[200,8] width:120 height:18
		colorPicker mroughReflection "RoughReflection color:" pos:[32,56] width:153 height:18
	--	checkbox mUseReflectionMap "Transmission Texture . . . . ." across:2 
		mapButton mReflectionTexture "T" pos:[200,48] width:120 height:18 
 
		spinner spn_exponentu "U-roughness" pos:[42,80] width:88 height:16 enabled:true range:[0,1,0.001] type:#float scale:0.001 default:0.001
		spinner spn_exponentv "V-roughness" pos:[42,96] width:88 height:16 enabled:true range:[0,1,0.001] type:#float scale:0.001 default:0.001
		spinner spn_index "IOR:" pos:[48,112] width:68 height:16 enabled:true range:[0,100,0.1] type:#float --default:1.5
 --default:1.5
		spinner spn_cauchyb "cauchyb" pos:[48,128] width:68 height:16 enabled:true range:[0,100,0.1] type:#float default:0
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
		kdtexture type:#textureMap ui:mkdTexture
		
		on diffusecolor set val do delegate.diffuse_color = val
		transmitivitycolor type:#color default:[100,100,100] ui:mTransmission
		--sigma type:#float default:1.5 ui:spn_sigma
		--KtTexture
		KtTexture type:#textureMap ui:mTransmissionTexture
		
			--useSigma type:#boolean ui:museSigma
			--sigma type:#float ui:msigma
			--sigmaTexture type:#textureMap ui:msigmaTexture
		
	)
	
	rollout paramsEm "settings" width:296 height:96
	(
		--mapButton m_emissionTexture "T" pos:[-69,7] width:300 height:20
		colorPicker mDiffuse "diffuse color:" pos:[32,8] width:104 height:18
		colorPicker mTransmission "Transmission color:" pos:[0,30] width:134 height:18
		mapButton mkdTexture "MKDTexture" pos:[144,8] width:128 height:16
		mapButton mTransmissionTexture "transmission Texture" pos:[144,32] width:128 height:16
	--	checkbox museSigma "Sigma ..........." pos:[0,56] width:89 height:15 across:3
	--	spinner msigma "" pos:[88,56] width:50 height:16 range:[0,100,0]
	--	mapButton msigmaTexture "T" pos:[144,56] width:128 height:16
			
	--	on museSigma changed s do
	--	(
	----		msigma.enabled = s
	--		msigmaTexture.enabled = s
	--	)
	)
	on paramsEm open do
	(
		--AreaLightSourceMap = LuxrenderBlackbody()
		
	)
)


--  	 plugin material LuxMix name:"LR Mix" classID:#(0x166c0818, 0x1c027268) extends:Blend replaceUI:false version:1
--  	(
--  		parameters main rollout:main
--  		(
--  			--TransmissionTexture type:#textureMap ui:mTransmissionTexture
--  			namedmaterial1 type:#textureMap --ui:btn3
--  			namedmaterial2 type:#textureMap --ui:btn10
--  			mixmat type:#float ui:spn_mix default:0.5
--  			
--  		)
--  		rollout main "Settings" width:264 height:328
--  		(
--  			spinner spn_mix "Mix amount:" pos:[16,152] width:106 height:16 enabled:true range:[0,1,1] type:#float default:0.5
--  			listbox lbx1 "ListBox" pos:[8,32] width:248 height:6 items:(for o in  scenematerials collect o.name)
--  			listbox lbx2 "ListBox" pos:[8,184] width:248 height:8 items:(for o in  scenematerials collect o.name)
--  			
--  			on lbx1 selected sel do
--  			(
--  			--lbx1 selection changed
--  				print lbx1.selected as string
--  			)
--  		)
--  		-->print lbx1.selected as string
--  		
--  		
--  	) 

	
	plugin material LuxNullMaterial name:"LR NullMaterial" classID:#(0x128af87a, 0x6e0169dc) extends:Standard replaceUI:true version:1
	(
		parameters main rollout:paramsEm
		(
			
		)
		
		rollout paramsEm "settings" width:160 height:104
		(
			
		)
		on paramsEm open do
		(
			--AreaLightSourceMap = LuxrenderBlackbody()
			
		)
	)
	--Class_ID(0x1a82153d, 0x7175d56)
	Plugin material LuxGlass2 name:"LR Glass2" classID:#(0x1a82153d,0x7175d56)extends:standard replaceUI:true version:1
	(
		
		--  Texture "my_ior" "fresnel" "constant" "float value" [1.5]
		--  MakeNamedVolume "my_volume" "clean" "texture fresnel" ["my_ior"] "color absorption" [0.1 15 0.0]
		--  MakeNamedMaterial "mymaterial" "string type" ["glass2"]
		-- 
		--	Interior "my_volume"
		--	NamedMaterial "my_material"
		-- "constant", "cauchy", "sellmeier", "luxpop", "sopra", "preset"
		
		parameters main rollout:paramsEm
		(
			ior type:#float default:1.5 ui:spn1
			abscolor type:#color default:[90,90,90] ui:cp1
			abscolorr type:#float
			abscolorg type:#float
			abscolorb type:#float
			abscolorinverted type:#color
			preset type:#string default:"constant"
			type type:#string default:"glass2"
			volumeproperty type:#string default:"clear"
			dispersion type:#boolean default:false UI:chk1
			on abscolor set val do 
			(
				delegate.diffuse_color = val
				abscolorinverted = val
				print abscolor as string
			)
		)
		
		rollout paramsEm "settings" width:160 height:190
		(
			spinner spn1 "IOR" pos:[16,56] width:136 height:16
			colorPicker cp1 "abs Color" pos:[8,120] width:144 height:32
			dropdownList ddl1 "DropDownList" pos:[8,8] width:144 height:40 items:#("constant", "cauchy", "sellmeier", "luxpop", "sopra", "preset")
			checkbox chk1 "Dispersion" pos:[16,80] width:72 height:16
			on cp1 changed col do
			(
				print "changed"
				temp = abscolor as point3
				print temp[1] as string
				abscolorr =  255 - temp[1]
				abscolorg = 255 - temp[2]
				abscolorb = 255 - temp[3]
				print abscolorr as string
				print temp[1] as string
			)
			on ddl1 selected i do
			(
				format "You selected '%'!\n" ddl1.items[i]
				preset = ddl1.items[i]
			)
		)
	)
	
	
-- 	MakeNamedMaterial "3_SkinForearm_123.mat2"
--    "string type" ["velvet"]
--    "color Kd" [0.235145 0.031609 0.031609]
--    "float p1" [-2.000000]
--    "float p2" [10.000000]
--    "float p3" [2.000000]
--    "float thickness" [0.1000000]
	-- Class_ID(0x64952715, 0x24c86046)
	Plugin material velvet name:"LR Velvet" classID:#(0x64952715,0x24c86046)extends:standard replaceUI:true version:1
	(
		parameters main rollout:paramsEm
		(
			kdcolor type:#color default:[90,90,90] ui:cp1
			--kdColor type:#color default:[90,90,90] ui:mkdColor
			thickness type:#float default:0.1 ui:spn1 --float thickness
			p1 type:#float default:-2.0 ui:spn2
			p2 type:#float default:10.0 ui:spn3
			p3 type:#float default:2.0 ui:spn4
			on kdColor set val do delegate.diffuse_color = val
		)
		rollout paramsEm "settings" width:160 height:190
		(
			colorPicker cp1 "Color" pos:[8,8] width:144 height:32
			spinner spn1 "thickness" pos:[16,48] width:136 height:16 range:[-1000,1000,0.1] --range:[-1000,1000,0.1]
			
			spinner spn2 "P1" pos:[48,72] width:104 height:16 range:[-1000,1000,0.1]
			spinner spn3 "P2" pos:[48,96] width:104 height:16 range:[-1000,1000,0.1]
			spinner spn4 "P3" pos:[49,120] width:103 height:16  range:[-1000,1000,0.1]
		)
		
		
	)
-- 	Plugin material mixmat name:"LR Mix" classID:#(0x66c758d0, 0x26a85575)extends:Blend replaceUI:true version:1
-- 	(
-- 		parameters main rollout:paramsEm
-- 		(
-- 			
-- 		)
-- 		rollout paramsEm "settings" width:160 height:190
-- 		(
-- 			materialButton btn1 "MaterialButton" pos:[8,8] width:144 height:24
-- 			materialButton btn2 "MaterialButton" pos:[8,40] width:144 height:24
-- 			spinner spn5 "" pos:[24,72] width:128 height:16
-- 			
-- 		)
-- 		on btn1 picked mtl do
-- 		(
-- 			print mtl
-- 		)
-- 		
-- 	)
		Plugin material mixmatblend name:"LR Mix blend" classID:#(0x64c752d0, 0x26a85575)extends:Blend replaceUI:false version:1
	(
		parameters main rollout:paramsEm
		(
			mixamount type:#float default:0.5 ui:spn5
			--on mixAmount set val do delegate.test = val
			kdTexture type:#textureMap ui:mkdTexture
			
		)
		rollout paramsEm "settings" width:160 height:64
		(
			spinner spn5 "LR MIX AMOUNT" pos:[24,8] width:128 height:16
			mapbutton mkdTexture"None" width:128 height:16 align:#right
		)
		
	)
	--0x6b0906a2, 0x159a3fc0
	plugin material LuxrenderPortal2 name:"LR Portal" classID:#(0x5ed626b6, 0x586b74bd) extends:Standard replaceUI:true version:1
	(
	   rollout params "Portal Parameters"
	   (
		   
		   
	   )
	)


	
	