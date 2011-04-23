try (destroyDialog lux_main) catch ()
global lux_main = "LuxMax Starting..."
(
	persistent global luxMax_Version = 1.0
	
	-- // Check the scene name for the script lifetime only
	luxMax_Scene = (getFilenameFile maxFileName)
	if (luxMax_Settings == undefined) then (persistent global luxMax_Settings = #())
	
	numlightsource = 0
	-- Cache rollouts
	lux_Dimmensions = undefined
	lux_LuxRenderEnginePresets = undefined
	lux_LuxRenderEngineConfiguration = undefined
	lux_external = undefined
	lux_Renderer = undefined
	lux_Sampler = undefined
	lux_SurfaceIntegrator = undefined
	lux_VolumeIntegrator = undefined
	lux_Filter = undefined
	lux_Accelerator = undefined
	--lux_LuxRenderNetwork = undefined
	lux_Output = undefined
	lux_Sampler_Random = undefined
	lux_Sampler_LowDiscrepancy = undefined
	lux_Sampler_ERPT = undefined
	lux_Sampler_Metropolis = undefined
	lux_SurfaceIntegrator_ExPhotonMap = undefined
	lux_SurfaceIntegrator_Path = undefined
	lux_Filter_mitchell = undefined
	lux_Film = undefined
	
	Slg_FilmRollout = undefined
	
	SurfaceIntegratorsRollouts = #()
	SamplerRollouts = #()
	FilltersRollouts =#()

	function ResetUI =
	(
		removeSubRollout lux_main.lx0 lux_external
		removeSubRollout lux_main.lx0 lux_LuxRenderEnginePresets
		removeSubRollout lux_main.lx0 lux_Renderer
		removeSubRollout lux_main.lx0 lux_Sampler
		removeSubRollout lux_main.lx0 lux_SurfaceIntegrator
		removeSubRollout lux_main.lx0 lux_VolumeIntegrator
		removeSubRollout lux_main.lx0 lux_Filter
		removeSubRollout lux_main.lx0 lux_Accelerator
		--removeSubRollout lux_main.lx0 lux_LuxRenderNetwork
		removeSubRollout lux_main.lx0 lux_Film
		removeSubRollout lux_main.lx0 lux_Output
		removeSubRollout lux_main.lx0 Slg_FilmRollout
	)
	function SetUpLuxRenderUI =
	(
		AddSubRollout lux_main.lx0 lux_external
		AddSubRollout lux_main.lx0 lux_LuxRenderEnginePresets
		AddSubRollout lux_main.lx0 lux_Renderer
		AddSubRollout lux_main.lx0 lux_Sampler
		AddSubRollout lux_main.lx0 lux_SurfaceIntegrator
		AddSubRollout lux_main.lx0 lux_VolumeIntegrator
		AddSubRollout lux_main.lx0 lux_Filter
		AddSubRollout lux_main.lx0 lux_Accelerator
		--AddSubRollout lux_main.lx0 lux_LuxRenderNetwork
		AddSubRollout lux_main.lx0 lux_Film
		AddSubRollout lux_main.lx0 lux_Output
	)
	

	
	function SetUpSLGPUUI =
	(
		AddSubRollout lux_main.lx0 Slg_FilmRollout
	)
	
	( --// Presets
		-- Add your own presets here
		
		--DimmensionsPreset #(name, x, y, ax, ay, fps, base)		
		DimmensionsPresets = #(
		#("DVCPRO HD 1080p", 1280, 1080, 3.0, 2.0, 24, 1.0),
		#("DVCPRO HD 720p", 960, 720, 4.0, 3.0, 24, 1.0),
		#("HDTV 1080p", 1920, 1080, 1.0, 1.0, 24, 1.0),
		#("HDTV 720p", 1280, 720, 1.0, 1.0, 24, 1.0)
		)
	)
	
	include "luxmax\\fn_common.ms"
	--include "luxmax\\fn_renderview.ms"
	include "luxmax\\fn_ply.ms"
	include "luxmax\\fn_ply_slg.ms"
	include "luxmax\\fn_export_lxo.ms"
	include "luxmax\\fn_export_camera.ms"
	include "luxmax\\fn_export_material.ms"
	include "luxmax\\fn_export_maxlights.ms"
	include "luxmax\\fn_export_luxlights.ms"
	include "luxmax\\fn_export.ms"
	include "luxmax\\rollout_sampler.ms"
	include "luxmax\\rollout_filter.ms"
	include "luxmax\\rollout_integrator.ms"
	
	( --// Main rollouts
		
			rollout Slg_FilmRollout "SLG Film" width:352 height:320
			(
				progressBar doit_prog "" pos:[8,296] width:296 height:14 color:(color 255 0 0)
 -- a red progress bar
 -- a red progress bar
				dropdownList ddl_filter_type "Filter Type" pos:[8,112] width:144 height:40 items:#("None", "Guassian")
				dropdownList ddl_tonemapType "Tonemap Type:" pos:[8,152] width:144 height:40 items:#("Linear Scale")
				spinner spn_Gamma "Gamma" pos:[16,200] width:136 height:16 --range:[0,100,1] --default:2,2
 --range:[0,100,1] --default:2,2
 --range:[0,100,1] --default:2,2
 --range:[0,100,1] --default:2,2
 --range:[0,100,1] --default:2,2
 --range:[0,100,1] --default:2,2
				dropdownList ddl6 "renderEngineType" pos:[8,224] width:152 height:40 items:#("PathGPU", "SPPMRenderEngine", "PathRenderEngine", "PathGPURenderEngine")
				edittext edt_image_name "" pos:[161,72] width:144 height:24
				label lbl_imagename "Image Name:" pos:[168,56] width:144 height:16
				edittext edt_flmName "" pos:[8,72] width:144 height:24
		
		--film.filter.type 
		--if (filterType == 0)
		--film->SetFilterType(FILTER_NONE);
		--else
		--film->SetFilterType(FILTER_GAUSSIAN);
				label lbl_flm_name "Film Name:" pos:[16,56] width:144 height:16
				button btn_slg_EXE "Browse to SLG.exe" pos:[8,8] width:144 height:16
				button btn_Export_SLG "Export SLG" pos:[8,32] width:144 height:16
				button btn_export_path "Export Path" pos:[160,8] width:160 height:16
				checkbox chk_slg_lauch "Lauch after export" pos:[160,32] width:152 height:16
				label lbl7 "" pos:[8,280] width:296 height:16
				
				
				on btn_slg_EXE pressed do
				(
					--browse to slg.exe
					f = getOpenFileName caption:"Open SLG.Exe :" \
					filename:"c:/slg.exe"
					if (f != undefined)do
					(
						btn_slg_EXE.text = f as string
					)
				)
				on btn_Export_SLG pressed do
				(
					objectArray = objects as array
					scnFilePath = stringStream ""
					scnFileName = ""
					str = stringStream ""
					
					OutputFileStr = stringstream ""
					cfgFileStr = stringstream ""
					cfgFilePath = StringStream ""
					
					BatchFile = StringStream ""
					batchfilePath = 	stringstream ""
					BatchFileStr = stringstream ""
					
					outputFileStr = Stringstream ""
					
					
					--Create a cfg file
					format "%%_%.cfg" (btn_export_path.text + "\\") (getSceneName())  (GetFrame()) to:cfgFilePath
					--create a scn file
					format "%%_%.scn" (btn_export_path.text + "\\") (getSceneName())  (GetFrame()) to:scnFilePath
					-- create a .bat file for launching SLG after export.
					format "%%_%.bat" (btn_export_path.text + "\\") (getSceneName())  (GetFrame()) to:batchfilePath 
				
					-- set the variable to scene file name
					scnFileName = ((getSceneName()) + "_" +  (GetFrame()) + ".scn" ) as string
					--get the path for the path, fix //'s
					FixedPath = fixWindowsPath (scnFilePath as string)
					print "Exporting scn file to:"
					print (FixedPath)
					--Create output file.
					
						--outputFile = createFile (FixedPath) --scnFilePath
						outputFile = dotNetObject "System.IO.StreamWriter" FixedPath --scnFilePath
						
						--cfgFile = createfile (fixWindowsPath (cfgFilePath as string))
						cfgFile = dotNetObject "System.IO.StreamWriter" (fixWindowsPath (cfgFilePath as string))
					
						--BatchFile = createfile (fixWindowsPath (batchfilePath as string))
						BatchFile = dotNetObject "System.IO.StreamWriter" (fixWindowsPath (batchfilePath as string))
							
							
					--begin put all logic here....
						
						--scene.camera.lookat = 7.634103 -4.168197 1.421921 12.037415 4.713311 0.106751
						tm = Inverse(getViewTM())
						pos = tm.row4
						up = normalize tm.row2
						look = (tm.row4 + -(normalize tm.row3))
						--format "scene.camera.lookat = % % % % % % % % %\n" (pos.x * luxScaleUnit()) (pos.y * luxScaleUnit()) (pos.z * luxScaleUnit()) (look.x * luxScaleUnit()) (look.y * luxScaleUnit()) (look.z * luxScaleUnit()) up.x up.y up.z to:outputFile
							format "scene.camera.lookat = % % % % % %\n" (pos.x * luxScaleUnit()) (pos.y * luxScaleUnit()) (pos.z * luxScaleUnit()) (look.x * luxScaleUnit()) (look.y * luxScaleUnit()) (look.z * luxScaleUnit()) up.x up.y up.z to:OutputFileStr
						
							--scene.camera.fieldofview = 90
							format "scene.camera.fieldofview = %\n" (getViewFOV()) to:OutputFileStr
						
								--Sort out all the lights so that they get created first.
								--NOTE: Not really needed, just be sure to have a \n at the end of last export.
								
								c = 1
								while c <= objectArray.count do
								(
									if(objectArray[c].name == "")do
									(
										errormsg = stringstream ""
										format ("ERROR: Found object with no name, it's been renamed to: %") ("no_name" + c as string) to:errormsg
										objectArray[c].name = ("no_name" + c as string)
										messagebox (errormsg)
									)
									
									if(classOf objectArray[c].material == SLGMaterial)do
									(
										---------------------------------------------------------------------------------
										--Light material
										---------------------------------------------------------------------------------
										-- scene.materials.light.whitelight
										if(objectArray[c].material.useLightMat == true)then
										(
											test = objectArray[c].material.GetLuxRenderString()
											format "%" (test as string) to:OutputFileStr
											format "scene.objects.whitelight.all = %" (objectArray[c].name + ".ply\n") to:OutputFileStr
											--Set the current item to undefined so that the next loop skips it.
											SLG_ply_export_script objectArray[c] (btn_export_path.text + "\\" + objectArray[c].name + ".ply") (luxScaleUnit())
											objectArray[c] = undefined
										)
										else
										(
											--Do nothing.
										)
									)
									c +=1
								)
								
								--Sort out all the other shaders \ objects
								i =1
								for CurrObj in objectArray do
								(
									
									doit_prog.value = 100.*i/objectArray.count
									i +=1
									if (CurrObj != undefined)do
									(
									--print "Exporting:"
									--print (CurrObj.name as string)
									
										--doit_prog.caption = ( "Exporting: " + CurrObj.name as string)
										lbl7.caption = ( "Exporting: " + CurrObj.name as string)
									--Create an array to store all materials to, so that they get exported first into the file....
									MatArray = #()
									if (superclassof CurrObj == geometryclass) do
									(
											if(classOf Currobj.material == SLGMaterial)do
											(
				/* 												---------------------------------------------------------------------------------
				* 												--Matte material
				* 												---------------------------------------------------------------------------------
				* 												if(CurrObj.material.useMattemat == true)do
				* 												(
				* 													--Matte material
				* 													test = CurrObj.material.GetLuxRenderString()
				* 													format "%" (test as string) to:OutputFileStr
				* 												)
				* 												format "scene.objects.%.% = %"(CurrObj.material.name) (CurrObj.name) (CurrObj.name + ".ply\n") to:OutputFileStr
				* 											)
				* 											
				* 											if(classOf Currobj.material != SLGMaterial)do
				* 											(
				* 												print "not SLG material, creating default"
				* 												format "scene.materials.matte.% = 0.85 0.85 0.85\n" (CurrObj.material.name) to:OutputFileStr
				* 											)
				*/											
											CurrObjMatStr = CurrObj.material.GetLuxRenderString()
											format "%" (CurrObjMatStr as string) to:OutputFileStr
											format "scene.objects.%.% = %"(CurrObj.material.name) (CurrObj.name) (CurrObj.name + ".ply\n") to:OutputFileStr
											--Export geometry..
										try(
											SLG_ply_export_script CurrObj (btn_export_path.text + "\\" + CurrObj.name + ".ply") (luxScaleUnit())
											print "material"
											print CurrObj.material.GetLuxRenderString
											)
										catch()
									)
								)
								)
							)
							doit_prog.value = 0 -- when ready, reset the progress bar to 0%
							lbl7.caption = ("")
							--SETUP CFG FILES!!!!!!!
							--Takes setting from 3dsmax main GUI
							format "image.width = %\n" renderwidth to:cfgFileStr
							format "image.height = %\n" renderheight to:cfgFileStr
							--format "%%_%.cfg" (btn_export_path.text + "\\") (getSceneName())  (GetFrame()) to:cfgFilePath
							format "image.filename = %_%\n" (getSceneName())  (GetFrame()) to:cfgFileStr
							--scene.file = SLG_test_scene_000000.scn
							format "scene.file = %\n " (scnFileName) to:cfgFileStr
								format "opencl.platform.index = 0\n" to:cfgFileStr
							--SETUP CFG FILES!!!!!!!
							tempScnfileName = (getSceneName()) + "_" +  (GetFrame()) + ".cfg" 
							format "\"%\" \"%\"" (btn_slg_EXE.text)(tempScnfileName) to:BatchFileStr
								
								
							--flush cfgFile
							--close cfgFile
							--flush scnFilePath
							--close scnFilePath
							--flush outputFile
							--close outputFile
							--flush BatchFile
							--close BatchFile
							
								BatchFile.write(BatchFileStr as string)
								BatchFile.Close()
								
								cfgFile.write(cfgFileStr as string)
								cfgFile.Close()
								
								outputFile.write(outputFileStr as string)
								outputFile.Close()
								
					if (chk_slg_lauch.checked)do
					(
						templaunchPath = (btn_export_path.text+ "\\"+ (getSceneName()) + "_" +  (GetFrame()) + ".bat" )
						ShellLaunch  (templaunchPath ) ""
					)
					
				)
				on btn_export_path pressed do
				(
					--set export path
					f = getSavePath caption:"Choose Save dir"
					if (f != undefined)do
					(
						btn_export_path.text = f as string
					)
				)
			)
		
		
		
		rollout lux_Dimmensions "Dimmensions" rolledup:true
		(
			dropdownlist DimmensionsPresets_ui "Render Presets"
			
			group "Resolution"
			(
				spinner xresolution "X:" type:#integer range:[4, 10000, 1280] align:#right across:2
				spinner yresolution "Y:" type:#integer range:[4, 10000, 720] align:#right
				--spinner resolutionscale "Scale %:" type:#integer range:[1, 100, 100] align:#right width:95
			)
			/*
			group "Aspect Ratio"
			(
				spinner spn_rwidth "X:" range:[1, 200, 1] align:#right across:2
				spinner spn_rheight "Y:" range:[1, 200, 1] align:#right 
			)
			group "Frame Range:"
			(
				spinner spn_start "Start:" type:#integer range:[1, 9999999, 1] align:#right across:2
				spinner spn_end "End:" type:#integer range:[1, 9999999, 100] align:#right
				spinner spn_step "Step:" type:#integer range:[1, 100, 1] align:#right width:85
			)
			group "Frame Rate:"
			(
				spinner spn_fps "Fps:" type:#integer range:[1, 120, 30] align:#right across:2
				spinner spn_base "Base:" range:[0.1, 120, 1] align:#right
				spinner spn_map_old "Old:" type:#integer range:[1, 900, 100] align:#right across:2
				spinner spn_map_new "new:" type:#integer range:[1, 900, 100] align:#right
			)
			
			checkbox chk_border	"Border"
			checkbox chk_crop		"Crop" enabled:false
			*/
			function applyPreset idx =
			(
				if idx < 1 then return false 
					
				p = DimmensionsPresets[idx]
				xresolution.value = p[2] 
				yresolution.value = p[3]
				--spn_rwidth[3]ue = p[4]
				--spn_rheight[3]ue = p[5]
				--spn_fps[3]ue = p[6]
				--spn_base[3]ue = p[7]
				renderWidth = xresolution.value
				renderHeight = yresolution.value
				
			)
			on xresolution changed val  do renderWidth = xresolution.value
			on yresolution changed val  do renderHeight = yresolution.value
					
			on lux_Dimmensions open do
			(
				items = #("Custom")
				for o in DimmensionsPresets do (append items o[1])
				DimmensionsPresets_ui.items = items
				xresolution.value = renderWidth
				yresolution.value = renderHeight	
			)
			on DimmensionsPresets_ui selected idx do (applyPreset (idx - 1))
		)
		rollout lux_LuxRenderEnginePresets "LuxRender Engine Presets" rolledup:true
		(
			dropdownlist luxrenderpresets "Render Presets:" items:#("Direct Lighting Preview, No GI", "Global Illumination Preview", "Metropolis Light Transport (unbiased recommented)", "OpenCL Path Tracing", "Photon Mapping (caustics off)", "Photon Mapping (caustics on)")
			
			on luxrenderpresets selected i do
			(
				--direct lighting
				if luxrenderpresets.items[i] == "Direct Lighting Preview, No GI" then
				(				
					fileIn "luxmax\\Presets\\Direct_Lighting_NoGI.ms"
					GetControlParams(lux_Renderer)
					GetControlParams(lux_Sampler)
					GetControlParams(lux_SurfaceIntegrator)
					GetControlParams(lux_VolumeIntegrator)
					GetControlParams(lux_Filter)
					GetControlParams(lux_Accelerator)
				)	
				if luxrenderpresets.items[i] == "Global Illumination Preview" then
				(				
					fileIn "luxmax\\Presets\\GI_preview.ms"
					GetControlParams(lux_Renderer)
					GetControlParams(lux_Sampler)
					GetControlParams(lux_SurfaceIntegrator)
					lux_SurfaceIntegrator.updateSubRollout()
					GetControlParams(lux_VolumeIntegrator)
					GetControlParams(lux_Filter)
					GetControlParams(lux_Accelerator)
				)	
				if luxrenderpresets.items[i] == "Metropolis Light Transport (unbiased recommented)" then
				(				
					fileIn "luxmax\\Presets\\Metropolis_unbiased_recommended.ms"
					GetControlParams(lux_Renderer)
					GetControlParams(lux_Sampler)
					GetControlParams(lux_SurfaceIntegrator)
					lux_SurfaceIntegrator.updateSubRollout()
					GetControlParams(lux_VolumeIntegrator)
					GetControlParams(lux_Filter)
					GetControlParams(lux_Accelerator)
				)	
				if luxrenderpresets.items[i] == "OpenCL Path Tracing" then
				(				
					fileIn "luxmax\\Presets\\OpenCL_path_tracing_unbiased.ms"
					GetControlParams(lux_Renderer)
					GetControlParams(lux_Sampler)
					GetControlParams(lux_SurfaceIntegrator)
					lux_SurfaceIntegrator.updateSubRollout()
					GetControlParams(lux_VolumeIntegrator)
					GetControlParams(lux_Filter)
					GetControlParams(lux_Accelerator)
				)		
				if luxrenderpresets.items[i] == "Photon Mapping (caustics off)" then
				(				
					fileIn "luxmax\\Presets\\Photon_mapping_final_caustics_off.ms"
					GetControlParams(lux_Renderer)
					GetControlParams(lux_Sampler)
					GetControlParams(lux_SurfaceIntegrator)
					lux_SurfaceIntegrator.updateSubRollout()
					GetControlParams(lux_VolumeIntegrator)
					GetControlParams(lux_Filter)
					GetControlParams(lux_Accelerator)
				)		
				if luxrenderpresets.items[i] == "Photon Mapping (caustics on)" then
				(				
					fileIn "luxmax\\Presets\\Photon_mapping_final_caustics_on.ms"
					GetControlParams(lux_Renderer)
					GetControlParams(lux_Sampler)
					GetControlParams(lux_SurfaceIntegrator)
					lux_SurfaceIntegrator.updateSubRollout()
					GetControlParams(lux_VolumeIntegrator)
					GetControlParams(lux_Filter)
					GetControlParams(lux_Accelerator)
				)		
			)
		)
		rollout lux_LuxRenderEngineConfiguration "LuxRender Engine" rolledup:false
		(
			dropdownlist ddl_mode "Rendering Mode:" items:#("External", "smallluxGPU")
			
			on ddl_mode selected val do
			(
				ResetUI()
				
				if (val == 1) do
					SetUpLuxRenderUI()
				if (val == 2) do
					SetUpSLGPUUI()
			)
			on lux_LuxRenderEngineConfiguration open do
			(
				GetControlParams(lux_LuxRenderEngineConfiguration)
				
				ResetUI()
				
				if (ddl_mode.selection == 1) do
					SetUpLuxRenderUI()
				if (ddl_mode.selection == 2) do
					SetUpSLGPUUI()
			)
		)
		rollout lux_external "LuxRender External Engine Configuration" rolledup:false
		(
			dropdownlist ddl_exttype "External type:" items:#("LuxRender GUI", "LuxConsole")
			
			checkbox chk_lxs "LXS" across:3 checked:true
			checkbox chk_lxm "LXM" checked:true enabled:true
			checkbox chk_lxo "LXO" checked:true enabled:true
			checkbox chk_ply "PLY" checked:true
			
			group "LuxRender Engine"
			(
				checkbox chk_run "Run Renderer" checked:false
				button btn_path "Path to LuxRender" width:260 align:#center enabled:true
				checkbox chk_threads "Auto Threads" checked:true enabled:true
			)
			
			group "Debug"
			(
				checkbox chk_scriptply "Debug: force maxscript export" checked:false
			)
			
			on btn_path pressed do
			(
				lx_path = getSavePath caption:"LuxRender Path"
				
				if (lx_path != undefined) do
				(
					luxmaxcfg.SetLuxMaxSetting "Engine" "LuxRenderPath" lx_path 
					btn_path.Text = lx_path
				)
			)

			on lux_external open do
			(
				GetControlParams(lux_external)
				 btn_path.Text = (luxmaxcfg.GetLuxMaxSetting "Engine" "LuxRenderPath") as string
			)
		)
		rollout lux_Renderer "Renderer" rolledup:true
		(
			dropdownlist ddl_renderer "Renderer" items:#("sampler", "hybrid", "sppm")

			function GetLuxRenderString =
			(
				str = stringstream ""
				format "\nRenderer \"%\"\n" ddl_renderer.selected to:str
				return str as string
			)
			on lux_Renderer open do (GetControlParams(lux_Renderer))
		)
		rollout lux_Sampler "Sampler" rolledup:true
		(
			dropdownlist ddl_sampler "Sampler Type:" -- items:#("Random", "Low Discrepancy", "ERPT" ,"Metropolis")
			spinner haltspp "Halt SPP:" type:#integer range:[0,999999,0] width:100 align:#right across:2
			spinner halttime "Halt Time:" type:#integer range:[0,999999,0] width:100 align:#right
			
			subrollout lx0 "" width:280 height:200
			
			function GetLuxRenderString =
			(
				return SamplerRollouts[ddl_sampler.selection].GetLuxRenderString()
			)
			
			on ddl_sampler selected idx do
			(
				for o in SamplerRollouts do
				(
					try (removeSubRollout lx0 o) catch()
				)
				AddSubRollout lux_Sampler.lx0 SamplerRollouts[ddl_sampler.selection]
			)
			
			on lux_Sampler open do
			(
				local samplers = #()
				
				for o in SamplerRollouts do
				(
					append samplers o.title
				)
				
				ddl_sampler.items = samplers
				
				GetControlParams(lux_Sampler)
				AddSubRollout lux_Sampler.lx0 SamplerRollouts[ddl_sampler.selection]
			)
		)
		rollout lux_SurfaceIntegrator "Surface Integrator" rolledup:true
		(
			dropdownlist ddl_surface "Surface Integrator"
			
			subrollout lx0 "" width:280 height:200
			
			function GetLuxRenderString =
			(
				return SurfaceIntegratorsRollouts[ddl_surface.selection].GetLuxRenderString()
			)
			
			function updateSubRollout =
			(
				for o in SurfaceIntegratorsRollouts do
				(
					try (removeSubRollout lx0 o) catch()
				)
				AddSubRollout lux_SurfaceIntegrator.lx0 SurfaceIntegratorsRollouts[ddl_surface.selection]
			)
			
			on ddl_surface selected idx do
			(
				updateSubRollout()
			)
			
			on lux_SurfaceIntegrator open do
			(
				local items = #()
				
				for o in SurfaceIntegratorsRollouts do
				(
					append items o.title
				)
				
				ddl_surface.items = items
				GetControlParams(lux_SurfaceIntegrator)
				
				if (ddl_surface.selection > 0) then
					AddSubRollout lux_SurfaceIntegrator.lx0 SurfaceIntegratorsRollouts[ddl_surface.selection]
			)
			
		)
		rollout lux_VolumeIntegrator "Volume Integrator" rolledup:true
		(
			dropdownlist ddl_volume "Volume Integrator" items:#("multi", "single", "emission")
			spinner stepsize "Step Size:" range:[0, 100, 1] type:#float fieldwidth:50
			
			function GetLuxRenderString =
			(
				str = stringstream ""
				format "\nVolumeIntegrator \"%\"\n" (GetLuxString "ddl_volume") to:str
				format "\t\"float stepsize\" [%]\n" (GetLuxValue "stepsize") to:str
				return (str as string)
			)
			on lux_VolumeIntegrator open do (GetControlParams(lux_VolumeIntegrator))
		)
		rollout lux_Filter "Filter" rolledup:true
		(
			dropdownlist ddl_filter "Filter:"
			
			subrollout lx0 "" width:280 height:140

			function GetLuxRenderString =
			(
				return FilltersRollouts[ddl_filter.selection].GetLuxRenderString()
			)
			
			on ddl_filter selected idx do
			(
				for o in FilltersRollouts do
				(
					try (removeSubRollout lx0 o) catch()
				)
				AddSubRollout lux_Filter.lx0 FilltersRollouts[ddl_filter.selection]
			)
			
			on lux_Filter open do
			(
				local items = #()
				
				for o in FilltersRollouts do
				(
					append items o.title
				)
				
				ddl_filter.items = items
				
				GetControlParams(lux_Filter)
				
				AddSubRollout lux_Filter.lx0 FilltersRollouts[ddl_filter.selection]
			)
		)
		rollout lux_Accelerator "Accelerator" rolledup:true
		(
			dropdownlist ddl_accelerator "Accelerator:" items:#("qbvh","bvh","grid","tabreckdtree")
			
			function GetLuxRenderString =
			(
				str = stringstream ""
				format "\nAccelerator \"%\"\n" (GetLuxString "ddl_accelerator") to:str
				return (str as string)
			)
			
			on lux_Accelerator open do (GetControlParams(lux_Accelerator))
		)
		rollout lux_LuxRenderNetwork "LuxRender Network"
		(
			-- edittext edt_addIp "" pos:[8,24] width:176 height:24 -- This line corrupt the max scene
			
			label lbl_server "IP" pos:[8,8] width:168 height:16
			listbox lbx_servers "ListBox" pos:[16,48] width:168 height:7
			button btn_add_server "add" pos:[192,24] width:72 height:24
			on btn_add_server pressed  do ()
		)
		rollout lux_Film "Film" rolledup:true
		(
			spinner writeinterval "Save interval:" fieldwidth:50 range:[0, 999999, 10] type:#integer
			spinner displayinterval "GUI refresh intervals:" fieldwidth:50 range:[0, 999999, 10] type:#integer
			
			group "Output Formats"
			(
				checkbox png "PNG" across:4 checked:true
				checkbox exr "EXR"
				checkbox tga "TGA"
				checkbox flm "FLM"
				checkbox rgba "Enable alpha Channels"
				checkbox effr "Enable Firefly rejection"
				spinner outlierrejection_k "Firefly rejection:" fieldwidth:50 range:[0, 20, 5] type:#integer
			)
			
			group "Color Space"
			(
				spinner whitex "White X:" across:2 fieldwidth:50 range:[0, 1, 0.31]
				spinner whitey "White Y:" fieldwidth:50 range:[-0, 1, 0.316]
				spinner redx "Red X:" across:2 fieldwidth:50 range:[-0, 1, 0.67]
				spinner redy "Red Y:" fieldwidth:50 range:[-0, 1, 0.33]
				spinner greenx "Green X:" across:2 fieldwidth:50 range:[-0, 1, 0.21]
				spinner greeny "Green Y:" fieldwidth:50 range:[-0, 999999, 0.71]
				spinner bluex "Blue X:" across:2 fieldwidth:50 range:[-0, 1, 0.14]
				spinner bluey "Blue Y:" fieldwidth:50 range:[-0, 1, 0.08]
			)
			
			group "Gamma"
			(
				spinner gamma "Gamma:" fieldwidth:50 range:[-999999, 999999, 2.2]
			)
			
			group "Tonemapping"
			(
				dropdownlist tonemapkernel "Tonemapper:" items:#("reinhard")
				spinner reinhard_prescale "Pre:" fieldwidth:50 across:3 range:[-999999, 999999, 1]
				spinner reinhard_postscale "Post:" fieldwidth:50 range:[-999999, 999999, 1.200000047683716]
				spinner reinhard_burn "Burn:" fieldwidth:50 range:[-999999, 999999, 6]
			)
			
			function GetLuxRenderString =
			(
				str = stringstream ""
				
				format "\nFilm \"fleximage\"\n" to:str
				format "\t\"integer xresolution\" [%]\n" (GetLuxValue "xresolution") to:str
				format "\t\"integer yresolution\" [%]\n" (GetLuxValue "yresolution") to:str
				
				luxWriteInteger "haltspp" (getLuxValue "haltspp") str
				luxWriteInteger "halttime" (getLuxValue "halttime") str

				luxWriteFloat "gamma"  (getLuxValue "gamma") str
				luxWriteInteger "displayinterval"  (getLuxValue "displayinterval") str
				LuxWriteInteger "writeinterval"  (getLuxValue "writeinterval") str
				
				format "\t\"bool write_resume_flm\" [\"%\"]\n" (flm.state as string) to:str
				format "\t\"bool write_exr\" [\"%\"]\n" (exr.state as string) to:str
				format "\t\"bool write_png\" [\"%\"]\n" "true" to:str
				format "\t\"bool write_tga\" [\"%\"]\n" (tga.state as string) to:str
				
				if (rgba.state == true) then
				(
					format "\t\"string write_exr_channels\" [\"RGBA\"]\n" to:str
					format "\t\"string write_png_channels\" [\"RGBA\"]\n" to:str
					format "\t\"string write_tga_channels\" [\"RGBA\"]\n" to:str
				)

				format "\t\"float colorspace_white\" [% %]\n" (whitex.value as string) (whitey.value as string) to:str
				format "\t\"float colorspace_red\" [% %]\n" (redx.value as string) (redy.value as string) to:str
				format "\t\"float colorspace_green\" [% %]\n" (greenx.value as string) (greeny.value as string) to:str
				format "\t\"float colorspace_blue\" [% %]\n" (bluex.value as string) (bluey.value as string) to:str

				LuxWriteString "tonemapkernel" tonemapkernel.selected str
				luxWriteFloat "reinhard_prescale" reinhard_prescale.value str
				luxWriteFloat "reinhard_postscale" reinhard_postscale.value str
				luxWriteFloat "reinhard_burn" reinhard_burn.value str
				
				LuxWriteString "filename" (getSceneName() + "_" + getFrame()) str
					if (effr.state == true) then
					(
						luxWriteInteger "outlierrejection_k" outlierrejection_k.value str
					)
				
				return str as string
			)
			on lux_Film open do (GetControlParams(lux_Film))
		)
		rollout lux_Output "Output"
		(
			label lbl1 "Output Directory:" align:#left
			button btn_outputpath "c:\\tmp" align:#center  width:270
			
			on btn_outputpath pressed do
			(
				lx_outputpath = getSavePath caption:"Output Path"
				
				if (lx_outputpath != undefined) do
				(
					btn_outputpath.Text = lx_outputpath
				)
			)
			
			on lux_Output open do
			(
				GetControlParams(lux_Output)
				if ((GetLuxValue "btn_outputpath") != undefined) do btn_outputpath.Text = (GetLuxValue "btn_outputpath")
			)
		)
		rollout lux_main "LuxRender Parameters"
		(
			subRollout lx0 "" width:320 height:570 pos:[0,0]
			
			label lb_camera "Camera:" align:#left
			dropdownList ddl_camera "" width:200 across:2
			button btn_cam_refresh "Refresh" width:90 align:#right
			
			label lb_render "Render:" align:#right across:3
			button btn_image "Image" width:90 align:#right
			button btn_Animation "Animation" width:90 align:#right enabled:false
			
			on lux_main open do
			(
				items = #()
				for obj in cameras do
				(
					if (classof obj != Targetobject) then (append items obj.name)
				)
				ddl_camera.items = items
			)
			on lux_main close do
			(
				SaveSettings()
			)
			on btn_image pressed do
			(
				-- Save setting
				SaveSettings()
				success = false
				
-- 				if (getLuxValue "ddl_mode" == 1)then
-- 				(
-- 					messagebox "SLG export.."
-- 					--luxWriteLookAt function str
-- 					
-- 					
-- 					
-- 					
-- 				)
				
				
				if (ddl_camera.selected == undefined) then success = luxWriteLxs undefined
				else success = luxWriteLxs (GetNodeByName ddl_camera.selected)
				
				lxsFilename = stringStream ""
				format "\"%/%_%.lxs\"" (getLuxValue "btn_outputpath") (getSceneName()) (GetFrame()) to:lxsFilename
					
				if (getLuxValue "ddl_exttype" == 1) then
				(
					if (((getLuxValue "chk_run")) == true and success == true) then
						shelllaunch ((getLuxValue "btn_path") + "\\luxrender.exe") (lxsFilename as string)
				)
				else
				(
					if (((getLuxValue "chk_run")) == true and success == true) then
					(
						--lux_OpenRenderBuffer (getSceneName() + " Frame: " + GetFrame()) renderwidth renderheight (getLuxValue "displayinterval") (lxsFilename as string)
					)
				)
				

				
				
			)
			on btn_Animation pressed do
			(
				-- Save setting
				SaveSettings()
				success = false
				
				progressStart "Rendering..." 
				
				if (ddl_camera.selected == undefined) then
				(
					for t = animationrange.start to animationrange.end do
					(
						if (getProgressCancel() == true) then exit
							
						slidertime = t
						success = luxWriteLxs undefined
						lxsFilename = stringStream ""
						format "\"%/%_%.lxs\"" (getLuxValue "btn_outputpath") (getSceneName())  (GetFrame()) to:lxsFilename
							
						if (getLuxValue "ddl_exttype" == 1) then
						(
							
							if (((getLuxValue "chk_run")) == true and success == true) then
								doscommand ((getLuxValue "btn_path") + "\\luxconsole.exe " + lxsFilename as string)
						)
					)
				)
				else
				(
					for t = animationrange.start to animationrange.end do
					(
						if (getProgressCancel() == true) then exit
							
						slidertime = t
						success = luxWriteLxs (GetNodeByName ddl_camera.selected)
						
						lxsFilename = stringStream ""
						format "\"%/%_%.lxs\"" (getLuxValue "btn_outputpath") (getSceneName())  (GetFrame()) to:lxsFilename
							
						if (getLuxValue "ddl_exttype" == 1) then
						(
							
							if (((getLuxValue "chk_run")) == true and success == true) then
								doscommand ((getLuxValue "btn_path") + "\\luxconsole.exe " + lxsFilename as string)
						)
					)
				)
				
				progressEnd()
			)
			on btn_cam_refresh pressed do
			(
				items = #()
				for obj in cameras do
				(
					if (classof obj != Targetobject) then (append items obj.name)
				)
				ddl_camera.items = items
			)
		)
	)
	
	createDialog lux_main 320 650 style:#(#style_border, #style_titlebar,#style_minimizebox, #style_sysmenu)
	AddSubRollout lux_main.lx0 lux_Dimmensions
	AddSubRollout lux_main.lx0 lux_LuxRenderEngineConfiguration
)