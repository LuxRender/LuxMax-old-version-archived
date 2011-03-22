plugin material LuxrenderNull name:"LR Null" classID:#(0x604a23b3, 0x20a0550e) extends:Standard replaceUI:true version:2
(
	include "luxmax\\fn_common.ms"
	include "luxmax\\mtl_logo.ms"
	
	function GetTextureMaps =
	(
		texturemaps = #(this.emissionTexture)
		return texturemaps
	)
	
	function GetLuxRenderString =
	(
		str = stringstream ""
		
		format "MakeNamedMaterial \"%\"\r\n" this.name to:str
		
		luxWriteString "type" "null" str
		
		return str as string
	)
	
	parameters main rollout:params
	(
	)
	
	rollout params "There are not any Parameters in Null Material"
	(
		on params open do
		(
			mental_ray_Preferences.mrExtensionsActive = false
		)
	)
	
	include "luxmax\\mtl_common.ms"
)