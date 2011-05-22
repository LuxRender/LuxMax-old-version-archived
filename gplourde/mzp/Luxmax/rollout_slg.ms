rollout Slg_FilmRollout "SLG Film"
(
	
	
	group "Basic Settings"
	(
	label lb_slg_path "Full path to SmallLuxGPU's executable:" align:#left
	button btn_slg_EXE "Browse to SLG.exe" width:280 height:20
	
	label lb_export_path "Save location:" align:#left
	button btn_export_path "c:\\tmp\\" width:280 height:20 
	
	button btn_Export_SLG "Export SLG" width:130 height:18 across:2 align:#left				
	checkbox chk_slg_lauch "Lauch after export" width:152 height:16
	checkbox chk_slg_telnet "Enable Telnet" width:152 height:16
	label lbl7 "Export Progress Bar" align:#left width:296 height:16 across:1 
	progressBar doit_prog "" width:280 height:14 color:(color 255 0 0) across:1
	)
	group "Dof"
	(
		spinner spn_lensradius "Lens Radius:" scale:1 range:[0,9999,0.1] align:#left width:120 height:16 fieldwidth:60 across:2
		spinner spn_focaldistance "focaldistance:" scale:1 range:[0,9999,0.1] align:#left width:120 height:16 fieldwidth:60 across:2 default:10
	)
	
	group "OpenCL Settings"
	(
	spinner spn_nativethreads "Native Threads:" scale:1 range:[0,1024,2] align:#left width:120 height:16 fieldwidth:30 across:2
	spinner spn_openclthreads "OpenCL Threads:" scale:1 range:[0,1024,2] align:#right width:120 height:16 fieldwidth:30 
	checkbox ch_cpu "Use CPU" align:#left across:2 checked:true
	checkbox ch_gpu "Use GPU" align:#left  checked:true
	spinner spn_opencltaskcount "Task Count:" scale:1 range:[1,1000000,131072] align:#left width:120 height:16 fieldwidth:60 across:2
	spinner spn_gpuworkgroupsize "GPU Workgroup Size:" scale:1 range:[0,4096,64] align:#right width:120 height:16 fieldwidth:30 
	)
	
	group "Advanced Settings"
	(
	dropdownList ddl_render_engine "Render Engine Type" width:135 height:40 items:#("Path", "SPPM", "Direct", "PathGPU","PathGPU2") across:2 align:#left
	dropdownList ddl_accel_type "Accelerator Type" width:135 height:40 items:#("Default", "BVH","QBVH","QBVH (image stored disabled)", "MQBVH (instances support)")  align:#right
	dropdownList ddl_film_filter_type "Film Filter Type" width:135 height:40 items:#("None", "Guassian") across:2 align:#left
	dropdownList ddl_tonemapType "Tonemap Type:" width:135 height:40 items:#("Linear", "Reinhard '02") align:#right 
	spinner spn_scale "Scale:" scale:0.001 range:[0.001,10,1] align:#right width:120 height:16 fieldwidth:65
	spinner spn_burn "Burn:" scale:0.001 range:[0.001,10,3.75] align:#right width:120 height:16 fieldwidth:65
	spinner spn_prescale "Pre-Scale:" scale:0.001 range:[0.001,10,1] align:#right width:120 height:16 fieldwidth:65
	spinner spn_postscale "Post-Scale:" scale:0.001 range:[0.001,10,1.2] align:#right width:120 height:16 fieldwidth:65
	
	dropdownList ddl_image_format "Image file format" width:135 height:40 items:#("PNG", "OpenEXR", "JPG") across:2 align:#left
	spinner spn_Gamma "Image Output Gamma:" scale:0.001 range:[0,100,1] align:#right width:120 height:16 fieldwidth:65 
	dropdownList ddl_sampler_type "Sampler type" width:135 height:40 items:#("Metropolis", "Stratisfied", "Random", "Inlined Random") across:2 align:#left
	dropdownList ddl_filter_type "Filter type" width:135 height:40 items:#("NONE", "BOX", "GAUSIAN", "MITCHEL") align:#right
	)
	
	group "Light Strategy"
	(	
	dropdownList ddl_light_strategy "" width:135 height:40 items:#("ONE_UNIFORM", "ALL_UNIFORM") align:#left 
	spinner spn_depth "Depth:" scale:1 range:[1,1024,6] align:#left width:120 height:16 fieldwidth:65 across:2
	spinner spn_shadow "Shadow:" scale:1 range:[1,1024,1] align:#right width:120 height:16 fieldwidth:65
	)
	
	dropdownList ddl_samples_per_pixel "Samples per pixel" width:135 height:40 items:#("1x1", "2x2", "3x3", "4x4", "5x5", "6x6", "7x7", "8x8", "9x9") align:#left 
	
	group "Russian Roulette Strategy"
	(
	dropdownList ddl_rrs_strategy "" width:135 height:40 items:#("Importance", "Probability") align:#left 
	spinner spn_rrdepth "Depth:" scale:1 range:[1,1024,6] align:#left width:120 height:16 fieldwidth:40 across:3
	spinner spn_rrcap "Cap:" scale:0.001 range:[0,1,0.25] align:#left width:120 height:16 fieldwidth:40
	spinner spn_rrprob "Prob:" scale:0.001 range:[0,1,0.75] align:#right width:120 height:16 fieldwidth:40
	)
	
	group "Participating Media"
	(
		checkbox usePartMedia "Use" align:#left across:3
		spinner spn_stepsize "Step Size:" scale:0.01 range:[0.01,100,2] align:#left width:120 height:16 fieldwidth:30
		spinner spn_part_rrprob "RR Prob:" scale:0.01 range:[0.01,1,0.33] align:#right width:120 height:16 fieldwidth:30
		colorpicker emission "Emission" align:#left width:80 height:16 across:2
		colorpicker scattering "Scattering" align:#left width:80 height:16
		label lb_boundingboxmin "Bounding Box Min" across:1
		spinner spn_bbmin_x "X" scale:0.01 range:[-1000000,100000,-10] align:#right width:120 height:16 fieldwidth:60 across:3
		spinner spn_bbmin_y "Y" scale:0.01 range:[-1000000,100000,-10] align:#right width:120 height:16 fieldwidth:60
		spinner spn_bbmin_z "Z" scale:0.01 range:[-1000000,100000,-10] align:#right width:120 height:16 fieldwidth:60
		label lb_boundingboxmax "Bounding Box Max" across:1
		spinner spn_bbmax_x "X" scale:0.01 range:[-1000000,100000,10] align:#right width:120 height:16 fieldwidth:60 across:3
		spinner spn_bbmax_y "Y" scale:0.01 range:[-1000000,100000,10] align:#right width:120 height:16 fieldwidth:60
		spinner spn_bbmax_z "Z" scale:0.01 range:[-1000000,100000,10] align:#right width:120 height:16 fieldwidth:60
	)
	
	

	on Slg_FilmRollout open do
	(
		btn_slg_EXE.Text = (luxmaxcfg.GetLuxMaxSetting "Engine" "SLGPath") as string
		if (btn_slg_EXE.Text == "") do btn_slg_EXE.Text = "undefined"
	)
	
	on btn_slg_EXE pressed do
	(
		local slg_bin = getOpenFileName caption:"Locate SLG :" types:"Executable(*.exe)|*.exe"
		if (slg_bin != undefined)do
		(
			luxmaxcfg.SetLuxMaxSetting "Engine" "SLGPath" slg_bin
			btn_slg_EXE.text = slg_bin as string
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
		
		SlgSun =#()
		
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
				
					--DOF
					format "scene.camera.lensradius = %\n" (spn_lensradius.value) to:OutputFileStr
					format "scene.camera.focaldistance = %\n" (spn_focaldistance.value) to:OutputFileStr
					
				--ENVIRONMENT MAP
				if (useEnvironmentMap == true and environmentMap != undefined and classof environmentMap == Bitmaptexture and environmentMap.fileName != undefined) then
					(
						format "scene.infinitelight.file = %\n" (fixWindowsPath environmentmap.filename) to:OutputFileStr
						format "scene.infinitelight.gain = 1.0 1.0 1.0\n" to:OutputFileStr
						format "scene.infinitelight.shift = 0 0\n" to:OutputFileStr
					)
			
				--PARTICIPATING MEDIA
				if (usePartMedia.checked == true) then
					(
						format "scene.partecipatingmedia.singlescatering.bbox = % % % % % %\n" spn_bbmin_x.value spn_bbmin_y.value spn_bbmin_z.value spn_bbmax_x.value spn_bbmax_y.value spn_bbmax_z.value to:OutputFileStr
						format "scene.partecipatingmedia.singlescatering.emission = % % %\n" (emission.color.r/255) (emission.color.b/255) (emission.color.g/255) to:OutputFileStr
						format "scene.partecipatingmedia.singlescatering.enable = 1\n" to:OutputFileStr
						format "scene.partecipatingmedia.singlescatering.rrprob = %\n" (spn_part_rrprob.value) to:OutputFileStr
						format "scene.partecipatingmedia.singlescatering.scattering = % % %\n" (scattering.color.r/255) (scattering.color.b/255) (scattering.color.g/255) to:OutputFileStr
						format "scene.partecipatingmedia.singlescatering.stepsize = %\n" (spn_stepsize.value) to:OutputFileStr
					)
					
					
					c = 1
					while c <= objectArray.count do
					(
						if (objectArray[c].ishidden == false)do
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
									format "scene.objects.%.% = %" (objectArray[c].material.name) (objectArray[c].name) (objectArray[c].name + ".ply\n") to:OutputFileStr
									--Set the current item to undefined so that the next loop skips it.
									SLG_ply_export_script objectArray[c] (btn_export_path.text + "\\" + objectArray[c].name + ".ply") (luxScaleUnit())
									objectArray[c] = undefined
								)
								else
								(
									--Do nothing.
								)
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
							if (CurrObj.ishidden == false)do
							(
								if (superclassof CurrObj == geometryclass) do
								(
										if(classOf Currobj.material == SLGMaterial)do
										(									
										CurrObjMatStr = CurrObj.material.GetLuxRenderString()
										format "%" (CurrObjMatStr as string) to:OutputFileStr
										format "scene.objects.%.% = %"(CurrObj.material.name) (CurrObj.name) (CurrObj.name + ".ply\n") to:OutputFileStr
										format "scene.objects.%.%.useplynormals = 1\n" (CurrObj.material.name) (CurrObj.name) to:OutputFileStr
										if 	(CurrObj.material.useMattemat == true and Currobj.material.MatteDifTexture != undefined) do
											(
												format "scene.objects.%.%.texmap = %\n" (CurrObj.material.name) (CurrObj.name) (fixWindowsPath CurrObj.material.MatteDifTexture.filename) to:OutputFileStr
											)
										if 	(CurrObj.material.useMatteMetalMat == true and Currobj.material.MatteMetalDifTexture != undefined) do
											(
												format "scene.objects.%.%.texmap = %\n" (CurrObj.material.name) (CurrObj.name) (fixWindowsPath CurrObj.material.MatteMetalDifTexture.filename) to:OutputFileStr
											)
										if 	(CurrObj.material.useMatteMirrorMat == true and Currobj.material.MatteMirrorDifTexture != undefined) do
											(
												format "scene.objects.%.%.texmap = %\n" (CurrObj.material.name) (CurrObj.name) (fixWindowsPath CurrObj.material.MatteMirrorDifTexture.filename) to:OutputFileStr
											)
										if 	(CurrObj.material.useAlloyMat == true and Currobj.material.AlloyDifTexture != undefined) do
											(
												format "scene.objects.%.%.texmap = %\n" (CurrObj.material.name) (CurrObj.name) (fixWindowsPath CurrObj.material.AlloyDifTexture.filename) to:OutputFileStr
											)
										if Currobj.material.bumpmap != undefined do
											(
												format "scene.objects.%.%.bumpmap = %\n" (CurrObj.material.name) (CurrObj.name) (fixWindowsPath CurrObj.material.bumpmap.filename) to:OutputFileStr
												format "scene.objects.%.%.bumpscale = %\n" (CurrObj.material.name) (CurrObj.name) (CurrObj.material.bumpscale) to:OutputFileStr
											)
										--scene.objects.07 - Default.Teapot010.useplynormals = 1
										
										--Export geometry..
									try(
										SLG_ply_export_script CurrObj (btn_export_path.text + "\\" + CurrObj.name + ".ply") (luxScaleUnit())
										--print "material"
										--print CurrObj.material.GetLuxRenderString
										)
										catch()
									)
								)
							)
						)
					)
				
				doit_prog.value = 0 -- when ready, reset the progress bar to 0%
				lbl7.caption = ("")
				--SETUP CFG FILE
				--Takes setting from 3dsmax main GUI
			
				--ACCEL and FILM
				format "accelerator.type = %\n" (ddl_accel_type.selection - 1) to:cfgFileStr
				format "film.filter.type = %\n" (ddl_film_filter_type.selection - 1) to:cfgFileStr
				format "film.gamma = 2.2\n" to:cfgFileStr
				format "film.tonemap.linear.scale = 1\n" to:cfgFileStr
				format "film.tonemap.type = 0\n" to:cfgFileStr
			
				--SCENE SETTINGS
				format "image.width = %\n" renderwidth to:cfgFileStr
				format "image.height = %\n" renderheight to:cfgFileStr
				format "image.filename = %_%.%\n" (getSceneName())  (GetFrame()) (ddl_image_format.selected as string)  to:cfgFileStr
				format "scene.file = %\n " (scnFileName) to:cfgFileStr
				
				--OPENCL
				if (ch_cpu.checked == true) then (format "opencl.cpu.use = 1\n" to:cfgFileStr) else (format "opencl.cpu.use = 0\n" to:cfgFileStr)
				if (ch_gpu.checked == true) then (format "opencl.gpu.use = 1\n" to:cfgFileStr) else (format "opencl.gpu.use = 0\n" to:cfgFileStr)
				format "opencl.nativethread.count = %\n" (spn_nativethreads.value as integer) to:cfgFileStr
				format "opencl.platform.index = 0\n" to:cfgFileStr
				format "opencl.renderthread.count = %\n" (spn_openclthreads.value as integer) to:cfgFileStr
				format "opencl.gpu.workgroup.size = %\n" (spn_gpuworkgroupsize.value as integer) to:cfgFileStr
				format "opencl.task.count = %\n" (spn_opencltaskcount.value as integer) to:cfgFileStr
				
				--FILTER
				format "path.filter.B = 0.333333\n" to:cfgFileStr
				format "path.filter.C = 0.333333\n" to:cfgFileStr
				format "path.filter.alpha = 2\n" to:cfgFileStr
				
				format "path.filter.type = %\n" (ddl_filter_type.selected) to:cfgFileStr
				format "path.filter.width.x = 1.5\n" to:cfgFileStr
				format "path.filter.width.y = 1.5\n" to:cfgFileStr
					
				--LIGHT STRATEGY
				format "path.lightstrategy = %\n" (ddl_light_strategy.selection) to:cfgFileStr
				format "path.maxdepth = %\n" (spn_depth.value as integer) to:cfgFileStr
				format "path.shadowrays = %\n" (spn_shadow.value as integer) to:cfgFileStr
				
				--RUSSIAN ROULETTE
				if (ddl_rrs_strategy.selection == 1) then
				(
				format "path.russianroulette.strategy = 1\n" to:cfgFileStr
				format "path.russianroulette.depth = %\n" (spn_rrdepth.value as integer) to:cfgFileStr
				format "path.russianroulette.cap = %\n" (spn_rrcap.value as float) to:cfgFileStr
				)
				if (ddl_rrs_strategy.selection == 2) then
				(
				format "path.russianroulette.strategy = 0\n" to:cfgFileStr
				format "path.russianroulette.depth = %\n" (spn_rrdepth.value as integer) to:cfgFileStr
				format "path.russianroulette.prob = %\n" (spn_rrprob.value as float) to:cfgFileStr
				)
				
				
				--SAMPLER 
				--Metropolis (hardcoded)
				if (ddl_sampler_type.selection == 1) then
				(
				format "path.sampler.type = METROPOLIS\n" to:cfgFileStr
				format "path.sampler.largesteprate = 0.4\n" to:cfgFileStr
				format "path.sampler.maxconsecutivereject = 512\n" to:cfgFileStr
				)
				--Stratisfied  (hardcoded)
				if (ddl_sampler_type.selection == 2) then
				(
				format "path.sampler.type = STRATIFIED\n" to:cfgFileStr
				format "path.sampler.xsamples = 3\n" to:cfgFileStr
				format "path.sampler.ysamples = 3\n" to:cfgFileStr
				)
				--Random
				if (ddl_sampler_type.selection == 3) then
				(
				format "path.sampler.type = RANDOM\n" to:cfgFileStr
				)
				--Inlined Random
				if (ddl_sampler_type.selection == 4) then
				(
				format "path.sampler.type = INLINED_RANDOM\n" to:cfgFileStr
				)
				
				
				--SAMPLES PER PIXEL
				format "path.sampler.spp = %\n" (ddl_samples_per_pixel.selection as integer) to:cfgFileStr
				
				--RENDER ENGINE
				format "renderengine.type = %\n" (ddl_render_engine.selection - 1) to:cfgFileStr
				
				--ADD SPPM SETTINGS  (Hardcoded)
				format "sppm.directlight.enable = 0"
				format "sppm.eyepath.maxdepth = 16"
				format "sppm.lookup.type = 2"
				format "sppm.photon.alpha = 0.7"
				format "sppm.photon.maxdepth = 8"
				format "sppm.photon.startradiusscale = 1."
				format "sppm.stochastic.count = 2500000"
				
				
				
				
					
				--SETUP CFG FILES!!!!!!!
				tempScnfileName = (getSceneName()) + "_" +  (GetFrame()) + ".cfg" 
					
					if (chk_slg_telnet.checked)then
					(
						format "\"%\" -T \"%\"" (btn_slg_EXE.text)(tempScnfileName) to:BatchFileStr
					)
					else
					(
							format "\"%\" \"%\"" (btn_slg_EXE.text)(tempScnfileName) to:BatchFileStr
					)
				
					
					
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
--)
	on btn_export_path pressed do
	(
		--set export path
		f = getSavePath caption:"Choose Save dir"
		if (f != undefined)do
		(
			btn_export_path.text = f as string
		)
	)
--)
)