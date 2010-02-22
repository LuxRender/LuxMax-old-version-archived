plugin camera LuxrenderCamera name:"LR Free" classID:#(0x3465725b, 0x7a7b54a6) extends:Freecamera replaceUI:true version:1 category:"Luxrender"
(
	parameters main rollout:params
	(
		lens type:#float default:43.456 ui:m_lens
		fov type:#float default:49 ui:m_fov
		
		ortho type:#boolean default:false ui:m_ortho
		
		clip type:#boolean default:false ui:m_clip
		nearclip type:#float default:0.1 ui:m_nearclip
		farclip type:#float default:100 ui:m_farclip
	)
	parameters main rollout:dofparams
	(
		usedof type:#boolean default:false ui:m_use
	)

	rollout params "Lux Parameters"
	(
		spinner m_lens "Lens:" range:[0,10000,0]
		spinner m_fov "FOV:" range:[0,175,45]
		
		checkbox m_ortho "Orthographic Projection"
		
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
		
		group "Clipping Planes"
		(
			checkbox m_clip "Clip Manually"
			spinner m_nearclip "Near Clip:" range:[0,100,0.1]
			spinner m_farclip "Far Clip:" range:[1,10000,100]
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
	
	rollout dofparams "Depth of Field" rolledup:true
	(
		checkbox m_use "Enable"
		checkbutton m_usefstop "Use f/stop" width:148 enabled:false
		spinner m_fstop "fstop" enabled:false
		spinner m_lensradius "Lens-Radius" enabled:false
		dropdownlist m_doftype "Focus Type:" items:#("Auto", "Target", "Manual", "Object") enabled:false
		pickbutton m_dofobject "None" width:148 enabled:false
		spinner m_dofdistance "Distance:" align:#right width:100 enabled:false
		spinner m_dofaperture "Aperture Blades:" align:#right width:132 enabled:false
		spinner m_dofpower "Power:" align:#right width:91 enabled:false
		dropdownlist m_distribution "Distribution:" items:#("Uniform", "Exponential", "Inverse Exponential", "Gaussian", "Inverse Gaussian") enabled:false
	)
	rollout architecturallens "Architectural & Aspect" rolledup:true
	(
		checkbox m_use "Enable"
		spinner m_shiftx "Shift X:" enabled:false
		spinner m_shifty "Shift Y:" enabled:false
		checkbox m_customaspectratio "Custom Aspect Ratio" enabled:false
		spinner m_aspectratio "Aspect Ratio:" enabled:false
	)
	rollout motionblur "Motion Blur" rolledup:true
	(
		checkbox m_use "Enable"
		dropdownlist m_presets "Presets:" enabled:false
		dropdownlist m_distribution "Distribution:" items:#("Uniform",  "Gaussian") enabled:false
		checkbox m_object "Object" enabled:false
		checkbox m_camera "Camera" enabled:false
	)
)