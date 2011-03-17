plugin Helper LuxRenderVolume
name:"LR Volume"
classID:#(0x66dad084, 0x48d0bfa0)
category:"LuxRender"
extends:dummy
(

	local meshObj

	parameters pblock rollout:params
	(
		ior type:#float ui:mior default:0
		absorption type:#color ui:mabsorption default:white
		absdepth type:#float ui:mdepth  default:1
		absscale type:#float ui:mscale default:1
	)
	rollout params "Volume Parameters"
	(
		dropdownlist mtype "Type:" items:#("clear")
		spinner mior "ior:" range:[0.0, 25, 0] fieldwidth:65 align:#right
		colorpicker mabsorption "Absoption:" color:white height:16 width:130 align:#right
		spinner mdepth "Abs. at depth:" range:[0.00001, 9999999, 1] align:#right fieldwidth:65 
		spinner mscale "Abs. scale:" range:[0.00001, 9999999, 1] align:#right fieldwidth:65 
		
	)
	
	on getDisplayMesh do
	(
		if (meshObj == undefined) do
		(
			meshObj = createInstance box length:20 width:20 height:20 mapCoords:false
		)

		meshObj.mesh
	)
	
	tool create
	(
		on mousePoint click do
		(
			nodeTM.translation = gridPoint;#stop
		)
	)
)