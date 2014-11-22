/*
***** BEGIN GPL LICENSE BLOCK *****

--------------------------------------------------------------------------
LuxMax Autodesk® 3ds Max® to Luxrender exporter
--------------------------------------------------------------------------

Authors:
Guillaume Plourde
Konstantinos Mourelas
Stig Atle Steffensen

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, see <http://www.gnu.org/licenses/>.

***** END GPL LICENCE BLOCK *****
*/

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
			dropdownlist lightstrategy "Light Strategy:" items:#("auto", "logpowerimp","allpowerimp","powerimp","importance","all","one")
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
		dropdownlist lightstrategy "Light Strategy:" items:#("auto", "logpowerimp","allpowerimp","powerimp","importance","all","one")
		spinner maxdepth "Max. depth" type:#integer range:[-9999, 9999, 16] fieldwidth:50
		dropdownlist rrstrategy "RR strategy" items:#("efficiency", "probability", "none")
		spinner rrcontinueprob "RR continue probability:" range:[-9999, 9999, 0.65] type:#float fieldwidth:50
		checkbox includeenvironment "include environment"
		checkbox directlightsampling "directlightsampling" 
		
		function GetLuxRenderString =
		(
			str = stringstream ""
			format "\nSurfaceIntegrator \"path\"\n" to:str
			luxWriteInteger "maxdepth" (getLuxValue "maxdepth") str
			luxWriteBool "includeenvironment" (getLuxValue "includeenvironment") str
			luxWriteBool "directlightsampling" (getLuxValue "directlightsampling") str
			luxWriteString "lightstrategy" (GetLuxString "lightstrategy") str
			luxWriteString "rrstrategy" (GetLuxString "rrstrategy") str
			return (str as string)
		)
		
		on lux_SurfaceIntegrator_Path open do (GetControlParams(lux_SurfaceIntegrator_Path))
	)
	rollout lux_SurfaceIntegrator_bidirectional "bidirectional"
	(
		spinner eyedepth "Eye depth:" type:#integer range:[0, 2048, 16] fieldwidth:60
		spinner lightdepth "Light depth:" type:#integer range:[0, 2048, 16] fieldwidth:60
		spinner eyerrthreshold "Eye RR Threshold:" type:#float scale:0.05 range:[-9999, 9999, 0] fieldwidth:60
		spinner lightrrthreshold "Light RR Threshold:" type:#float scale:0.05 range:[-9999, 9999, 0] fieldwidth:60
		dropdownlist strategy "Strategy:" items:#("one", "all", "auto") fieldwidth:60
		
		function GetLuxRenderString =
		(
			str = stringstream ""
			format "\nSurfaceIntegrator \"bidirectional\"\n" to:str
			luxWriteInteger "eyedepth" (getLuxValue "eyedepth") str
			luxWriteInteger "lightdepth" (getLuxValue "lightdepth") str
			luxWriteFloat "eyerrthreshold" (getLuxValue "eyerrthreshold") str
			luxWriteFloat "lightrrthreshold" (getLuxValue "lightrrthreshold") str
			luxWriteString "strategy" (GetLuxString "strategy") str
			return (str as string)
		)
		
		on lux_SurfaceIntegrator_bidirectional open do (GetControlParams(lux_SurfaceIntegrator_bidirectional))
	)
	rollout lux_SurfaceIntegrator_sppm "sppm"
	(
		spinner maxphotondepth "maxphotondepth:" type:#integer range:[0, 2048, 16] fieldwidth:60
		spinner maxeyedepth "maxeyedepth:" type:#integer range:[0, 2048, 16] fieldwidth:60
		spinner photonperpass "photonperpass:" type:#integer range:[0, 99999999, 1000000] fieldwidth:60
		spinner startradius "startradius:" type:#float scale:0.05 range:[-9999, 9999, 2] fieldwidth:60
		spinner startk "startk:" type:#integer range:[0,1000,0] fieldwidth:60
		spinner glossythreshold "glossythreshold:" type:#float range:[0,1000,0] fieldwidth:60
		spinner malpha "alpha:" type:#float scale:0.05 range:[-9999, 9999, 0.7] fieldwidth:60
		dropdownlist lookupaccel "Look up accelerator:" items:#("hybridhashgrid","kdtree","hashgrid")
		dropdownlist ddlrandom_sampler "Pixel Sampler:" items:#("vegas", "hilbert", "tile", "linear")
		checkbox includeenvironment "include environment"
		
		function GetLuxRenderString =
		(
			str = stringstream ""
			format "\nSurfaceIntegrator \"sppm\"\n" to:str
			luxWriteInteger "photonperpass" (getLuxValue "photonperpass") str
			luxWriteInteger "maxeyedepth" (getLuxValue "maxeyedepth") str
			luxWriteInteger "maxphotondepth" (getLuxValue "maxphotondepth") str
			luxWriteFloat "alpha" (getLuxValue "malpha") str
			luxWriteFloat "startradius" (getLuxValue "startradius") str
			luxWriteInteger "startk" (getLuxValue "startk") str
			luxWriteFloat "glossythreshold" (getLuxValue "glossythreshold") str
			luxWriteString "lookupaccel" (GetLuxString "lookupaccel") str
			format "\"string pixelsampler\" [\"%\"]\n" (getLuxString "ddlrandom_sampler") to:str
			luxWriteBool "includeenvironment" (getLuxValue "includeenvironment") str
			return (str as string)
		)
		
		on lux_SurfaceIntegrator_sppm open do (GetControlParams(lux_SurfaceIntegrator_sppm))
	)
	
	SurfaceIntegratorsRollouts = #(lux_SurfaceIntegrator_bidirectional, lux_SurfaceIntegrator_Path, lux_SurfaceIntegrator_ExPhotonMap, lux_SurfaceIntegrator_sppm)
)