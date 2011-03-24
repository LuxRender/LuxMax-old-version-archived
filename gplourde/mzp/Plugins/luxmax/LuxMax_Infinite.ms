dxshadermanager.SetVisible false
mental_ray_Preferences.mrExtensionsActive =  false

plugin light LuxInfinite name:"LR Infinite" classID:#(0x343993e2, 0x54ccb040) extends:SkyLight replaceUI:true version:1 category:"Luxrender"
(
	parameters pblock rollout:params 
	(
		gain type:#float ui:spn_gain default:1 animatable:false
		importance type:#float ui:spn_importance default:1
		color type:#color ui:mcolor default:white
		exterior type:#node ui:mExterior
		lightgroup type:#string ui:edt_group default:"default"
	)
	
	rollout params "LR Infinite"
	(
		fn volumeFilter obj =
		(
			(classof obj) as string == "LuxRenderVolume"
		)
		
		spinner spn_gain "Gain:" width:136 fieldwidth:55 align:#right
		spinner spn_importance "Importance:" width:136 fieldwidth:55 align:#right
		colorpicker mcolor "Color:" height:16 width:98 align:#right
		
		group "Common"
		(
			label lbl_group "Light Group:" align:#left
			edittext edt_group "" align:#right width:110 text:"default"
			label lbexterior "Exterior:" align:#left
			pickbutton mExterior "none" width:110 height:16 align:#right autoDisplay:true filter:volumeFilter
		)
		
		on params open do
		(
			mental_ray_Preferences.mrExtensionsActive = false
		)
	)
	
	tool create
	( 
		on mousePoint click do 
		(
			nodeTM.translation = gridPoint;#stop 
		)
	) 	
)