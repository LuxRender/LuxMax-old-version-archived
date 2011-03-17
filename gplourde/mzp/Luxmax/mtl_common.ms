parameters common_parameters rollout:common
(
	useBumpmap type:#boolean ui:museBumpmap
	bumpmap type:#float ui:mbumpmap
	bumpmapTexture type:#textureMap ui:mbumpmapTexture
	useEmission type:#boolean ui:museEmission
	emissionTexture type:#textureMap ui:memissionTexture
	emissionColor type:#color ui:memissionColor default:white
	temperature type:#float default:6500 ui:mTemp
	power type:#float default:100 ui:mPower
	efficacy type:#float default:17 ui:mEfficacy
	gain type:#float default:1 ui:mGain
	arealightgroup type:#string ui:mGroup default:"arealight"
	interior type:#node ui:mInterior
	exterior type:#node ui:mExterior
)

rollout common "Common Parameters"
(
	fn volumeFilter obj = (
	(
		print obj
		classof obj) as string == "LuxRenderVolume"
	)
		
	group "Volume"
	(
		label lbinterior "Interior . . . . . . . . . . . . . . . . . . . . ." align:#left across:2
		pickbutton mInterior "none" width:110 height:16 align:#right autoDisplay:true filter:volumeFilter
		label lbexterior "Exterior . . . . . . . . . . . . . . . . . . . . ." align:#left across:2
		pickbutton mExterior "none" width:110 height:16 align:#right autoDisplay:true filter:volumeFilter
	)
	
	group "Bumpmap"
	(
		-- Bumpmap parameters
		checkbox museBumpmap "Bumpmap . . . . " across:3
		spinner mbumpmap " " scale:0.01 range:[0,1,0] width:50 align:#left fieldwidth:65
		mapbutton mbumpmapTexture "T" width:110 height:16 align:#right
	)
	
	on museBumpmap changed s do
	(
		mbumpmap.enabled = s
		mbumpmapTexture.enabled = s
	)

	group "Emission"
	(
		-- Emission paramters
		checkbox museEmission "Use Emission"
		
		label lblmGroup  "Group . . . . . . . . . ." across:3 align:#left
		edittext mGroup "" text:"default" width:200 align:#left
		label lblmGroup_
		
		label lb_emissionColor "Color . . . . . . . . . ." align:#left across:3
		colorpicker memissionColor width:85 align:#left height:16
		mapbutton memissionTexture "T" width:100 height:16 align:#left
		
		label lblmTemp  "Temp. (Kelvin) . . . . . . . . . . . . . . . . . . . . ." across:2 align:#left
		spinner mTemp " " range:[1000,10000,6500] fieldwidth:65 align:#right
		
		label lblmPower  "Power (W) . . . . . . . . . . . . . . . . . . . . . . ." across:2 align:#left
		spinner mPower " " range:[0,10000,100] fieldwidth:65 align:#right
		
		label lblmEfficacy  "Efficacy (LM/W) . . . . . . . . . . . . . . . . . . . ." across:2 align:#left
		spinner mEfficacy " " range:[0,100,17] fieldwidth:65 align:#right
		
		label lblmGain  "Gain . . . . . . . . . . . . . . . . . . . . . . . . . . . ." across:2 align:#left
		spinner mGain " " range:[0,100,1] align:#right fieldwidth:65
	)
	
	on museEmission changed s do
	(
		memissionTexture.enabled = s
	)

	on common open do
	(
		mbumpmap.enabled = museBumpmap.state
		mbumpmapTexture.enabled = museBumpmap.state
		memissionTexture.enabled = museEmission.state
	)
)