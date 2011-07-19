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

plugin TextureMap LuxrenderImageMap name:"LR ImageMap" classID:#(0x1bbf1b50, 0x39e50806) extends:Bitmaptexture replaceUI:true version:1
(
	include "luxmax\\fn_common.ms"
	
	function GetTextureMaps = (return #())
	
	function GetLuxRenderString =
	(
		str = stringstream ""
		
		type = #("float", "color")
		wrap = #("repeat", "black", "clamp")
		uv = #("uv", "spherical", "cylindrical", "planar")
		filtertype = #("bilinear", "nearest", "mipmap_ewa", "mipmap_trilinear")
		
		if this.normalmap == false then
		(	
		format "Texture \"%\" \"%\" \"imagemap\" \"string wrap\" [\"%\"] \"string filename\" [\"%\"]\n" this.name type[this.type] wrap[this.wrap] this.filename to:str
		)
		else
		(
		format "Texture \"%\" \"float\" \"normalmap\" \"string wrap\" [\"%\"] \"string filename\" [\"%\"]\n" this.name wrap[this.wrap] this.filename to:str	
		)
		luxWriteInteger "discardmipmaps" this.discardmipmaps str
		luxWriteString "filtertype" filtertype[this.filtertype] str
		
		luxWriteFloat "gain" this.gain str
		luxWriteFloat "gamma" this.gamma str
		luxWriteFloat "maxanisotropy" this.maxanisotropy str
		
		luxWriteString "mapping" uv[this.uv] str
		luxWriteFloat "uscale" this.uscale str
		luxWriteFloat "vscale" this.vscale str 
		luxWriteFloat "udelta" this.udelta str
		luxWriteFloat "vdelta" this.vdelta str 
		
		return str as string
	)
	
	parameters main rollout:params
	(
		normalmap type:#boolean default:false ui:m_normalmap
		
		filename type:#string default:"" ui:m_filename
		wrap type:#integer default:1 ui:m_wrap
		filtertype type:#integer default:1 ui:mfiltertype
		type type:#integer default:1 ui:mtype
		
		discardmipmaps type:#integer ui:mdiscardmipmaps default:0
		gain type:#float ui:mgain default:1
		gamma type:#float ui:mgamma default:2.2
		maxanisotropy type:#float ui:mmaxanisotropy default:8
	)
	rollout params "ImageMap Parameters"
	(
		label lb_filename "Bitmap:" align:#left
		button m_filename "" width:220 align:#left across:2
		button m_display "View Image" align:#right
		
		checkbox m_normalmap "Normal Map" align:#left
		dropdownlist mtype "Type:" items:#("float", "color") width:140 align:#left across:2
		dropdownlist m_wrap "Wrap:" items:#("Repeat", "Black", "white", "Clamp") width:140 align:#left
		dropdownlist mfiltertype "Filter type:" items:#("bilinear", "nearest", "mipmap_ewa", "mipmap_trilinear") width:140 align:#left
		
		label lbdiscardmipmaps "Discard mipmaps bellow . . . . . . . . . . . . . . ." across:2 align:#left
		spinner mdiscardmipmaps "" type:#integer range:[0,999999,0] fieldwidth:65
		label lbGain "Gain . . . . . . . . . . . . . . . . . . . . . . . . . . . ." across:2 align:#left
		spinner mgain "" type:#float range:[0,10,1] fieldwidth:65
		label lbgamma "Gamma . . . . . . . . . . . . . . . . . . . . . . . . . ." across:2 align:#left
		spinner mgamma "" type:#float range:[0,6,2.2] fieldwidth:65
		label lbmaxanisotropy "Max. Anisotropy . . . . . . . . . . . . . . . . . . . . " across:2 align:#left
		spinner mmaxanisotropy "" type:#float range:[-999999,999999,8] fieldwidth:65
		
		on m_display pressed do
		(
			if (delegate.bitmap == undefined) then return false
			
			display delegate.bitmap
		)
		
		on m_normalmap changed state do
		(
			if m_normalmap.checked == true then
			(	
			gamma = 1.0
			)
			else
			(	
			gamma = 2.2
			)
		)			
		
		
		
		on m_filename pressed do
		(
			f = getOpenFileName types:"Image(*.*)|*.*"
			
			if (f != undefined) do
			(
				r = fixWindowsPath f
				
				m_filename.text = r
				filename = r
				
				delegate.bitmap = openBitMap filename
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
	parameters main rollout:paramsCoordinates
	(
		uv type:#integer default:1 ui:m_uv
		uscale type:#float default:1 ui:m_uscale
		vscale type:#float default:1 ui:m_vscale
		udelta type:#float default:0 ui:m_udelta
		vdelta type:#float default:0 ui:m_vdelta
	)	
	rollout paramsCoordinates "Coordinates"
	(
		dropdownlist m_uv "Mapping:" items:#("uv", "vpherical", "cylindrical", "planar") align:#left width:140

		spinner m_uscale "U Scale:" range:[-100, 100, 1] fieldwidth:65 width:100 align:#left across:2
		spinner m_vscale "V Scale:" range:[-100, 100, 1] fieldwidth:65 width:100 align:#left
		
		spinner m_udelta "U Delta:" range:[-100, 100, 0] fieldwidth:65 width:100 align:#left across:2
		spinner m_vdelta "V Delta:" range:[-100, 100, 0] fieldwidth:65 width:100 align:#left
	)
)