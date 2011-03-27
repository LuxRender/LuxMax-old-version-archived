plugin light LuxInfinite name:"LR Infinite" classID:#(0x343993e2, 0x54ccb040) extends:SkyLight replaceUI:true version:1 category:"LuxRender"
(
	include "luxmax\\fn_common.ms"
	
	parameters pblock rollout:params 
	(
		mapname type:#textureMap ui:m_texturemap
		maptype type:#integer ui:m_mapping default:1
		
		gain type:#float ui:spn_gain default:1 animatable:false
		importance type:#float ui:spn_importance default:1
		exterior type:#node ui:mExterior
		lightgroup type:#string ui:edt_group default:"default"
		
		color type:#color ui:mcolor default:white
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
			mapbutton m_texturemap "none" height:20 width:135 align:#right
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

		on m_texturemap rightclick do
		(
			m_texturemap.text = "none"
			mapname = undefined
		)
		
		on params create do
		(
			m_filename.text = mapname
		)
	)
	
	local meshObj
	
	on getDisplayMesh do
	(
		if (meshObj == undefined) do
		(
			meshObj = createInstance sphere mapCoords:false wirecolor:yellow segs:12 radius:20
		)

		return meshObj.mesh
	)
	
	tool create
	(
		on mousePoint click do
		(
			nodeTM.translation = gridPoint;#stop
		)
	)
)