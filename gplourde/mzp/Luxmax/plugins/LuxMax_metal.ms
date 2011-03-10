plugin material LuxrenderMetal name:"LR Metal" classID:#(0x26705ce9, 0x4c088767) extends:Standard replaceUI:true version:2
(
	include "luxmax\\fn_common.ms"
	include "luxmax\\mtl_logo.ms"
	
	function GetTextureMaps =
	(
		texturemaps = #(this.roughnessTexture, this.uroughnessTexture, this.vroughnessTexture, this.bumpmapTexture, this.emissionTexture)
		return texturemaps
	)
	
	function GetLuxRenderString =
	(
		str = stringstream ""
		
		format "MakeNamedMaterial \"%\"\n" this.name to:str
		
		if this.useanisotropy == true then
		(
			if this.uroughnessTexture != undefined then
			format "\t\"texture uroughness\" [\"%\"]\n" this.uroughnessTexture.name to:str
			else
			luxWriteFloat "uroughness"  this.uroughness str
		
			if this.vroughnessTexture != undefined then
			format "\t\"texture vroughness\" [\"%\"]\n" this.vroughnessTexture.name to:str
			else
			luxWriteFloat "vroughness"  this.vroughness str
			
		)
		else
		(
			if this.roughnessTexture != undefined then
			(format "\t\"texture uroughness\" [\"%\"]\n" this.roughnessTexture.name to:str)
			else
			(luxWriteFloat "uroughness"  this.roughness str)
		
			if this.roughnessTexture != undefined then
			(format "\t\"texture vroughness\" [\"%\"]\n" this.roughnessTexture.name to:str)
			else
			(luxWriteFloat "vroughness"  this.roughness str)
			
		)
		
		luxWriteString "type" "metal" str

		
		if (this.metalname == 1)do
				(
					luxWriteString "name" "aluminium" str
				)
				if (this.metalname == 2)do
				(
					luxWriteString "name" "amorphous carbon" str
				)				
				if (this.metalname == 3)do
				(
					luxWriteString "name" "gold" str
				)
				if (this.metalname == 4)do
				(
					luxWriteString "name" "copper" str
				)
				if (this.metalname == 5)do
				(
					luxWriteString "string filename" "[\"%\"]\n" this.nkdatapath str
				)
	
		return str as string
	)
	
	parameters main rollout:params
	(
		metalname type:#integer ui:mname default:1
		useanisotropy type:#boolean ui:museanisotropy
		roughness type:#float ui:mroughness default:0.0001
		roughnessTexture type:#textureMap ui:mroughnessTexture
		uroughness type:#float ui:muroughness default:0.0001
		uroughnessTexture type:#textureMap ui:muroughnessTexture
		vroughness type:#float ui:mvroughness default:0.0001
		vroughnessTexture type:#textureMap ui:mvroughnessTexture
	)
	
	rollout params "Metal Parameters"
	(
		label lbmetalselect "Select metal. . . . . . . . . . . ." across:2 align:#left 
		dropdownList mname "" items:#("Aluminium", "Amorphous carbon", "Gold", "Copper", "NK Data") align:#left
		
		label lbroughness "Roughness. . . . . . ." across:3 align:#left
		spinner mroughness " " range:[0.0001,1,0.1] width:50 align:#left fieldwidth:65 enabled:true scale:0.0001
		mapbutton mroughnessTexture "None" width:110 height:16 align:#right
		
		checkbox museanisotropy "Use Anisotropic Roughness" across:1 align:#left
		
		label lbu "u-roughness . . . . . . . " across:3 align:#left
		spinner muroughness " "  range:[0.0001,1,0.1] width:50 align:#left fieldwidth:65 scale:0.0001
		mapbutton muroughnessTexture "None" width:110 height:16 align:#right
		label lbv "v-roughness . . . . . . . " across:3 align:#left
		spinner mvroughness " " range:[0.0001,1,0.1]  width:50 align:#left fieldwidth:65 scale:0.0001
		mapbutton mvroughnessTexture "None" width:110 height:16 align:#right
		
		on museanisotropy changed s do
		(	
		    lbu.enabled = s
			lbv.enabled = s
			muroughness.enabled = s
			muroughnessTexture.enabled = s
			mvroughness.enabled = s
			mvroughnessTexture.enabled = s
		)	
		
		on mname selected i do
		(
			usenkdata = 0
			
			format "You selected '%'!\n" mname.items[i]
			if (mname.items[i] == "NK Data")then
			(
				--print "NkData selection works!!!!!!"
				
				f = getOpenFileName types:"NkData(*.nk)|*.nk" caption:"Open A NK Data File:" --\ 
				--filename:"c:/test/test.nk"
				if (f != undefined)then
				(
					
					
					nkdatapath = f
					lbl7.text =f as string
					print f
					usenkdata = 1
					print usenkdata as string					
					
					temppath = (f)
					print temppath
					temppathfixed = replaceChar (temppath as string) "\\" "\\\\"
					print temppathfixed
					print "end found nk data"
					nkdatapath = temppathfixed
					print nkdatapathm
				)
				else
				(
					usenkdata = 1
					nkdatapath = "No Nk file selected"
					lbl7.text =nkdatapath as string
				)
			)
			print usenkdata as string
			
		)
				
		
		on params open do
		(
			mental_ray_Preferences.mrExtensionsActive = false
			lbu.enabled = museanisotropy.state
			lbv.enabled = museanisotropy.state
			muroughness.enabled = museanisotropy.state
			muroughnessTexture.enabled = museanisotropy.state
			mvroughness.enabled = museanisotropy.state
			mvroughnessTexture.enabled = museanisotropy.state
		)
	)
	
	include "luxmax\\mtl_common.ms"
)