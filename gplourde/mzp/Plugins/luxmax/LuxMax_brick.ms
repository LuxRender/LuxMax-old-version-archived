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

plugin TextureMap LuxrenderBrick name:"LR Brick" classID:#(0x7e5627ee, 0x12e07349) extends:Bitmaptexture replaceUI:true version:1
(
	include "luxmax\\fn_common.ms"
	
	function GetTextureMaps = 
	(
		texturemaps = #(this.tex1, this.tex2, this.tex3)
		return texturemaps
	)
	
	function GetLuxRenderString =
	(
		str = stringstream ""
		
		format "Texture \"%\"" this.name to:str
		
		if this.type == 1 then
				(format "\t\"float\"" to:str)
			else
				(format "\t\"color\"" to:str)
		
		format "\t\"brick\"\n" to:str
		
		luxWriteFloat "brickwidth" this.brickwidth str
		luxWriteFloat "brickheight" this.brickheight str
		luxWriteFloat "brickdepth" this.brickdepth str
		
		luxWriteFloat "mortarsize" this.mortarsize str
		
		bond = #("running", "flemish", "english", "herringbone", "basket", "chain link", "stucked")
		luxWriteString "brickbond" bond[this.bond] str
		
		if (this.bond == 1 or this.bond == 2) then (luxWriteFloat "brickrun" this.brickrun str)

		if this.Tex1 != undefined then
				format "\t\"texture bricktex\" [\"%\"]\n" this.Tex1.name to:str
			else
				luxWriteColor "bricktex"  this.bricktex str
			
		if this.Tex2 != undefined then
				format "\t\"texture mortartex\" [\"%\"]\n" this.Tex2.name to:str
			else
				luxWriteColor "mortartex"  this.mortartex str
		
		if this.Tex3 != undefined then
				format "\t\"texture brickmodtex\" [\"%\"]\n" this.Tex3.name to:str
			else
				luxWriteColor "brickmodtex"  this.brickmodtex str
		
		format "\t\"vector scale\" [% % %]\n" this.xs this.ys this.zs to:str
		format "\t\"vector rotate\" [% % %]\n" this.xr this.yr this.zr to:str
		format "\t\"vector translate\" [% % %]\n" this.xt this.yt this.zt to:str
		
		coordinates = #("local", "global", "local_normal", "global_normal", "uv")
		luxWriteString "coordinates" coordinates[this.coordinates] str
		

		return str as string
	)
	
	parameters main rollout:params
	(
		bricktex type:#color ui:mbricktex default:[255,255,255]
		Tex1 type:#textureMap ui: mTex1
		mortartex type:#color ui:mmortartex default:[0,0,0]
		Tex2 type:#textureMap ui: mTex2
		brickmodtex type:#color ui:mbrickmodtex default:[255,255,255]
		Tex3 type:#textureMap ui: mTex3

		brickwidth type:#float ui:mbrickwidth default:0.3
		brickheight type:#float ui:mbrickheight default:0.1
		brickdepth type:#float ui:mbrickdepth default:0.15
		mortarsize type:#float ui:mmortarsize default:0.01
		
		bond type:#integer default:1 ui:mbond
		brickrun type:#float ui:mbrickrun default:0.5
		
	
	)
		
	rollout params "Brick Parameters"
	(
		group "Colors or Textures"
		(
		label lb1 "Brick . . . . . . . . ."  align:#left across:3 default:#enabled 
		colorpicker mbricktex "" align:#left width:80 height:16
		mapbutton mTex1 "" width:110 height:16 align:#right
		label lb2 "Mortar . . . . . . . . ."  align:#left across:3 default:#enabled 
		colorpicker mmortartex "" align:#left width:80 height:16
		mapbutton mTex2 "" width:110 height:16 align:#right
		label lb3 "Brickmod . . . . . . . . ."  align:#left across:3 default:#enabled 
		colorpicker mbrickmodtex "" align:#left width:80 height:16
		mapbutton mTex3 "" width:110 height:16 align:#right
		)
		group "Parameters"
		(
		spinner mbrickwidth "Brick width:" type:#float range:[0,10,0.3] fieldwidth:65 across:2 align:#left
		spinner mbrickheight "Brick height:" type:#float range:[0,10,0.1] fieldwidth:65  align:#right
		spinner mbrickdepth "Brick depth:" type:#float range:[0,10,0.15] fieldwidth:65  across:2 align:#left
		spinner mmortarsize "Mortar size:" type:#float range:[0,1,0] fieldwidth:65  align:#right
		dropdownlist mbond "Bond Type" items:#("running", "flemish", "english", "herringbone", "basket", "chain link", "stucked") across:2 align:#left
		spinner mbrickrun "Brick run:" type:#float range:[-10,10,0.5] fieldwidth:65  align:#right 
		)
		
		on mbond selected i do
		(
			if (mbond.selection == 1 or mbond.selection == 2) 
			then mbrickrun.enabled = true
			else mbrickrun.enabled = false
		)
		
	)
	

	include "luxmax\\texture_common.ms"
)
