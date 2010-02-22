-- // =======================================================================================================================================================
-- // Constant

plugin TextureMap LuxrenderConstant name:"LR Constant" classID:#(0x251e0d83, 0x7d6a5c67) extends:Bitmaptexture replaceUI:true version:1
( 
	parameters main rollout:params
	(
		color type:#color default:[100,100,100] ui:m_Color
	)

	rollout params "Constant Parameters"
	(
		colorpicker m_Color "Color: " align:#left
	)
)

-- // =======================================================================================================================================================
-- // Blackbody

plugin TextureMap LuxrenderBlackbody name:"LR Blackbody" classID:#(0x48d3ea0a, 0x760c9178) extends:Bitmaptexture replaceUI:true version:1
( 
	parameters main rollout:params
	(
		temperature type:#float default:6500 ui:mTemp
		power type:#float default:100 ui:mPower
		efficacy type:#float default:17 ui:mEfficacy
		gain type:#float default:1 ui:mGain
		group type:#string default:"default"ui:mGroup
	)

	rollout params "Blackbody Parameters"
	(
		spinner mTemp "Temperature (Kelvin):" range:[1000,10000,6500]
		spinner mPower "Power (W):" range:[0,10000,100]
		spinner mEfficacy "Efficacy (LM/W):" range:[0,100,17]
		spinner mGain "Gain:" range:[0,100,1] align:#right
		
		edittext mGroup "Group:" text:"default" width:300 align:#right
	)
)

-- // =======================================================================================================================================================
-- // Checkerboard

plugin TextureMap LuxrenderCheckboard name:"LR Checkboard" classID:#(0x6be51c96, 0x5fe65d5e) extends:Bitmaptexture replaceUI:true version:1
( 
	parameters main rollout:params
	(
		aamode type:#integer default:1 ui:m_aamode
		color1 type:#color default:[0,0,0] ui:m_Color1
		color2 type:#color default:[255,255,255] ui:m_Color2
	)

	parameters main rollout:paramsCoordinates
	(
		uv type:#integer default:1 ui:m_uv
		uscale type:#float default:1 ui:m_uscale
		vscale type:#float default:1 ui:m_vscale
		udelta type:#float default:0 ui:m_udelta
		vdelta type:#float default:0 ui:m_vdelta
	)

	parameters main rollout:paramsCoordinates3
	(

	)
	
	rollout params "Checkboard Parameters"
	(
		dropdownlist m_aamode "AA Mode:" items:#("Closedform", "SuperSample", "None") align:#l width:200
		colorpicker m_Color1 "Color: " align:#left
		colorpicker m_Color2 "Color: " align:#left
	)

	rollout paramsCoordinates "Coordinates"
	(
		dropdownlist m_uv "Mapping:" items:#("UV", "Spherical", "Cylindrical", "Planar") align:#right width:200

		spinner m_uscale "U Scale:" range:[-100, 100, 1] width:100 align:#right
		spinner m_vscale "V Scale:" range:[-100, 100, 1] width:100 align:#right
		
		spinner m_udelta "U Delta:" range:[-100, 100, 0] width:100 align:#right
		spinner m_vdelta "V Delta:" range:[-100, 100, 0] width:100 align:#right
	)

	rollout paramsCoordinates3 "Coordinate 3D" rolledup:true
	(

	)
	
	on create do
	(
	)
)

-- // =======================================================================================================================================================
-- // ImageMap

plugin TextureMap LuxrenderImageMap name:"LR ImageMap" classID:#(0x1bbf1b50, 0x39e50806) extends:Bitmaptexture replaceUI:true version:1
( 
	parameters main rollout:params
	(
		filename type:#string default:"" ui:m_filename
		wrap type:#integer default:1 ui:m_wrap
	)

	parameters main rollout:paramsCoordinates
	(
		uv type:#integer default:1 ui:m_uv
		uscale type:#float default:1 ui:m_uscale
		vscale type:#float default:1 ui:m_vscale
		udelta type:#float default:0 ui:m_udelta
		vdelta type:#float default:0 ui:m_vdelta
	)
	
	rollout params "ImageMap Parameters"
	(
		label lb_filename "Bitmap:" pos:[8,10]
		button m_filename "" pos:[50,8] width:265
		dropdownlist m_wrap "Wrap:" items:#("Repeat", "Black", "Clamp") align:#right width:200
		
		on m_filename pressed do
		(
			f = getOpenFileName types:"Image(*.*)|*.*"
			if (f != undefined) do
			(
				f = filterstring f "\\"
				
				r = ""
				
				for i = 1 to (f.count - 1) do
				(
					append r (f[i] + "\\\\")
				)
				
				append r f[f.count]
				
				m_filename.text = r
				filename = r
			)
		)
		
		on params open do
		(
			m_filename.text = filename
		)
		
		on params create do
		(
			m_filename.text = filename
		)
	)
	
	rollout paramsCoordinates "Coordinates"
	(
		dropdownlist m_uv "Mapping:" items:#("UV", "Spherical", "Cylindrical", "Planar") align:#right width:200

		spinner m_uscale "U Scale:" range:[-100, 100, 1] width:100 align:#right
		spinner m_vscale "V Scale:" range:[-100, 100, 1] width:100 align:#right
		
		spinner m_udelta "U Delta:" range:[-100, 100, 0] width:100 align:#right
		spinner m_vdelta "V Delta:" range:[-100, 100, 0] width:100 align:#right
	)
)