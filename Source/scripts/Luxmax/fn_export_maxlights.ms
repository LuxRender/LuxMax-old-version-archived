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

fn lux_export_mrSkyPortal obj =
(
	str = stringstream ""
		
	p0 = ([-(obj.width / 2), -(obj.length / 2), 0])
	p1 = ([(obj.width / 2), -(obj.length / 2), 0])
	p2 = ([-(obj.width / 2), (obj.length / 2), 0])
	p3 = ([(obj.width / 2), (obj.length / 2), 0])
	
	points = #(p0, p1, p2, p3)
	
	--format "AttributeBegin # \"%\"\n" obj.name to:str

	r1 = obj.transform.row1
	r2 = obj.transform.row2
	r3 = obj.transform.row3
	r4 = obj.transform.row4
			
	format "\tTransform [% % % 0.0 % % % 0.0 % % % 0.0 % % % 1.0]\n" r1.x r1.y r1.z r2.x r2.y r2.z r3.x r3.y r3.z (r4.x * luxScaleUnit()) (r4.y * luxScaleUnit()) (r4.z * luxScaleUnit())to:str
	/*
	format "\tLightGroup \"default\"\n" to:str
	format "\tTexture \"area:light\" \"color\" \"blackbody\" \"float temperature\" [6500.0]\n" to:str
	format "\tAreaLightSource \"area\" \"texture L\" [\"area:light\"]\n" to:str
	format "\t\"float power\" [100.0]\n" to:str
	format "\t\"float efficacy\" [17.0]\n" to:str
	format "\t\"float gain\" [1.0]\n" to:str
	format "\tMaterial \"matte\" \"color Kd\" [0.8 0.8 0.8]\n" to:str
	*/
	format "\tPortalShape \"mesh\"\n" to:str
	format "\t\"integer triindices\" [2 3 1 0 2 1]\n" to:str
	format "\t\"point P\" [" to:str
	for p in points do
	(
		format "% % % " (p.x * luxScaleUnit()) (p.y * luxScaleUnit()) (p.z * luxScaleUnit()) to:str
	)
	format "]\n" to:str
	format "\t\"normal N\" [0 0 -1 0 0 -1 0 0 -1 0 0 -1 ]\n" to:str
	--format "AttributeEnd\n" to:str
	
	return (str as string)
)

fn lux_export_spot obj =
(
	numlightsource += 1
	str = stringstream ""
	
	tm = obj.transform
	t = [0,0,-1]

	r1 = obj.transform.row1
	r2 = obj.transform.row2
	r3 = obj.transform.row3
	r4 = obj.transform.row4
	
	format "AttributeBegin # %\n" obj.name to:str
	
	format "\tTransform [% % % 0.0 % % % 0.0 % % % 0.0 % % % 1.0]\n" r1.x r1.y r1.z r2.x r2.y r2.z r3.x r3.y r3.z (r4.x * luxScaleUnit()) (r4.y * luxScaleUnit()) (r4.z * luxScaleUnit())to:str
	
	format "LightGroup \"%\"\n" obj.name to:str
	format "LightSource \"spot\"\n" to:str
	luxWriteFloat "gain" obj.multiplier str
	luxWriteColor "L" obj.color str
	luxWritePoint "from" ([0, 0, 0]) str
	luxWritePoint "to" t str
	format "AttributeEnd # %\n\n" obj.name to:str
	
	return str as string
)

fn lux_export_direct obj =
(
	numlightsource += 1
	str = stringstream ""
	
	tm = obj.transform
	t = [0,0,-1]

	r1 = obj.transform.row1
	r2 = obj.transform.row2
	r3 = obj.transform.row3
	r4 = obj.transform.row4
	
	format "AttributeBegin # %\n" obj.name to:str
	
	format "\tTransform [% % % 0.0 % % % 0.0 % % % 0.0 % % % 1.0]\n" r1.x r1.y r1.z r2.x r2.y r2.z r3.x r3.y r3.z (r4.x * luxScaleUnit()) (r4.y * luxScaleUnit()) (r4.z * luxScaleUnit())to:str
	
	format "LightGroup \"%\"\n" obj.name to:str
	format "LightSource \"distant\"\n" to:str
	luxWriteFloat "gain" obj.multiplier str
	luxWriteColor "L" obj.color str
	luxWritePoint "from" ([0, 0, 0]) str
	luxWritePoint "to" t str
	format "AttributeEnd # %\n\n" obj.name to:str
	
	return str as string
)

fn lux_export_omni obj =
(
	numlightsource += 1
	str = stringstream ""
	
	r1 = obj.transform.row1
	r2 = obj.transform.row2
	r3 = obj.transform.row3
	r4 = obj.transform.row4
	
	format "AttributeBegin # %\n" obj.name to:str
	
	format "\tTransform [% % % 0.0 % % % 0.0 % % % 0.0 % % % 1.0]\n" r1.x r1.y r1.z r2.x r2.y r2.z r3.x r3.y r3.z (r4.x * luxScaleUnit()) (r4.y * luxScaleUnit()) (r4.z * luxScaleUnit())to:str
	
	format "LightGroup \"%\"\n" obj.name to:str
	format "LightSource \"point\"\n" to:str
	--luxWriteFloat "gain" obj.multiplier str
	--luxWriteColor "L" obj.color str
	luxWritePoint "from" ([0, 0, 0]) str
	format "AttributeEnd # %\n\n" obj.name to:str
	
	return str as string
)