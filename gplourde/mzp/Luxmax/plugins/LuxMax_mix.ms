Plugin material LuxrenderMix name:"LR Mix" classID:#(0x1dd40858, 0x1b266b58) extends:standard replaceUI:true version:2
(
	include "luxmax\\fn_common.ms"
	
	function GetTextureMaps =
	(
		texturemaps = #(mmixvalueTexture)
		return texturemaps
	)
	
	function GetLuxRenderString =
	(
		str = stringstream ""
			
		if (CheckLuxRenderCompat this.material1 == true and CheckLuxRenderCompat this.material2 == true) then
		(
			format "#BEGIN Mix Material: %\n" this.name to:str
			format "%\n%\n" (this.material1.GetLuxRenderString()) (this.material2.GetLuxRenderString()) to:str		
			format "MakeNamedMaterial \"%\"\n" this.name to:str
			luxWriteString "namedmaterial1" this.material1.name str
			luxWriteString "namedmaterial2" this.material2.name str
				
			if this.mixvalueTexture != undefined then
				format "\t\"texture amount\" [\"%\"]\n" this.mixvalueTexture.name to:str
			else
				luxWriteFloat "amount"  this.mixvalue str
			
			luxWriteString "type" "mix" str
			format "#END Mix Material: %\n" this.name to:str
		)

		return str as string
	)
	parameters main rollout:paramsEm
	(
		material1 type:#material ui: mmaterial1
		material2 type:#material ui: mmaterial2
		
		mixvalue type:#float ui:mmixvalue default:0.5
		mixvalueTexture type:#textureMap ui:mmixvalueTexture
	)
	rollout paramsEm "Mix Parameters" width:160 height:64
	(
		label lbmaterial1 "Material 1 . . . . . . . . . . . . . . . . . . ." across:2 align:#left
		materialButton mmaterial1 "" width:110 height:16 align:#right
		label lbmaterial2 "Material 2 . . . . . . . . . . . . . . . . . . ." across:2 align:#left
		materialButton mmaterial2 "" width:110 height:16 align:#right
		
		label lbmixvalue "Mix amount . . . . ." across:3 align:#left
		spinner mmixvalue "" range:[0, 1, 0.5] type:#float width:50 fieldwidth:65 align:#left
		mapbutton mmixvalueTexture "" width:110 height:16 align:#right
	)
	include "luxmax\\mtl_common.ms"
)
