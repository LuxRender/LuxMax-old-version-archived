--Class_ID(0x6c044fc0, 0x11b5394c)
dxshadermanager.SetVisible false
mental_ray_Preferences.mrExtensionsActive =  false

plugin light LuxSun name:"LR Sun" classID:#(0x6c044fc0, 0x11b5394c) extends:SkyLight replaceUI:true version:1 category:"Luxrender"
(
	local lastR1, meshObj
	
	parameters pblock rollout:params 
	(
		gain type:#float ui:spn_gain default:1 animatable:true
		nsamples type:#integer default:1 ui:spn_nsamples animatable:true
		turbidity type:#float ui:spn_turbidity default:2 animatable:true
		relsize type:#float UI:spn_relsize default:1.0 animatable:true
		
		radius1 type:#float animatable:true default:20.0
	)
	
	rollout params "LR Sun" width:162 height:143
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