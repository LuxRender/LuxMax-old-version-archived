-- ----------------------------------------------------------------------------------------------------------------------------------------------------
-- Luxrender Materials plug-ins for 3dsmax
-- ----------------------------------------------------------------------------------------------------------------------------------------------------
--
-- Authors:
-- Guillaume Plourde
--
-- This program is free software; you can redistribute it and/or
-- modify it under the terms of the GNU General Public License
-- as published by the Free Software Foundation; version 2
-- of the License.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program; if not, write to the Free Software Foundation,
-- Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
--
-- ----------------------------------------------------------------------------------------------------------------------------------------------------

LuxrenderBlackbody = false

--// Matte

plugin material LuxrenderMatte name:"LR Matte" classID:#(0x61108483, 0x4d218a72) extends:Standard replaceUI:true version:1
( 
	parameters main rollout:params
	(
		kdColor type:#color default:[90,90,90] ui:mkdColor
		kdTexture type:#textureMap ui:mkdTexture

		usetranslucency type:#boolean ui:usetrans
		krColor type:#color default:[90,90,90] ui:mkrColor
		krTexture type:#textureMap ui:mkrTexture
		ktColor type:#color default:[90,90,90] ui:mktColor
		ktTexture type:#textureMap ui:mktTexture
		
		useSigma type:#boolean ui:museSigma
		sigma type:#float ui:msigma
		sigmaTexture type:#textureMap ui:msigmaTexture
		
		useBumpmap type:#boolean ui:museBumpmap
		bumpmap type:#float ui:mbumpmap
		bumpmapTexture type:#textureMap ui:mbumpmapTexture
		
		emission type:#boolean ui:memission
		emissionTexture type:#textureMap ui:memissionTexture
		
		useSubdivision type:#boolean ui:museSubdivision
		subdivision type:#integer ui:mSubdivision
		isSharpen type:#boolean ui:mSharpenBounds
		isSmooth type:#boolean ui:mSmooth
		
		useDisplacement type:#boolean ui:museDisplacement
		displacement type:#float ui:mdisplacement
		displacementTexture type:#textureMap ui:mdisplacementTexture
	)
	
	rollout params "Matte Parameters"
	(
		-- Basic matte parameters
		group "Basic Parameters" (
			label lb_diffuse "Diffuse . . . . . . . . ." align:#left across:3
			colorpicker mkdColor "" across:2 height:18 
			mapbutton mkdTexture"None" width:120 height:18 align:#right
		)
	
		group "Advanced Parameters"
		(
			-- Oren-Nayar parameters
			checkbox museSigma "Sigma . . . . . . ." across:3
			spinner msigma "" range:[0,100,0] width:68 align:#left
			mapbutton msigmaTexture "T" width:120 height:18 align:#right

			-- Bumpmap parameters
			checkbox museBumpmap "Bumpmap . . . ." across:3
			spinner mbumpmap "" scale:0.01 range:[0,1,0] width:68 align:#left
			mapbutton mbumpmapTexture "T" width:120 height:18 align:#right
	
			-- Emission paramters
			checkbox memission "Emission Texture . . . . . . . . ." across:2 enabled:false
			mapbutton memissionTexture "T" width:120 height:18 align:#right
		)
		
		on museSigma changed s do
		(
			msigma.enabled = s
			msigmaTexture.enabled = s
		)
		on museBumpmap changed s do
		(
			mbumpmap.enabled = s
			mbumpmapTexture.enabled = s
		)
		on memission changed s do
		(
			memissionTexture.enabled = s
		)
		group "Translucency Parameters"
		(
			checkbox usetrans "Translucency"
			label lb_reflection "Reflection . . . . . . ." align:#left across:3
			colorpicker mkrColor "" height:18 
			mapbutton mkrTexture"None" width:120 height:18 align:#right
			label lb_transmission "Transmission . . . . ." align:#left across:3
			colorpicker mktColor "" height:18 
			mapbutton mktTexture"None" width:120 height:18 align:#right
		)
		on usetrans changed s do
		(
			mkrColor.enabled = s
			mkrTexture.enabled = s
			mktColor.enabled = s
			mktTexture.enabled = s
			lb_reflection.enabled = s
			lb_transmission.enabled = s
			
			if (s == true) then
			(
				lb_diffuse.enabled = false
				mkdColor.enabled = false
				mkdTexture.enabled = false	
			)
			else
			(
				lb_diffuse.enabled = true
				mkdColor.enabled = true
				mkdTexture.enabled = true	
			)
		)
		group "Subdivision Parameters"
		(
			checkbox museSubdivision "Subdivision . . ." across:3 enabled:true
			spinner msubdivision "" scale:1 range:[0,12,0] type:#integer width:68 align:#left
			label lb0 ""
			checkbox mSharpenBounds "Sharpen Bounds" enabled:false
			checkbox mSmooth "Smooth" enabled:false
		)
		on museSubdivision changed s do
		(
			msubdivision.enabled = s
			mSharpenBounds.enabled = s
			mSmooth.enabled = s
		)
		group "Displacement Map Parameters"
		(
			checkbox museDisplacement "Displacement . ." across:3  enabled:true
			spinner mdisplacement "" scale:0.1 range:[-10,10,0] width:68 align:#left
			mapbutton mDisplacementTexture "T" width:120 height:18 align:#right
		)
		on museDisplacement changed s do
		(
			mdisplacement.enabled = s
			mDisplacementTexture.enabled = s
		)
		on params open do
		(
			msigma.enabled = museSigma.state
			msigmaTexture.enabled = museSigma.state
			
			mbumpmap.enabled = museBumpmap.state
			mbumpmapTexture.enabled = museBumpmap.state
			
			memissionTexture.enabled = memission.state
			
			msubdivision.enabled = museSubdivision.state
			mSharpenBounds.enabled = museSubdivision.state
			mSmooth.enabled = museSubdivision.state
			
			mdisplacement.enabled = museDisplacement.state
			mDisplacementTexture.enabled = museDisplacement.state
			
			lb_reflection.enabled = usetrans.state
			lb_transmission.enabled = usetrans.state
			mkrColor.enabled = usetrans.state
			mkrTexture.enabled = usetrans.state
			mktColor.enabled = usetrans.state
			mktTexture.enabled = usetrans.state
			
			if (usetrans.state == true) then
			(
				lb_diffuse.enabled = false
				mkdColor.enabled = false
				mkdTexture.enabled = false
			)
		)
	)
)

--// Glossy

plugin material LuxrenderGlossy name:"LR Glossy" classID:#(0xfe1ebdc, 0x3b7b37e6) extends:Standard replaceUI:true version:1
( 
	parameters main rollout:params
	(
		kdcolor type:#color default:[90,90,90] ui:mDiffuse
		kdtexture type:#textureMap ui:mDiffuseTexture
		kscolor type:#color default:[90,90,90] ui:mSpec
		kstexture type:#textureMap ui:mSpecTexture
		useka type:#boolean default:false ui:museabsorption
		kacolor type:#color default:[90,90,90] ui:mAbsorption
		katexture type:#textureMap ui:mAbsorptionTexture
		kadepth type:#float ui:mDepth default:0.15
		
		useior type:#boolean ui:chk_ior
		ior type:#float ui:spn_ior
		iorTexture type:#textureMap ui:m_IOR
		
		useBumpmap type:#boolean ui:museBumpmap
		bumpmap type:#float ui:mbumpmap
		bumpmapTexture type:#textureMap ui:mbumpmapTexture
		
		emission type:#boolean ui:memission
		emissionTexture type:#textureMap ui:memissionTexture
		
		useSubdivision type:#boolean ui:museSubdivision
		Subdivision type:#float ui:mSubdivision
		isSharpen type:#boolean ui:mSharpenBounds
		isSmooth type:#boolean ui:mSmooth
		
		useDisplacement type:#boolean ui:museDisplacement
		displacement type:#float ui:mdisplacement
		displacementTexture type:#textureMap ui:mdisplacementTexture
	)

	
	rollout params "Glossy Parameters"
	(
		group "Basic Parameters" (
			label lb_diffuse "Diffuse . . . . . . . . . " align:#left across:3
			colorpicker mDiffuse "" align:#left height:18
			mapbutton mDiffuseTexture"None" width:120 height:18 align:#right
			label useSpecular "Specular . . . . . . . ." across:3 align:#left
			colorpicker mSpec ""  align:#left height:18
			mapbutton mSpecTexture"None" width:120 height:18 align:#right
			checkbox museabsorption "Absorption . . . ." align:#left across:3
			colorpicker mAbsorption "" align:#left height:18 enabled:false
			mapbutton mAbsorptionTexture "None" width:120 height:18 align:#right enabled:false
			label lb_depth "Absorption Depth . . . . . . . . . . . . . . . . . . . . ." align:#left across:2
			spinner mDepth "" width:60 align:#right range:[0,15,0.15] scale:0.01
		)
		on museabsorption changed s do
		(
			mAbsorption.enabled = s
			mAbsorptionTexture.enabled = s
		)
		group "Advanced Parameters"
		(
			checkbox chk_ior "IOR . . . . . . . . " across:3
			spinner spn_ior "" width:68 range:[1,50,1.5] align:#left
			mapbutton m_IOR "T" width:120 height:20 align:#right
		
			label lb_exponentu "U-Exponent . . . . . . " across:3 enabled:false
			spinner spn_exponentu "" width:68  range:[1,1000000,50] align:#left enabled:false
			mapbutton spn_exponentuTexture "None" width:120 height:18 align:#right enabled:false
			label lb_exponentv "V-Exponent . . . . . . " across:3 enabled:false
			spinner spn_exponentv ""  width:68 range:[1,1000000,50] align:#left enabled:false
			mapbutton spn_exponentvTexture "None" width:120 height:18 align:#right enabled:false

			-- Bumpmap parameters
			checkbox museBumpmap "Bumpmap . . . ." across:3 enabled:true
			spinner mbumpmap "" scale:0.01 range:[0,1,0] width:68 align:#left
			mapbutton mbumpmapTexture "T" width:120 height:18 align:#right
			
			-- Emission paramters
			checkbox memission "Emission Texture . . . . . . . . . . " across:2 enabled:false
			mapbutton memissionTexture "T" width:120 height:18 align:#right
		)
		on chk_ior changed s do
		(
			spn_ior.enabled = s
			m_IOR.enabled = s
		)
		on museBumpmap changed s do
		(
			mbumpmap.enabled = s
			mbumpmapTexture.enabled = s
		)
		on memission changed s do
		(
			memissionTexture.enabled = s
		)
		group "Subdivision Parameters"
		(
			checkbox museSubdivision "Subdivision . . ." across:3 enabled:true
			spinner msubdivision "" scale:1 range:[0,12,0] type:#integer width:50 align:#left
			label lb0 ""
			checkbox mSharpenBounds "Sharpen Bounds"
			checkbox mSmooth "Smooth"
		)
		on museSubdivision changed s do
		(
			msubdivision.enabled = s
			mSharpenBounds.enabled = s
			mSmooth.enabled = s
		)
		group "Displacement Map Parameters"
		(
			checkbox museDisplacement "Displacement . ." across:3  enabled:true
			spinner mdisplacement "" scale:0.1 range:[-10,10,0] width:50 align:#left
			mapbutton mDisplacementTexture "T" width:120 height:18 align:#right
		)
		on museDisplacement changed s do
		(
			mdisplacement.enabled = s
			mDisplacementTexture.enabled = s
		)
		on params open do
		(
			mAbsorption.enabled = museabsorption.state
			mAbsorptionTexture.enabled = museabsorption.state
			spn_ior.enabled = chk_ior.state
			m_ior.enabled = chk_ior.state
			
			mbumpmap.enabled = museBumpmap.state
			mbumpmapTexture.enabled = museBumpmap.state
			
			memissionTexture.enabled = memission.state
			
			msubdivision.enabled = museSubdivision.state
			mSharpenBounds.enabled = museSubdivision.state
			mSmooth.enabled = museSubdivision.state
			
			mdisplacement.enabled = museDisplacement.state
			mDisplacementTexture.enabled = museDisplacement.state
		)
	)
)

--// Glass

plugin material LuxrenderGlass name:"LR Glass" classID:#(0x1416e9d, 0x5f7312b0) extends:Standard replaceUI:true version:1
( 
	parameters main rollout:params
	(
		Kt type:#color default:[255,255,255] ui:mTransmission
		KtTexture type:#textureMap ui:mTransmissionTexture
		Kr type:#color default:[255,255,255] ui:mReflection
		KrTexture type:#textureMap ui:mReflectionTexture
		
		useior type:#boolean ui:chk_ior
		ior type:#float ui:spn_ior
		iorTexture type:#textureMap ui:m_IOR
		
		useBumpmap type:#boolean ui:museBumpmap
		bumpmap type:#float ui:mbumpmap
		bumpmapTexture type:#textureMap ui:mbumpmapTexture
		
		emission type:#boolean ui:memission
		emissionTexture type:#textureMap ui:memissionTexture
		
		useSubdivision type:#boolean ui:museSubdivision
		Subdivision type:#float ui:mSubdivision
		isSharpen type:#boolean ui:mSharpenBounds
		isSmooth type:#boolean ui:mSmooth
		
		useDisplacement type:#boolean ui:museDisplacement
		displacement type:#float ui:mdisplacement
		displacementTexture type:#textureMap ui:mdisplacementTexture
	)

	
	rollout params "Glass Parameters"
	(
		group "Glass Parameters"
		(
			label lb_Transmission "Transmission . . . . ." align:#left across:3
			colorpicker mTransmission "" height:18
			mapbutton mTransmissionTexture"None" width:120 height:18 align:#right
			label lb_Reflection "Reflection . . . . . . . " align:#left across:3
			colorpicker mReflection "" height:18
			mapbutton mReflectionTexture"None" width:120 height:18 align:#right
		)
		group "Advanced Parameters"
		(
			checkbox chk_ior "IOR . . . . . . . . " across:3
			spinner spn_ior "" width:68 range:[1,50,1.5] align:#left
			mapbutton m_IOR "T" width:120 height:20 align:#right
		
			label lb_exponentu "U-Exponent . . . . . . " across:3 enabled:false
			spinner spn_exponentu "" width:68  range:[1,1000000,50] align:#left enabled:false
			mapbutton spn_exponentuTexture "None" width:120 height:18 align:#right enabled:false
			label lb_exponentv "V-Exponent . . . . . . " across:3 enabled:false
			spinner spn_exponentv ""  width:68 range:[1,1000000,50] align:#left enabled:false
			mapbutton spn_exponentvTexture "None" width:120 height:18 align:#right enabled:false

			-- Bumpmap parameters
			checkbox museBumpmap "Bumpmap . . . ." across:3 enabled:true
			spinner mbumpmap "" scale:0.01 range:[0,1,0] width:68 align:#left
			mapbutton mbumpmapTexture "T" width:120 height:18 align:#right

			-- Emission paramters
			checkbox memission "Emission Texture . . . . . . . . . . " across:2 enabled:true
			mapbutton memissionTexture "T" width:120 height:18 align:#right
		)
		on chk_ior changed s do
		(
			spn_ior.enabled = s
			m_IOR.enabled = s
		)
		on museBumpmap changed s do
		(
			mbumpmap.enabled = s
			mbumpmapTexture.enabled = s
		)
		on memission changed s do
		(
			memissionTexture.enabled = s
		)			
		group "Subdivision Parameters"
		(
			checkbox museSubdivision "Subdivision . . ." across:3 enabled:true
			spinner msubdivision "" scale:1 range:[0,12,0] type:#integer width:50 align:#left  enabled:false
			label lb0 ""
			checkbox mSharpenBounds "Sharpen Bounds" enabled:false
			checkbox mSmooth "Smooth" enabled:false
		)
		on museSubdivision changed s do
		(
			msubdivision.enabled = s
			mSharpenBounds.enabled = s
			mSmooth.enabled = s
		)
		group "Displacement Map Parameters"
		(
			checkbox museDisplacement "Displacement . ." across:3  enabled:true
			spinner mdisplacement "" scale:0.1 range:[-10,10,0] width:50 align:#left
			mapbutton mDisplacementTexture "T" width:120 height:18 align:#right
		)
		on museDisplacement changed s do
		(
			mdisplacement.enabled = s
			mDisplacementTexture.enabled = s
		)
		on params open do
		(
			spn_ior.enabled = chk_ior.state
			m_ior.enabled = chk_ior.state
			
			mbumpmap.enabled = museBumpmap.state
			mbumpmapTexture.enabled = museBumpmap.state
			
			memissionTexture.enabled = memission.state
			
			msubdivision.enabled = museSubdivision.state
			mSharpenBounds.enabled = museSubdivision.state
			mSmooth.enabled = museSubdivision.state
			
			mdisplacement.enabled = museDisplacement.state
			mDisplacementTexture.enabled = museDisplacement.state
		)
	)
)

--// RoughGlass

plugin material LuxrenderRoughGlass name:"LR RoughGlass" classID:#(0x24fa894, 0x727a5aca) extends:Standard replaceUI:true version:1
( 
	parameters main rollout:params
	(
		Kt type:#color default:[255,255,255] ui:mTransmission
		KtTexture type:#textureMap ui:mTransmissionTexture
		Kr type:#color default:[255,255,255] ui:mReflection
		KrTexture type:#textureMap ui:mReflectionTexture

		usecauchyb type:#boolean ui:useCauchyb
		cauchyb type:#float ui:mcauchyb
		cauchybTexture type:#textureMap ui:mcauchybTexture
		
		useior type:#boolean ui:chk_ior
		ior type:#float ui:spn_ior
		iorTexture type:#textureMap ui:m_IOR
		
		useBumpmap type:#boolean ui:museBumpmap
		bumpmap type:#float ui:mbumpmap
		bumpmapTexture type:#textureMap ui:mbumpmapTexture
		
		emission type:#boolean ui:memission
		emissionTexture type:#textureMap ui:memissionTexture
		
		useSubdivision type:#boolean ui:museSubdivision
		Subdivision type:#float ui:mSubdivision
		isSharpen type:#boolean ui:mSharpenBounds
		isSmooth type:#boolean ui:mSmooth
		
		useDisplacement type:#boolean ui:museDisplacement
		displacement type:#float ui:mdisplacement
		displacementTexture type:#textureMap ui:mdisplacementTexture
	)

	rollout params "Glass Parameters"
	(
		group "Glass Parameters"
		(
			label lb_Transmission "Transmission . . . . ." align:#left across:3
			colorpicker mTransmission "" height:18
			mapbutton mTransmissionTexture"None" width:120 height:18 align:#right
			label lb_Reflection "Reflection . . . . . . . " align:#left across:3
			colorpicker mReflection "" height:18
			mapbutton mReflectionTexture"None" width:120 height:18 align:#right
		)
		group "Dispersive Refraction"
		(
			checkbox useCauchyb "Dispersive Refraction"
			label lb_cauchyb "Cauchyb . . . . . . . " across:3 align:#left
			spinner mcauchyb ""  width:68 scale:0.001 range:[0, 1, 0.02] align:#left
		)
		group "Advanced Parameters"
		(
			mapbutton mcauchybTexture "None" width:120 height:18 align:#right
			checkbox chk_ior "IOR . . . . . . . . " across:3
			spinner spn_ior "" width:68 range:[1,50,1.5] align:#left
			mapbutton m_IOR "T" width:120 height:20 align:#right
			
			label lb_exponentu "U-Exponent . . . . . . " across:3 enabled:false
			spinner spn_exponentu "" width:68  range:[1,1000000,50] align:#left enabled:false
			mapbutton spn_exponentuTexture "None" width:120 height:18 align:#right enabled:false
			label lb_exponentv "V-Exponent . . . . . . " across:3 enabled:false
			spinner spn_exponentv ""  width:68 range:[1,1000000,50] align:#left enabled:false
			mapbutton spn_exponentvTexture "None" width:120 height:18 align:#right enabled:false

			-- Bumpmap parameters
			checkbox museBumpmap "Bumpmap . . . ." across:3 enabled:true
			spinner mbumpmap "" scale:0.01 range:[0,1,0] width:68 align:#left
			mapbutton mbumpmapTexture "T" width:120 height:18 align:#right

			-- Emission paramters
			checkbox memission "Emission Texture . . . . . . . . . . " across:2 enabled:false
			mapbutton memissionTexture "T" width:120 height:18 align:#right
		)
		on chk_ior changed s do
		(
			spn_ior.enabled = s
			m_IOR.enabled = s
		)
		on museBumpmap changed s do
		(
			mbumpmap.enabled = s
			mbumpmapTexture.enabled = s
		)
		on memission changed s do
		(
			memissionTexture.enabled = s
		)			
		group "Subdivision Parameters"
		(
			checkbox museSubdivision "Subdivision . . ." across:3 enabled:true
			spinner msubdivision "" scale:1 range:[0,12,0] type:#integer width:50 align:#left  enabled:false
			label lb0 ""
			checkbox mSharpenBounds "Sharpen Bounds" enabled:false
			checkbox mSmooth "Smooth" enabled:false
		)
		on museSubdivision changed s do
		(
			msubdivision.enabled = s
			mSharpenBounds.enabled = s
			mSmooth.enabled = s
		)
		group "Displacement Map Parameters"
		(
			checkbox museDisplacement "Displacement . ." across:3  enabled:true
			spinner mdisplacement "" scale:0.1 range:[-10,10,0] width:50 align:#left
			mapbutton mDisplacementTexture "T" width:120 height:18 align:#right
		)
		on museDisplacement changed s do
		(
			mdisplacement.enabled = s
			mDisplacementTexture.enabled = s
		)
		on params open do
		(
			spn_ior.enabled = chk_ior.state
			m_ior.enabled = chk_ior.state
			
			mbumpmap.enabled = museBumpmap.state
			mbumpmapTexture.enabled = museBumpmap.state
			
			memissionTexture.enabled = memission.state
			
			msubdivision.enabled = museSubdivision.state
			mSharpenBounds.enabled = museSubdivision.state
			mSmooth.enabled = museSubdivision.state
			
			mdisplacement.enabled = museDisplacement.state
			mDisplacementTexture.enabled = museDisplacement.state
		)
	)
)

--// Metal

plugin material LuxrenderMetal name:"LR Metal" classID:#(0x26705ce9, 0x4c088767) extends:Standard replaceUI:true version:1
( 
	parameters main rollout:params
	(
		metalname type:#integer ui:mname default:1
		
		useBumpmap type:#boolean ui:museBumpmap
		bumpmap type:#float ui:mbumpmap
		bumpmapTexture type:#textureMap ui:mbumpmapTexture
		
		emission type:#boolean ui:memission
		emissionTexture type:#textureMap ui:memissionTexture
		
		useSubdivision type:#boolean ui:museSubdivision
		Subdivision type:#float ui:mSubdivision
		isSharpen type:#boolean ui:mSharpenBounds
		isSmooth type:#boolean ui:mSmooth
		
		useDisplacement type:#boolean ui:museDisplacement
		displacement type:#float ui:mdisplacement
		displacementTexture type:#textureMap ui:mdisplacementTexture
	)

	
	rollout params "Metal Parameters"
	(
		dropdownlist mname "Name:"  items:#("Aluminium", "Amorphous carbon", "Gold", "Copper")
		
		group "Advanced Parameters"
		(
			label lb_exponentu "U-Exponent . . . . . . " across:3 enabled:false
			spinner spn_exponentu "" width:68  range:[1,1000000,50] align:#left enabled:false
			mapbutton spn_exponentuTexture "None" width:120 height:18 align:#right enabled:false
			label lb_exponentv "V-Exponent . . . . . . " across:3 enabled:false
			spinner spn_exponentv ""  width:68 range:[1,1000000,50] align:#left enabled:false
			mapbutton spn_exponentvTexture "None" width:120 height:18 align:#right enabled:false

			-- Bumpmap parameters
			checkbox museBumpmap "Bumpmap . . . ." across:3 enabled:false
			spinner mbumpmap "" scale:0.01 range:[0,1,0] width:68 align:#left
			mapbutton mbumpmapTexture "T" width:120 height:18 align:#right

			-- Emission paramters
			checkbox memission "Emission Texture . . . . . . . . . . " across:2 enabled:false
			mapbutton memissionTexture "T" width:120 height:18 align:#right
		)
		on museBumpmap changed s do
		(
			mbumpmap.enabled = s
			mbumpmapTexture.enabled = s
		)
		on memission changed s do
		(
			memissionTexture.enabled = s
		)			
		group "Subdivision Parameters"
		(
			checkbox museSubdivision "Subdivision . . ." across:3 enabled:true
			spinner msubdivision "" scale:1 range:[0,12,0] type:#integer width:50 align:#left  enabled:false
			label lb0 ""
			checkbox mSharpenBounds "Sharpen Bounds" enabled:false
			checkbox mSmooth "Smooth" enabled:false
		)
		on museSubdivision changed s do
		(
			msubdivision.enabled = s
			mSharpenBounds.enabled = s
			mSmooth.enabled = s
		)
		group "Displacement Map Parameters"
		(
			checkbox museDisplacement "Displacement . ." across:3  enabled:true
			spinner mdisplacement "" scale:0.1 range:[-10,10,0] width:50 align:#left
			mapbutton mDisplacementTexture "T" width:120 height:18 align:#right
		)
		on museDisplacement changed s do
		(
			mdisplacement.enabled = s
			mDisplacementTexture.enabled = s
		)
		on params open do
		(
			mbumpmap.enabled = museBumpmap.state
			mbumpmapTexture.enabled = museBumpmap.state
			
			memissionTexture.enabled = memission.state
			
			msubdivision.enabled = museSubdivision.state
			mSharpenBounds.enabled = museSubdivision.state
			mSmooth.enabled = museSubdivision.state
			
			mdisplacement.enabled = museDisplacement.state
			mDisplacementTexture.enabled = museDisplacement.state
		)
	)
)

--// Null

plugin material LuxrenderNull name:"LR Null" classID:#(0x128af87a, 0x6e0169dc) extends:Standard replaceUI:true version:1
(
	rollout params "Null Parameters"
	(
	)
)

--// Car Paint

plugin material LuxrenderCarPaint name:"LR Car Paint" classID:#(0x4d900917, 0x6546d259) extends:Standard replaceUI:true version:1
( 
	parameters main rollout:params
	(
		paintname type:#integer ui:mname default:1
		useka type:#boolean default:false ui:museabsorption
		kacolor type:#color default:[90,90,90] ui:mAbsorption
		katexture type:#textureMap ui:mAbsorptionTexture
		kadepth type:#float ui:mDepth default:4
		
		useBumpmap type:#boolean ui:museBumpmap
		bumpmap type:#float ui:mbumpmap
		bumpmapTexture type:#textureMap ui:mbumpmapTexture
		
		useSubdivision type:#boolean ui:museSubdivision
		Subdivision type:#float ui:mSubdivision
		isSharpen type:#boolean ui:mSharpenBounds
		isSmooth type:#boolean ui:mSmooth
		
		useDisplacement type:#boolean ui:museDisplacement
		displacement type:#float ui:mdisplacement
		displacementTexture type:#textureMap ui:mdisplacementTexture
	)

	
	rollout params "Car Paint Parameters"
	(
		dropdownlist mname "Name:"  items:#("Blue Matte", "Blue", "White", "2k Acrylack", "BMW 339", "Opel Titan", "Polaris Silber", "Ford F8")
		group "Basic Parameters" (
			checkbox museabsorption "Absorption . . . ." align:#left across:3
			colorpicker mAbsorption "" align:#left height:18 enabled:false
			mapbutton mAbsorptionTexture "None" width:120 height:18 align:#right enabled:false
			label lb_depth "Absorption Depth . . . . . . . . . . . . . . . . . . . . ." align:#left across:2
			spinner mDepth "" width:60 align:#right range:[0,15,0.15] scale:0.01
		)
		on museabsorption changed s do
		(
			mAbsorption.enabled = s
			mAbsorptionTexture.enabled = s
		)
		group "Advanced Parameters"
		(
			-- Bumpmap parameters
			checkbox museBumpmap "Bumpmap . . . ." across:3 enabled:false
			spinner mbumpmap "" scale:0.01 range:[0,1,0] width:68 align:#left
			mapbutton mbumpmapTexture "T" width:120 height:18 align:#right
			
			-- Emission paramters
			checkbox memission "Emission Texture . . . . . . . . . . " across:2 enabled:false
			mapbutton memissionTexture "T" width:120 height:18 align:#right
		)
		on museBumpmap changed s do
		(
			mbumpmap.enabled = s
			mbumpmapTexture.enabled = s
		)
		on memission changed s do
		(
			memissionTexture.enabled = s
		)
		group "Subdivision Parameters"
		(
			checkbox museSubdivision "Subdivision . . ." across:3 enabled:true
			spinner msubdivision "" scale:1 range:[0,12,0] type:#integer width:50 align:#left
			label lb0 ""
			checkbox mSharpenBounds "Sharpen Bounds"
			checkbox mSmooth "Smooth"
		)
		on museSubdivision changed s do
		(
			msubdivision.enabled = s
			mSharpenBounds.enabled = s
			mSmooth.enabled = s
		)
		group "Displacement Map Parameters"
		(
			checkbox museDisplacement "Displacement . ." across:3  enabled:true
			spinner mdisplacement "" scale:0.1 range:[-10,10,0] width:50 align:#left
			mapbutton mDisplacementTexture "T" width:120 height:18 align:#right
		)
		on museDisplacement changed s do
		(
			mdisplacement.enabled = s
			mDisplacementTexture.enabled = s
		)
		on params open do
		(
			mAbsorption.enabled = museabsorption.state
			mAbsorptionTexture.enabled = museabsorption.state
			
			mbumpmap.enabled = museBumpmap.state
			mbumpmapTexture.enabled = museBumpmap.state
			
			memissionTexture.enabled = memission.state
			
			msubdivision.enabled = museSubdivision.state
			mSharpenBounds.enabled = museSubdivision.state
			mSmooth.enabled = museSubdivision.state
			
			mdisplacement.enabled = museDisplacement.state
			mDisplacementTexture.enabled = museDisplacement.state
		)
	)
)

-- // Area Light

plugin material LuxrenderLight name:"LR Light" classID:#(0x23131fb9, 0x5134a570) extends:Standard replaceUI:true version:1
( 
	parameters main rollout:paramsEm
	(
		AreaLightSourceMap type:#textureMap ui:m_emissionTexture
	)
	
	rollout paramsEm "Light"
	(
		mapbutton m_emissionTexture "T" width:300 height:20 align:#center
	)
	
	on create do
	(
		AreaLightSourceMap = LuxrenderBlackbody name:""
	)
)

--// Portal

plugin material LuxrenderPortal name:"LR Portal" classID:#(0x6b0906a2, 0x159a3fc0) extends:Standard replaceUI:true version:1
(
	rollout params "Portal Parameters"
	(
	)
)