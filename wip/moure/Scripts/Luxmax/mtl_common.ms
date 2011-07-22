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

	appendifunique tm m
	
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

--UPDATERENDERBUFFER
/*
function updateRenderBuffer mat =
(
	
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
*/

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
	if (mat.bzoom == false) then (format "LookAt 0.0 -3.0 0.5 0.0 -2.0 0.5 0.0 0.0 1.0\n" to:strout)
	else (format "LookAt 0.250000 -1.500000 0.750000 0.250000 -0.500000 0.750000 0.000000 0.000000 1.000000\n" to:strout)
	format "Camera \"perspective\" \"float fov\" [22.5]\n" to:strout
	format "Film \"fleximage\"" to:strout
	--Size Params
	if (mat.dd_preview_size == 1) then
	(
	format "\"integer xresolution\" [80] \"integer yresolution\" [80]" to:strout 
	)
	if (mat.dd_preview_size == 2) then
	(
	format "\"integer xresolution\" [140] \"integer yresolution\" [140]" to:strout 
	)
	if (mat.dd_preview_size == 3) then
	(
	format "\"integer xresolution\" [200] \"integer yresolution\" [200]" to:strout 
	)
	if (mat.dd_preview_size == 4) then
	(
	format "\"integer xresolution\" [300] \"integer yresolution\" [300]" to:strout 
	)
	--Quality Params
	if (mat.dd_preview_quality == 1) then
	(
	format "\"string tonemapkernel\" [\"linear\"] \"integer haltspp\" [80] \"integer halttime\" [5] \"integer reject_warmup\" [64] \"bool write_png\" [\"true\"] \"integer writeinterval\" [1] \"string filename\" [\"matpreview_%\"]\n" mat.name to:strout
	)
	if (mat.dd_preview_quality == 2) then
	(
	format "\"string tonemapkernel\" [\"linear\"] \"integer haltspp\" [120] \"integer halttime\" [10] \"integer reject_warmup\" [64] \"bool write_png\" [\"true\"] \"integer writeinterval\" [1] \"string filename\" [\"matpreview_%\"]\n" mat.name to:strout
	)
	if (mat.dd_preview_quality == 3) then
	(
	format "\"string tonemapkernel\" [\"linear\"] \"integer haltspp\" [150] \"integer halttime\" [15] \"integer reject_warmup\" [64] \"bool write_png\" [\"true\"] \"integer writeinterval\" [1] \"string filename\" [\"matpreview_%\"]\n" mat.name to:strout
	)
	if (mat.dd_preview_quality == 4) then
	(
	format "\"string tonemapkernel\" [\"linear\"] \"integer haltspp\" [200] \"integer halttime\" [30] \"integer reject_warmup\" [64] \"bool write_png\" [\"true\"] \"integer writeinterval\" [1] \"string filename\" [\"matpreview_%\"]\n" mat.name to:strout
	)
		
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
		
	--CAMERA LOOK AT PROPERTIES
	if (mat.dd_preview_scene ==  1) then
	(format "Transform [0.5 0.0 0.0 0.0  0.0 0.5 0.0 0.0  0.0 0.0 0.5 0.0  0.0 0.0 0.5 1.0]\n" to:strout)
	if (mat.dd_preview_scene ==  2) then
	(format "Transform [0.35 -0.35 0.0 0.0  0.25 0.25 0.35 0.0  -0.25 -0.25 0.35 0.0  0.0 0.0 0.5 1.0]\n" to:strout)
	if (mat.dd_preview_scene ==  3) then
	(format "Transform [0.4 0.4 0.0 0.0 -0.4 0.4 0.0 0.0 0.0 0.0 0.6 0.0 0.0 0.0 0.0 1]\n" to:strout)
	format "TransformBegin\n" to:strout
	format "Scale 1.000000 1.000000 1.000000\n" to:strout
	format "TransformEnd\n" to:strout
		
	if (mat.useEmission == true) then
	(	
		LuxWriteEmission mat strout
	)
				
	format "NamedMaterial \"%\"\n" mat.name to:strout

	if (mat.interior != undefined) do format "Interior  \"%\"\n" mat.interior.name  to:strout
	if (mat.exterior != undefined) do format "Exterior  \"%\"\n" mat.exterior.name to:strout
	
	
	--SCENE SELECTION
	
	if (mat.dd_preview_scene ==  1) then
	(
	format "Shape \"sphere\" \"float radius\" [1.0]\n" to:strout
	)
	if (mat.dd_preview_scene ==  2) then
	(
	format "Shape \"torus\" \"float radius\" [1.0]\n" to:strout
	)
	if (mat.dd_preview_scene ==  3) then
	(
	format "Shape \"plymesh\" \"string filename\" [\"%\"]\n" (mat.teapotfilename as string) to:strout
	)
	
	format "AttributeEnd\n\n" to:strout

	format "AttributeBegin\n" to:strout
	format "Transform [5.0 0.0 0.0 0.0  0.0 5.0 0.0 0.0  0.0 0.0 5.0 0.0  0.0 0.0 0.0 1.0]\n" to:strout
	format "Texture \"checks::pattern\" \"float\" \"checkerboard\"\"integer dimension\" [2] \"string mapping\" [\"uv\"] \"float uscale\" [36.8] \"float vscale\" [36.0]\n" to:strout
	format "Texture \"checks\" \"color\" \"mix\" \"texture amount\" [\"checks::pattern\"] \"color tex1\" [0.9 0.9 0.9] \"color tex2\" [0.0 0.0 0.0]\n" to:strout
	format "Material \"matte\" \"texture Kd\" [\"checks\"]\n" to:strout
	format "Shape \"loopsubdiv\" \"integer nlevels\" [3] \"bool dmnormalsmooth\" [\"true\"] \"bool dmsharpboundary\" [\"false\"] \"integer indices\" [ 0 1 2 0 2 3 1 0 4 1 4 5 5 4 6 5 6 7 ]\"point P\" [ 1.000000 1.000000 0.000000 -1.000000 1.000000 0.000000 -1.000000 -1.000000 0.000000 1.000000 -1.000000 0.000000 1.000000 3.000000 0.000000 -1.000000 3.000000 0.000000 1.000000 3.000000 2.000000 -1.000000 3.000000 2.000000] \"normal N\" [ 0.000000 0.000000 1.000000 0.000000 0.000000 1.000000 0.000000 0.000000 1.000000 0.000000 0.000000 1.000000 0.000000 -0.707083 0.707083 0.000000 -0.707083 0.707083 0.000000 -1.000000 0.000000 0.000000 -1.000000 0.000000] \"float uv\" [ 0.333334 0.000000 0.333334 0.333334 0.000000 0.333334 0.000000 0.000000 0.666667 0.000000 0.666667 0.333333 1.000000 0.000000 1.000000 0.333333 ]\n" to:strout
	format "AttributeEnd\n" to:strout
	
	
	--LIGHT SELECTION
	if (mat.useEmission == false) then
	(
		
			if (mat.dd_preview_light == 1) then
				(	
				format "AttributeBegin\n" to:strout
				format "Transform [1.0 0.0 0.0 0.0  0.0 1.0 0.0 0.0  0.0 0.0 1.0 0.0  1.0 -1.0 4.0 1.0]\n" to:strout
				format "Texture \"pL\" \"color\" \"blackbody\" \"float temperature\" [6500.0]\n" to:strout
				format "LightSource \"point\" \"texture L\" [\"pL\"] \"float gain\" [0.002]\n" to:strout
				format "AttributeEnd\n" to:strout
				)
			if (mat.dd_preview_light == 2) then
				(
				format "AttributeBegin\n" to:strout
				format "Transform [1.0 0.0 0.0 0.0  0.0 1.0 0.0 0.0  0.0 0.0 1.0 0.0  1.0 -4.0 1.0 1.0]\n" to:strout
				format "ReverseOrientation\n" to:strout
				format "AreaLightSource \"area\" \"color L\" [1.0 1.0 1.0]\n" to:strout
				format "\"float gain\" [0.3]\n" to:strout
				format "Shape \"disk\" \"float radius\" [1.0]\n" to:strout
				format "AttributeEnd\n" to:strout
				)
			if (mat.dd_preview_light == 3) then
				(
				format "AttributeBegin\n" to:strout
				format "Transform [1.0 0.0 0.0 0.0  0.0 1.0 0.0 0.0  0.0 0.0 1.0 0.0  1.0 -1.0 4.0 1.0]\n" to:strout
				format "Texture \"pL\" \"color\" \"blackbody\" \"float temperature\" [6500.0]\n" to:strout
				format "LightSource \"point\" \"texture L\" [\"pL\"] \"float gain\" [0.002]\n" to:strout
				format "AttributeEnd\n" to:strout
				format "AttributeBegin\n" to:strout
				format "LightSource \"sky\" \"float gain\" [0.0001]\n" to:strout
				format "AttributeEnd\n" to:strout
				)
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
	dd_preview_scene type:#integer ui:m_dd_preview_scene default:1
	dd_preview_quality type:#integer ui:m_dd_preview_quality default:1
	dd_preview_size type:#integer ui:m_dd_preview_size default:1
	dd_preview_light type:#integer ui:m_dd_preview_light default:1
	bzoom type:#boolean ui:m_bzoom default:false
    filename type:#string
	preview_time type:#float default:3
	teapotfilename type:#string
)

rollout preview "Preview" width:334 height:260
(
	dropdownList m_dd_preview_scene "Scene"  width:70 height:40 items:#("sphere", "torus", "teapot") across:4
	dropdownList m_dd_preview_quality "Render Quality"  width:70 height:40 items:#("low", "medium", "high", "extra")
	dropdownList m_dd_preview_size "Render Size"  width:70 height:40 items:#("small", "medium", "large", "extra") 
	dropdownList m_dd_preview_light "Lighting"  width:70 height:40 items:#("direct", "area", "direct+sky")
	checkbox m_bzoom "Zoom"  width:80 height:19 across:2
	button m_preview "Make Preview" width:80 height:40 
	

	Timer timer1 "" width:24 height:24 interval:1000 active:false
	bitmap pictureBox1 "" across:1 align:#center width:300 height:300  across:1  
	
	
	on preview open do
	(
        FileInGamma = 1
		teapotfilename = fixWindowsPath ((getdir #scripts) + "\Luxmax\Ply\Teapot.ply")
		timer1.active = false
		filename = this.name as string
		pictureBox1.filename = ((getdir #temp) + "\matpreview_" + (filename as string) + ".png" ) 
	)
	
	on m_preview pressed do
	(	
		luxMaterialPreview this
		
		if dd_preview_quality == 1 then preview_time = 7
		if dd_preview_quality == 2 then preview_time = 12
		if dd_preview_quality == 3 then preview_time = 17
		if dd_preview_quality == 4 then preview_time = 32
		
		if timer1.active == false then
		(	
		timer1.active = true
		)
		
	)
	
	on timer1 tick do
		(
			
		if timer1.ticks == preview_time do
		(	
		print "updating preview"
		pictureBox1.filename = ((getdir #temp) + "\matpreview_" + (filename as string) + ".png" )
		timer1.active = false
		timer1.ticks = 0
		)
		
		)
		
	
)
