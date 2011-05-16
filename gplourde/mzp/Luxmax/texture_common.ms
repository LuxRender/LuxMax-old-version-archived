parameters advanced rollout:transformations
	(
		type type:#integer default:1 ui:mtype
		
		xr type:#float ui:mxr default:0
		yr type:#float ui:myr default:0
		zr type:#float ui:mzr default:0
		
		xs type:#float ui:mxs default:1
		ys type:#float ui:mys default:1
		zs type:#float ui:mzs default:1
		
		xt type:#float ui:mxt default:0
		yt type:#float ui:myt default:0
		zt type:#float ui:mzt default:0
		
		coordinates  type:#integer default:1 ui:mcoordinates 
	)

	rollout transformations "General"
	(	
			group "Texture Type"
		(
		dropdownlist mtype "Filter type:" items:#("float", "color") width:140 align:#left 
		)
		group "Scale Vector"
		(
		spinner mxs "x:" type:#float range:[0,1000,1] fieldwidth:40 across:3 align:#left
		spinner mys "y:" type:#float range:[0,1000,1] fieldwidth:40 align:#center
		spinner mzs "z:" type:#float range:[0,1000,1] fieldwidth:40 align:#right
		)
		group "Rotate Vector"
		(
		spinner mxr "x:" type:#float range:[0,360,0] fieldwidth:40 across:3 align:#left
		spinner myr "y:" type:#float range:[0,360,0] fieldwidth:40 align:#center
		spinner mzr "z:" type:#float range:[0,360,0] fieldwidth:40 align:#right
		)
		group "Translate Vector"
		(
		spinner mxt "x:" type:#float range:[-1000,1000,0] fieldwidth:40 across:3 align:#left
		spinner myt "y:" type:#float range:[-1000,1000,0] fieldwidth:40 align:#center
		spinner mzt "z:" type:#float range:[-1000,1000,0] fieldwidth:40 align:#right
		)
		group "Coordinates System"
		(
		dropdownlist mcoordinates "Space:" items:#("local", "global", "local_normal", "global_normal", "uv") align:#center across:1
		)
	)