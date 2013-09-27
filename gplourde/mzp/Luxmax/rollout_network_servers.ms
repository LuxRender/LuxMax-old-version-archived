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
persistent global networkservers -- = #()

rollout lux_NetworkServers "Network Servers" width:320 height:240 rolledup:true
(
	listbox lbx1_networkServers "ListBox" pos:[8,96] width:296 height:8
	edittext edt1_networkServers_ip "" pos:[16,32] width:112 height:24
	edittext edt2_networkServers_port "" pos:[160,32] width:56 height:24 
 
	button btn_networkserver_Add "Add" pos:[16,64] width:112 height:24
	label lbl_networkserver_ip "Ip" pos:[24,8] width:24 height:16
	label lbl2_networkserver_port "port (18018 is default)" pos:[168,8] width:110 height:16
	button btn_networkserversClear "Clear server list" pos:[136,64] width:88 height:24
	
	
	on lux_NetworkServers open do
	(
		print ("opened network render gui")
		lbx1_networkServers.items = networkservers
		if (networkservers == undefined)do
		(
			networkservers = #()
		)
	)
	on btn_networkserver_Add pressed do
	(
		if (edt1_networkServers_ip.text == "")then
		(
			messagebox("Please enter IP")
			return 1
		)
		
		if (edt2_networkServers_port.text == "")then
		(
			messagebox("Please enter port")
			return 1
		)
		
		append networkservers (edt1_networkServers_ip.text + ":" + edt2_networkServers_port.text)
		lbx1_networkServers.items = networkservers
	)
	on btn_networkserversClear pressed do
	(
		networkservers = #()
		lbx1_networkServers.items = networkservers
	)
)
