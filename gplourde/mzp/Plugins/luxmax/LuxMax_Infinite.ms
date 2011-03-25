dxshadermanager.SetVisible false
mental_ray_Preferences.mrExtensionsActive =  false

plugin light LuxInfinite name:"LR Infinite" classID:#(0x343993e2, 0x54ccb040) extends:SkyLight replaceUI:true version:1 category:"Luxrender"
(
	include "luxmax\\fn_common.ms"
	
	parameters pblock rollout:params 
	(
		mapname type:#string default:"" ui:m_filename
		maptype type:#integer ui:m_mapping default:1
		gain type:#float ui:spn_gain default:1 animatable:false
		importance type:#float ui:spn_importance default:1
		color type:#color ui:mcolor default:white
		exterior type:#node ui:mExterior
		lightgroup type:#string ui:edt_group default:"default"
		multiply type:#boolean ui:m_multiply default:false
	)
	
	rollout params "LR Infinite"
	(
		fn volumeFilter obj =
		(
			(classof obj) as string == "LuxRenderVolume"
		)
		
		spinner spn_gain "Gain:" width:136 fieldwidth:55 align:#right
		spinner spn_importance "Importance:" width:136 fieldwidth:55 align:#right
		colorpicker mcolor "Color:" height:18 width:98 align:#right
		
		group "HDRI Map"
		(
			button m_filename "none" width:132 height:20 align:#left
			dropdownlist m_mapping "Map Type:" items:#("Lat Long", "Angular", "Vert Cross")
			checkbox m_multiply "Multiply by color"
		)
		
		group "Common"
		(
			label lbl_group "Light Group:" align:#left
			edittext edt_group "" align:#right width:110 text:"default"
			label lbexterior "Exterior:" align:#left
			pickbutton mExterior "none" width:110 height:20 align:#right autoDisplay:true filter:volumeFilter
		)
		
		on mExterior rightclick do
		(
			mExterior.text = "none"
			exterior = undefined
		)
		
		on m_filename rightclick do
		(
			m_filename.text = "none"
			mapname = "undefined"
		)
		
		on m_filename pressed do
		(
			f = getOpenFileName types:"Image(*.*)|*.*"
			
			if (f != undefined) do
			(
				r = fixWindowsPath f
				
				m_filename.text = r
				mapname = r
			)
		)
		
		on params create do
		(
			m_filename.text = mapname
		)
		
		on params open do
		(
			mental_ray_Preferences.mrExtensionsActive = false
			m_filename.text = mapname
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