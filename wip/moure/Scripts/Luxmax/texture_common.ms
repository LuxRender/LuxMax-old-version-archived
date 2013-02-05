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

parameters advanced rollout:transformations
	(
		type type:#integer default:2 ui:mtype
		
		xr type:#float ui:mxr default:0
		yr type:#float ui:myr default:0
		zr type:#float ui:mzr default:0
		
		xs type:#float ui:mxs default:1
		ys type:#float ui:mys default:1
		zs type:#float ui:mzs default:1
		
		xt type:#float ui:mxt default:0
		yt type:#float ui:myt default:0
		zt type:#float ui:mzt default:0
		
		coordinates  type:#integer default:1 ui:mcoordinates 
	)

rollout transformations "General"
	(	
			group "Texture Type"
		(
		dropdownlist mtype "Filter type:" items:#("float", "color") width:140 align:#left 
		)
		group "Scale Vector"
		(
		spinner mxs "x:" type:#float range:[0,1000,1] fieldwidth:40 across:3 align:#left
		spinner mys "y:" type:#float range:[0,1000,1] fieldwidth:40 align:#center
		spinner mzs "z:" type:#float range:[0,1000,1] fieldwidth:40 align:#right
		)
		group "Rotate Vector"
		(
		spinner mxr "x:" type:#float range:[0,360,0] fieldwidth:40 across:3 align:#left
		spinner myr "y:" type:#float range:[0,360,0] fieldwidth:40 align:#center
		spinner mzr "z:" type:#float range:[0,360,0] fieldwidth:40 align:#right
		)
		group "Translate Vector"
		(
		spinner mxt "x:" type:#float range:[-1000,1000,0] fieldwidth:40 across:3 align:#left
		spinner myt "y:" type:#float range:[-1000,1000,0] fieldwidth:40 align:#center
		spinner mzt "z:" type:#float range:[-1000,1000,0] fieldwidth:40 align:#right
		)
		group "Coordinates System"
		(
		dropdownlist mcoordinates "Space:" items:#("local", "global", "local_normal", "global_normal", "uv") align:#center across:1
		)
	)
	
function luxTexturePreview tex =
(
	strout = stringstream ""
	format "LookAt 0.0 0.0 1.0  0.0 0.0 0.0  0.0 1.0 0.0\n" to:strout
	format "Camera \"orthographic\" \"float screenwindow\" [-0.5 0.5 -0.5 0.5]\n" to:strout
	format "Film \"fleximage\"" to:strout
	--Size Params
	format "\"integer xresolution\" [200] \"integer yresolution\" [200]" to:strout 
	
	--Quality Params
	format "\"string tonemapkernel\" [\"linear\"] \"integer haltspp\" [100] \"integer halttime\" [5] \"integer reject_warmup\" [64] \"bool write_png\" [\"true\"] \"integer writeinterval\" [1] \"string filename\" [\"luxtexpreview_%\"]\n" tex.name to:strout

	format "PixelFilter \"mitchell\"\n" to:strout
	format "Sampler \"metropolis\"\n" to:strout
	format "SurfaceIntegrator \"bidirectional\"\n" to:strout
	format "VolumeIntegrator \"emission\"\n" to:strout
	format "WorldBegin\n\n" to:strout
	
	/*
	texturemaps = #()
	
	if (CheckLuxRenderCompat tex == false) then return false
	
	for _t in (tex.GetTextureMaps()) do (GetTextureMapsProc _t &texturemaps)

	texturemaps = makeUniqueArray texturemaps
	
	for i = texturemaps.count to 1 by -1 do (format "%\n" (texturemaps[i].GetLuxRenderString()) to:strout)
	
	try (format "%\r\n" (tex.GetLuxRenderString()) to:strout) catch ()
	*/
	
	format "%\r\n" (tex.GetLuxRenderString()) to:strout	
	format "MakeNamedMaterial \"01 - Default\"\n" to:strout
	format "\"texture Kd\" [\"%\"]\n" tex.name to:strout	
	format "\"float sigma\" [0.0]\n" to:strout
	format "\"string type\" [\"matte\"]\n" to:strout
		
	
	format "\nAttributeBegin\n" to:strout
		
	--CAMERA LOOK AT PROPERTIES

	format "Transform [0.5 0.0 0.0 0.0  0.0 0.5 0.0 0.0  0.0 0.0 0.5 0.0  0.0 0.0 0.5 1.0]\n" to:strout

	format "TransformBegin\n" to:strout
	format "Scale 1.000000 1.000000 1.000000\n" to:strout
	format "TransformEnd\n" to:strout
	format "NamedMaterial \"01 - Default\"\n" tex.name to:strout

	--SCENE 
	format "Shape \"trianglemesh\" \"integer indices\" [ 0 1 2 0 2 3 ] \"point P\" [1 1 0.0 1 -1 0.0 -1 -1 0.0 -1 1 0.0] \"float uv\" [0.0 1.0  0.0 0.0  1.0 0.0  1.0 1.0]\n" to:strout
	format "AttributeEnd\n\n" to:strout

	--PLANE	
	/*
	format "AttributeBegin\n" to:strout
	format "Transform [5.0 0.0 0.0 0.0  0.0 5.0 0.0 0.0  0.0 0.0 5.0 0.0  0.0 0.0 0.0 1.0]\n" to:strout
	format "Texture \"checks::pattern\" \"float\" \"checkerboard\"\"integer dimension\" [2] \"string mapping\" [\"uv\"] \"float uscale\" [36.8] \"float vscale\" [36.0]\n" to:strout
	format "Texture \"checks\" \"color\" \"mix\" \"texture amount\" [\"checks::pattern\"] \"color tex1\" [0.9 0.9 0.9] \"color tex2\" [0.0 0.0 0.0]\n" to:strout
	format "Material \"matte\" \"texture Kd\" [\"checks\"]\n" to:strout
	format "Shape \"loopsubdiv\" \"integer nlevels\" [3] \"bool dmnormalsmooth\" [\"true\"] \"bool dmsharpboundary\" [\"false\"] \"integer indices\" [ 0 1 2 0 2 3 1 0 4 1 4 5 5 4 6 5 6 7 ]\"point P\" [ 1.000000 1.000000 0.000000 -1.000000 1.000000 0.000000 -1.000000 -1.000000 0.000000 1.000000 -1.000000 0.000000 1.000000 3.000000 0.000000 -1.000000 3.000000 0.000000 1.000000 3.000000 2.000000 -1.000000 3.000000 2.000000] \"normal N\" [ 0.000000 0.000000 1.000000 0.000000 0.000000 1.000000 0.000000 0.000000 1.000000 0.000000 0.000000 1.000000 0.000000 -0.707083 0.707083 0.000000 -0.707083 0.707083 0.000000 -1.000000 0.000000 0.000000 -1.000000 0.000000] \"float uv\" [ 0.333334 0.000000 0.333334 0.333334 0.000000 0.333334 0.000000 0.000000 0.666667 0.000000 0.666667 0.333333 1.000000 0.000000 1.000000 0.333333 ]\n" to:strout
	format "AttributeEnd\n" to:strout
	*/
	
	--LIGHT
	format "AttributeBegin\n" to:strout
	format "Transform [1.0 0.0 0.0 0.0  0.0 1.0 0.0 0.0  0.0 0.0 1.0 0.0  1.0 -1.0 4.0 1.0]\n" to:strout
	format "Texture \"pL\" \"color\" \"blackbody\" \"float temperature\" [6500.0]\n" to:strout
	format "LightSource \"point\" \"texture L\" [\"pL\"] \"float gain\" [0.002]\n" to:strout
	format "AttributeEnd\n" to:strout

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
	filename type:#string
	preview_time type:#float default:3
)

rollout preview "Preview" width:334 height:206
(
	button m_preview "Make Preview" pos:[206,161] width:106 height:40 
 
 
	Timer timer1 "" pos:[13,52] width:24 height:24 interval:1000 active:false
	bitmap pictureBox "" pos:[2,2] width:200 height:200 across:1
	
	
	
	
	on preview open do
	(
		timer1.active = false
		pictureBox.filename = ((getdir #temp)+"\luxtexpreview_"+this.name+".png") 
	)
	on m_preview pressed do
	(	
		luxTexturePreview this
		if timer1.active == false then
		(	
		timer1.active = true
		)
		
	)
	on timer1 tick do
	(
			
	if timer1.ticks == 5 do
		(	
		print "updating preview"
		pictureBox.filename = ((getdir #temp) + "\luxtexpreview_" + this.name + ".png" )
		timer1.active = false
		timer1.ticks = 0
		)
		
	)
)
