dxshadermanager.SetVisible false
mental_ray_Preferences.mrExtensionsActive =  false

plugin light LuxSky name:"LR Sky" classID:#(0x42905cfe, 0x20037237) extends:SkyLight replaceUI:true version:1 category:"Luxrender"
(
	parameters pblock rollout:params 
	(
		gain type:#float ui:spn_gain default:1 animatable:true
		nsamples type:#integer default:1 ui:spn_nsamples animatable:true
		turbidity type:#float ui:spn_turbidity default:2 animatable:true
		relsize type:#float UI:spn_relsize default:1.0 animatable:true
	)
	
	rollout params "LR Sky" width:162 height:143
	(
		spinner spn_gain "Gain" pos:[16,8] width:136 height:16
		spinner spn_nsamples "NSamples" pos:[16,32] width:136 height:16 type:#integer
		spinner spn_turbidity "Turbidity" pos:[16,56] width:136 height:16 range:[0,30,0]
		spinner spn_relsize "Relative size" pos:[16,80] width:136 height:16 type:#float
		
		on params open do
		(
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