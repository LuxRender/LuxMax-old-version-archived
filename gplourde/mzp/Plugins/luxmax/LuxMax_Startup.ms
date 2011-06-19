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

macroScript Lux_RenderSetup category:"LuxRender" tooltip:"Render Setup"
(
	if doesFileExist @"$scripts\luxmax\luxmax.ms" do filein @"$scripts\luxmax\luxmax.ms" 
)

LuxRenderMenu = menuMan.findMenu "LuxRender"

if (LuxRenderMenu != undefined) then
(
	menuMan.unRegisterMenu LuxRenderMenu
)

(
	mainMenuBar = menuMan.getMainMenuBar()

	LuxRenderMenu = menuMan.createMenu "LuxRender"
	
	item0 = menuMan.createActionItem "Lux_RenderSetup" "LuxRender"
	item0.setTitle "Render Setup"
	item0.setUseCustomTitle true
	LuxRenderMenu.addItem item0 -1

	subMenuItem  = menuMan.createSubMenuItem "LuxRender Menu" LuxRenderMenu
	subMenuIndex = mainMenuBar.numItems() -1
	
	mainMenuBar.addItem subMenuItem subMenuIndex
	
	menuMan.updateMenuBar()
)
