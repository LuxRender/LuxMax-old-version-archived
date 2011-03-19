plugin TextureMap LuxrenderColorScale name:"LR Color Scale" classID:#(0x310d8e68, 0x2721a267) extends:Bitmaptexture replaceUI:true version:1
(
	include "luxmax\\fn_common.ms"
	
	function GetTextureMaps =
	(
		texturemaps = #(this.maptex1, this.maptex2)
		return texturemaps
	)
	
	function GetLuxRenderString =
	(
		str = stringstream ""

		format "Texture \"%\" \"color\" \"scale\"\n" this.name to:str
		
		if (this.maptex1 != undefined) then
			format "\t \"texture tex1\" [\"%\"]\n" this.maptex1.name to:str
		else
			luxWriteColor "tex1" this.colortex1 str
		
		if (this.maptex2 != undefined) then
			format "\t \"texture tex2\" [\"%\"]\n" this.maptex2.name to:str
		else		
			luxWriteColor "tex2" this.colortex2 str

		return str as string
	)
	
	parameters main rollout:params
	(
		colortex1 type:#color ui:tex1Scale
		colortex2 type:#color ui:tex2Scale
		
		maptex1 type:#texturemap ui:tex1Texture
		maptex2 type:#texturemap ui:tex2Texture
	)
	rollout params "ImageMap Parameters"
	(
		-- tex1 parameters
		label lbTex1 "Texture 1 . . . . . . ."  align:#left across:3
		colorpicker tex1Scale " " width:80 height:16 align:#left
		mapbutton tex1Texture "T" width:110 height:16 align:#right
		
		-- tex2 parameters
		label lbTex2 "Texture 2 . . . . . . ."  align:#left across:3
		colorpicker  tex2Scale " " width:80 height:16 align:#left
		mapbutton tex2Texture "T" width:110 height:16 align:#right		
	)
)