plugin Helper LuxRenderVolume
name:"LR Volume"
classID:#(0x66dad084, 0x48d0bfa0)
category:"LuxRender"
extends:dummy
(

	local lastSize, meshObj

	parameters pblock rollout:params
	(

	)
	rollout params "HelperTest Parameters"
	(

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