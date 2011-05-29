plugin light LuxSky name:"LR Sky" classID:#(0x42905cfe, 0x20037237) extends:SkyLight replaceUI:true version:1 category:"LuxRender"
(
	parameters pblock0 rollout:params0
	(
		gain type:#float ui:spn_gain default:1 animatable:true
		nsamples type:#integer default:1 ui:spn_nsamples animatable:true
		importance type:#float ui:spn_importance default:1
		exterior type:#node ui:mExterior
		lightgroup type:#string ui:edt_group default:"default"
	)
	
	parameters pblock1 rollout:params1
	(
		type type:#integer ui:ddl_type default:3
		turbidity type:#float ui:spn_turbidity default:2.2
		horizonbrightness type:#float ui:spn_horizonbrightness default:1
		horizonsize type:#float ui:spn_horizonsize default:1
		sunhalobrightness type:#float ui:spn_sunhalobrightness default:1
		sunhalosize type:#float ui:spn_sunhalosize default:1
		backscattering type:#float ui:spn_backscattering default:1
	)
	
	rollout params0 "LuxRender Lamps"
	(
		fn volumeFilter obj = ((classof obj) as string == "LuxRenderVolume")
		
		spinner spn_gain "Gain:" width:136 fieldwidth:55 align:#right
		spinner spn_importance "Importance:" width:136 fieldwidth:55 align:#right
		spinner spn_nsamples "Samples:"width:136 type:#integer fieldwidth:55 align:#right

		group "Common"
		(
			label lbl_group "Light Group:" align:#left
			edittext edt_group "" align:#right width:138 text:"default"
			label lbexterior "Exterior:" align:#left
			pickbutton mExterior "none" width:138 height:20 align:#right autoDisplay:true filter:volumeFilter
		)
		
		on mExterior rightclick do
		(
			mExterior.text = "none"
			exterior = undefined
		)
	)
	rollout params1 "LuxRender Sky"
	(
		dropdownlist ddl_type "Sky Type:" items:#("Sun Only","Sky Only","Sun & Sky")
		spinner spn_turbidity "Turbidity:" width:136 range:[0.70,50,0]  fieldwidth:40 align:#right
		spinner spn_horizonbrightness "Horizon Brightness:" width:136 range:[0,1.32,1]  fieldwidth:40 align:#right
		spinner spn_horizonsize "Horizon Size:" width:136 range:[1,10,1]  fieldwidth:40 align:#right
		spinner spn_sunhalobrightness "Halo brightness:" width:136 range:[1,10,1]  fieldwidth:40 align:#right
		spinner spn_sunhalosize "Halo Size:" width:136 range:[1,10,0]  fieldwidth:40 align:#right
		spinner spn_backscattering "Back Scattering:" width:136 range:[1,10,0]  fieldwidth:40 align:#right
		
		on ddl_type selected val do
		(
			if ddl_type.selection == 1 then
			(
				spn_turbidity.enabled = false
				spn_horizonbrightness.enabled = false
				spn_horizonsize.enabled = false
				spn_sunhalobrightness.enabled = false
				spn_sunhalosize.enabled = false
				spn_backscattering.enabled = false
			)
			if ddl_type.selection == 2 then
			(
				spn_turbidity.enabled = true
				spn_horizonbrightness.enabled = true
				spn_horizonsize.enabled = true
				spn_sunhalobrightness.enabled = false
				spn_sunhalosize.enabled = false
				spn_backscattering.enabled = false
			)
			if ddl_type.selection == 3 then
			(
				spn_turbidity.enabled = true
				spn_horizonbrightness.enabled = true
				spn_horizonsize.enabled = true
				spn_sunhalobrightness.enabled = true
				spn_sunhalosize.enabled = true
				spn_backscattering.enabled = true
			)
			
		)
		
	)
)