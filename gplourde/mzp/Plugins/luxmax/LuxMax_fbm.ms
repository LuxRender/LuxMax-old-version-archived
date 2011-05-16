plugin TextureMap LuxrenderFbm name:"LR Fbm" classID:#(0x2e1760ac, 0x47ae5296) extends:Bitmaptexture replaceUI:true version:1
(
	include "luxmax\\fn_common.ms"
	
	function GetTextureMaps = 
	(
		texturemaps = #(this.tex1, this.tex2)
		return texturemaps
	)
	
	function GetLuxRenderString =
	(
		str = stringstream ""
		
		format "Texture \"%:amount\" \"float\" \"fbm\"\n" this.name to:str
		
		luxwriteInteger "octaves" this.octaves str
		luxWriteFloat "roughness" this.roughness str
		
		
		format "\t\"vector scale\" [% % %]\n" this.xs this.ys this.zs to:str
		format "\t\"vector rotate\" [% % %]\n" this.xr this.yr this.zr to:str
		format "\t\"vector translate\" [% % %]\n" this.xt this.yt this.zt to:str
		
		
		coordinates = #("local", "global", "local_normal", "global_normal", "uv")
		luxWriteString "coordinates" coordinates[this.coordinates] str
		
		format "Texture \"%\"" this.name to:str
		
		
		if this.type == 1 then
				(format "\t\"float\"" to:str)
			else
				(format "\t\"color\"" to:str)
		
		format "\t\"mix\"" to:str
		format "\t\"texture amount\" [\"%:amount\"]" this.name to:str
		
				
		if this.Tex1 != undefined then
				format "\t\"texture tex1\" [\"%\"]\n" this.Tex1.name to:str
			else
				luxWriteColor "tex1"  this.Color1 str
			
		if this.Tex2 != undefined then
				format "\t\"texture tex2\" [\"%\"]\n" this.Tex2.name to:str
			else
				luxWriteColor "tex2"  this.Color2 str
		
		

		return str as string
	)
	
	parameters main rollout:params
	(
		Color1 type:#color ui:mColor1 default:[255,255,255]
		Tex1 type:#textureMap ui: mTex1
		Color2 type:#color ui:mColor2 default:[0,0,0]
		Tex2 type:#textureMap ui: mTex2
		
		octaves type:#integer ui:moctaves default:6
		roughness type:#float ui:mroughness default:0.5
	)
		
	rollout params "Fbm parameters"
	(
		group "Colors or Textures"
		(
		label lb1 "Color1 . . . . . . . . ."  align:#left across:3 default:#enabled 
		colorpicker mColor1 "" align:#left width:80 height:16
		mapbutton mTex1 "Tex1" width:110 height:16 align:#right
		label lb2 "Color2 . . . . . . . . ."  align:#left across:3 default:#enabled 
		colorpicker mColor2 "" align:#left width:80 height:16
		mapbutton mTex2 "Tex2" width:110 height:16 align:#right
		)
		group "Noise Parameters"
		(
		spinner moctaves "Octaves:" type:#integer range:[1,100,6] fieldwidth:65 across:2 align:#left
		spinner mroughness "Roughness:" type:#float range:[0,1,0.5] fieldwidth:65   align:#right
		)
	)
	

	include "luxmax\\texture_common.ms"
)
