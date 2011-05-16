plugin TextureMap LuxrenderBlenderMarble name:"LR Blender Marble" classID:#(0x7993480e, 0x799c73df) extends:Bitmaptexture replaceUI:true version:1
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
		
		format "Texture \"%:amount\" \"float\" \"blender_marble\"\n" this.name to:str
		
		ntype = #("soft", "sharp", "sharper")
		luxWriteString "type" ntype[this.ntype] str
		
		noisetype = #("soft_noise", "hard_noise")
		luxWriteString "noisetype" noisetype[this.noisetype] str
		
		luxwriteInteger "noisedepth" this.noisedepth str
		
		luxWriteFloat "noisesize" this.noisesize str
		luxWriteFloat "turbulence" this.turbulence str
		
		noisebasis2 = #("sin", "saw", "tri")
		luxWriteString "noisebasis2" noisebasis2[this.noisebasis2] str
		noisebasis = #("blender_original", "original_perlin", "improved_perlin","voronoi_f1" , "voronoi_f2", "voronoi_f3", "voronoi_f4", "voronoi_f1f2", "voronoi_crackle", "cell_noise")
		luxWriteString "noisebasis" noisebasis[this.noisebasis] str
		
		luxWriteFloat "bright" this.bright str
		luxWriteFloat "contrast" this.contrast str
		
		
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
		
		ntype type:#integer default:1 ui:mntype 
		noisetype type:#integer default:1 ui:mnoisetype 
		
		noisedepth type:#float ui:mnoisedepth default:2
		noisesize type:#float ui:mnoisesize default:0.25
		turbulence type:#float ui:mturbulence default:5
		
		noisebasis2 type:#integer default:1 ui:mnoisebasis2 
		noisebasis type:#integer default:1 ui:mnoisebasis 
		
		bright type:#float ui:mbright default:1
		contrast type:#float ui:mcontrast default:1
		
		
	)
		
	rollout params "Blender Voronoi"
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
		dropdownlist mntype "Type" items:#("soft", "sharp", "sharper") align:#left across:2
		dropdownlist mnoisetype "Noise Type" items:#("soft_noise", "hard_noise") align:#right
		spinner mnoisedepth "depth:" type:#integer range:[0,6,2] fieldwidth:40 across:3 align:#left
		spinner mnoisesize "size:" type:#float range:[0,10,0.25] fieldwidth:40  align:#middle
		spinner mturbulence "turbul:" type:#float range:[0,200,5] fieldwidth:40 align:#right
		dropdownlist mnoisebasis2 "Noise Basis 2" items:#("sin", "saw", "tri") across:2 align:#left
		dropdownlist mnoisebasis "Noise Basis" items:#("blender_original", "original_perlin", "improved_perlin","voronoi_f1" , "voronoi_f2", "voronoi_f3", "voronoi_f4", "voronoi_f1f2", "voronoi_crackle", "cell_noise") align:#right
		)

		group "Level"
		(
		spinner mbright "bright:" type:#float range:[-2,2,1] fieldwidth:65 across:2 align:#left
		spinner mcontrast "contrast:" type:#float range:[-2,2,0] fieldwidth:65 align:#right
		)
		
		
	)
	

	include "luxmax\\texture_common.ms"
)
