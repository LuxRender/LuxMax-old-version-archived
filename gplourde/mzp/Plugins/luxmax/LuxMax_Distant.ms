plugin light LuxDistant name:"LR Distant" classID:#(0x20b4375f, 0x53248ad9) extends:SkyLight replaceUI:true version:1 category:"LuxRender"
(
	parameters pblock0 rollout:params0
	(
		gain type:#float ui:spn_gain default:1 animatable:false
		importance type:#float ui:spn_importance default:1
		exterior type:#node ui:mExterior
		lightgroup type:#string ui:edt_group default:"default"
	)
	
	parameters pblock1 rollout:params1
	(
		color type:#color ui:mcolor default:white
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
	
	rollout params1 "LuxRender Distant"
	(
		colorpicker mcolor "Color:" height:16 width:98 align:#right
	)
)