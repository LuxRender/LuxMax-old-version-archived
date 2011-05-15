plugin TextureMap LuxrenderBlenderStucci name:"LR Blender Stucci" classID:#(0xc1b3763, 0xe33083e) extends:Bitmaptexture replaceUI:true version:1
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
		
		format "Texture \"%:amount\" \"float\" \"blender_stucci\"\n" this.name to:str
		
		ntype = #("plastic", "wall_in", "wall_out")
		luxWriteString "type" ntype[this.ntype] str
		
		noisetype = #("soft_noise", "hard_noise")
		luxWriteString "noisetype" noisetype[this.noisetype] str
		
		luxWriteFloat "noisesize" this.noisesize str
		luxWriteFloat "turbulence" this.turbulence str
		
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
		
		noisesize type:#float ui:mnoisesize default:0.25
		turbulence type:#float ui:mturbulence default:5
		
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
		dropdownlist mntype "Type" items:#("plastic", "wall_in", "wall_out") align:#left across:2
		dropdownlist mnoisetype "Noise Type" items:#("soft_noise", "hard_noise") align:#right
		spinner mnoisesize "noise size:" type:#float range:[0,10,0.25] fieldwidth:65 across:2 align:#left
		spinner mturbulence "turbulence:" type:#float range:[0,200,5] fieldwidth:65 align:#right
		dropdownlist mnoisebasis "Noise Basis" items:#("blender_original", "original_perlin", "improved_perlin","voronoi_f1" , "voronoi_f2", "voronoi_f3", "voronoi_f4", "voronoi_f1f2", "voronoi_crackle", "cell_noise") align:#right
		)

		group "Level"
		(
		spinner mbright "bright:" type:#float range:[-2,2,1] fieldwidth:65 across:2 align:#left
		spinner mcontrast "contrast:" type:#float range:[-2,2,0] fieldwidth:65 align:#right
		)
		
		
	)
	

	parameters advanced rollout:transformations
	(
		type type:#integer default:1 ui:mtype
		
		xr type:#float ui:mxr default:0
		yr type:#float ui:myr default:0
		zr type:#float ui:mzr default:0
		
		xs type:#float ui:mxs default:1
		ys type:#float ui:mys default:1
		zs type:#float ui:mzs default:1
		
		xt type:#float ui:mxt default:0
		yt type:#float ui:myt default:0
		zt type:#float ui:mzt default:0
		
		coordinates  type:#integer default:1 ui:mcoordinates 
	)

	rollout transformations "General"
	(	
		group "Texture Type"
		(
		dropdownlist mtype "Filter type:" items:#("float", "color") width:140 align:#left 
		)
		group "Scale Vector"
		(
		spinner mxs "x:" type:#float range:[0,1000,1] fieldwidth:40 across:3 align:#left
		spinner mys "y:" type:#float range:[0,1000,1] fieldwidth:40 align:#center
		spinner mzs "z:" type:#float range:[0,1000,1] fieldwidth:40 align:#right
		)
		group "Rotate Vector"
		(
		spinner mxr "x:" type:#float range:[0,360,0] fieldwidth:40 across:3 align:#left
		spinner myr "y:" type:#float range:[0,360,0] fieldwidth:40 align:#center
		spinner mzr "z:" type:#float range:[0,360,0] fieldwidth:40 align:#right
		)
		group "Translate Vector"
		(
		spinner mxt "x:" type:#float range:[-1000,1000,0] fieldwidth:40 across:3 align:#left
		spinner myt "y:" type:#float range:[-1000,1000,0] fieldwidth:40 align:#center
		spinner mzt "z:" type:#float range:[-1000,1000,0] fieldwidth:40 align:#right
		)
		group "Coordinates System"
		(
		dropdownlist mcoordinates "Space:" items:#("local", "global", "local_normal", "global_normal", "uv") align:#center across:1
		)
	)
)
