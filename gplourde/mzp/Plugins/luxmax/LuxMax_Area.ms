plugin light luxAreaLight name:"LR Area" classID:#(0x4a005589, 0x189a7b50)extends:mr_Sky_Portal replaceUI:true version:1 category:"LuxRender"
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
	
	rollout params1 "LuxRender Area Lamp"
	(
		colorpicker mcolor "Color:" height:16 width:98 align:#right
		spinner mpower "Power:" fieldwidth:55 align:#right
		spinner mefficacy "Efficacy:" fieldwidth:55 align:#right
		
		spinner mwidth "Width:" type:#worldunits range:[0,99999999,100] fieldwidth:55 align:#right
		spinner mlength "Length:" type:#worldunits range:[0,99999999,100] fieldwidth:55 align:#right
		
		on mwidth changed val do delegate.light_width = val
		on mlength changed val do delegate.light_length = val
			
		on params1 open do
		(
			mwidth.value = delegate.light_width
			mlength.value = delegate.light_length
		)
	)
	tool create
	(
		on mousePoint click do
		case click of
		(
			1: coordsys grid (nodeTM.translation = gridPoint)
		)
		on mouseMove click do
		(
			case click of
			(
				2: (
					delegate.width = abs(gridDist.x * 2)
					delegate.length = abs(gridDist.y * 2)
					params1.mwidth.value = abs(gridDist.x * 2)
					params1.mlength.value  = abs(gridDist.y * 2)
					)
				3: (#stop)
			)
		)
	)
)