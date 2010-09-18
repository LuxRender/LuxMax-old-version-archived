plugin camera LuxrenderCamera name:"LR Free" classID:#(0x3465725b, 0x7a7b54a6) extends:Freecamera replaceUI:true version:1 category:"Luxrender"
(
	parameters main rollout:params
	(
		lens type:#float default:43.456 ui:m_lens
		fov type:#float default:49 ui:m_fov
		enableAfocus type:#boolean default:false
		ortho type:#boolean default:false ui:m_ortho
		clip type:#boolean default:false ui:m_clip
		nearclip type:#float default:0.1 ui:m_nearclip
		farclip type:#float default:100 ui:m_farclip
	)
	
	on close do
	(
		
		
	)

	
	parameters main rollout:dofparams
	(
		usedof type:#boolean default:true ui:m_use
		lensradius type:#float default:0.0 UI:m_lensradius
		focaldistance type:#float default:0.1 UI:m_dofdistance
	)
	
	parameters filmparams rollout:filmparams
	(
		hltstpint type:#integer default:0 ui:hltstp
		premultiplyalpha type:#boolean default:false  UI:chk7
		filename type:#string default:"default" UI:edt1
		writeEXR type:#boolean default:false UI:chkwriteexr --chkwriteexr
		writeTGA type:#boolean default:false UI:chk3
		writePNG type:#boolean default:false UI:chkwritepng
		writeResumeFilm type:#boolean default:false ui:chk4
		Debug type:#boolean default:false UI:chk5
		displayinterval type:#integer default:8 UI:spn4
		writeinterval type:#integer default:180 UI:spn7
		gamma type:#float default:2.2 UI:spngamma default:2.2
		
		filtertype type:#string default:"mitchell"
		filterboxx type:#float default:2.0 UI:spn_pixelfilter
		--filterboxy type:#float default:2.0 UI:spn_pixelfilter_y
		
		filternumber type:#integer default:1
		--ddl1.selection
		resumeprevfilm type:#boolean default:true UI:chk11
		rejectwarmup type:#integer default:12 UI:spn5
		--("reinhard", "linear","contrast", "maxwhite")
		
		tonemapkernel type:#string default:"reinhard" --UI:lbl13
		
		usereinhard type:#boolean default:true
		reinhard_prescale type:#float default:1.0 UI:spn_reinhard_prescale -- reinhard_prescale  0.0 - 8.0 def: 1
		reinhard_postscale type:#float default:1.0 UI:spn_reinhard_postscale --reinhard_postscale  the same def: 1
		reinhard_burn type:#float default:6.0 UI:spn_reinhard_burn		--reinhard_burn   0.0 - 12 def: 6.0
		usereinhardint type:#integer default:1 -- int for bool check!!
		
		--linear settings and things
		uselinear type:#boolean default:false 
		linear_sensitivity type:#float default:50 UI:spn_linear_sensitivity -- 50.0 
		linear_exposure type:#float default:1.0 UI:spn_linear_exposure --1.0 
		linear_fstop type:#float default:2.8 UI:spn_linear_fstop --2.8 
		linear_gamma type:#float default:1.0 UI:spn_linear_gamma --1.0
		
		usecontrast type:#boolean default:false
		usemaxwhite type:#boolean default:false
		
		tonemapnumber type:#integer default:1 UI:ddl5
		contrast_ywa type:#float default:1.0 UI:spn_contrast_ywa
		halttime type:#integer default:0 UI:spnhalttime
	)
	
	
	rollout filmparams "Film parameters" width:160 height:720
	(
		
		label lbl1 "Halt on sampels per pixel:" pos:[8,8] width:144 height:16
		spinner hltstp "" pos:[8,24] width:144 height:16 range:[0,1e+008,0] type:#integer
		checkbox chkwriteexr "Write EXR" pos:[8,112] width:72 height:16
		checkbox chkwritepng "Write PNG" pos:[80,112] width:96 height:16
		spinner spn4 "" pos:[8,224] width:104 height:16 range:[0,999999,8] type:#integer
		label lbl3 "Display Interval (sec):" pos:[8,208] width:112 height:16
		checkbox chk3 "Write TGA" pos:[8,128] width:72 height:16
		checkbox chk4 "Write resume film" pos:[8,144] width:112 height:16
		edittext edt1 "" pos:[8,192] width:144 height:16 --default:"render"
		label lbl4 "Filename:" pos:[8,176] width:144 height:16
		checkbox chk5 "Debug" pos:[8,272] width:104 height:16
		label lbl5 "Reject varmup:" pos:[8,288] width:112 height:16
		spinner spn5 "" pos:[8,304] width:104 height:16 range:[0,1e+008,0] type:#integer
		spinner spngamma "" pos:[8,336] width:104 height:16 range:[0,1e+008,0] type:#float
		label lbl6 "Gamma:" pos:[8,320] width:112 height:16 range:[0,100,2,2] type:#float
		dropdownList ddl1 "Pixelfilter" pos:[8,352] width:144 height:40 items:#("mitchell", "triangle", "gaussian", "sinc") selection:1
		spinner spn_pixelfilter "size:" pos:[16,392] width:136 height:16 range:[0,1e+008,0] type:#integer
		dropdownList ddl3 "LDR clamp method" pos:[8,408] width:144 height:40 items:#("lum")
		label lbl_writeinterval "Write Interval: (sec)" pos:[8,240] width:112 height:16
		spinner spn7 "" pos:[8,256] width:104 height:16 range:[0,999999,180] type:#integer
		checkbox chk11 "Do resume prev film" pos:[8,160] width:112 height:16 checked:false
		checkbox chk7 "premultiply alpha" pos:[8,96] width:120 height:16
		dropdownList ddl5 "Tonemap kernel" pos:[8,448] width:144 height:40 items:#("reinhard", "linear", "contrast", "maxwhite") selection:1
		GroupBox grp1 "reinhard settings:" pos:[8,488] width:145 height:72 enabled:false
		spinner spn_reinhard_prescale "Prescale" pos:[24,504] width:120 height:16 enabled:false
		spinner spn_reinhard_postscale "Postscale" pos:[24,520] width:120 height:16 enabled:false
		spinner spn_reinhard_burn "Burn" pos:[24,536] width:120 height:16 enabled:false
		GroupBox grp_linear "Linear" pos:[8,560] width:144 height:88 enabled:false
		spinner spn_linear_sensitivity "sensitivity" pos:[24,576] width:120 height:16 enabled:false 
 
		spinner spn_linear_exposure "exposure" pos:[24,592] width:120 height:16 enabled:false 
 
		spinner spn_linear_fstop "fstop" pos:[24,608] width:120 height:16 enabled:false 
 
		spinner spn_linear_gamma "Gamma" pos:[24,624] width:120 height:16 enabled:false
		GroupBox grpContrast "Contrast" pos:[8,648] width:144 height:40 enabled:false
		spinner spn_contrast_ywa "YWA" pos:[24,664] width:120 height:16 enabled:false

		label lbl7 "Halt after minutes:" pos:[7,48] width:145 height:16
		spinner spnhalttime "" pos:[8,64] width:144 height:16 type:#integer
		
		on filmparams open do
		(
			print "opened camera params.."
			print "Enabling UI for last selected tonemap kernel.."
			
			if(usereinhard)do
			(
				spn_reinhard_prescale.enabled = true
				spn_reinhard_postscale.enabled = true
				spn_reinhard_burn.enabled = true
				grp1.enabled = true
			)
			
			if (uselinear)do
			(
				grp_linear.enabled = true
				spn_linear_sensitivity.enabled = true
				spn_linear_exposure.enabled = true
				spn_linear_fstop.enabled = true
				spn_linear_gamma.enabled = true
			)
			
			if (usecontrast)do
			(
				grpContrast.enabled = true
				spn_contrast_ywa.enabled = true
				
			)
			
			if(usecontrast)do
			(
			 --no gui for contrast 	
			)
		)
		on hltstp changed val do
		(
			setUserProp $ "hltstp" hltstp.value
		)
		on chkwriteexr changed state do
		(
			--writeexr
			if (chkwriteexr.state == true)then
			(
				writeEXR = true
				setUserProp $ "writeEXR" "true"
			)
			else
			(
				writeEXR = false
				setUserProp $ "writeEXR" "false"
			)
		)
		on chkwritepng changed state do
		(
			if (chkwritepng.state == true)then
			(
				writePNG = true
				setUserProp $ "writePNG" "true"
			)
			else
			(
				writePNG = false
				setUserProp $ "writePNG" "false"
			)
		)
		on spn4 changed val do
		(
			--spn4 displayinterval change
			setUserProp $ "displayinterval" spn4.value
		)
		on chk3 changed state do
		(
			--writeTGA = true\false
			if (chk3.state == true)then
			(
				writeTGA = true
				setUserProp $ "writeTGA" "true"
			)
			else
			(
				writeTGA = false
				setUserProp $ "writeTGA" "false"
			)
		)
		on chk4 changed state do
		(
			--writeTGA = true\false
			if (chk4.state == true)then
			(
				writeResumeFilm = true
				setUserProp $ "writeResumeFilm" "true"
			)
			else
			(
				writeResumeFilm = false
				setUserProp $ "writeResumeFilm" "false"
			)
		)
		on edt1 entered text do
		(
		--enter name data
			setUserProp $ "FileName" edt1.text
		)
		on chk5 changed state do
		(
			--writeexr
			if (chk5.state == true)then
			(
				Debug = true
				setUserProp $ "Debug" "true"
			)
			else
			(
				Debug = false
				setUserProp $ "Debug" "false"
			)
		)
		on spn5 changed val do
		(
			setUserProp $ "rejectwarmup" spn5.value
		)
		on spngamma changed val do
		(
			setUserProp $ "gamma" spngamma.value
		)
		on ddl1 selected i do
		(
		--format "Filter: '%'\n" ddl1.items[i]
			--print ddl1.items[i]
			--get the number of sel item
			filternumber = ddl1.selection
			--("mitchell", "triangle", "gaussian", "sinc")
			if (filternumber == 1)do
			(
				--filternumber = ddl1.selection
				print filternumber as string
				filtertype = "mitchell"
				print "Filter selected is "
				print filtertype
				setUserProp $ "filtertype" filtertype
				filterboxx =  spn_pixelfilter.value
				setUserProp $ "filterboxx" filterboxx
				
				--filterboxy =spn_pixelfilter_x.value
				--setUserProp $ "filterboxy" filterboxy
				print filterboxx
				--print filterboxy
			)
			
			if (filternumber ==2 )do
			(
				print filternumber as string
				filtertype = "triangle"
				print "Filter selected is "
				print filtertype
				setUserProp $ "filtertype" filtertype
				filterboxx =  spn_pixelfilter.value
				setUserProp $ "filterboxx" filterboxx
				
			)
			
			if (filternumber ==3 )do
				(
				--filternumber = ddl1.selection
				print filternumber as string
				filtertype = "gaussian"
				print "Filter selected is "
				print filtertype
				setUserProp $ "filtertype" filtertype
				filterboxx =  spn_pixelfilter.value
				setUserProp $ "filterboxx" filterboxx
							
				--filterboxy =spn_pixelfilter_x.value
				--setUserProp $ "filterboxy" filterboxy
				--print filterboxx
				--print filterboxy
			)
			
			--sinc
			if (filternumber ==4)do
				(
				--filternumber = ddl1.selection
				print filternumber as string
				filtertype = "sinc"
				print "Filter selected is "
				print filtertype
				setUserProp $ "filtertype" filtertype
				filterboxx =  spn_pixelfilter.value
				setUserProp $ "filterboxx" filterboxx
							
				--filterboxy =spn_pixelfilter_x.value
				--setUserProp $ "filterboxy" filterboxy
				--print filterboxx
				--print filterboxy
			)
			
			
		)
		on spn7 changed val do
		(
			setUserProp $ "writeinterval" spn7.value
		)
		on chk11 changed state do
		(
			--writeTGA = true\false
			if (chk4.state == true)then
			(
				writeResumeFilm = true
				setUserProp $ "writeResumeFilm" "true"
			)
			else
			(
				writeResumeFilm = false
				setUserProp $ "writeResumeFilm" "false"
			)
		)
		on chk7 changed state do
		(
			if (chk7.state == true)then
			(
				premultiplyalpha = true
				setUserProp $ "premultiplyalpha" "true"
			)
			else
			(
				premultiplyalpha = false
				setUserProp $ "premultiplyalpha" "false"
			)
			
		)
		on ddl5 selected i do
		(
			tonemapnumber = ddl5.selection
			--("reinhard", "linear","contrast", "maxwhite")
			
			if (tonemapnumber ==1) do
			(
				tonemapkernel = "reinhard"
				usereinhard = true
				uselinear = false
				usecontrast = false
				usemaxwhite = false
				
				--enable reinhard ui
				--lbl13.text = tonemapkernel
				print tonemapnumber as string
				spn_reinhard_prescale.enabled = true
				spn_reinhard_postscale.enabled = true
				spn_reinhard_burn.enabled = true
				grp1.enabled = true
				
				--disable linear ui
				grp_linear.enabled = false
				spn_linear_sensitivity.enabled = false
				spn_linear_exposure.enabled = false
				spn_linear_fstop.enabled = false
				spn_linear_gamma.enabled = false
				
				
				--set all userproperties for reinhard
				setUserProp $ "usereinhard" usereinhard
				setUserProp $ "uselinear" uselinear
				setUserProp $ "usecontrast" usecontrast
				setUserProp $ "usemaxwhite" usemaxwhite
				
				setUserProp $ "reinhard_prescale" reinhard_prescale
				setUserProp $ "reinhard_postscale" reinhard_postscale
				setUserProp $ "reinhard_burn" reinhard_burn
				setUserProp $ "usereinhardint" usereinhardint --usereinhardint
			)
			
			if (tonemapnumber ==2) do
			(
				--disable reinhard UI
				spn_reinhard_prescale.enabled = false
				spn_reinhard_postscale.enabled = false
				spn_reinhard_burn.enabled = false
				grp1.enabled = false
				
				--enabled linear UI
				grp_linear.enabled = true
				spn_linear_sensitivity.enabled = true
				spn_linear_exposure.enabled = true
				spn_linear_fstop.enabled = true
				spn_linear_gamma.enabled = true
				--disable contrast ui
				grpContrast.enabled = false
				spn_contrast_ywa.enabled = false
				
				tonemapkernel = "linear"
				usereinhard = false
				uselinear = true
				usecontrast = false
				usemaxwhite = false
				
				--lbl13.text = tonemapkernel
				print tonemapnumber as string
				setUserProp $ "uselinear" true
				setUserProp $ "usereinhard" false
				setUserProp $ "usecontrast" false
				setUserProp $ "usemaxwhite" false
				
				setUserProp $ "linear_sensitivity" linear_sensitivity
				setUserProp $ "linear_exposure"  linear_exposure
				setUserProp $ "linear_fstop" linear_fstop
				setUserProp $ "linear_gamma" linear_gamma
			)
			
			if (tonemapnumber ==3) do
			(
				tonemapkernel = "contrast"
				usereinhard = false
				uselinear = false
				usecontrast = true
				usemaxwhite = false
				setUserProp $ "uselinear" false
				setUserProp $ "usereinhard" false
				setUserProp $ "usecontrast" true
				setUserProp $ "usemaxwhite" false
				--print tonemapnumber as string
				
				--disable reinhard UI
				spn_reinhard_prescale.enabled = false
				spn_reinhard_postscale.enabled = false
				spn_reinhard_burn.enabled = false
				grp1.enabled = false
				
				--enabled linear UI
				grp_linear.enabled = false
				spn_linear_sensitivity.enabled = false
				spn_linear_exposure.enabled = false
				spn_linear_fstop.enabled = false
				spn_linear_gamma.enabled = false
				--enable contrast ui
				grpContrast.enabled = true
				spn_contrast_ywa.enabled = true
				
				setUserProp $ "contrast_ywa" contrast_ywa
			)
			if (tonemapnumber ==4)do
			(
				tonemapkernel = "maxwhite"
				usereinhard = false
				uselinear = false
				usecontrast = false
				usemaxwhite = true
				--lbl13.text = tonemapkernel
				
				--disable reinhard UI
				spn_reinhard_prescale.enabled = false
				spn_reinhard_postscale.enabled = false
				spn_reinhard_burn.enabled = false
				grp1.enabled = false
				
				--enabled linear UI
				grp_linear.enabled = false
				spn_linear_sensitivity.enabled = false
				spn_linear_exposure.enabled = false
				spn_linear_fstop.enabled = false
				spn_linear_gamma.enabled = false
				--enable contrast ui
				grpContrast.enabled = false
				spn_contrast_ywa.enabled = false
				usemaxwhite = true
				print tonemapnumber as string
			)
			--sets the userprop to whatever is selected in dropdown
			setUserProp $ "tonemapkernel" tonemapkernel
		)
		on spn_reinhard_prescale changed val do
		(
			reinhard_prescale = spn_reinhard_prescale.value
			setUserProp $ "reinhard_prescale" reinhard_prescale
		)
		on spn_reinhard_postscale changed val do
		(
		--reinhard_postscale
			reinhard_postscale = spn_reinhard_postscale.value
			setUserProp $ "reinhard_postscale" reinhard_postscale
		)
		on spn_reinhard_burn changed val do
		(
		--reinhard_burn
			reinhard_burn = spn_reinhard_burn.value
			setUserProp $ "reinhard_burn" reinhard_burn
		)
		on spn_linear_sensitivity changed val do
		(
			linear_sensitivity = spn_linear_sensitivity.value
			setUserProp $ "linear_sensitivity" linear_sensitivity
		)
		on spn_linear_fstop changed val do
		(
			linear_fstop = spn_linear_fstop.value
			setUserProp $ "linear_fstop" linear_fstop
		)
		on spn_linear_gamma changed val do
		(
			linear_gamma = spn_linear_gamma.value
			setUserProp $ "linear_gamma" linear_gamma
		)
		on spn_contrast_ywa changed val do
		(
			--contrast ywa
			contrast_ywa = spn_contrast_ywa.value
			setUserProp $ "contrast_ywa" contrast_ywa
		)
		on spnhalttime changed val do
		(
		--halttime
			setUserProp $ "halttime" (halttime * 60)
		)
	)
	
			parameters sampler rollout:sampler
			(
				sampler_filter_number type:#integer UI:ddl_sampler default:1
				sampler_filter_name type:#string default:"random"
				
				random_pixelsamples type:#integer UI:spn_random_pixelsamples default:4
				random_pixelsampler type:#string default:"vegas"
				
				lowdiscrepancy_pixelsamples type:#integer default:4 UI:spn16
				lowdiscrepancy_pixelsampler type:#string default:"vegas"
				
				metropolis_initsamples type:#integer default:100000 UI:spn_metropolis_initsamples
				metropolis_maxconsecrejects type:#integer default:512 UI:spn_metropolis_maxconsrej
				metrolpolis_largemutationprob type:#float default:0.4 UI:spn_metropolis_largemutprob
				metrolpolis_micromutationprob type:#float default:0.0 UI:spn_metropolis_miceromutprob
				metrolpolis_mutationrange type:#float default:(renderWidth + renderHeight / 32) UI:spn_metropolis_mutationrange
				metrolpolis_usevariance type:#boolean default:false
				
				erpt_initsamples type:#integer default:100000
				erpt_chainlength type:#integer default:2000
				erpt_mutationrange type:#float default: (renderWidth + renderHeight / 50)
				
				
				
			)
			
			
			--	http://www.luxrender.net/forum/viewtopic.php?f=27&t=3698#p35250
			parameters environment rollout:environment
			(
				environmentimage type:#string default:"" UI:edt2
				useenvmap type:#boolean default:false
				envtype_filter_number type:#integer default:1
				
				envmaptype type:#string default:""
				envgain type:#float default:1.0 UI:spn1
				envgamma type:#float default:1.0 UI:spn2
			)
			
			rollout environment "environment" width:160 height:200
			(
				button btn4 "Browse" pos:[8,32] width:144 height:24
				edittext edt2 "" pos:[8,64] width:144 height:24
				dropdownList ddl1 "Mapping Type" pos:[8,96] width:144 height:40 items:#("angular", "latlong", "vcross")
				
				
				spinner spn1 "Gamma" pos:[32,144] width:120 height:16
				spinner spn2 "Gain" pos:[48,160] width:104 height:16
				checkbox chk1 "Use map" pos:[8,8] width:144 height:16
				
				on btn4 pressed do
				(
					f = getOpenFileName types:"Exr(*.exr)|*.exr| Jpg(*.jpg)|*.jpg|All|*.*|" --\ 
					
					if (f != undefined)then
					(
						environmentimage = f
						--btn1.caption = f
						edt2.text = f
						--useenvmap = true
						setuserprop $ "environmentimage" f
					)
					else
					(
						messagebox "No Luxvol Selected.."
						environmentimage = ""
						--useenvmap = false
					)
				)
				on ddl1 selected i do
				(
					envtype_filter_number = ddl1.selection
					
					if (envtype_filter_number == 1)do
					(
						envmaptype = "angular"
					)
					if (envtype_filter_number == 2)do
					(
						envmaptype = "latlong"
					)
					if (envtype_filter_number == 3)do
					(
						envmaptype = "vcross"
					)
					setuserprop $ "envmaptype" envmaptype
					
				)
				on spn1 changed val do
				(
					setuserprop $ "envgain" envgain
				)
				on spn2 changed val do
				(
					setuserprop $ "envgamma" envgamma
				)
				on chk1 changed state do
				(
				--use envmap
					if chk1.checked == true do
					(
						if edt2.text == "" do
						(
							messagebox "Please specify a map"
							chk1.checked = false
							break
						)
						setUserProp $"useenvmap" "true"
						useenvmap = true
					)
					if chk1.checked == false do
					(
						setUserProp $"useenvmap" "false"
						useenvmap = false
					)
					
				)
				
			on environment open do
			(
			 print "test"	
				print useenvmap
				if (useenvmap) do
				(
					chk1.checked = true
				)
			)
				
			)
			
			
			
	
			rollout sampler "sampler" width:160 height:472
			(
				dropdownList ddl_sampler "Sampler" pos:[0,0] width:144 height:40 items:#("random", "lowdiscrepancy", "metropolis", "erpt") 
				
				GroupBox grp_random "random" pos:[0,40] width:144 height:40
				spinner spn_random_pixelsamples "" pos:[8,56] width:128 height:16 type:#integer
				
				GroupBox grp5 "lowdiscrepancy" pos:[0,80] width:144 height:40
				spinner spn16 "Pixelsamples:" pos:[32,96] width:103 height:16 type:#integer
				
				GroupBox grp11 "metropolis" pos:[0,120] width:144 height:208
				spinner spn_metropolis_initsamples "" pos:[8,152] width:128 height:16 range:[0,1e+006,1] type:#integer
				label lbl13 "Initsamples:" pos:[8,136] width:64 height:16
				spinner spn_metropolis_maxconsrej "" pos:[8,184] width:128 height:16
				label lbl14 "max consecutive rejects" pos:[8,168] width:128 height:16
				label lbl23 "large mutation prob" pos:[8,200] width:96 height:16
				spinner spn_metropolis_largemutprob "" pos:[8,216] width:129 height:16
				label lbl24 "micro mutation prob" pos:[8,232] width:96 height:16
				spinner spn_metropolis_miceromutprob "" pos:[8,248] width:129 height:16 range:[0,1e+006,1]
				label lbl25 "mutation range" pos:[8,264] width:96 height:16
				spinner spn_metropolis_mutationrange "" pos:[8,280] width:129 height:16 range:[0,1e+006,1]
				checkbox chk_metropolis_use_variance "use variance" pos:[16,304] width:120 height:16
				
				groupBox grp4 "ERPT" pos:[0,328] width:144 height:128
				spinner spn_erpt_initsample "InitSamples" pos:[16,344] width:120 height:16
				spinner spn_erpt_chainlength "Chainlength" pos:[16,368] width:120 height:16
				spinner spn_ERPT_mutationrange "Mutationrange" pos:[16,392] width:120 height:16
				
				on sampler open do
				(
					--print "opened sampler.."
					print "setting default values.."
					try
					(
						if (getUserProp $  "hltstpint" == undefined) do
						(
							print "it's not there.. creating it now!!"
							setUserProp $  "hltstpint" hltstpint
						)
						
						if (getUserProp $  "premultiplyalpha" == undefined) do
						(
							print "it's not there.. creating it now!!"
							setUserProp $  "premultiplyalpha" premultiplyalpha
						)
						
						if (getUserProp $  "filename" == undefined) do
						(
							print "it's not there.. creating it now!!"
							setUserProp $  "filename" filename
						)
						
						if (getUserProp $  "writeEXR" == undefined) do
						(
							print "it's not there.. creating it now!!"
							setUserProp $  "writeEXR" writeEXR
						)
						
						if (getUserProp $  "writeTGA" == undefined) do
						(
							print "it's not there.. creating it now!!"
							setUserProp $  "writeTGA" writeEXR
						)
						
						if (getUserProp $  "writePNG" == undefined) do
						(
							print "it's not there.. creating it now!!"
							setUserProp $  "writePNG" writeEXR
						)
						if(getUserProp $ "writeResumeFilm" == undefined) do
						(
							setUserProp $  "writeResumeFilm" writeResumeFilm
						)
						if(getUserProp $ "Debug" == undefined) do
						(
							setUserProp $  "Debug" Debug
						)
						if(getUserProp $ "displayinterval" == undefined) do
						(
						setUserProp $  "displayinterval" displayinterval
						)
						if(getUserProp $ "writeinterval" == undefined) do
						(
						setUserProp $  "writeinterval" writeinterval
						)
						if(getUserProp $ "gamma" == undefined) do
						(
						setUserProp $  "gamma" gamma
						)
						if(getUserProp $ "filtertype" == undefined) do
						(
							setUserProp $  "filtertype" filtertype
						)
						if(getUserProp $ "filterboxx" == undefined) do
						(
							setUserProp $  "filterboxx" filterboxx
						)
						if(getUserProp $ "filternumber" == undefined) do
						(
							setUserProp $  "filternumber" filternumber
						)
						if(getUserProp $ "resumeprevfilm" == undefined) do
						(
							setUserProp $  "resumeprevfilm" resumeprevfilm
						)
						if(getUserProp $ "rejectwarmup" == undefined) do
						(
							setUserProp $  "rejectwarmup" rejectwarmup
						)
						if(getUserProp $ "tonemapkernel" == undefined) do
						(
							setUserProp $  "tonemapkernel" tonemapkernel
						)
						if(getUserProp $ "usereinhard" == undefined) do
						(
							setUserProp $  "tonemapkernel" tonemapkernel
						)
						if(getUserProp $ "reinhard_prescale" == undefined) do
						(
							setUserProp $  "reinhard_prescale" reinhard_prescale
						)
						if(getUserProp $ "reinhard_postscale" == undefined) do
						(
							setUserProp $  "reinhard_postscale" reinhard_postscale
						)
						if(getUserProp $ "reinhard_burn" == undefined) do
						(
							setUserProp $  "reinhard_burn" reinhard_burn
						)
						if(getUserProp $ "usereinhardint" == undefined) do
						(
							setUserProp $  "usereinhardint" usereinhardint
						)
						if(getUserProp $ "uselinear" == undefined) do
						(
							setUserProp $  "uselinear" uselinear
						)
						if(getUserProp $ "linear_sensitivity" == undefined) do
						(
							setUserProp $  "linear_sensitivity" linear_sensitivity
						)
						if(getUserProp $ "linear_exposure" == undefined) do
						(
							setUserProp $  "linear_exposure" linear_exposure
						)
						if(getUserProp $ "linear_fstop" == undefined) do
						(
							setUserProp $  "linear_fstop" linear_fstop
						)
						if(getUserProp $ "linear_gamma" == undefined) do
						(
							setUserProp $  "linear_gamma" linear_gamma
						)
						if(getUserProp $ "usecontrast" == undefined) do
						(
							setUserProp $  "usecontrast" usecontrast
						)
						if(getUserProp $ "usemaxwhite" == undefined) do
						(
							setUserProp $  "usemaxwhite" usemaxwhite
						)
						if(getUserProp $ "tonemapnumber" == undefined) do
						(
							setUserProp $  "tonemapnumber" tonemapnumber
						)
						if(getUserProp $ "contrast_ywa" == undefined) do
						(
							setUserProp $  "contrast_ywa" contrast_ywa
						)
						if(getUserProp $ "halttime" == undefined) do
						(
							setUserProp $  "halttime" halttime
						)
						if(getUserProp $ "sampler_filter_number" == undefined) do
						(
							setUserProp $  "sampler_filter_number" sampler_filter_number
						)
						if(getUserProp $ "sampler_filter_name" == undefined) do
						(
							setUserProp $  "sampler_filter_name" sampler_filter_name
						)
						if(getUserProp $ "random_pixelsamples" == undefined) do
						(
							setUserProp $  "random_pixelsamples" random_pixelsamples
						)
						if(getUserProp $ "random_pixelsampler" == undefined) do
						(
							setUserProp $  "random_pixelsampler" random_pixelsampler
						)
						if(getUserProp $ "lowdiscrepancy_pixelsamples" == undefined) do
						(
							setUserProp $  "lowdiscrepancy_pixelsamples" lowdiscrepancy_pixelsamples
						)
						if(getUserProp $ "lowdiscrepancy_pixelsampler" == undefined) do
						(
							setUserProp $  "lowdiscrepancy_pixelsampler" lowdiscrepancy_pixelsampler
						)
						if(getUserProp $ "metropolis_initsamples" == undefined) do
						(
							setUserProp $  "metropolis_initsamples" metropolis_initsamples
						)
						if(getUserProp $ "metropolis_maxconsecrejects" == undefined) do
						(
							setUserProp $  "metropolis_maxconsecrejects" metropolis_maxconsecrejects
						)
						if(getUserProp $ "metrolpolis_largemutationprob" == undefined) do
						(
							setUserProp $  "metrolpolis_largemutationprob" metrolpolis_largemutationprob
						)
						if(getUserProp $ "metrolpolis_micromutationprob" == undefined) do
						(
							setUserProp $  "metrolpolis_micromutationprob" metrolpolis_micromutationprob
						)
						if(getUserProp $ "metrolpolis_mutationrange" == undefined) do
						(
							setUserProp $  "metrolpolis_mutationrange" metrolpolis_mutationrange
						)
						if(getUserProp $ "metrolpolis_usevariance" == undefined) do
						(
							setUserProp $  "metrolpolis_usevariance" metrolpolis_usevariance
						)
						if(getUserProp $ "erpt_initsamples" == undefined) do
						(
							setUserProp $  "erpt_initsamples" erpt_initsamples
						)
						if(getUserProp $ "erpt_chainlength" == undefined) do
						(
							setUserProp $  "erpt_chainlength" erpt_chainlength
						)
						if(getUserProp $ "erpt_mutationrange" == undefined) do
						(
							setUserProp $  "erpt_mutationrange" erpt_mutationrange
						)
						if(getUserProp $ "environmentimage" == undefined)do
						(
							setUserProp $ "environmentimage" ""
						)
						if(getUserProp $ "envgain" == undefined)do
						(
							setUserProp $ "envgain" envgain
						)
						if(getUserProp $ "envgamma" == undefined)do
						(
							setUserProp $ "envgamma" envgamma
						)
						if (getUserProp $"envmaptype" == undefined)do
						(
							setUserProp $ "envmaptype" "angular"
						)
						if (getUserProp $"useenvmap" == undefined)do
						(
							setUserProp $"useenvmap" "false"
						)
						
					)
					catch()
				)
				on ddl_sampler selected i do
				(
					sampler_filter_number = ddl_sampler.selection
					
					if (sampler_filter_number == 1)do
					(
						print sampler_filter_number as string
						sampler_filter_name = "random"
						print sampler_filter_name
						setUserProp $ "sampler_filter_name" sampler_filter_name
						setUserProp $ "random_pixelsamples" random_pixelsamples
						setUserProp $ "sampler_filter_number" sampler_filter_number
						
						--Disable GUI
						grp_random.enabled = true
						spn_random_pixelsamples.enabled = true
						
						grp5.enabled = false --lowdiscrepancy
						spn16.enabled = false
						
						grp11.enabled = false
						spn_metropolis_initsamples.enabled = false
						lbl13.enabled = false
						spn_metropolis_maxconsrej.enabled = false
						lbl14.enabled = false
						lbl23.enabled = false
						spn_metropolis_largemutprob.enabled = false
						lbl24.enabled = false
						spn_metropolis_miceromutprob.enabled = false
						lbl25.enabled = false
						spn_metropolis_mutationrange.enabled = false
						chk_metropolis_use_variance.enabled = false
						
						grp4.enabled = false
						spn_erpt_initsample.enabled = false
						spn_erpt_chainlength.enabled = false
						spn_ERPT_mutationrange.enabled = false
						
						
						
					)
					
					if (sampler_filter_number == 2)do
					(
						print sampler_filter_number as string
						sampler_filter_name = "lowdiscrepancy"
						print sampler_filter_name
						setUserProp $ "sampler_filter_name" sampler_filter_name
						setUserProp $ "lowdiscrepancy_pixelsamples" lowdiscrepancy_pixelsamples 
						setUserProp $ "lowdiscrepancy_pixelsampler" lowdiscrepancy_pixelsampler 
						setUserProp $ "sampler_filter_number" sampler_filter_number
						--lowdiscrepancy_pixelsampler
						
						--Disable GUI
						grp_random.enabled = false
						spn_random_pixelsamples.enabled = false
						
						grp5.enabled = true --lowdiscrepancy
						spn16.enabled = true
						
						grp11.enabled = false
						spn_metropolis_initsamples.enabled = false
						lbl13.enabled = false
						spn_metropolis_maxconsrej.enabled = false
						lbl14.enabled = false
						lbl23.enabled = false
						spn_metropolis_largemutprob.enabled = false
						lbl24.enabled = false
						spn_metropolis_miceromutprob.enabled = false
						lbl25.enabled = false
						spn_metropolis_mutationrange.enabled = false
						chk_metropolis_use_variance.enabled = false
						
						grp4.enabled = false
						spn_erpt_initsample.enabled = false
						spn_erpt_chainlength.enabled = false
						spn_ERPT_mutationrange.enabled = false
						
						
						
					)
					
					if (sampler_filter_number == 3)do
					(
						print sampler_filter_number as string
						sampler_filter_name = "metropolis"
						print sampler_filter_name
						setUserProp $ "sampler_filter_name" sampler_filter_name
						setUserProp $ "metropolis_initsamples" metropolis_initsamples
						setUserProp $ "metropolis_maxconsecrejects"  metropolis_maxconsecrejects
						setUserProp $ "metrolpolis_largemutationprob"  metrolpolis_largemutationprob
						setUserProp $ "metrolpolis_micromutationprob"  metrolpolis_micromutationprob
						setUserProp $ "metrolpolis_mutationrange"  metrolpolis_mutationrange
						setUserProp $ "metrolpolis_usevariance"  metrolpolis_usevariance
						setUserProp $"sampler_filter_number" sampler_filter_number
						
						--Disable GUI
						grp_random.enabled = false
						spn_random_pixelsamples.enabled = false
						
						grp5.enabled = false --lowdiscrepancy
						spn16.enabled = false
						
						grp11.enabled = true
						spn_metropolis_initsamples.enabled = true
						lbl13.enabled = true
						spn_metropolis_maxconsrej.enabled = true
						lbl14.enabled = true
						lbl23.enabled = true
						spn_metropolis_largemutprob.enabled = true
						lbl24.enabled = true
						spn_metropolis_miceromutprob.enabled = true
						lbl25.enabled = true
						spn_metropolis_mutationrange.enabled = true
						chk_metropolis_use_variance.enabled = true
						
						grp4.enabled = false
						spn_erpt_initsample.enabled = false
						spn_erpt_chainlength.enabled = false
						spn_ERPT_mutationrange.enabled = false
						
						
						
					)
					
					if (sampler_filter_number == 4)do
					(
						print sampler_filter_number as string
						sampler_filter_name = "erpt"
						print sampler_filter_name
						setUserProp $ "sampler_filter_name" sampler_filter_name
						setUserProp $ "erpt_initsamples"  erpt_initsamples
						setUserProp $ "erpt_chainlength"  erpt_chainlength
						setUserProp $ "erpt_mutationrange"  erpt_mutationrange
						setUserProp $"sampler_filter_number" sampler_filter_number
						
												--Disable GUI
						grp_random.enabled = false
						spn_random_pixelsamples.enabled = false
						
						grp5.enabled = false --lowdiscrepancy
						spn16.enabled = false
						
						grp11.enabled = false
						spn_metropolis_initsamples.enabled = false
						lbl13.enabled = false
						spn_metropolis_maxconsrej.enabled = false
						lbl14.enabled = false
						lbl23.enabled = false
						spn_metropolis_largemutprob.enabled = false
						lbl24.enabled = false
						spn_metropolis_miceromutprob.enabled = false
						lbl25.enabled = false
						spn_metropolis_mutationrange.enabled = false
						chk_metropolis_use_variance.enabled = false
						
						grp4.enabled = true
						spn_erpt_initsample.enabled = true
						spn_erpt_chainlength.enabled = true
						spn_ERPT_mutationrange.enabled = true
					)
				)
				on spn_random_pixelsamples changed val do
				(
					--spn_random_pixelsamples
					random_pixelsamples = spn_random_pixelsamples.value 
				)
				on spn_erpt_initsample changed val do
				(
				--initsamples
					--erpt_initsamples
					setUserProp $"erpt_initsamples" erpt_initsamples
				)
				on spn_erpt_chainlength changed val do
				(
				--chainlength
					--erpt_chainlength
					setUserProp $"erpt_chainlength" erpt_chainlength
				)
				on spn_ERPT_mutationrange changed val do
				(
				--erpt
					--erpt_mutationrange
					setUserProp $"erpt_mutationrange" erpt_mutationrange
				)
			)


	
		on params open do
		(
			--msigma.enabled = museSigma.state
			--enable disable all ui stuff here..
			
			
			
		)
		on params create do
		(
			--msigma.enabled = museSigma.state
			--enable disable all ui stuff here..
			
			
			
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
	
	rollout dofparams "Depth of Field" width:160 height:336
	(
		checkbox m_use "Enable" pos:[13,7] width:57 height:15 visible:false
		checkbutton m_usefstop "Use f/stop" pos:[7,27] width:148 height:21 enabled:true visible:false
		spinner m_fstop "fstop" pos:[56,53] width:93 height:16 enabled:true visible:false
		spinner m_lensradius "" pos:[16,96] width:136 height:16 enabled:true range:[0,100,0.001] scale:0.001
 
		dropdownList m_doftype "Focus Type:" pos:[16,120] width:136 height:40 enabled:true items:#("Auto", "Target", "Manual", "Object") visible:false
		pickbutton m_dofobject "Pic Focus Object" pos:[8,160] width:148 height:21 enabled:true visible:true
		spinner m_dofdistance "" pos:[8,208] width:140 height:16 enabled:true type:#worldunits scale:0.001
		spinner m_dofaperture "Aperture Blades:" pos:[8,232] width:142 height:16 enabled:true visible:false
		spinner m_dofpower "Power:" pos:[56,248] width:91 height:16 enabled:true visible:false
		dropdownList m_distribution "Distribution:" pos:[8,264] width:144 height:40 enabled:true items:#("Uniform", "Exponential", "Inverse Exponential", "Gaussian", "Inverse Gaussian") visible:false
		label lbl1 "Lens radius (0=no dof):" pos:[8,72] width:136 height:16
		label lbl3 "Focus Plane Distance:" pos:[8,184] width:136 height:16
		
		on m_use changed s do
		(
		--musedof
			--m_use.enabled = s
		
		)
		on m_doftype selected sel do
		(
		--focus dropbox
			if (m_doftype.selected == "Auto")then
			(
				print "enable autofocus = true"
				enableAfocus = true
			)
			else
			(
				print "enable enable autofocus = false"
				enableAfocus = false
			)
		)
		on m_dofobject picked obj do
		(
		-- distance object a b obj
			--messagebox ("distance between cam and obj is: " + (distance $ obj) as string)
			m_dofdistance.value = (distance $ obj)
			m_dofobject.text = "Focus obj = " + obj.name
			
		)
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
