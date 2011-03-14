plugin camera LuxrenderCamera name:"LR Free" classID:#(0x3465725b, 0x7a7b54a6) extends:Freecamera replaceUI:true version:1 category:"LuxRender"
(
	parameters main rollout:params
	(
		cameratype type:#integer ui:m_type default:1
		lens type:#float default:35 ui:m_lens
		fov type:#float default:54.432 ui:m_fov
		orthoscale type:#float default:1 ui:m_scale
		
		autofocus type:#boolean default:true ui:m_autofocus
		fstop type:#float default:2.8 ui:m_fstop
		
		usedof type:#boolean default:true ui:m_dof
		targetdistance type:#float ui:m_distance
		
		exposuretiming type:#integer default:1 ui:m_exposuretiming
		openangle type:#integer ui:m_openangle default:0
		closeangle type:#integer ui:m_closeangle default:1
		
		shiftx type:#float ui:m_shiftx
		shifty type:#float ui:m_shifty
		
		useclip type:#boolean default:false ui:m_clip
		hither type:#float default:0.1 ui:m_nearclip
		yon type:#float default:100 ui:m_farclip
		
		usemotionblur type:#boolean default:false ui:musemotionblur
		distribution type:#integer ui:mdistribution default:1
		cameramotionblur type:#boolean default:false ui:mcameramotionblur
		objectmotionblur type:#boolean default:false ui:mobjectmotionblur
			
	)
	rollout params "Parameters"
	(
		dropdownlist m_type "Camera type:" items:#("perspective", "orthographic", "environment")
		spinner m_lens "Lens:" range:[0,10000,0] fieldwidth:50
		spinner m_fov "FOV:" range:[0,175,45] fieldwidth:50
		spinner m_scale "Scale:" range:[0,99999,1] fieldwidth:50
		
		group "Stock Lenses"
		(
			button m_l15mm "15mm" across:3 width:41 align:#left
			button m_l20mm "20mm"  width:41 align:#center
			button m_l24mm "24mm" width:41 align:#right
			button m_l28mm "28mm" across:3 width:41 align:#left
			button m_l35mm "35mm" width:41 align:#center
			button m_l50mm "50mm" width:41 align:#right
			button m_l85mm "85mm" across:3 width:41 align:#left
			button m_l135mm "135mm" width:41 align:#center
			button m_l200mm "200mm" width:41 align:#right
		)
		group "Common"
		(		
			checkbox m_autofocus "Auto focus" enabled:true
			spinner m_fstop "f/Stop:" fieldwidth:50 range:[-99999999,99999999,0]
		
			checkbox m_dof "Depth of field"
			spinner m_distance "Distance:" fieldwidth:50 range:[-99999999,99999999,0]
			pickbutton m_target "Pick target" width:140
			
			dropdownlist m_exposuretiming "Exposure timing:" items:#("normalized", "degrees", "absolute")
			spinner m_openangle "Open:" type:#integer fieldwidth:50  range:[-99999999,99999999,0]--0
			spinner m_closeangle "Close:" type:#integer fieldwidth:50  range:[-99999999,99999999,0]-- 360
		)
		group "Motion Blur"
		(
			checkbox musemotionblur "Enable"
			dropdownlist mdistribution "Distribution:" items:#("gaussian", "uniform")
			checkbox mcameramotionblur "Camera"
			checkbox mobjectmotionblur "Objects"
		)
		group "Shift"
		(
			spinner m_shiftx "Shift X:" fieldwidth:50 range:[-99999999,99999999,0]
			spinner m_shifty "Shift Y:" fieldwidth:50 range:[-99999999,99999999,0]
		)

		group "Clipping"
		(
			checkbox m_clip "Enable"
			spinner m_nearclip "Start:" fieldwidth:50 range:[-99999999,99999999,0]
			spinner m_farclip "End:" fieldwidth:50 range:[-99999999,99999999,0]
		)
		
		on m_target picked o do
		(
			m_target.text = o.name
			m_distance.value = (distance $.position o.position)
		)
		
		on m_type selected i do
		(
			if (i == 2) then delegate.orthoProjection = true
			else delegate.orthoProjection = false
		)
		on m_lens changed v do
		(
			m_fov.value = camerafov.mmtofov v
			delegate.fov = m_fov.value
		)
		on m_fov changed v do
		(
			m_lens.value = camerafov.fovtomm v
			delegate.fov = v
		)
		on m_l15mm pressed do (
				m_lens.value = 15
				m_fov.value = camerafov.mmtofov m_lens.value
				delegate.fov = m_fov.value
		)
		on m_l20mm pressed do (
				m_lens.value = 20
				m_fov.value = camerafov.mmtofov m_lens.value
				delegate.fov = m_fov.value
		)
		on m_l24mm pressed do (
				m_lens.value = 24
				m_fov.value = camerafov.mmtofov m_lens.value
				delegate.fov = m_fov.value
		)
		on m_l28mm pressed do (
				m_lens.value = 28
				m_fov.value = camerafov.mmtofov m_lens.value
				delegate.fov = m_fov.value
		)
		on m_l35mm pressed do (
				m_lens.value = 35
				m_fov.value = camerafov.mmtofov m_lens.value
				delegate.fov = m_fov.value
		)
		on m_l50mm pressed do (
				m_lens.value = 50
				m_fov.value = camerafov.mmtofov m_lens.value
				delegate.fov = m_fov.value
		)
		on m_l85mm pressed do (
				m_lens.value = 85
				m_fov.value = camerafov.mmtofov m_lens.value
				delegate.fov = m_fov.value
		)
		on m_l135mm pressed do (
				m_lens.value = 135
				m_fov.value = camerafov.mmtofov m_lens.value
				delegate.fov = m_fov.value
		)
		on m_l200mm pressed do (
				m_lens.value = 200
				m_fov.value = camerafov.mmtofov m_lens.value
				delegate.fov = m_fov.value
		)
	)
	
	--// Get Camera FOV in luxrender expected format
	function GetCameraFov _lens =
	(
		f = 2 * atan(0.5 * 32.0 /_lens)	
		return f
	)
	
	function GetScreenWindow xr yr =
	(
		sw = #(0, 0, 0, 0)
		
		if cameratype == 2 then
			_scale = 1.0 / 2.0
		else
			_scale = 1.0
		
		aspect = xr as float / yr as float
		invaspect = 1.0 / aspect
		
		if aspect > 1.0 then
		(
			sw[1] = ((2.0 * shiftx) - 1) * _scale
			sw[2] = ((2.0 * shiftx) + 1) * _scale
			sw[3] = ((2.0 * shifty) - invaspect) * _scale
			sw[4] = ((2.0 * shifty) + invaspect) * _scale
		)
		else
		(
			sw[1] = ((2.0 * shiftx) - aspect) * _scale
			sw[2] = ((2.0 * shiftx) + aspect) * _scale
			sw[3] = ((2.0 * shifty) - 1) * _scale
			sw[4] = ((2.0 * shifty) + 1) * _scale
		)
		
		return sw
	)
	function GetLuxRenderString =
	(
		local types = #("perspective", "orthographic", "environment")
		local shutterdistributiontypes = #("gaussian", "uniform")
		
		str = stringstream ""
		format "\nCamera \"%\"\n" (types[cameratype]) to:str
		
		sw = GetScreenWindow renderWidth renderHeight 
		
		format "\t\"float screenwindow\" [% % % %]\n" sw[1] sw[2] sw[3] sw[4] to:str
		
		if (autofocus == true) do
			format "\t\"bool autofocus\" [\"true\"]\n" to:str
		
		if (usedof == true and autofocus == false) then
		(
			lensradius = (lens as float / 1000.0) / ( 2.0 * fstop as float)
			format "\t\"float lensradius\" [%]\n" lensradius to:str
			format "\t\"float focaldistance\" [%]\n" (targetdistance / 100.0) to:str
		)
		
		if (cameratype == 1) do
			format "\t\"float fov\" [%]\n" ((GetCameraFov lens) as string) to:str
		
		if (useclip == true) do
		(
			format "\t\"float hither\" [%]\n" (hither / 100.0) to:str
			format "\t\"float yon\" [%]\n" (yon / 100.0) to:str
		)
		
		if exposuretiming == 1 then
		(
			format "\t\"float shutteropen\" [%]\n" ((openangle / framerate as float) as string) to:str
			format "\t\"float shutterclose\" [%]\n" ((closeangle / framerate as float) as string) to:str
		)
		else if exposuretiming == 3 then
		(
			format "\t\"float shutteropen\" [%]\n" ((openangle) as string) to:str
			format "\t\"float shutterclose\" [%]\n" ((closeangle) as string) to:str
		)
		else if exposuretiming == 2 then
		(
			format "\t\"float shutteropen\" [%]\n" ((openangle/ (framerate  as float * 360.0)) as string) to:str
			format "\t\"float shutterclose\" [%]\n" ((closeangle/ (framerate as float * 360.0)) as string) to:str
		)
		
		if (usemotionblur == true) do
			format "\t\"string shutterdistribution\" [\"%\"]\n" (shutterdistributiontypes[distribution]) to:str
		
		if (usemotionblur == true and cameramotionblur == true) do
			format "\t\"string endtransform\" [\"CameraEndTransform\"]" to:str
		
		return str as string
	)
)