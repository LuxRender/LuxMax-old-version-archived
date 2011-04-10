parameters common_parameters rollout:common
(
	useBumpmap type:#boolean ui:museBumpmap
	bumpmap type:#float ui:mbumpmap
	bumpmapTexture type:#textureMap ui:mbumpmapTexture
	
	subdivscheme type:#integer ui:msubdivscheme default:1
	nsubdivlevels type:#integer ui:mnsubdivlevels default:1
	
	dmscale type:#float ui:mdmscale default:1
	dmoffset type:#float ui:mdmoffset default:0
	
	dmnormalsmooth type:#boolean ui:mdmnormalsmooth default:false
	dmsharpboundary type:#boolean ui:mdmsharpboundary default:false
	
	useDisplacement type:#boolean ui:museDisplacement
	displacement type:#float ui:mdisplacement
	displacementTexture type:#textureMap ui:mdisplacementTexture
	
	useEmission type:#boolean ui:museEmission
	emissionTexture type:#textureMap ui:memissionTexture
	emissionColor type:#color ui:memissionColor default:white
	power type:#float default:100 ui:mPower
	efficacy type:#float default:17 ui:mEfficacy
	gain type:#float default:1 ui:mGain
	arealightgroup type:#string ui:mGroup default:"arealight"
	interior type:#node ui:mInterior
	exterior type:#node ui:mExterior
	iespath type:#string 
	useies type:#boolean ui:museies	
	useflipz type:#boolean ui:museflipz
)

rollout common "Common Parameters" rolledup:true
(
	fn volumeFilter obj = (
	(
		classof obj) as string == "LuxRenderVolume"
	)
		
	group "Volume"
	(
		label lbinterior "Interior . . . . . . . . . . . . . . . . . . . . ." align:#left across:2
		pickbutton mInterior "none" width:110 height:16 align:#right autoDisplay:true filter:volumeFilter
		label lbexterior "Exterior . . . . . . . . . . . . . . . . . . . . ." align:#left across:2
		pickbutton mExterior "none" width:110 height:16 align:#right autoDisplay:true filter:volumeFilter
	)
	
	group "Bumpmap"
	(
		-- Bumpmap parameters
		checkbox museBumpmap "Bumpmap . . . . " across:3
		spinner mbumpmap " " scale:0.01 range:[0,1,0] width:50 align:#left fieldwidth:65
		mapbutton mbumpmapTexture "T" width:110 height:16 align:#right
	)
	
	group "Displacement"
	(
		checkbox museDisplacement "Displacement . . " across:3
		spinner mdisplacement " " scale:0.01 range:[0,1,0] width:50 align:#left fieldwidth:65
		mapbutton mdisplacementTexture "T" width:110 height:16 align:#right
		
		dropdownlist msubdivscheme "Subdivision Scheme" items:#("none", "microdisplacement", "loop")
		spinner mnsubdivlevels "Level:" type:#integer range:[0,1000,1] fieldwidth:65
		
		spinner mdmscale "Scale:" type:#float range:[-1000,1000,0] fieldwidth:65
		spinner mdmoffset "Offset:" type:#float range:[-1000,1000,0] fieldwidth:65
		
		checkbox mdmnormalsmooth "Normal Smoothing"
		checkbox mdmsharpboundary "Sharpen Bounds"
	)
	
	on museBumpmap changed s do
	(
		mbumpmap.enabled = s
		mbumpmapTexture.enabled = s
	)
	on museDisplacement changed s do
	(
		mdisplacement.enabled = s
		mdisplacementTexture.enabled = s
	)
	
	group "Emission"
	(
		-- Emission paramters
		checkbox museEmission "Use Emission"
		
		label lblmGroup  "Group . . . . . . . . . ." across:3 align:#left
		edittext mGroup "" text:"default" width:200 align:#left
		label lblmGroup_
		
		label lb_emissionColor "Color . . . . . . . . . ." align:#left across:3
		colorpicker memissionColor width:85 align:#left height:16
		mapbutton memissionTexture "T" width:100 height:16 align:#left

		label lblmPower  "Power (W) . . . . . . . . . . . . . . . . . . . . . . ." across:2 align:#left
		spinner mPower " " range:[0,10000,100] fieldwidth:65 align:#right
		
		label lblmEfficacy  "Efficacy (LM/W) . . . . . . . . . . . . . . . . . . . ." across:2 align:#left
		spinner mEfficacy " " range:[0,100,17] fieldwidth:65 align:#right
		
		label lblmGain  "Gain . . . . . . . . . . . . . . . . . . . . . . . . . . . ." across:2 align:#left
		spinner mGain " " range:[0,100,1] align:#right fieldwidth:65
		
		checkbox museies "Use IES data file" across:2 align:#left 
		button bties "Browse" align:#left
		
		checkbox museflipz "Flip Light z axis" across:1 align:#left 
		
		
	)
	
	on museies changed s do 
		(
			bties.enabled = s
		)
		
	on bties pressed do
		
		(
			
			f = getOpenFileName types:"IES(*.ies)|*.ies" caption:"Open an IES File:"
			if (f != undefined)then
				(
					r = fixWindowsPath f
				
				    bties.text = r
				    iespath = r
					bties.text = iespath
					print iespath
				)
		)
	
	on museEmission changed s do
	(
		memissionTexture.enabled = s
		museies.enabled = s
	)

	on common open do
	(
		bties.enabled = museies.state
		museies.enabled = museEmission.state
		mbumpmap.enabled = museBumpmap.state
		mbumpmapTexture.enabled = museBumpmap.state
		
		mdisplacement.enabled = museDisplacement.state
		mdisplacementTexture.enabled = museDisplacement.state
		
		memissionTexture.enabled = museEmission.state
	)
)

function GetTextureMapsProc m &tm =
(
	if (CheckLuxRenderCompat m == false) then return false

	append tm m
	
	childtm = #()
	join childtm (m.GetTextureMaps())
	
	for _t in childtm do
	(
		if (CheckLuxRenderCompat _t == false) then continue
		GetTextureMapsProc _t &tm
	)
)

function export_volumes =
(
	str = stringstream ""
	
	for obj in helpers do
	(
		if (classof obj == LuxRenderVolume) then
		(
			types = #("clear", "homogeneous")
			
			_absorption = #(0, 0, 0)
			
			_absorption[1] = (-log(amax #(obj.absorption.r / 255, 1e-30) )/((obj.absdepth * luxScaleUnit()) * obj.absscale) * 1)
			_absorption[2] = (-log(amax #(obj.absorption.g / 255, 1e-30) )/((obj.absdepth * luxScaleUnit()) * obj.absscale) * 1)
			_absorption[3] = (-log(amax #(obj.absorption.b / 255, 1e-30) )/((obj.absdepth * luxScaleUnit()) * obj.absscale) * 1)
			
			format "MakeNamedVolume \"%\" \"%\"\r\n" obj.name types[obj.type] to:str
			luxWriteFloat "fresnel" obj.ior str
			
			if (obj.type == 1) then
			(
				format "\t\"color absorption\" [% % %]\r\n" _absorption[1] _absorption[2] _absorption[3] to:str
			)
			else
			(				
				format "\t\"color g\" [% % %]\r\n" obj.sasymmetryR obj.sasymmetryG obj.sasymmetryB to:str
				format "\t\"color sigma_a\" [% % %]\r\n" _absorption[1] _absorption[2] _absorption[3] to:str
				luxWriteColor "sigma_s" (obj.scattering * obj.scatteringscale) str
			)
			
			format "\r\n" to:str
		)
	)
	
	--mabsorption * -log(ceil i (1e-30) )/(mdepth * mscale) * 1
	--depthed = (-math.log(max([(float(i)),1e-30]))/(self.depth*self.absorption_scale)) * ((float(i))==1.0 and -1 or 1)

	return str as string
)

function updateRenderBuffer =
(
	filename = ((getdir #temp) + "\matpreview.png")
	try (
		_bitmapStream = dotNetObject "System.IO.FileStream" (filename) (dotNetClass "System.IO.FileMode").Open (dotNetClass "System.IO.FileAccess").Read (dotNetClass "System.IO.FileShare").ReadWrite
		local _bitmap = dotNetObject "System.Drawing.Bitmap" _bitmapStream

		_bitmapStream.Dispose()
		return _bitmap.Clone()
		
	
	) catch
	(
		local _bitmap = dotNetObject "System.Drawing.Bitmap" 1 1
		return _bitmap
	)
)

--// Write emission properties of given material
function luxWriteEmission objmaterial strout =
(
	luxWriteName "LightGroup" objmaterial.arealightgroup strout
	luxWriteName "AreaLightSource" "area" strout

	if (objmaterial.emissionTexture != undefined) then
		format "\t\"texture L\" [\"%\"]\n" objmaterial.emissionTexture.name to:strout
	else
		LuxWriteColor "L" objmaterial.emissionColor strout
	
	luxWriteFloat "power" objmaterial.power strout 
	luxWriteFloat "efficacy" objmaterial.efficacy strout
	luxWriteFloat "gain" objmaterial.gain strout
	
	if (objmaterial.useies == true) then
	(
	luxwriteString "iesname" objmaterial.iespath strout
	)
	if (objmaterial.useflipz == true) then
	(
	format "\t\"bool flipz\" [\"true\"]\n" to:strout
	)

)

function luxMaterialPreview mat =
(
	strout = stringstream ""

	format "LookAt 0.0 -3.0 0.5 0.0 -2.0 0.5 0.0 0.0 1.0\n" to:strout
	format "Camera \"perspective\" \"float fov\" [22.5]\n" to:strout
	format "Film \"fleximage\" \"integer xresolution\" [200] \"integer yresolution\" [200] \"string tonemapkernel\" [\"linear\"] \"integer haltspp\" [100] \"integer reject_warmup\" [64] \"bool write_png\" [\"true\"] \"integer writeinterval\" [1] \"string filename\" [\"matpreview\"]\n" to:strout
	format "PixelFilter \"mitchell\"\n" to:strout
	format "Sampler \"metropolis\"\n" to:strout
	format "SurfaceIntegrator \"bidirectional\"\n" to:strout
	format "VolumeIntegrator \"emission\"\n" to:strout
	format "WorldBegin\n\n" to:strout
	
	format "%" (export_volumes()) to:strout
	
	texturemaps = #()
	
	if (CheckLuxRenderCompat mat == false) then return false
	
	for _t in (mat.GetTextureMaps()) do (GetTextureMapsProc _t &texturemaps)

	texturemaps = makeUniqueArray texturemaps
	
	for i = texturemaps.count to 1 by -1 do (format "%\n" (texturemaps[i].GetLuxRenderString()) to:strout)
	
	try (format "%\r\n" (mat.GetLuxRenderString()) to:strout) catch ()
	
	format "\nAttributeBegin\n" to:strout
	format "Transform [0.5 0.0 0.0 0.0  0.0 0.5 0.0 0.0  0.0 0.0 0.5 0.0  0.0 0.0 0.5 1.0]\n" to:strout
	format "TransformBegin\n" to:strout
	format "Scale 1.000000 1.000000 1.000000\n" to:strout
	format "TransformEnd\n" to:strout
		
	if (mat.useEmission == true) then
	(	
		LuxWriteEmission mat strout
	)
				
	format "NamedMaterial \"%\"\n" mat.name to:strout

	if (mat.interior != undefined) do	format "Interior  \"%\"\n" mat.interior.name  to:strout
	if (mat.exterior != undefined) do format "Exterior  \"%\"\n" mat.exterior.name to:strout
		
	format "Shape \"sphere\" \"float radius\" [1.0]\n" to:strout
	format "AttributeEnd\n\n" to:strout

	format "AttributeBegin\n" to:strout
	format "Transform [5.0 0.0 0.0 0.0  0.0 5.0 0.0 0.0  0.0 0.0 5.0 0.0  0.0 0.0 0.0 1.0]\n" to:strout
	format "Texture \"checks::pattern\" \"float\" \"checkerboard\"\"integer dimension\" [2] \"string mapping\" [\"uv\"] \"float uscale\" [36.8] \"float vscale\" [36.0]\n" to:strout
	format "Texture \"checks\" \"color\" \"mix\" \"texture amount\" [\"checks::pattern\"] \"color tex1\" [0.9 0.9 0.9] \"color tex2\" [0.0 0.0 0.0]\n" to:strout
	format "Material \"matte\" \"texture Kd\" [\"checks\"]\n" to:strout
	format "Shape \"loopsubdiv\" \"integer nlevels\" [3] \"bool dmnormalsmooth\" [\"true\"] \"bool dmsharpboundary\" [\"false\"] \"integer indices\" [ 0 1 2 0 2 3 1 0 4 1 4 5 5 4 6 5 6 7 ]\"point P\" [ 1.000000 1.000000 0.000000 -1.000000 1.000000 0.000000 -1.000000 -1.000000 0.000000 1.000000 -1.000000 0.000000 1.000000 3.000000 0.000000 -1.000000 3.000000 0.000000 1.000000 3.000000 2.000000 -1.000000 3.000000 2.000000] \"normal N\" [ 0.000000 0.000000 1.000000 0.000000 0.000000 1.000000 0.000000 0.000000 1.000000 0.000000 0.000000 1.000000 0.000000 -0.707083 0.707083 0.000000 -0.707083 0.707083 0.000000 -1.000000 0.000000 0.000000 -1.000000 0.000000] \"float uv\" [ 0.333334 0.000000 0.333334 0.333334 0.000000 0.333334 0.000000 0.000000 0.666667 0.000000 0.666667 0.333333 1.000000 0.000000 1.000000 0.333333 ]\n" to:strout
	format "AttributeEnd\n" to:strout
	
	if (mat.useEmission == false) then
	(
	format "AttributeBegin\n" to:strout
	format "Transform [1.0 0.0 0.0 0.0  0.0 1.0 0.0 0.0  0.0 0.0 1.0 0.0  1.0 -1.0 4.0 1.0]\n" to:strout
	format "Texture \"pL\" \"color\" \"blackbody\" \"float temperature\" [6500.0]\n" to:strout
	format "LightSource \"point\" \"texture L\" [\"pL\"] \"float gain\" [0.002]\n" to:strout
	format "AttributeEnd\n" to:strout
	)
		
	format "WorldEnd\n" to:strout

	lxsFilename = stringStream ""
	format "%\luxpreview.lxs" (getdir #temp) to:lxsFilename
	
	f = dotNetObject "System.IO.StreamWriter" (lxsFilename as string)
	f.Write (strout as string)
	f.Close()
	f.Dispose()

	if (lux_ConsoleProcess != undefined) then
	(
		try
		(
			lux_ConsoleProcess.Kill()
		) catch()
	)
			
	if (lux_renderBuffer != undefined) then try
	(
		lux_ConsoleProcess.Stop()
		lux_ConsoleProcess.Kill()
		lux_ConsoleProcess.Dispose()
		destrydialog lux_renderBuffer
	) catch ()
	
	if (lux_ConsoleProcess == undefined) then
		global lux_ConsoleProcess = DotNetObject "System.Diagnostics.Process"
	
	lux_ConsoleProcess.StartInfo.UseShellExecute = false
	lux_ConsoleProcess.StartInfo.FileName = ((luxmaxcfg.GetLuxMaxSetting "Engine" "LuxRenderPath") + "\\luxconsole.exe")
	lux_ConsoleProcess.StartInfo.Arguments = ("\"" + lxsFilename as string + "\"")
	lux_ConsoleProcess.StartInfo.CreateNoWindow = true
	lux_ConsoleProcess.EnableRaisingEvents = false
	
	lux_ConsoleProcess.StartInfo.RedirectStandardInput = false
	lux_ConsoleProcess.StartInfo.RedirectStandardOutput = false
	lux_ConsoleProcess.StartInfo.RedirectStandardError = false	

	lux_ConsoleProcess.Start()
)

parameters preview_params rollout:preview
(
	--image type:#bitmap ui:pictureBox2
)

rollout preview "Preview"
(
	dotnetControl pictureBox1 "System.Windows.Forms.PictureBox" width:100 height:100 bgcolor:black across:2
	--bitmap pictureBox2
	button m_preview "Make Preview" width:110 height:16 align:#right
	timer timer1 "" interval:100
	
	on m_preview pressed do
	(
		luxMaterialPreview this
	)
	
	on preview open do
	(
		pictureBox1.SizeMode = (DotNetClass "PictureBoxSizeMode").StretchImage
	)
	on timer1 tick do
	(
		pictureBox1.Image = updateRenderBuffer()
	)
)
