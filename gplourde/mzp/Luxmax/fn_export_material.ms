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

function export_texturemaps =
(
	str = stringstream ""
	
	texturemaps = #()
	
	
	
	for obj in geometry do
	(
		if (obj.ishidden) then continue
		if (CheckLuxRenderCompat obj.material == false) then continue
		
		for _t in (obj.material.GetTextureMaps()) do
		(
			GetTextureMapsProc _t &texturemaps
		)

	)
	
	print texturemaps
	texturemaps = makeUniqueArray texturemaps
	print "------AFTER-------"
	print texturemaps
	
    for i = texturemaps.count to 1 by -1 do
	(
		format "%\r\n" (texturemaps[i].GetLuxRenderString()) to:str
	)
	
	return str as string
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

function export_lxm lxm =
(
	str = stringstream ""
	
	format "%" (export_volumes()) to:str
	format "%" (export_texturemaps()) to:str
	
	materials = #()
	
	for obj in geometry do
	(
		if (obj.ishidden) then continue
		
		appendifunique materials obj.material
	)
	
	materials = makeUniqueArray materials
	
	for _m in materials do
	(
		try (format "%\r\n" (_m.GetLuxRenderString()) to:str) catch ()
	)
	
	f = dotNetObject "System.IO.StreamWriter" lxm
	f.Write (str as string)
	f.Close()
)