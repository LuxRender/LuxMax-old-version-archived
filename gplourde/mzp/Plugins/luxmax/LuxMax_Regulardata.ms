plugin TextureMap LuxrenderRegularData name:"LR Regular Data" classID:#(0x7033425b, 0x2306160a) extends:Bitmaptexture replaceUI:true version:1
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
		
		
		format "Texture \"%\" \"color\" \"regulardata\"\n" this.name to:str
 
		return str as string
	)
	
	
	
	
	
parameters main rollout:rlregulardata	
(

)	
	
rollout rlregulardata "Regular Data" width:314 height:399
(

)
	
	
	
)