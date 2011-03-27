plugin TextureMap LuxrenderEqualEnergy name:"LR Equal Energy" classID:#(0x7a0a50ef, 0x55967bcd) extends:Bitmaptexture replaceUI:true version:1
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
		
		
		format "Texture \"%\" \"color\" \"equalenergy\"\n" this.name to:str
		luxWriteFloat "energy"  this.energy str
 
		return str as string
	)
	
	
	
	
	
parameters main rollout:rlequalenergy
(
	energy type:#float ui:menergy default:1
)	
	
rollout rlequalenergy "Equal Energy Texture Parameter" width:314 height:399
(

	spinner menergy "Energy" range:[0,1,1] scale:0.001 align:#center 
	
)
	
	
	
)