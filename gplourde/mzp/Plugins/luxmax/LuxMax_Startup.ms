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
