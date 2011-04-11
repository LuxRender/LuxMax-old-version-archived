--LuxGlass2 Material
Plugin material LuxRenderGlass2 name:"LR Glass2" classID:#(0x1a82153d,0x7175d56)extends:standard replaceUI:true version:2
(
	include "luxmax\\fn_common.ms"
	include "luxmax\\mtl_logo.ms"
	
	function GetTextureMaps =
	(
		texturemaps = #()
		return texturemaps
	)
	
	function GetLuxRenderString =
	(
		str = stringstream ""
		format "#BEGIN Glass2 Material: %\n" this.name to:str
		format "MakeNamedMaterial \"%\"\n" this.name to:str
		luxWriteBool "architectural" this.isarchitectural str
		luxWriteBool "dispersion" this.isdispersion str
		luxWriteString "type" "glass2" str
		format "#END Glass2 Material: %\n" this.name to:str
		return str as string
	)
	
	parameters main rollout:paramsEm
	(
		isarchitectural type:#boolean ui:marchitectural
		isdispersion type:#boolean ui:mdispersion
	)
	
	rollout paramsEm "settings"
	(
		checkbox marchitectural "Architectural"
		checkbox mdispersion "Dispersion"
	
	
	on paramsEm open do
	(
		delegate.opacity = 50
	)
	)
	include "luxmax\\mtl_common.ms"
)