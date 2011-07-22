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

(
	global lux_outputbmp = undefined
	
	function lux_OpenRenderBuffer =
	(
		theFrm = dotNetObject "MaxCustomControls.MaxForm"
		theFrm.width = 1280
		theFrm.height = 720
		theFrm.text = "LuxRender"
		
		pictureBox1 =dotNetObject "System.Windows.Forms.PictureBox"
		
		pictureBox1.Image = dotNetObject "System.Drawing.Bitmap" ("c:\\tmp\\teapot.png")
		pictureBox1.width = 1280
		pictureBox1.height = 720
		pictureBox1.location = dotNetObject "System.Drawing.Point" 0 0
	
		theFrm.controls.add(pictureBox1)
		
		thePtr = DotNetObject "System.IntPtr" (windows.getMAXHWND())
		theHwnd = DotNetObject "MaxCustomControls.Win32HandleWrapper" thePtr
		theFrm.Show(theHwnd)
	)
	
	lux_OpenRenderBuffer()
)