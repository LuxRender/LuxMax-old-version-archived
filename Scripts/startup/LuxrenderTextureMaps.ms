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
		filenametemp type:#string default:"" 
		on filenametemp set val do delegate.filename  = val
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
				--messagebox (f as string)
				filenametemp = f
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

-- // =======================================================================================================================================================
-- // lampspectrum -- Class_ID(0x59cb7df2, 0x52d63bd3)

--  lampspectrum names
--     	1:"Daylight", 2:"Candle", 3:"Incandescent1", 4:"Incandescent2",
--     	5:"Welsbach", 6:"AntiInsect", 7:"FLD2", 8:"FL37K",
--     	9:"CFL27K", 10:"CFL4K", 11:"CFL6K", 12:"GroLux",
--     	13:"LCDS", 14:"FLAV8K",  16:"FLAV17K",
--     	17:"HPM2", 18:"HPMFL1", 19:"HPMFL2", 20:"HPMSB",
--     	21:"HPMSBFL", 22:"SS1", 23:"SS2", 24:"LPS",
--     	25:"MPS", 26:"HPS", 27:"SHPS", 28:"MHN",
--     	29:"MHWWD", 30:"MHSc", 31:"MHD", 32:"FeCo",
--     	33:"GaPb", 34:"BLAU", 35:"PLANTA", 36:"GRUN",
--     	37:"LEDB", 38:"RedLaser", 39:"GreenLaser", 40:"XeI",
--     	41:"Rb", 42:"Cd", 43:"Zn", 44:"Ne",
--     	45:"NeKrFL", 46:"NeXeFL1", 48:"NeXeFL2",
--     	49:"Ar", 50:"HPMFL2Glow", 51:"Butane", 52:"Alcohol",
--     	53:"BLP", 54:"BLNG", 55:"TV", 56:"Xe",
--     	57:"CarbonArc", 58:"HPX", 59:"LPM2", 60:"FLBLB",
--     	61:"HPMBL", 
--     	62:"FLBL", 63:"UVA", 64:"HPMFLCobaltGlass",
--     	65:"CobaltGlass", 66:"HPMFLCL42053", 67:"CL42053", 68:"HPMFLRedGlass",
--     	69:"RedGlass", 70:"OliveOil"

plugin TextureMap LuxrenderLampSpectrum name:"LR LampSpectrum" classID:#(0x59cb7df2, 0x52d63bd3) extends:Bitmaptexture replaceUI:true version:1
( 
	parameters main rollout:params
	(
		--spectruname type:#integer default:1 ui:m_uv
		spectrumname type:#integer ui:lbx1
		spectrumselectionint type:#integer default:1
		spectrumnamestring type:#string default:""
		spectrumgroupstring type:#string default:"Default" UI:edt1
	)
	
	rollout params "LampSpectrum Parameters" width:295 height:264
	(
		listbox lbx1 "ListBox" pos:[8,8] width:280 height:9 items:#("Daylight", "Candle", "Incandescent1", "Incandescent2", "Welsbach", "AntiInsect", "FLD2", "FL37K", "CFL27K", "CFL4K", "CFL6K", "GroLux", "LCDS", "FLAV8K", "FLAV17K", "HPM2", "HPMFL1", "HPMFL2", "HPMSB", "HPMSBFL", "SS1", "SS2", "LPS", "MPS", "HPS", "SHPS", "MHN", "MHWWD", "MHSc", "MHD", "FeCo", "GaPb", "BLAU", "PLANTA", "GRUN", "LEDB", "RedLaser", "GreenLaser", "XeI", "Rb", "Cd", "Zn", "Ne", "NeKrFL", "NeXeFL1", "NeXeFL2", "Ar", "HPMFL2Glow", "Butane", "Alcohol", "BLP", "BLNG", "TV", "Xe", "CarbonArc", "HPX", "LPM2", "FLBLB", "HPMBL", "FLBL", "UVA", "HPMFLCobaltGlass", "CobaltGlass", "HPMFLCL42053", "CL42053", "HPMFLRedGlass", "RedGlass", "OliveOil")
	--	GroupBox grp1 "Info:" pos:[8,152] width:280 height:96
		--label lbl1 "Label" pos:[16,168] width:264 height:72
		editText edt1 "Default" pos:[8,176] width:184 height:24
		label lbl1 "Lightgroup:" pos:[8,152] width:184 height:16
		
		on lbx1 selected i do
		(
			format "You selected %\n" lbx1.items[i]
			spectrumnamestring = lbx1.items[i] as string
		)
	)
	
)