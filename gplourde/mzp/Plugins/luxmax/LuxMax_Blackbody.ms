plugin TextureMap LuxrenderBlackbody name:"LR Blackbody" classID:#(0x111b42bf, 0x63ee250a) extends:Bitmaptexture replaceUI:true version:1
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

		format "Texture \"%\" \"color\" \"blackbody\"\r\n" this.name to:str
		luxWriteFloat "temperature" this.temperature str

		return str as string
	)
	
	parameters main rollout:params
	(
		temperature type:#float default:6500 ui:mTemp
	)
	rollout params "Blackbody Parameters"
	(
		label lblmTemp  "Temp. (Kelvin) . . . . . . . . . . . . . . . . . . . . ." across:2 align:#left
		spinner mTemp " " range:[1000,10000,6500] fieldwidth:65 align:#right
	)
)