( --// Surface Integrators
	rollout lux_SurfaceIntegrator_ExPhotonMap "exphotonmap"
	(
		spinner maxdepth "Max. depth" type:#integer range:[-9999, 9999, 8] fieldwidth:50
		spinner maxphotondepth  "Max. photon depth" type:#integer range:[-9999, 9999, 10] fieldwidth:50
		spinner directphotons "Direct Photons" type:#integer range:[-9999999, 9999999, 1000000] fieldwidth:50
		spinner causticphotons "Caustic Photons" type:#integer range:[-9999999, 9999999, 20000] fieldwidth:50
		spinner indirectphotons "Indirect Photons" type:#integer range:[-9999999, 9999999, 200000] fieldwidth:50
		spinner radiancephotons "Radiance Photons" type:#integer range:[-9999999, 9999999, 200000] fieldwidth:50
		spinner nphotonsused "Number of Photons used" type:#integer range:[-9999, 9999, 50] fieldwidth:50
		spinner maxphotondist "Max. Photon Distance" type:#float range:[-9999, 9999, 0.1] fieldwidth:50
		checkbox finalgather "Final Gather"
		spinner finalgathersamples "Final Gather samples" type:#integer range:[-9999, 9999, 32] fieldwidth:50
		spinner gatherangle "Gather angle:" range:[-9999, 9999, 10] type:#float fieldwidth:50
		dropdownlist renderingmode "Rendering Mode:" items:#("path", "directlighting")
		dropdownlist rrstrategy "RR strategy" items:#("efficiency", "probability", "none")
		spinner rrcontinueprob "RR continue probability:" range:[-9999, 9999, 0.65] type:#float fieldwidth:50
		
		group "Advanced"
		(
			checkbox chk_advanced "Enable"
			spinner distancethreshold "Distance threshold:" range:[-9999, 9999, 0.75] type:#float fieldwidth:50
			edittext photonmapsfile "Photonmaps file:"
			dropdownlist lightstrategy "Light Strategy:" items:#("logpowerimp","allpowerimp","powerimp","importance","all","one","auto")
			checkbox dbg_enabledirect "dbg_enabledirect"
			checkbox dbg_enableradiancemap "dbg_enableradiancemap"
			checkbox dbg_enableindircaustic "dbg_enableindircaustic"
			checkbox dbg_enableindirdiffuse "dbg_enableindirdiffuse"
			checkbox dbg_enableindirspecular "dbg_enableindirspecular"
		)

		function GetLuxRenderString =
		(
			str = stringstream ""
			format "\nSurfaceIntegrator \"exphotonmap\"\n" to:str
			luxWriteInteger "maxdepth" (getLuxValue "maxdepth") str
			luxWriteInteger "maxphotondepth" (getLuxValue "maxphotondepth") str
			luxWriteInteger "directphotons" (getLuxValue "directphotons") str
			luxWriteInteger "causticphotons" (getLuxValue "causticphotons") str
			luxWriteInteger "indirectphotons" (getLuxValue "indirectphotons") str
			luxWriteInteger "radiancephotons" (getLuxValue "radiancephotons") str
			luxWriteInteger "nphotonsused" (getLuxValue "nphotonsused") str
			luxWriteFloat "maxphotondist" (getLuxValue "maxphotondist") str
			luxWriteBool "finalgather" (getLuxValue "finalgather") str
			luxWriteInteger "finalgathersamples" (getLuxValue "finalgathersamples") str
			luxWriteString "renderingmode" (GetLuxString "renderingmode") str
			luxWriteFloat "gatherangle" (getLuxValue "gatherangle") str
			luxWriteString "rrstrategy" (GetLuxString "rrstrategy") str
			luxWriteFloat "rrcontinueprob" (getLuxValue "rrcontinueprob") str
			
			if (chk_advanced.state == true) then
			(
				luxWriteFloat "distancethreshold" (getLuxValue "distancethreshold") str
				luxWriteString "photonmapsfile" (GetLuxString "photonmapsfile") str
				luxWriteString "lightstrategy" (GetLuxString "lightstrategy") str
				luxWriteBool "dbg_enabledirect" (getLuxValue "dbg_enabledirect") str
				luxWriteBool "dbg_enableradiancemap" (getLuxValue "dbg_enableradiancemap") str
				luxWriteBool "dbg_enableindircaustic" (getLuxValue "dbg_enableindircaustic") str
				luxWriteBool "dbg_enableindirdiffuse" (getLuxValue "dbg_enableindirdiffuse") str
				luxWriteBool "dbg_enableindirspecular" (getLuxValue "dbg_enableindirspecular") str
			)
			
			return (str as string)
		)
		
		on lux_SurfaceIntegrator_ExPhotonMap open do (GetControlParams(lux_SurfaceIntegrator_ExPhotonMap))
	)
	rollout lux_SurfaceIntegrator_Path "path"
	(
		spinner maxdepth "Max. depth" type:#integer range:[-9999, 9999, 8] fieldwidth:50

		function GetLuxRenderString =
		(
			str = stringstream ""
			format "\nSurfaceIntegrator \"path\"\n" to:str
			format "\"integer maxdepth\" [10] \n" to:str
			format "\"bool includeenvironment\" [\"true\"] \n" to:str
			format "\"string lightstrategy\" [\"one\"] \n" to:str
			format "\"string rrstrategy\" [\"efficiency\"]\n" to:str
			return (str as string)
		)
		
		on lux_SurfaceIntegrator_Path open do (GetControlParams(lux_SurfaceIntegrator_Path))
	)			
	SurfaceIntegratorsRollouts = #(lux_SurfaceIntegrator_Path, lux_SurfaceIntegrator_ExPhotonMap)
)