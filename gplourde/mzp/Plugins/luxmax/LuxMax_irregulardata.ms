plugin TextureMap LuxrenderIrregularData name:"LR Irregular Data" classID:#(0x11270981, 0x288e6988) extends:Bitmaptexture replaceUI:true version:1
(
	include "luxmax\\fn_common.ms"
	
	function GetTextureMaps =
	(
		texturemaps = #()
		return texturemaps
	)
		
		
	function GetLuxRenderString =
	(
		str = stringstream ""
		
		
		format "Texture \"%\" \"color\" \"irregulardata\"\n" this.name to:str
 
		return str as string
	)
	
	
	
	
	
parameters main rollout:rlirregulardata	
(

)	
	
rollout rlirregulardata "Irregular Data" width:314 height:399
(

)
	
	
	
)