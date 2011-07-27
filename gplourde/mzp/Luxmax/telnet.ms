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

function slgtelnetWrite msg =
(
	local sglclient = undefined
	
	try (
		sglclient = DotNetObject "System.Net.Sockets.TcpClient" "127.0.0.1" 18081
	) catch ()
	
	if (sglclient != undefined) then
	(
		stream = sglclient.GetStream()

		data = (dotNetClass "System.Text.Encoding").ASCII.GetBytes (msg + "\n\r")
		for b in data do stream.WriteByte b
		stream.Flush()

		--data = #(0x255, 0x253, 0x18)
		--for b in data do stream.WriteByte b
		--stream.Flush()
		
		stream.Close()
		sglclient.Close()
	)
)


rollout sgl_telnetTest "SGL Telnet" width:216 height:104
(
	button btn_echo_on "Echo On"  width:96 height:21 across:2
	button btn_echo_off "Echo Off"  width:96 height:21
	button btn_render_start "Render Start"  width:96 height:21 across:2
	button btn_render_stop "Render Stop"  width:96 height:21 
	button btn_image_reset "Image Reset"  width:96 height:21 across:2
	button btn_camera_update "Update Camera" width:96 height:21
	Timer timerupdatecamera "" width:24 height:24 interval:1000 active:false
		
	on btn_echo_on pressed do
		slgtelnetWrite "echocmd.on"
	on btn_echo_off pressed do
		slgtelnetWrite "echocmd.off"
	on btn_render_start pressed do
		slgtelnetWrite "render.start"
	on btn_render_stop pressed do
		slgtelnetWrite "render.stop"
	on btn_image_reset pressed do
		slgtelnetWrite "image.reset"
	on btn_camera_update pressed do
	(
		timerupdatecamera.active = false
		timerupdatecamera.ticks = 0
		timerupdatecamera.active = true
		slgtelnetWrite "render.stop"
	)
	
	on timerupdatecamera tick do
	(
		
		if timerupdatecamera.ticks == 2 do
		(	
		newtm = Inverse(getViewTM())
		newpos = newtm.row4
		newup = normalize newtm.row2
		newlook = (newtm.row4 + -(normalize newtm.row3))
		newstring = "set scene.camera.lookat = " + ((newpos.x * luxScaleUnit()) as string) + " " + ((newpos.y * luxScaleUnit()) as string) + " " + ((newpos.z * luxScaleUnit()) as string) + " " + ((newlook.x * luxScaleUnit()) as string) + " " + ((newlook.y * luxScaleUnit()) as string) + " " + ((newlook.z * luxScaleUnit()) as string)  
		print (newstring as string)	
		slgtelnetWrite (newstring as string)

		)	
		if timerupdatecamera.ticks == 4 do
		(	
		slgtelnetWrite "render.start"
		)
		if timerupdatecamera.ticks == 5 do
		(	
		timerupdatecamera.active = false
		timerupdatecamera.ticks = 0
		)	
	)
	
)

--createdialog sgl_telnetTest 140 200 
