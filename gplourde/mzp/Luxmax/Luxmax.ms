try (destroyDialog lux_main) catch ()
global lux_main = "LuxMax Starting..."
(
	persistent global luxMax_Version = 1.0
	
	-- // Check the scene name for the script lifetime only
	luxMax_Scene = (getFilenameFile maxFileName)
		
	if (luxMax_Settings == undefined) then (persistent global luxMax_Settings = #())
	
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
	lux_LuxRenderNetwork = undefined
	lux_Output = undefined
	lux_Sampler_Random = undefined
	lux_Sampler_LowDiscrepancy = undefined
	lux_Sampler_ERPT = undefined
	lux_Sampler_Metropolis = undefined
	lux_SurfaceIntegrator_ExPhotonMap = undefined
	lux_SurfaceIntegrator_Path = undefined
	lux_Filter_mitchell = undefined
	lux_Film = undefined
	
	SurfaceIntegratorsRollouts = #()
	SamplerRollouts = #()
	FilltersRollouts =#()

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
	include "luxmax\\fn_ply.ms"
	include "luxmax\\fn_export_camera.ms"
	include "luxmax\\fn_export_material.ms"
	include "luxmax\\fn_export.ms"
	include "luxmax\\rollout_sampler.ms"
	include "luxmax\\rollout_filter.ms"
	include "luxmax\\rollout_integrator.ms"
		
	( --// Main rollouts
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
				GetControlParams(lux_Dimmensions)
				renderWidth = xresolution.value
				renderHeight = yresolution.value	
			)
			on DimmensionsPresets_ui selected idx do (applyPreset (idx - 1))
		)
		rollout lux_LuxRenderEnginePresets "LuxRender Engine Presets" rolledup:true
		(
			dropdownlist ddl_presets "Engine Presets"
		)
		rollout lux_LuxRenderEngineConfiguration "LuxRender Engine" rolledup:true
		(
			dropdownlist ddl_mode "Rendering Mode:" items:#("External")
		)
		rollout lux_external "LuxRender External Engine Configuration" rolledup:false
		(
			dropdownlist ddl_exttype "External type:" items:#("LuxRender GUI", "LuxConsole")
			
			checkbox chk_lxs "LXS" across:3 checked:true
			checkbox chk_lxm "LXM" checked:false enabled:false
			checkbox chk_ply "PLY" checked:true
			--checkbox chk_lxo "LXO" checked:true enabled:false
			
			group "LuxRender Engine"
			(
				checkbox chk_run "Run Renderer" checked:false
				button btn_path "Path to LuxRender" width:260 align:#center enabled:true
				checkbox chk_threads "Auto Threads" checked:true enabled:true
			)
			on btn_path pressed do
			(
				lx_path = getSavePath caption:"LuxRender Path"
				
				if (lx_path != undefined) do
				(
					btn_path.Text = lx_path
				)
			)

			on lux_external open do
			(
				GetControlParams(lux_external)
				if ((GetLuxValue "btn_path") != undefined) do btn_path.Text = (GetLuxValue "btn_path")
			)
		)
		rollout lux_Renderer "Renderer" rolledup:true
		(
			dropdownlist ddl_renderer "Renderer" items:#("sampler", "hybridsampler", "hybridsppm")
			
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
			
			subrollout lx0 "" width:280 height:300
			
			function GetLuxRenderString =
			(
				return SurfaceIntegratorsRollouts[ddl_surface.selection].GetLuxRenderString()
			)
			
			on ddl_surface selected idx do
			(
				for o in SurfaceIntegratorsRollouts do
				(
					try (removeSubRollout lx0 o) catch()
				)
				AddSubRollout lux_SurfaceIntegrator.lx0 SurfaceIntegratorsRollouts[ddl_surface.selection]
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
			dropdownlist ddl_volume "Volume Integrator" items:#("single", "emission")
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
		rollout lux_LuxRenderNetwork "LuxRender Network" rolledup:true
		(
			
		)
		rollout lux_Film "Film" rolledup:true
		(
			spinner writeinterval "Save interval:" fieldwidth:50 range:[-999999, 999999, 10] type:#integer
			spinner displayinterval "GUI refresh intervals:" fieldwidth:50 range:[-999999, 999999, 10] type:#integer
			
			group "Output Formats"
			(
				checkbox png "PNG" across:4 checked:true
				checkbox exr "EXR"
				checkbox tga "TGA"
				checkbox flm "FLM"
				checkbox rgba "Enable alpha Channels"
				spinner outlierrejection_k "Firefly rejection:" fieldwidth:50 range:[0, 999999, 0] type:#integer
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
				format "\t\"bool write_png\" [\"%\"]\n" (png.state as string) to:str
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
				
				LuxWriteString "filename" (getSceneName()) str
				luxWriteInteger "outlierrejection_k" outlierrejection_k.value str
				
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
			subrollout lx0 "" width:320 height:570 pos:[0,0]
			dropdownlist ddl_camera "Camera"
			button btn_image "Image" width:130 align:#center across:2
			button btn_Animation "Animation" width:120 align:#center enabled:false
			
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
				
				if (ddl_camera.selected == undefined) then success = luxWriteLxs undefined
				else success = luxWriteLxs (GetNodeByName ddl_camera.selected)
				
				if (((getLuxValue "chk_run")) == true and success == true) then shelllaunch ((getLuxValue "btn_path") + "\\luxrender.exe") (((getLuxValue "btn_outputpath") + "\\" + getSceneName() + ".lxs"))
			)
			on btn_Animation pressed do
			(

			)
		)
	)
	
	createDialog lux_main 320 650 style:#(#style_border, #style_titlebar,#style_minimizebox, #style_sysmenu)
	AddSubRollout lux_main.lx0 lux_Dimmensions
	--AddSubRollout lux_main.lx0 lux_LuxRenderEnginePresets
	AddSubRollout lux_main.lx0 lux_LuxRenderEngineConfiguration
	AddSubRollout lux_main.lx0 lux_external
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