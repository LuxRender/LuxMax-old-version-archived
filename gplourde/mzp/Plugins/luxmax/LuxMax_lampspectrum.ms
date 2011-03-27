plugin TextureMap LuxrenderLampspectrum name:"LR Lampspectrum" classID:#(0x79817daf, 0x4e6312bc) extends:Bitmaptexture replaceUI:true version:1
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
		
		
		format "Texture \"%\" \"color\" \"lampspectrum\"\n" this.name to:str
		luxwriteString "name" this.lampstring str
		
		return str as string
	)
	
	
	
	
	
parameters main rollout:params
(
	lampstring type:#string 		
)	
	
rollout params "Lampspectrum" width:314 height:399
(
	dropdownlist lbx_lampspectrum "Lampspectrum Presets:" width:320 height:20 align:#center across:1

	on  lbx_lampspectrum selected val do
		(
			lampspectrum_presets = luxGetLampspectrumPresets()
			
			if lampspectrum_presets[val].value == undefined do return false
			lampstring = lampspectrum_presets[val].value
			
		)
	
	on params open do
		(
			items = #()
			
			for o in (luxGetLampspectrumPresets()) do
			(
				append items o.name
			)
			
			lbx_lampspectrum.items = items
		)
	
)



)
