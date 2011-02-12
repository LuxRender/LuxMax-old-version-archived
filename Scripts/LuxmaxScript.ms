--This is written by stig atle steffensen www.stigatle.net
-- for luxrender exporter. www.luxrender.net
--with good help from Perpixel and  Guillermo M. Leal LLaguno (who created and release PBRT v2 exporter).

	persistent global IsMatteTexture
	persistent global IsLuxCamera
	persistent global render_width
	persistent global render_height
	persistent global doexport
	persistent global lxssavefilepath
	persistent global templxssavefilepath
	persistent global launchafterexport
	persistent global exefile 
	persistent global out_Geom_file
	persistent global exportanim
	persistent global sequencefolder
	persistent global sequencestart
	persistent global sequenceend
	persistent global exportanim
	persistent global tempframe
	persistent global exportwithplugin
	persistent global skip_exsisting_geom
	persistent global TheSkyPortals
	global exportply	
	persistent global temp_mat_file
	persistent global temp_geom_file
	global forpreview
	global tempShaderBox
	persistent global luxconsolepath
	
	fn writeToFile string &out_Geom_file =
	(
		format string to:out_Geom_file
	)
	
		fn PbrtColor c =
	(
		return ( ((c.r / 255)) as string + " " + ((c.g / 255)) as string + " " + ((c.b / 255)) as string )
	)
	
	fn replaceChar str oChar rChar = 
	(
		tStr = ""
		for i=1 to str.count do
		(
			if str[i] == oChar then tStr += rChar
			else tStr += str[i] 
		)
		tStr
	)
	
	fn preview_selected_material &temp_mat_file =
	(
		if (activeMeditSlot == undefined) then
		(
			messagebox "error.."
		)
		else 
		(
			format "#matname is = %\n" (meditMaterials[activeMeditSlot].name) to:temp_mat_file
			---------------------------------------------------------------------------------------------------------------------------
			format "LookAt 0.0 -3.0 0.5 0.0 -2.0 0.5 0.0 0.0 1.0\n" to:temp_mat_file
			format "Camera \"perspective\" \"float fov\" [22.5]\n" to:temp_mat_file
			format "Film \"fleximage\" \"integer xresolution\" [140] \"integer yresolution\" [140] \"integer ldr_writeinterval\" [3600] \"string tonemapkernel\" [\"linear\"] \"integer haltspp\" [1] \"integer reject_warmup\" [64] \"bool write_png\" [\"true\"] \"string filename\" [\"matpreview\"]\n" to:temp_mat_file
			format "PixelFilter \"mitchell\" \"float xwidth\" [1.500000] \"float ywidth\" [1.500000] \"float B\" [0.333330] \"float C\" [0.333330] \"bool supersample\" [\"true\"]\n" to:temp_mat_file
			format "Sampler \"lowdiscrepancy\" \"string pixelsampler\" [\"hilbert\"] \"integer pixelsamples\" [16]\n" to:temp_mat_file
			format "SurfaceIntegrator \"distributedpath\" \"integer directsamples\" [1] \"integer diffusereflectdepth\" [1] \"integer diffusereflectsamples\" [4] \"integer diffuserefractdepth\" [4] \"integer diffuserefractsamples\" [1] \"integer glossyreflectdepth\" [1] \"integer glossyreflectsamples\" [2] \"integer glossyrefractdepth\" [4] \"integer glossyrefractsamples\" [1] \"integer specularreflectdepth\" [2] \"integer specularrefractdepth\" [4]\n" to:temp_mat_file
			format "WorldBegin\n" to:temp_mat_file
			---------------------------------------------------------------------------------------------------------------------------
			--MATERIAL FOR PREVIEW OBJECT
			---------------------------------------------------------------------------------------------------------------------------
			format "AttributeBegin\n" to:temp_mat_file
			format "Include\"temp_matpreview.lxm\"\n" to:temp_mat_file
			format "Transform [0.5 0.0 0.0 0.0  0.0 0.5 0.0 0.0  0.0 0.0 0.5 0.0  0.0 0.0 0.5 1.0]\n" to:temp_mat_file
			format "TransformBegin\n" to:temp_mat_file
			format "Scale 1.000000 1.000000 1.000000\n" to:temp_mat_file
			format "TransformEnd\n" to:temp_mat_file
			format "Shape \"sphere\" \"float radius\" [1.0]\n" to:temp_mat_file
			format "AttributeEnd\n" to:temp_mat_file
			--MATERIAL FOR PREVIEW OBJECT
			---------------------------------------------------------------------------------------------------------------------------
			format "AttributeBegin\n" to:temp_mat_file
			format "Transform [5.0 0.0 0.0 0.0  0.0 5.0 0.0 0.0  0.0 0.0 5.0 0.0  0.0 0.0 0.0 1.0]\n" to:temp_mat_file
			format "Texture \"checks::pattern\" \"float\" \"checkerboard\"\"integer dimension\" [2] \"string aamode\" [\"supersample\"]\"string mapping\" [\"uv\"] \"float uscale\" [36.8] \"float vscale\" [36.0]\n" to:temp_mat_file
			format "Texture \"checks\" \"color\" \"mix\" \"texture amount\" [\"checks::pattern\"] \"color tex1\" [0.9 0.9 0.9] \"color tex2\" [0.0 0.0 0.0]\n" to:temp_mat_file
			format "Material \"matte\" \"texture Kd\" [\"checks\"]\n" to:temp_mat_file
			format "Shape \"loopsubdiv\" \"integer nlevels\" [3] \"bool dmnormalsmooth\" [\"true\"] \"bool dmsharpboundary\" [\"false\"] \"integer indices\" [ 0 1 2 0 2 3 1 0 4 1 4 5 5 4 6 5 6 7 ]\"point P\" [ 1.000000 1.000000 0.000000 -1.000000 1.000000 0.000000 -1.000000 -1.000000 0.000000 1.000000 -1.000000 0.000000 1.000000 3.000000 0.000000 -1.000000 3.000000 0.000000 1.000000 3.000000 2.000000 -1.000000 3.000000 2.000000] \"normal N\" [ 0.000000 0.000000 1.000000 0.000000 0.000000 1.000000 0.000000 0.000000 1.000000 0.000000 0.000000 1.000000 0.000000 -0.707083 0.707083 0.000000 -0.707083 0.707083 0.000000 -1.000000 0.000000 0.000000 -1.000000 0.000000] \"float uv\" [ 0.333334 0.000000 0.333334 0.333334 0.000000 0.333334 0.000000 0.000000 0.666667 0.000000 0.666667 0.333333 1.000000 0.000000 1.000000 0.333333 ]\n" to:temp_mat_file
			format "AttributeEnd\n" to:temp_mat_file
			format "AttributeBegin\n" to:temp_mat_file
			format "Transform [1.0 0.0 0.0 0.0  0.0 1.0 0.0 0.0  0.0 0.0 1.0 0.0  1.0 -1.0 4.0 1.0]\n" to:temp_mat_file
			format "Texture \"pL\" \"color\" \"blackbody\" \"float temperature\" [6500.0]\n" to:temp_mat_file
			format "LightSource \"point\" \"texture L\" [\"pL\"] \"float gain\" [0.002]\n" to:temp_mat_file
			format "AttributeEnd\n" to:temp_mat_file
			format "WorldEnd\n" to:temp_mat_file
			forpreview = 0
			
			
			
		)
	)
	
	
	fn load_diffuse Obj &out_Geom_file =
	(
	if (Obj.material.kdTexture != undefined) do
				(
					getandwriteMaterialTexture Obj.material.kdTexture out_Geom_file
					if (Obj.material.kdcolor.r as float != 255) or (Obj.material.kdcolor.g as float != 255) or (Obj.material.kdcolor.b as float != 255) then
					(
					format "Texture \"%.scale\" \"color\" \"scale\" \"texture tex1\" [\"%\"] \"color tex2\" [% % %]\n" Obj.material.kdtexture.name Obj.material.kdtexture.name (Obj.material.Kdcolor.r / 255) (Obj.material.Kdcolor.g / 255) (Obj.material.Kdcolor.b / 255)   to:out_Geom_file
					)
				)	
	)
	
	fn write_diffuse Obj &out_Geom_file =
	(
		if (Obj.material.kdTexture != undefined) then
			(
			if (Obj.material.kdcolor.r as float != 255) or (Obj.material.kdcolor.g as float != 255) or (Obj.material.kdcolor.b as float != 255) then
				(
				format "\"texture Kd\" \"%.scale\"\n" Obj.material.kdtexture.name to:out_Geom_file
				)
			else
				(
				format "\"texture Kd\" \"%\"\n" Obj.material.kdtexture.name to:out_Geom_file	
				)
			)
		else
		(
		format " \"color Kd\" [% % %]\n" (Obj.material.Kdcolor.r / 255) (Obj.material.Kdcolor.g / 255) (Obj.material.Kdcolor.b / 255)  to:out_Geom_file
		)	
	)
	
	fn load_specular Obj &out_Geom_file =
	(
		if (Obj.material.ksTexture != undefined) do
			(
				getandwriteMaterialTexture Obj.material.ksTexture out_Geom_file
				if (Obj.material.kscolor.r as float != 255) or (Obj.material.kscolor.g as float != 255) or (Obj.material.kscolor.b as float != 255) then
				(
				format "Texture \"%.scale\" \"color\" \"scale\" \"texture tex1\" [\"%\"] \"color tex2\" [% % %]\n" Obj.material.kstexture.name Obj.material.kstexture.name (Obj.material.Kscolor.r / 255) (Obj.material.Kscolor.g / 255) (Obj.material.Kscolor.b / 255)   to:out_Geom_file
				)
			)
	)
	
	fn write_specular Obj &out_Geom_file =
	(
		if (Obj.material.ksTexture != undefined) then
		(
			if (Obj.material.kscolor.r as float != 255) or (Obj.material.kscolor.g as float != 255) or (Obj.material.kscolor.b as float != 255) then
				(
				format "\"texture Ks\" \"%.scale\"\n" Obj.material.kstexture.name to:out_Geom_file
				)
			else
				(
				format "\"texture Ks\" \"%\"\n" Obj.material.kstexture.name to:out_Geom_file	
				)
		)
		else
		(
		format " \"color Ks\" [% % %]\n" (Obj.material.Kscolor.r / 255) (Obj.material.Kscolor.g / 255) (Obj.material.Kscolor.b / 255)  to:out_Geom_file
		)
	)
	
	fn load_sigma Obj &out_Geom_file =
	(
		if Obj.material.usesigma as string == "true" then
		(
			if (Obj.material.sigmaTexture != undefined) do
				(
				format "Texture \"%\" \"float\" \"imagemap\" \"string wrap\" [\"repeat\"] \"string filename\" [\"%\"]\n" Obj.material.sigmatexture.name obj.material.sigmatexture.filename to:out_Geom_file
				format "Texture \"%.scale\" \"float\" \"scale\" \"texture tex1\" [\"%\"] \"float tex2\" [%]\n" Obj.material.sigmatexture.name Obj.material.sigmatexture.name Obj.material.sigma to:out_Geom_file
				)
		)
	)
	
	fn write_sigma Obj &out_Geom_file =
	(	if Obj.material.usesigma as string == "true" then
		(
			if (Obj.material.sigmaTexture != undefined) then
			(
				format "\"texture sigma\" \"%.scale\"\n" Obj.material.sigmatexture.name to:out_Geom_file
			)
			else
			(
				format "\"float sigma\" [%]\n" Obj.material.sigma to:out_Geom_file
			)
		)	
	)
	
	fn load_uroughness Obj &out_Geom_file =
	(
			if (Obj.material.uroughnessTexture != undefined) do
				(
				format "Texture \"%\" \"float\" \"imagemap\" \"string wrap\" [\"repeat\"] \"string filename\" [\"%\"]\n" Obj.material.uroughnesstexture.name obj.material.uroughnesstexture.filename to:out_Geom_file
				format "Texture \"%.scale\" \"float\" \"scale\" \"texture tex1\" [\"%\"] \"float tex2\" [%]\n" Obj.material.uroughnesstexture.name Obj.material.uroughnesstexture.name Obj.material.uroughness to:out_Geom_file
				)
		
	)
	
	fn write_uroughness Obj &out_Geom_file =
	(	
			if (Obj.material.uroughnessTexture != undefined) then
			(
				format "\"texture uroughness\" \"%.scale\"\n" Obj.material.uroughnesstexture.name to:out_Geom_file
			)
			else
			(
				format "\"float uroughness\" [%]\n" Obj.material.uroughness to:out_Geom_file
			)
		
	)
	
	fn load_vroughness Obj &out_Geom_file =
	(
			if (Obj.material.vroughnessTexture != undefined) do
				(
				format "Texture \"%\" \"float\" \"imagemap\" \"string wrap\" [\"repeat\"] \"string filename\" [\"%\"]\n" Obj.material.vroughnesstexture.name obj.material.vroughnesstexture.filename to:out_Geom_file
				format "Texture \"%.scale\" \"float\" \"scale\" \"texture tex1\" [\"%\"] \"float tex2\" [%]\n" Obj.material.vroughnesstexture.name Obj.material.vroughnesstexture.name Obj.material.vroughness to:out_Geom_file
				)
		
	)
	
	fn write_vroughness Obj &out_Geom_file =
	(	
			if (Obj.material.vroughnessTexture != undefined) then
			(
				format "\"texture vroughness\" \"%.scale\"\n" Obj.material.vroughnesstexture.name to:out_Geom_file
			)
			else
			(
				format "\"float vroughness\" [%]\n" Obj.material.vroughness to:out_Geom_file
			)
		
	)
	
	fn load_bump Obj &out_Geom_file =
	(
		if Obj.material.useBumpmap as string == "true" then
		(
			if (Obj.material.bumpmapTexture != undefined) do
				(
				format "Texture \"%\" \"float\" \"imagemap\" \"string wrap\" [\"repeat\"] \"string filename\" [\"%\"]\n" Obj.material.bumpmaptexture.name obj.material.bumpmaptexture.filename to:out_Geom_file
				format "Texture \"%.scale\" \"float\" \"scale\" \"texture tex1\" [\"%\"] \"float tex2\" [%]\n" Obj.material.bumpmaptexture.name Obj.material.bumpmaptexture.name Obj.material.bumpMap to:out_Geom_file
				)
		)
	)
	
	fn write_bump Obj &out_Geom_file =
	(
		if (Obj.material.bumpmapTexture != undefined) do
			(
				format "\"texture bumpmap\" \"%.scale\"\n" Obj.material.bumpmaptexture.name to:out_Geom_file
			)
	)
	
	fn load_absorption Obj &out_Geom_file =
	(
		if Obj.material.useka as string == "true" then
		(
			if (Obj.material.kaTexture != undefined) do
				(
				format "Texture \"%\" \"color\" \"imagemap\" \"string wrap\" [\"repeat\"] \"string filename\" [\"%\"]\n" Obj.material.katexture.name obj.material.katexture.filename to:out_Geom_file
				format "Texture \"%.scale\" \"color\" \"scale\" \"texture tex1\" [\"%\"] \"color tex2\" [% % %]\n" Obj.material.katexture.name Obj.material.katexture.name (Obj.material.Kacolor.r / 255) (Obj.material.Kacolor.g / 255) (Obj.material.Kacolor.b / 255) to:out_Geom_file
				)
			if (Obj.material.dTexture != undefined) do
				(
				format "Texture \"%\" \"float\" \"imagemap\" \"string wrap\" [\"repeat\"] \"string filename\" [\"%\"]\n" Obj.material.dtexture.name obj.material.dtexture.filename to:out_Geom_file
				format "Texture \"%.scale\" \"float\" \"scale\" \"texture tex1\" [\"%\"] \"float tex2\" [%]\n" Obj.material.dtexture.name Obj.material.dtexture.name Obj.material.d to:out_Geom_file
				)
				
		)
	)
	
	fn write_absorption Obj &out_Geom_file =
	(
		if Obj.material.useka as string == "true" then
		(	
		if (Obj.material.kaTexture != undefined) then
		(
			if (Obj.material.kacolor.r as float != 255) or (Obj.material.kacolor.g as float != 255) or (Obj.material.kacolor.b as float != 255) then
				(
				format "\"texture Ka\" \"%.scale\"\n" Obj.material.katexture.name to:out_Geom_file
				)
			else
				(
				format "\"texture Ka\" \"%\"\n" Obj.material.katexture.name to:out_Geom_file	
				)
		)
		else
		(
		format " \"color Ka\" [% % %]\n" (Obj.material.Kacolor.r / 255) (Obj.material.Kacolor.g / 255) (Obj.material.Kacolor.b / 255)  to:out_Geom_file
		)
		if (Obj.material.dTexture != undefined) then
			(
				format "\"texture d\" \"%.scale\"\n" Obj.material.dtexture.name to:out_Geom_file
			)
			else
			(
				format "\"float d\" [%]\n" Obj.material.d to:out_Geom_file
			)
		)
	)
	
	fn load_bump Obj &out_Geom_file =
	(
		if Obj.material.useBumpmap as string == "true" then
		(
			if (Obj.material.bumpmapTexture != undefined) do
				(
				format "Texture \"%\" \"float\" \"imagemap\" \"string wrap\" [\"repeat\"] \"string filename\" [\"%\"]\n" Obj.material.bumpmaptexture.name obj.material.bumpmaptexture.filename to:out_Geom_file
				format "Texture \"%.scale\" \"float\" \"scale\" \"texture tex1\" [\"%\"] \"float tex2\" [%]\n" Obj.material.bumpmaptexture.name Obj.material.bumpmaptexture.name Obj.material.bumpMap to:out_Geom_file
				)
		)
	)
	
	fn write_bump Obj &out_Geom_file =
	(
		if (Obj.material.bumpmapTexture != undefined) do
			(
				format "\"texture bumpmap\" \"%.scale\"\n" Obj.material.bumpmaptexture.name to:out_Geom_file
			)
	)
	
	fn load_emissiontexture Obj &out_Geom_file =
	(
		if Obj.material.useEmission as string == "true" then
		(
       
			if (classof obj.material.emissionTexture == LuxrenderBlackbody) do
			(
			format "LightGroup \"%\"\n" obj.material.emissionTexture.group to:out_Geom_file	
			format "Texture \"%:light:L\" \"color\" \"blackbody\" \"float temperature\" [%]\n" Obj.name obj.material.emissionTexture.temperature to:out_Geom_file
			format "AreaLightSource \"area\" \"texture L\" [\"%:light:L\"]\n" Obj.name to:out_Geom_file
			format "\"float power\" [%]\n" obj.material.emissionTexture.power to:out_Geom_file
			format "\"float efficacy\" [%]\n" obj.material.emissionTexture.efficacy to:out_Geom_file
			format "\"float gain\" [%]\n" obj.material.emissionTexture.gain to:out_Geom_file
			)
			if (classof obj.material.emissionTexture == LuxrenderImageMap) do
			(
			format "LightGroup \"%\"\n" obj.material.emissionTexture.group to:out_Geom_file		
			format "Texture \"%:light:L\" \"color\" \"imagemap\" \"string wrap\"[\"repeat\"]\"string filename\" [\"%\"]\n" Obj.name obj.material.emissionTexture.filename to:out_Geom_file
			format "AreaLightSource \"area\" \"texture L\" [\"%:light:L\"]\n" Obj.name to:out_Geom_file
			format "\"float power\" [%]\n" obj.material.emissionTexture.power to:out_Geom_file
			format "\"float efficacy\" [%]\n" obj.material.emissionTexture.efficacy to:out_Geom_file
			format "\"float gain\" [%]\n" obj.material.emissionTexture.gain to:out_Geom_file
			)
			        
		)
    )
	
	fn write_emissiontexture Obj &out_Geom_file =
	(
		if (Obj.material.emissionTexture != undefined) do
			(
			format "\"texture emission\" [\"%\"]\n" Obj.material.emissionTexture.name to:out_Geom_file
			)
	)
	
	fn load_transmission Obj &out_Geom_file =
	(
	if (Obj.material.ktTexture != undefined) do
				(
					getandwriteMaterialTexture Obj.material.ktTexture out_Geom_file
					if (Obj.material.ktcolor.r as float != 255) or (Obj.material.ktcolor.g as float != 255) or (Obj.material.ktcolor.b as float != 255) then
					(
					format "Texture \"%.scale\" \"color\" \"scale\" \"texture tex1\" [\"%\"] \"color tex2\" [% % %]\n" Obj.material.kttexture.name Obj.material.kttexture.name (Obj.material.Ktcolor.r / 255) (Obj.material.Ktcolor.g / 255) (Obj.material.Ktcolor.b / 255)   to:out_Geom_file
					)
				)	
	)
	
	fn write_transmission Obj &out_Geom_file =
	(
		if (Obj.material.ktTexture != undefined) then
			(
			if (Obj.material.ktcolor.r as float != 255) or (Obj.material.ktcolor.g as float != 255) or (Obj.material.ktcolor.b as float != 255) then
				(
				format "\"texture Kt\" \"%.scale\"\n" Obj.material.kttexture.name to:out_Geom_file
				)
			else
				(
				format "\"texture Kt\" \"%\"\n" Obj.material.kttexture.name to:out_Geom_file	
				)
			)
		else
		(
		format " \"color Kt\" [% % %]\n" (Obj.material.Ktcolor.r / 255) (Obj.material.Ktcolor.g / 255) (Obj.material.Ktcolor.b / 255)  to:out_Geom_file
		)	
	)
	
	
	fn load_reflection Obj &out_Geom_file =
	(
	if (Obj.material.krTexture != undefined) do
				(
					getandwriteMaterialTexture Obj.material.krTexture out_Geom_file
					if (Obj.material.krcolor.r as float != 255) or (Obj.material.krcolor.g as float != 255) or (Obj.material.krcolor.b as float != 255) then
					(
					format "Texture \"%.scale\" \"color\" \"scale\" \"texture tex1\" [\"%\"] \"color tex2\" [% % %]\n" Obj.material.krtexture.name Obj.material.krtexture.name (Obj.material.Krcolor.r / 255) (Obj.material.Krcolor.g / 255) (Obj.material.Krcolor.b / 255)   to:out_Geom_file
					)
				)	
	)
	
	fn write_reflection Obj &out_Geom_file =
	(
		if (Obj.material.krTexture != undefined) then
			(
			if (Obj.material.krcolor.r as float != 255) or (Obj.material.krcolor.g as float != 255) or (Obj.material.krcolor.b as float != 255) then
				(
				format "\"texture Kr\" \"%.scale\"\n" Obj.material.krtexture.name to:out_Geom_file
				)
			else
				(
				format "\"texture Kr\" \"%\"\n" Obj.material.krtexture.name to:out_Geom_file	
				)
			)
		else
		(
		format " \"color Kr\" [% % %]\n" (Obj.material.Krcolor.r / 255) (Obj.material.Krcolor.g / 255) (Obj.material.Krcolor.b / 255)  to:out_Geom_file
		)	
	)
	
	fn write_simgatexture Obj &out_Geom_file =
	(
		format "\"texture sigma\" [\"%\"]\n" Obj.filename to:out_Geom_file
	)
	
	fn write_sigmaFloat Obj &out_Geom_file =
	(
		format "\"float sigma\" [%]\n" Obj.sigma to:out_Geom_file
	)
	
	fn write_texturemap Obj &out_Geom_file =
	(
		format "Texture \"%\"\n" Obj.name to:out_Geom_file
		format "\"color\" \"imagemap\" \"string wrap\" [\"repeat\"]\n" to:out_Geom_file
		format "\"string filename\" [\"%\"]\n" Obj.filename to:out_Geom_file

	)
	fn write_texturemap_float Obj &out_Geom_file=
	(
		format "Texture \"%\"\n" Obj.name to:out_Geom_file
		format "\"float\" \"imagemap\" \"string wrap\" [\"repeat\"]\n" to:out_Geom_file
		format "\"string filename\" [\"%\"]\n" Obj.filename to:out_Geom_file
	)
	
	fn getandwriteMaterialTexture Obj &out_Geom_file=
	(
		if ( classof Obj == LuxrenderImageMap) then
		(
			write_texturemap Obj out_Geom_file
		)
	)

	
	fn WriteShaders Obj  &out_Geom_file = 
	(
		--addModifier obj (Edit_Mesh ())

		Local MeshArrays = #(#(), #(), #(), #())
		num_faces = Obj.numfaces
		--	print (classof Obj.material)
			
			if (Obj.numfaces != 0) then
		(
			if (classof Obj.material != undefined) then
			(
			
			--MATTE MATERIAL BEGIN	
			
			if classof Obj.material == LuxrenderMatte  then 
			(
				load_diffuse Obj out_Geom_file
				load_sigma Obj out_Geom_file
				load_bump Obj out_Geom_file
				load_emissiontexture Obj out_Geom_file
				format "MakeNamedMaterial \"%\"\n" Obj.material.name to:out_Geom_file
				format "\"string type\" \"matte\"\n" to:out_Geom_file
				write_diffuse Obj out_Geom_file
				write_sigma Obj out_Geom_file
				write_bump Obj out_Geom_file
				write_emissiontexture Obj out_Geom_file
				format "NamedMaterial \"%\"\n" Obj.material.name to:out_Geom_file
			)
			
			
	----METAL BEGIN
			if classOf obj.material == LuxrenderMetal then
			(

				load_bump Obj out_Geom_file
				load_uroughness Obj out_Geom_file
				load_vroughness Obj out_Geom_file
				load_emissiontexture Obj out_Geom_file
				format "MakeNamedMaterial \"%\"\n" Obj.material.name to:out_Geom_file
				format "\"string type\" \"metal\"\n" to:out_Geom_file
				write_bump Obj out_Geom_file
				write_uroughness Obj out_Geom_file
				write_vroughness Obj out_Geom_file
				write_emissiontexture Obj out_Geom_file
				
				if (obj.material.metalname == 1)do
				(
					format	"\t\"string name\" [\"aluminium\"]\n" to:out_Geom_file
				)
				if (obj.material.metalname == 2)do
				(
					format	"\t\"string name\" [\"amorphous carbon\"]\n" to:out_Geom_file
				)				
				if (obj.material.metalname == 3)do
				(
					format	"\t\"string name\" [\"gold\"]\n" to:out_Geom_file
				)
				if (obj.material.metalname == 4)do
				(
					format	"\t\"string name\" [\"copper\"]\n" to:out_Geom_file
				)
				if (obj.material.metalname == 5)do
				(
					format "\t\"string filename\" [\"%\"]\n" obj.material.nkdatapath to:out_Geom_file
				)
				format "NamedMaterial \"%\"" Obj.material.name to:out_Geom_file
			)
			
			if classOf obj.material == LuxrenderGlass then
			(
				load_transmission Obj out_Geom_file
				load_reflection Obj out_Geom_file
				load_bump Obj out_Geom_file
				format "MakeNamedMaterial \"%\"\n" Obj.material.name to:out_Geom_file
				format "\"string type\" \"glass\"\n" to:out_Geom_file
				write_transmission Obj out_Geom_file
				write_reflection Obj out_Geom_file
				if (obj.material.usearchitectural as string == "true") then
				(
					format " \"bool architectural\" [\"true\"]\n" to:out_Geom_file
				)
				else
				(
					format " \"bool architectural\" [\"false\"]\n" to:out_Geom_file
				)
				format " \"float index\" [%]\n" Obj.material.ior to:out_Geom_file
				if (obj.material.usedispersive as string == "true") do
				(
					format "\"float cauchyb\" [%]\n" Obj.material.cauchyb to:out_Geom_file
				)
				write_bump Obj out_Geom_file
				format "NamedMaterial \"%\"" Obj.material.name to:out_Geom_file
			)
			
			if classOf obj.material == LuxGlass2 then
			(
				format "Texture \"my_ior\" \"fresnel\" \"%\" \"float value\" [%]\n" Obj.material.preset Obj.material.ior to:out_Geom_file
				
				format "MakeNamedVolume \"my_volume\" \"%\" \"texture fresnel\" [\"my_ior\"] \"color absorption\" [% % %]\n" Obj.material.volumeproperty (Obj.material.abscolorr) (Obj.material.abscolorg) (Obj.material.abscolorb) to:out_Geom_file
				format "MakeNamedMaterial \"mymaterial\" \"string type\" [\"glass2\"]" to:out_Geom_file
				if (obj.material.dispersion as string == "on")do
				(
					format "\"bool dispersion\" [\"true\"] \n" to:out_Geom_file
				)
				if (obj.material.dispersion as string == "off")do
				(
					format "\"bool dispersion\" [\"false\"] \n" to:out_Geom_file
				)
				format "Interior \"my_volume\" \n" to:out_Geom_file
				format "NamedMaterial \"mymaterial\" \n" to:out_Geom_file
			)
			
			if classOf obj.material == LuxrenderGlossy then
			(
				load_diffuse Obj out_Geom_file
				load_emissiontexture Obj out_Geom_file
				load_bump Obj out_Geom_file
				load_uroughness Obj out_Geom_file
				load_vroughness Obj out_Geom_file
				load_specular Obj out_Geom_file
				load_absorption Obj out_Geom_file
				format "MakeNamedMaterial \"%\"\n" Obj.material.name to:out_Geom_file
				if Obj.material.useGlossylossy as string != "true" then
						(
						format "\"string type\" \"glossy\"\n" to:out_Geom_file
						)
					else
						(
						format "\"string type\" \"glossy_lossy\"\n" to:out_Geom_file
						)
				write_diffuse Obj out_Geom_file
				write_specular Obj out_Geom_file
				write_bump Obj out_Geom_file
				write_uroughness Obj out_Geom_file
				write_vroughness Obj out_Geom_file
				write_absorption Obj out_Geom_file
				format "NamedMaterial \"%\"\n" Obj.material.name to:out_Geom_file					
					

			)
				
			if classOf obj.material == LuxrenderLight then
			(
				tempmap = getSubTexmap obj.material 1
			--	print (classOf tempmap)
				
				if (classOf tempmap == LuxrenderBlackbody) then
				(
					format "LightGroup \"%\"\n" obj.material.AreaLightSourceMap.group to:out_Geom_file
					format "Texture \"area:light\" \"color\" \"blackbody\" \"float temperature\" [%]\n" obj.material.AreaLightSourceMap.temperature to:out_Geom_file
					format "AreaLightSource \"area\" \"texture L\" [\"area:light\"]\n" to:out_Geom_file
					format "\"float power\" [%]\n" obj.material.AreaLightSourceMap.power to:out_Geom_file
					format "\"float efficacy\" [%]\n" obj.material.AreaLightSourceMap.efficacy to:out_Geom_file
					format "\"float gain\" [%]\n" obj.material.AreaLightSourceMap.gain to:out_Geom_file
					format "Material \"matte\" \"color Kd\" [0.8 0.8 0.8]" to:out_Geom_file
				)
				
				if (classof tempmap == LuxrenderLampSpectrum) then
				(
					format "LightGroup \"%\"\n" obj.material.AreaLightSourceMap.spectrumgroupstring to:out_Geom_file
					format "Texture \"%\" \"color\" \"lampspectrum\" \"string name\" [\"%\"]\n" obj.material.AreaLightSourceMap.name obj.material.AreaLightSourceMap.spectrumnamestring to:out_Geom_file
					format "AreaLightSource \"area\" \"texture L\" [\"%\"]\n" obj.material.AreaLightSourceMap.name to:out_Geom_file
				)
			)
				
			if classOf obj.material == LuxMatteTrans then
			(
				load_transmission Obj out_Geom_file
				load_reflection Obj out_Geom_file
				load_sigma Obj out_Geom_file
				load_bump Obj out_Geom_file
				format "MakeNamedMaterial \"%\"\n" Obj.material.name to:out_Geom_file
				format "\"string type\" \"mattetranslucent\"\n" to:out_Geom_file
				write_reflection Obj out_Geom_file
				write_transmission Obj out_Geom_file
				write_sigma Obj out_Geom_file
				write_bump Obj out_Geom_file
				format "NamedMaterial \"%\"" Obj.material.name to:out_Geom_file
			)
			
			if classof obj.material == LuxrenderMirror then
			(
				format "MakeNamedMaterial \"%\"\n" Obj.material.name to:out_Geom_file
				format "\"string type\" \"mirror\"\n" to:out_Geom_file
				format "\"color Kr\" [% % %]" (obj.material.mirrorkdColor.r / 255) (obj.material.mirrorkdColor.g / 255) (obj.material.mirrorkdColor.b / 255) to:out_Geom_file
				format "\"float film\" [%]\n" obj.material.mirror_film to:out_Geom_file
				format "\"float filmindex\" [%]\n" obj.material.mirror_index to:out_Geom_file
				format "NamedMaterial \"%\"" Obj.material.name to:out_Geom_file
			)
			
			if classof obj.material == LuxNullMaterial then
			(
				format "MakeNamedMaterial \"%\"\n" Obj.material.name to:out_Geom_file
				format "\"string type\" \"null\"\n" to:out_Geom_file
				format "NamedMaterial \"%\"" Obj.material.name to:out_Geom_file
			)
			
			if classof obj.material == LuxTest then
			(
				if (obj.material.KtTexture != undefined) then
				(
					write_texturemap Obj.material.ktTexture out_Geom_file
				)
				if (obj.material.KrTexture != undefined) then
				(
					write_texturemap Obj.material.KrTexture out_Geom_file
				)
				
				format "MakeNamedMaterial \"%\"\n" Obj.material.name to:out_Geom_file
				format "\"string type\" \"roughglass\"\n" to:out_Geom_file
				if (obj.material.KtTexture != undefined) then
				(
					format " \"texture Kt\" [\"%\"]\n" obj.material.KtTexture.name to:out_Geom_file
				)
				if (obj.material.KrTexture != undefined) then
				(
					format " \"texture Kr\" [\"%\"]\n" obj.material.KrTexture.name to:out_Geom_file
				)
				
				if (obj.material.KtTexture == undefined) then
				(
					format "\"color Kt\" [% % %]\n" (Obj.material.transmissioncolor.r / 255) (Obj.material.transmissioncolor.g / 255) (Obj.material.transmissioncolor.b / 255)  to:out_Geom_file
				)
				
				if (obj.material.KrTexture == undefined) then
				(
					format "\"color Kr\" [% % %]\n" (Obj.material.roughreflectioncolor.r / 255) (Obj.material.roughreflectioncolor.g / 255) (Obj.material.roughreflectioncolor.b / 255)  to:out_Geom_file
				)
				
				format "\"float vroughness\" [%]\n" obj.material.vroughness to:out_Geom_file
				format "\"float uroughness\" [%]\n" obj.material.uroughness to:out_Geom_file
				format "\"float index\" [%]\n" obj.material.ior to:out_Geom_file
				format "\"float cauchyb\" [%]\n" obj.material.cauchyb to:out_Geom_file
				format "NamedMaterial \"%\"" Obj.material.name to:out_Geom_file
			)
			
			if classof obj.material == velvet then
			(
				format "MakeNamedMaterial \"%\"\n" Obj.material.name to:out_Geom_file
				format "\"string type\" [\"velvet\"]\n" to:out_Geom_file
				format "\"color Kd\" [% % %]\n"  (Obj.material.kdColor.r / 255) (Obj.material.kdColor.g / 255) (Obj.material.kdColor.b / 255)  to:out_Geom_file
				format "\"float thickness\" [%]\n" Obj.material.thickness to:out_Geom_file
				format "\"float p1\" [%]\n"  Obj.material.p1 to:out_Geom_file
				format "\"float p2\" [%]\n" Obj.material.p2 to:out_Geom_file
				format "\"float p3\" [%]\n" Obj.material.p3 to:out_Geom_file
				format "NamedMaterial \"%\"" Obj.material.name to:out_Geom_file
			)
			
			if classof obj.material == LuxrenderPortal2 then
			(
				--format "PortalShape \"trianglemesh\"\n" to:out_Geom_file
			)
			
			if classof obj.material == LuxrenderCarPaint then
			(
				load_diffuse Obj out_Geom_file
				if (Obj.material.ks1Texture != undefined) do
				(
				getandwriteMaterialTexture Obj.material.ks1Texture out_Geom_file
				if (Obj.material.ks1color.value as float != 255) then
				(
				format "Texture \"%.scale\" \"color\" \"scale\" \"texture tex1\" [\"%\"] \"color tex2\" [% % %]\n" Obj.material.ks1texture.name Obj.material.ks1texture.name (Obj.material.Ks1color.r / 255) (Obj.material.Ks1color.g / 255) (Obj.material.Ks1color.b / 255)   to:out_Geom_file
				)
				)
				if (Obj.material.ks2Texture != undefined) do
				(
				getandwriteMaterialTexture Obj.material.ks2Texture out_Geom_file
				if (Obj.material.ks2color.value as float != 255) then
				(
				format "Texture \"%.scale\" \"color\" \"scale\" \"texture tex1\" [\"%\"] \"color tex2\" [% % %]\n" Obj.material.ks2texture.name Obj.material.ks2texture.name (Obj.material.Ks2color.r / 255) (Obj.material.Ks2color.g / 255) (Obj.material.Ks2color.b / 255)   to:out_Geom_file
				)
				)
				if (Obj.material.ks3Texture != undefined) do
				(
				getandwriteMaterialTexture Obj.material.ks3Texture out_Geom_file
				if (Obj.material.ks3color.value as float != 255) then
				(
				format "Texture \"%.scale\" \"color\" \"scale\" \"texture tex1\" [\"%\"] \"color tex2\" [% % %]\n" Obj.material.ks3texture.name Obj.material.ks3texture.name (Obj.material.Ks3color.r / 255) (Obj.material.Ks3color.g / 255) (Obj.material.Ks3color.b / 255)   to:out_Geom_file
				)
				)
				load_bump Obj out_Geom_file
				load_absorption Obj out_Geom_file
				load_emissiontexture Obj out_Geom_file
				format "MakeNamedMaterial \"%\"\n" Obj.material.name to:out_Geom_file
				format "\"string type\" \"carpaint\"\n" to:out_Geom_file
				write_diffuse Obj out_Geom_file
				if (Obj.material.ks1Texture != undefined) then
				(
				if (Obj.material.ks1color.value as float != 255) then
				(
				format "\"texture Ks1\" \"%.scale\"\n" Obj.material.ks1texture.name to:out_Geom_file
				)
				else
				(
				format "\"texture Ks1\" \"%\"\n" Obj.material.ks1texture.name to:out_Geom_file	
				)
				)
				else
				(
				format " \"color Ks1\" [% % %]\n" (Obj.material.Ks1color.r / 255) (Obj.material.Ks1color.g / 255) (Obj.material.Ks1color.b / 255)  to:out_Geom_file
				)
				if (Obj.material.ks2Texture != undefined) then
				(
				if (Obj.material.ks2color.value as float != 255) then
				(
				format "\"texture Ks2\" \"%.scale\"\n" Obj.material.ks2texture.name to:out_Geom_file
				)
				else
				(
				format "\"texture Ks2\" \"%\"\n" Obj.material.ks2texture.name to:out_Geom_file	
				)
				)
				else
				(
				format " \"color Ks2\" [% % %]\n" (Obj.material.Ks2color.r / 255) (Obj.material.Ks2color.g / 255) (Obj.material.Ks2color.b / 255)  to:out_Geom_file
				)
								if (Obj.material.ks3Texture != undefined) then
				(
				if (Obj.material.ks3color.value as float != 255) then
				(
				format "\"texture Ks3\" \"%.scale\"\n" Obj.material.ks3texture.name to:out_Geom_file
				)
				else
				(
				format "\"texture Ks3\" \"%\"\n" Obj.material.ks3texture.name to:out_Geom_file	
				)
				)
				else
				(
				format " \"color Ks3\" [% % %]\n" (Obj.material.Ks3color.r / 255) (Obj.material.Ks3color.g / 255) (Obj.material.Ks3color.b / 255)  to:out_Geom_file
				)
				format "\"float R1\" [%]\n" Obj.material.floatR1 to:out_Geom_file
				format "\"float R2\" [%]\n" Obj.material.floatR2 to:out_Geom_file
				format "\"float R3\" [%]\n" Obj.material.floatR3 to:out_Geom_file
				format "\"float M1\" [%]\n" Obj.material.floatM1 to:out_Geom_file
				format "\"float M2\" [%]\n" Obj.material.floatM2 to:out_Geom_file
				format "\"float M3\" [%]\n" Obj.material.floatM3 to:out_Geom_file
				write_bump Obj out_Geom_file
				write_absorption Obj out_Geom_file
				write_emissiontexture Obj out_Geom_file
				format "NamedMaterial \"%\"\n" Obj.material.name to:out_Geom_file
				
			)
				--format "NamedMaterial \"%\"" Obj.material.name to:out_Geom_file
			)
			--AttributeEnd
			--format "AttributeEnd\n" to:out_Geom_file
		)
	)

		fn Pbrt_Lights Lt &out_file = 
		(
			--print "Exporting light..."
		--	print Lt.name
		--	print "\""
			-- Point Lights
			if classof Lt == Omnilight then (
				format "# Point Light-> %\n"  Lt.name to:out_file		
				format "TransformBegin \n"  to:out_file
				format "\t Translate % % %\n" Lt.pos.x Lt.pos.y Lt.pos.z to:out_file
				format "\t LightSource \"point\" \n"  to:out_file
				format "\t \"point from\" [0 0 0] \n"  to:out_file 
				format "TransformEnd \n"	 Lt.name to:out_file	
				format "# End Point Light-> %\n\n"	 Lt.name to:out_file	
			)
			
			-- Spot Lights
			else if classof Lt == targetSpot  then 
			(
				theDir = normalize (Lt.target.pos - Lt.pos)
				format "# Spot Light-> %\n"  Lt.name to:out_file	
				format "TransformBegin		\n"  to:out_file
				format "\t Translate % % %\n" Lt.pos.x Lt.pos.y Lt.pos.z to:out_file
				format "\t LightSource \"spot\" \n"  to:out_file
				format "\t \"point from\" [0 0 0] \n"  to:out_file
				format "\t \"point to\" [% % %] \n"  theDir.x theDir.y theDir.z to:out_file
				format "\t \"float coneangle\" [%] \n" Lt.hotspot to:out_file
				format "\t \"float conedeltaangle\" [%] \n" (Lt.falloff - Lt.hotspot) to:out_file
				format "TransformEnd \n"	 to:out_file	
				format "# End Spot Light-> %\n\n"	 Lt.name to:out_file	
			)	
			else if classof Lt == TargetDirectionallight then 
				(
					theDir = normalize (Lt.target.pos - Lt.pos)
					format "# Direct Light-> %\n"  Lt.name to:out_file
					format "TransformBegin	\n"  to:out_file
					format "\t Translate % % %\n" Lt.pos.x Lt.pos.y Lt.pos.z to:out_file
					format "\t LightSource \"distant\" \n"  to:out_file
					format "\t \"point from\" [0 0 0] \n"  to:out_file
					format "\t \"point to\" [% % %] \n"  theDir.x theDir.y theDir.z to:out_file
					format "TransformEnd \n" to:out_file		
					format "# End Direct Light-> %\n\n"	 Lt.name to:out_file	
				)
			
			else if classof Lt == LuxSun then
			(
				format "AttributeBegin # %\n"	 Lt.name to:out_file	
				format "LightGroup \"Sun\"\n" to:out_file	
				format "LightSource \"sun\"\n" to:out_file	
				--scan for portals and add them

				
				--scan for portals and add them
				format "\"vector sundir\" [% % %]" Lt.pos.x Lt.pos.y Lt.pos.z to:out_file
				format "\"float gain\" [%]\n" Lt.gain to:out_file
				format "\"float relsize\" [%]\n" Lt.relsize to:out_file
				format "\"float turbidity\" [%]\n" Lt.turbidity to:out_file
				format "\"integer nsamples\" [%]\n" Lt.nsamples to:out_file
				
				for i = 1 to TheSkyPortals.count do
				(
					print "adding portal shapes.."
					print (TheSkyPortals[i].name)
					temppath = getFilenamePath templxssavefilepath
					print exportply
					if (exportply as string == "true")do
					(
						temppathfixed = replaceChar (temppath as string) "\\" "\\\\"
						format "Include \"%\"" (temppathfixed + TheSkyPortals[i].name + ".ply\n" ) to:out_file
					)
					if (exportply as string == "false")do
					(
						temppathfixed = replaceChar (temppath as string) "\\" "\\\\"
						format "Include \"%\"" (temppathfixed + TheSkyPortals[i].name + ".lxm\n" ) to:out_file
					)
				)
				
				format "AttributeEnd # %\n\n"	 Lt.name to:out_file	
			)
			
			else if classOf Lt == LuxSky then
			(
				format "AttributeBegin # %\n" Lt.name to:out_file	
				format "LightGroup \"Sky\"\n" to:out_file
				format "LightSource \"sky\"\n" to:out_file
				format "\"vector sundir\" [0 0 1]" to:out_file
				format "\"float gain\" [%]\n" Lt.gain to:out_file
				format "\"float relsize\" [%]\n" Lt.relsize to:out_file
				format "\"float turbidity\" [%]\n" Lt.turbidity to:out_file
				format "\"integer nsamples\" [%]\n" Lt.nsamples to:out_file
				
				for i = 1 to TheSkyPortals.count do
				(
					print "adding portal shapes.."
					print (TheSkyPortals[i].name)
					temppath = getFilenamePath templxssavefilepath
					print exportply
					if (exportply as string == "true")do
					(
						temppathfixed = replaceChar (temppath as string) "\\" "\\\\"
						format "Include \"%\"" (temppathfixed + TheSkyPortals[i].name + ".ply\n" ) to:out_file
					)
					if (exportply as string == "false")do
					(
						temppathfixed = replaceChar (temppath as string) "\\" "\\\\"
						format "Include \"%\"" (temppathfixed + TheSkyPortals[i].name + ".lxm\n" ) to:out_file
					)
				)
				
				format "AttributeEnd # %\n\n"	 Lt.name to:out_file	
			)
			
		)



		fn outputCameraSettings &out_file =
		(
			if (exportwithplugin == false) then
			(
				cam_pos 	= $.transform.translationpart 
				cam_dir		=$.dir
				cam_look 	= cam_pos - cam_dir
				cam_up		= $.transform.row2
				format "# Camera %\n" 	$.name to:out_file
				format "LookAt % % %\n" 	 cam_pos[1] cam_pos[2] cam_pos[3] to:out_file
				format "\t\t % % %\n" 	cam_look[1] cam_look[2] cam_look[3] to:out_file					
			)
			if (exportwithplugin == true) then
			(
				
				--print "exporting with camera."
				m3_camera = $.transform
				pos = m3_camera.row4
				up = normalize m3_camera.row2
				look = (m3_camera.row4 + -(normalize m3_camera.row3))
				--format "LookAt % % % % % % % % %\n" (pos.x /100) (pos.y /100 ) (pos.z /100) (look.x /100) (look.y /100) (look.z /100) up.x up.y up.z to:out_file
					format "LookAt % % % % % % % % %\n" (pos.x) (pos.y) (pos.z) (look.x) (look.y) (look.z) up.x up.y up.z to:out_file
			)
				
				
				--TODO:
				--check if user uses plugin or script to export.
				--format "\t\t % % %\n\n" 	0 0 1 to:out_file
				--format "\t\t % % %\n\n" 	0 0 1 to:out_file
				
			format "Camera \"perspective\"\n" to:out_file
				-- 			if (renderwidth > renderheight) do
				-- 			(
				-- 				 print "width is higher then height"
				-- 				--default:
				 				--"float screenwindow" [-1.0 1.0 -1.0 1.0]
				-- 				--x1 x2 y1 y2
				-- 				
				-- 				format "\"float screenwindow\" [-1.0 1.0 -1.0 1.0]\n" to:out_Geom_file
				-- 			)
				--	r_aspect=(renderWidth as float)/renderHeight
				--corrected_fov = 2.0*atan(tan($.fov/2.0)/r_aspect)

			--			r_aspect = 1280 as float / 768 as float -- get the real render size
			--f = $.fov -- fov of the camera in degree
			--fov = 2.0 * (RADTODEG(atan(tan(DEGTORAD(f / 2.0)) / r_aspect))) -- the result
			
			r_aspect = renderwidth as float / renderheight as float -- get the real render size
			f = $.fov -- fov of the camera in degree
			fov = 2.0 * (RADTODEG(atan(tan(DEGTORAD(f / 2.0)) / r_aspect))) -- the result
				
			corrected_fov = fov
			format "\"float fov\" [%]\n" corrected_fov to:out_file
			--print corrected_fov
			

				
				
			--	format "\"float screenwindow\" [-1.0 1.0 -1.0 1.0]" to:out_Geom_file
			
				if ( $.lensradius != 0)do
			(
				format "\"float lensradius\" [%]\n" ($.lensradius) to:out_file
				format "\"float focaldistance\" [%]\n" ($.focaldistance) to:out_file
			)
			format "Film \"fleximage\" \"integer xresolution\" [%] \"integer yresolution\" [%]\n" renderwidth renderheight  to:out_file
			format "\"integer outlierrejection_k\" [%] \n" $.Fireflies_Rej to:out_file
			format "\"integer haltspp\" [%] \n" 	(getUserProp $ "hltstpint") to:out_file 
			format "\"integer halttime\" [%] \n" 	(getUserProp $ "halttime") to:out_file 

			if ($.tonemapnumber == 1)do
			(
				format "\"string tonemapkernel\" [\"%\"] \n" (getUserProp $ "tonemapkernel") to:out_file
				format "\"float reinhard_prescale\" [%] \n"  (getUserProp $ "reinhard_prescale") to:out_file
				format "\"float reinhard_postscale\" [%] \n" (getUserProp $ "reinhard_postscale") to:out_file
				format "\"float reinhard_burn\" [%] \n" (getUserProp $ "reinhard_burn") to:out_file
			)
			
			if($.tonemapnumber == 2)do
			(
				format "\"string tonemapkernel\" [\"%\"] \n" (getUserProp $ "tonemapkernel") to:out_file
				format "\"float linear_sensitivity\" [%] \n" (getUserProp $ "linear_sensitivity") to:out_file
				format "\"float linear_exposure\" [%] \n" (getUserProp $ "linear_exposure") to:out_file
				format "\"float linear_fstop\" [%] \n" (getUserProp $ "linear_fstop") to:out_file
				format "\"float linear_gamma\" [%] \n" (getUserProp $ "linear_gamma") to:out_file
			)
			
			if ($.tonemapnumber == 3)do
			(
				format "\"string tonemapkernel\" [\"%\"] \n" (getUserProp $ "tonemapkernel") to:out_file
				format "\"float contrast_ywa\" [%] \n" (getUserProp $ "contrast_ywa") to:out_file
			)
			
			if ($.tonemapnumber == 4)do
			(
				format "\"string tonemapkernel\" [\"%\"] \n" (getUserProp $ "tonemapkernel") to:out_file
			)
			
			if ($.tonemapnumber == 5)do
			(
				format "\"string tonemapkernel\" [\"%\"] \n" (getUserProp $ "tonemapkernel") to:out_file
			)
			
			format "\"integer displayinterval\" [%] \n" 	(getUserProp $ "displayinterval") to:out_file
			format "\"integer writeinterval\" [%] \n" 	(getUserProp $ "writeinterval") to:out_file
			format "\"bool write_exr\" [\"%\"] \n" 	(getUserProp $ "writeEXR") to:out_file
			format "\"bool write_png\" [\"%\"] \n" 	(getUserProp $ "writePNG") to:out_file
			format "\"bool write_tga\" [\"%\"] \n" 	(getUserProp $ "writeTGA") to:out_file
			format "\"string filename\" [\"%\"] \n" 	(getUserProp $ "FileName") to:out_file
			format "\"bool write_resume_flm\" [\"%\"] \n" 	(getUserProp $ "writeResumeFilm") to:out_file
			format "\"integer reject_warmup\" [%] \n" 	(getUserProp $ "rejectwarmup") to:out_file
			
			format "\"bool debug\" [\"%\"] \n" 	(getUserProp $ "Debug") to:out_file
			format "\"float gamma\" [%] \n" (getUserProp $ "gamma") to:out_file
			
			filtertype = (getUserProp $ "filtertype")
			
			if($.filtertypeint == 1)do
			(
				format "PixelFilter \"%\" \n" filtertype to:out_file
				format "\"integer pixelsamples\" [%] \n" $.filterboxx to:out_file
			)
			
			if($.filtertypeint == 2 )do
			(
				format "PixelFilter \"%\" \n" filtertype to:out_file
				format "\"float B\" [%] \n"	$.filterboxx to:out_file
				format "\"float C\" [%] \n"	$.filterboxx to:out_file
			)
			if($.filtertypeint == 3)do
			(
				format "PixelFilter \"%\" \n" filtertype to:out_file
				format "\"float xwidth\" [%] \n"	$.filterboxx to:out_file
				format "\"float ywidth\" [%] \n"	$.filterboxx to:out_file
			)
			
			if($.filtertypeint == 4)do
			(
				format "PixelFilter \"%\" \n" filtertype to:out_file
				format "\"float xwidth\" [%] \n"	$.filterboxx to:out_file
				format "\"float ywidth\" [%] \n"	$.filterboxx to:out_file
				format "\"float tau\" [3.0] \n" to:out_file
			)
			
			sampler_filter_name = (getUserProp $ "sampler_filter_name")
			
			if (sampler_filter_name == "lowdiscrepancy")do
			(
				format "Sampler \"%\" \n" sampler_filter_name to:out_file
				format "\"integer pixelsamples\" [%] \n"	(getUserProp $ "lowdiscrepancy_pixelsamples") to:out_file
			)
			
			if (sampler_filter_name == "random")do
			(
				format "Sampler \"%\" \n" sampler_filter_name to:out_file
				format "\"integer pixelsamples\" [%] \n"	(getUserProp $ "random_pixelsamples") to:out_file
			)
			
			if (sampler_filter_name == "metropolis")do
			(
				format "Sampler \"%\" \n" sampler_filter_name to:out_file
				format "\"integer initsamples\" [%] \n" (getUserProp $ "metropolis_initsamples") to:out_file
				format "\"integer maxconsecrejects\" [%] \n" (getUserProp $ "metropolis_maxconsecrejects") to:out_file
				format "\"float largemutationprob\" [%] \n" (getUserProp $ "metrolpolis_largemutationprob") to:out_file
				format "\"float micromutationprob\" [%] \n" (getUserProp $ "metrolpolis_micromutationprob") to:out_file
				format "\"float mutationrange\" [%] \n" (getUserProp $ "metrolpolis_mutationrange") to:out_file
			)
			
			if (sampler_filter_name == "erpt") do
			(
				format "Sampler \"%\" \n" sampler_filter_name to:out_file
				format "\"integer initsamples\" [%] \n" (getUserProp $ "erpt_initsamples") to:out_file
				format "\"integer chainlength\" [%] \n" (getUserProp $ "erpt_chainlength") to:out_file
				format "\"integer mutationrange\" [%] \n" (getUserProp $ "erpt_mutationrange") to:out_file
			)
			
			if ($.surfaceintegratorint == 1)do
			(
				format "SurfaceIntegrator \"bidirectional\" \n" to:out_file
				format "\"integer eyedepth\" [%] \n" ($.bidir_eyedepth) to:out_file
				format "\"integer lightdepth\" [%] \n" ($.bidir_lightdepth) to:out_file
				format "\"integer eyetrrhold\" [%] \n" ($.bidir_eyetrrhold) to:out_file
				format "\"integer lighttrhold\" [%] \n" ($.bidir_lighttrhold) to:out_file
			)
			
			if ($.surfaceintegratorint == 2)do
			(
				format "SurfaceIntegrator \"directlighting\" \n" to:out_file
				--direct lighting
				tempLightStrategy = ""
				if ($.lightstrategyint ==1)do
				(
					tempLightStrategy = "one"
				)
				if ($.lightstrategyint ==2)do
				(
					tempLightStrategy = "all"
				)
				if ($.lightstrategyint ==3)do
				(
					tempLightStrategy = "auto"
				)
				if ($.lightstrategyint ==4)do
				(
					tempLightStrategy = "importance"
				)
				if ($.lightstrategyint ==5)do
				(
					tempLightStrategy = "powerimp"
				)
				if ($.lightstrategyint ==6)do
				(
					tempLightStrategy = "allpowerimp"
				)
				if ($.lightstrategyint ==7)do
				(
					tempLightStrategy = "logpowerimp"
				)
				format  "\"string lightstrategy\" [\"%\"] \n" tempLightStrategy to:out_file
			)
			
			if ($.surfaceintegratorint == 3)do
			(
				format "SurfaceIntegrator \"exphotonmap\" \n" to:out_file
				
			)
			
			if ($.surfaceintegratorint ==4)do
			(
				--maxdepth	
				format "SurfaceIntegrator \"path\" \n" to:out_file
				format "\"integer maxdepth\" [%] \n" $.pathdepth to:out_file
				
			)
			
			if ($.surfaceintegratorint == 6)do
			(
				format "Renderer \"hybrid\" \n" to:out_file
				format "SurfaceIntegrator \"path\" \n" to:out_file
				format "\"integer maxdepth\" [10] \n" to:out_file
				format "\"bool includeenvironment\" [\"true\"] \n" to:out_file
				format "\"string lightstrategy\" [\"one\"] \n" to:out_file
				format  "\"string rrstrategy\" [\"efficiency\"] \n" to:out_file
			)
			
			format "WorldBegin\n" to:out_file 
			
			---volume for camera
			if ($.use_medium)do
			(
				
				--Texture "Scene:named_volumes:1.tex:value" "fresnel" "constant" "float value" [1.459000]
				format "Texture \"my_volume\" \"fresnel\" \"constant\"  \"float value\" [1.459000] \"float gain\" [%] \n" $.mediumgain to:out_Geom_file
				
				--MakeNamedVolume "Scatter" "homogeneous" "texture fresnel" ["Scene:named_volumes:1.tex:value"]
				format "MakeNamedVolume \"Scatter\" \"homogeneous\" \"texture fresnel\" [\"my_volume\"]\n" to:out_Geom_file
				
				--"color sigma_a" [0.0150931982401 0.0150931982401 0.0150931982401]
				format "\"color sigma_a\" [% % %]\n" ($.sigmaa.r / 255) ($.sigmaa.g / 255) ($.sigmaa.b / 255) to:out_Geom_file
				
				--"color sigma_s" [0.039781 0.039781 0.039781]
				format "\"color sigma_s\" [% % %]\n" ($.sigmas.r / 255) ($.sigmas.g / 255) ($.sigmas.b / 255) to:out_Geom_file
				--"color g" [0.700000 0.700000 0.700000]
				format "\"color g\" [0.700000 0.700000 0.700000]\n" to:out_Geom_file
				
				format "Exterior \"Scatter\" \n" to:out_Geom_file
			)
			--volume for camera
			
			if (getUserProp $ "useenvmap" as string == "true")do
			(
				format "\n# Enviromentmap goes here\n" to:out_file 
				format "AttributeBegin \n" to:out_file 
				format "Rotate -90.0  0 0 1" to:out_file 
				format "Scale -1 1 1" to:out_file
				format "LightGroup \"environment\" \n" to:out_file 
				format "LightSource \"infinite\" \n" to:out_file 
				format "\"string mapping\" [\"%\"] \n" (getUserProp $ "envmaptype") to:out_file
				temppath = (getUserProp $ "environmentimage")
				temppathfixed = replaceChar (temppath as string) "\\" "\\\\"
				format "\"string mapname\" [\"%\"] \n" temppathfixed to:out_file
				format "\"float gamma\" [%] \n" (getUserProp $ "envgamma") to:out_file
				format "\"float envgain\" [%] \n" (getUserProp $ "envgain") to:out_file
				format "AttributeEnd \n" to:out_file 
			)
			format "\n" to:out_file 
		)

		fn DumpXForms obj =
		( -- output node transform properties
			format "%:\t%\n" "transform" obj.transform
			format "%:\t%\n" "position " obj.pos
			format "%:\t%\n" "rotation " obj.rotation
			-- output node's pivot point location
			format "%:\t%\n" "pivot " obj.pivot
			-- output object offsets
			format "%:\t%\n" "objectoffsetpos " obj.objectoffsetpos
			format "%:\t%\n" "objectoffsetrot " obj.objectoffsetrot
			format "%:\t%\n" "objectoffsetscale" obj.objectoffsetscale
			-- output object transform
			format "%:\t%\n" "objecttransform " obj.objecttransform
		)
		
		fn writeSkyPortal obj &out_file =
		(
			--ObjectBegin  "Plane.001"
			format "ObjectBegin \"%\"\n" obj.name to:out_file
			--Transform [1.200000047683716 0.000000000000000 0.000000000000000 0.000000000000000 0.000000000000000 1.200000047683716 0.000000000000000 0.000000000000000 0.000000000000000 0.000000000000000 1.200000047683716 0.000000000000000 0.000000000000000 0.000000000000000 20.711303710937500 1.000000000000000]
			--Shape "trianglemesh"
			format "Shape \"trianglemesh\"\n" to:out_file
			--"integer indices" [0 1 2 0 2 3]
			--"point P" [1.000000000000000 0.999999940395355 -0.050191871821880 1.000000000000000 -1.000000000000000 -0.050191871821880 -1.000000119209290 -0.999999821186066 -0.050191871821880 -0.999999642372131 1.000000357627869 -0.050191871821880]
			--"normal N" [0.000000000000000 0.000000000000000 -1.000000000000000 0.000000000000000 0.000000000000000 -1.000000000000000 0.000000000000000 0.000000000000000 -1.000000000000000 0.000000000000000 0.000000000000000 -1.000000000000000]
			--ObjectEnd
			
			
		)
		
		rollout luxmaxgeom "Scene" width:232 height:112
		(
			button btn_Export "Export" pos:[8,56] width:216 height:16
			progressBar progressBarexport "ProgressBar" pos:[8,80] width:216 height:16 color:(color 30 10 190)
		--	button btn7 "Button" pos:[8,120] width:112 height:28
			--checkbox chk_use_old_script "Use old script export." pos:[8,8] width:128 height:16
			checkbox chk_ply "ply export" pos:[8,24] width:80 height:16
			checkbox chk_skip_exsisting_geom "skip exsisting geometry files" pos:[8,40] width:160 height:16
			checkbox chk_kill_lux "Kill luxrender.exe before launching" pos:[8,8] width:192 height:16
			
			on luxmaxgeom open do
				(
				
			)
			on btn_Export pressed do
			(
				if templxssavefilepath == undefined then
				(
					messagebox "Please choose where to save lxs before export."
				)
				
				if templxssavefilepath != undefined then
				(
					if (chk_kill_lux.checked == true)then
					(
						try
						(
							HiddenDOSCommand  "taskkill /IM luxrender.exe"
							HiddenDOSCommand  "taskkill /IM luxconsole.exe"
						)catch()
					)
					
					exportanim = false
					deleteFile lxssavefilepath
					out_Geom_file = createfile lxssavefilepath
					
					if (viewport.getType() !=#view_camera)do
					(
						doexport = false
						messagebox("Please render through a Luxrender camera.")
						launchafterexport = false
					)
					
					if (viewport.getType()  == #view_camera)do
					(
						doexport = false
						tempcam = viewport.getCamera()
						select tempcam
						max modify mode
						max create mode
						
						if (classof $ as string == "LuxrenderCamera")then
						(
							outputCameraSettings out_Geom_file
							doexport = true
						)
						else
						(
							doexport = false
							messagebox("Please render through a Luxrender camera.")
							launchafterexport = false
						)
					)
					
					if (doexport) do
					(
						TheObjects = for o in objects where superclassof o == GeometryClass and classof o != Targetobject and (not o.isHidden) and (not classof o.material == LuxrenderPortal2) and classof o != mr_Sky_Portal collect o
						--TheObjects = for o in objects where superclassof o == GeometryClass and classof o != Targetobject and (not o.isHidden) and classof o != mr_Sky_Portal collect o
						TheLights 	=  for o in lights where  classof o != Targetobject and (not o.isHidden) and classof o != mr_Sky_Portal collect o
						
					--	print "Found numlights in scene:"
					--	print TheLights.count as string
						
						TheSun = for o in lights where  classof o == LuxSun and classof o != mr_Sky_Portal collect o
						TheSky = for o in lights where  classof o == LuxSky  and classof o != mr_Sky_Portal collect o 
						TheSkyPortals = for o in objects where classof o.material == LuxrenderPortal2 collect o
							
						
						for o = 1 to TheLights.count do
						(
							if TheLights[o].enabled == on then 
							(
								Pbrt_Lights TheLights[o] out_Geom_file
								progressBarexport.value = 100.*o/TheLights.count
							)
						)
						for o = 1 to TheSun.count do
						(
						--	print "found sun -- exporting"
							Pbrt_Lights TheSun[o] out_Geom_file
						)
						
						for o = 1 to TheSky.count do
						(
							--print "found sky -- exporting."
							Pbrt_Lights TheSky[o] out_Geom_file
						)
						

						
						progressBarexport.value = 0
						
						
							exportwithplugin = true
						
							for o =1 to TheSkyPortals.count do
							(
								
								--(
								addModifier TheSkyPortals[o] (Edit_Mesh ())
								temppath = getFilenamePath templxssavefilepath
									if (chk_ply.state == true)do
									(
										exportply = true
										temppathfixed = replaceChar (temppath as string) "\\" "\\\\"
										
										if (chk_skip_exsisting_geom.state == false)do
										(
											LMX_ExportPLY TheSkyPortals[o] (temppath + TheObjects[o].name + ".ply" ) false--$ "c:\\luxrender\\test.ply" false
										)
										
										if (chk_skip_exsisting_geom.state == true)do
										(
											filepathforchecking = (temppathfixed + TheSkyPortals[o].name + ".ply")
											
											if(doesFileExist filepathforchecking == false)do
											(
												LMX_ExportPLY TheSkyPortals[o] (temppath + TheSkyPortals[o].name + ".ply" ) false--$ "c:\\luxrender\\test.ply" false
											)
										)
									)
									
									if (chk_ply.state == false)do
									(
										exportply = false
										--LMX_ExportPLY TheObjects[o] (temppath + TheObjects[o].name + ".lxg" ) true--$ "c:\\luxrender\\test.ply" false
										if (chk_skip_exsisting_geom.state == false)do
										(
											print "exporting"
											print  TheSkyPortals[o].name
											LMX_ExportMesh TheSkyPortals[o] (temppath + TheSkyPortals[o].name + ".lxm" )
										)
										
										if (chk_skip_exsisting_geom.state == true)do
										(
											filepathforchecking = (temppath + TheSkyPortals[o].name + ".lxm")
											if(doesFileExist filepathforchecking == false)do
											(
												LMX_ExportMesh TheSkyPortals[o] (temppath + TheSkyPortals[o].name + ".lxm" ) false--$ "c:\\luxrender\\test.ply" false
											)
										)
									)
							)
						
							for o = 1 to TheObjects.count do
							(
								addModifier TheObjects[o] (Edit_Mesh ())
								format "\n#**** Object: % **** \n"  TheObjects[o].name to:out_Geom_file
								format "AttributeBegin \n"  to:out_Geom_file
								WriteShaders TheObjects[o] out_Geom_file
								temppath = getFilenamePath templxssavefilepath
							
								--LMX_ExportMesh TheObjects[o] (temppath + TheObjects[o].name + ".lxm" )
									print "chk_ply.state"
									print chk_ply.state
									
									if (chk_ply.state == true)do
									(
										exportply = true
										temppathfixed = replaceChar (temppath as string) "\\" "\\\\"
										
										--print "exporting ply format"
									--	print "skip existing:"
									--	print skip_exsisting_geom
										
										if (chk_skip_exsisting_geom.state == false)do
										(
											 
											LMX_ExportPLY TheObjects[o] (temppath + TheObjects[o].name + ".ply" ) false--$ "c:\\luxrender\\test.ply" false
										)
										
										if (chk_skip_exsisting_geom.state == true)do
										(
											filepathforchecking = (temppathfixed + TheObjects[o].name + ".ply")
											
											if(doesFileExist filepathforchecking == false)do
											(
											--	print "exporting object since geometry is new since initial export."
												LMX_ExportPLY TheObjects[o] (temppath + TheObjects[o].name + ".ply" ) false--$ "c:\\luxrender\\test.ply" false
											)
										)
										writeToFile ("Shape \"plymesh\" \"string filename\" " + "[\"" + (temppathfixed + TheObjects[o].name + ".ply\"] \n" )) out_Geom_file
									)
									
									if (chk_ply.state == false)do
									(
										exportply = false
										--LMX_ExportPLY TheObjects[o] (temppath + TheObjects[o].name + ".lxg" ) true--$ "c:\\luxrender\\test.ply" false
										if (chk_skip_exsisting_geom.state == false)do
										(
											print "exporting"
											print  TheObjects[o].name
											LMX_ExportMesh TheObjects[o] (temppath + TheObjects[o].name + ".lxm" )
										)
										
										if (chk_skip_exsisting_geom.state == true)do
										(
											filepathforchecking = (temppath + TheObjects[o].name + ".lxm")
											if(doesFileExist filepathforchecking == false)do
											(
												--print "exporting object since geometry is new since initial export."
												print "object file not found, exporting"
												LMX_ExportMesh TheObjects[o] (temppath + TheObjects[o].name + ".lxm" ) false--$ "c:\\luxrender\\test.ply" false
											)
											
										)
										temppathfixed = replaceChar (temppath as string) "\\" "\\\\"
										writeToFile ( "Include" + "\"" + (temppathfixed + TheObjects[o].name + ".lxm\"\n" )) out_Geom_file
									)
									
								format "AttributeEnd\n" to:out_Geom_file
								
								progressBarexport.value = 100.*o/TheObjects.count
								progress_text =  "Exporting geometry: " + ((100.0 / TheObjects.count * o) as integer)as string  + " % done."
								pushprompt progress_text	
								deleteModifier TheObjects[o] (1)
							)
						)
						--)
						writeToFile "WorldEnd" out_Geom_file
						progressBarexport.value = 0
						progressended_text =  "Exporting geometry done!"
						pushprompt progressended_text	
					)
					
					if(launchafterexport == true)then
					(
						--print out_Geom_file as string
						--print (" \"" + templxssavefilepath + " \"")
						ShellLaunch (exefile as string)  ("\"" + templxssavefilepath + "\"")
					)
					close out_Geom_file	
				)
			--)
			on chk_skip_exsisting_geom changed state do
			(
				skip_exsisting_geom = state
			)
		--)
	)


		rollout luxmaxcam "Camera Settings" width:162 height:78
		(
			label lbl5 "Set output resolution in render setup dialog settings (F10). Tip: enable safeframes in viewport. (Shift + F)" pos:[8,8] width:152 height:56
			
		)

		rollout SceneFile "Scene file" width:232 height:104
		(
			GroupBox grp1 "Scene file path:" pos:[8,8] width:216 height:80
			button btn_file_browse "Browse" pos:[16,48] width:200 height:16
			edittext edt_scenefile_path "" pos:[16,24] width:200 height:16
			
			button btn2 "Open file location and select file" pos:[16,64] width:200 height:16
			
			on SceneFile open do
			(
				edt_scenefile_path.text = templxssavefilepath as string
			)
			on btn_file_browse pressed do
			(
				templxssavefilepath = getSaveFileName caption:"Open A Test File:"  types:"Lxs(*.lxs)|*.lxs"
				if (templxssavefilepath  != undefined) then
				(
					edt_scenefile_path.text = templxssavefilepath as string
					lxssavefilepath = templxssavefilepath
				)
			)
			on btn2 pressed  do
			(
				--open file location
				try 
				(
					--folderpath = getFilenamePath lxssavefilepath
					--HiddenDOSCommand("explorer.exe " + folderpath)
					
					folderpath = getFilenamePath lxssavefilepath
					HiddenDOSCommand("explorer.exe /select ," +lxssavefilepath)
					
				)
				catch
				(
					messageBox ("Some error occured. please make sure file path is valid.")
				)
			)
		)
		
		rollout systemsettings "Luxrender" width:232 height:133
		(
			edittext edt1 "" pos:[16,24] width:200 height:16
			button btn_browse_lux "Browse" pos:[16,48] width:200 height:16
			GroupBox grp1 "Lauch after export:" pos:[8,8] width:216 height:88
			checkbox chk1 "Launch after export" pos:[16,72] width:128 height:16
					
			on systemsettings open do
			(
				if (exefile == undefined) then
				(
					exefile = "Browse to luxrender.."
				)
				edt1.text = exefile
				--print exefile
				--print "opening rollout"
				
				if launchafterexport as string == "true" then
				(
					chk1.state = true
					--print "Debug:"
					--print (exefile as string)
					
				)
			)
			
			on btn_browse_lux pressed  do
			(
				
				f = getOpenFileName caption:"browse to luxrender exe:" \ 
				filename:"c:/luxrender.exe"
				edt1.text = f
				exefile = f
				--print "Debug:"
				--print (f as string)
			)
			on chk1 changed state do
			(
				launchafterexport = state
			)
		)
		
		
		rollout about_script "About" width:232 height:185 rolledup:true
		(
			label lbl1 "Written by Stig Atle steffensen - www.stigatle.net" pos:[40,16] width:160 height:32
			label lbl2 " for the Luxrender renderer. www.luxrender.net" pos:[40,48] width:160 height:32
			label lbl5 "Some code is from PBRT 2 Exporter by Guillermo M. Leal LLaguno." pos:[40,144] width:176 height:32
			label lbl4 "And big tha for perpixel for starting the exporter (materials \ textures) so that it can be used as a base for this exporter." pos:[40,88] width:176 height:56
		)
		
		rollout preview_material "Preview Material" width:232 height:246
		(
			button btn1 "Create preview for sel material" pos:[8,176] width:216 height:24
			bitmap bmp1 "Bitmap" pos:[8,8] width:216 height:128 --fileName:"C:\Program Files\Autodesk\3ds Max 2011\Scripts\matpreview.png"
			button btn3 "Browse to luxconsole" pos:[8,144] width:216 height:24
			
			
			on preview_material open do
			(
				if (luxconsolepath == undefined) do
				(
					btn3.text = "Browse to luxconsole.exe"
					
				)
				if (luxconsolepath != undefined) do
				(
					btn3.text = luxconsolepath
					
				)
			)
			on btn1 pressed do
			(
				if (luxconsolepath == undefined) do
					(
						messagebox "Please browse to luxconsole.exe."
					)
				if (luxconsolepath != undefined)do
				(
					--create preview
					temp_mat_file = createFile (scriptsPath + "temp_matpreview.lxs")
					preview_selected_material temp_mat_file
					close temp_mat_file
					temp_mat_file2 = createFile (scriptsPath + "temp_matpreview.lxm")
					tempShaderBox = box name:"tempShaderBox" position:[0,0,0] height:1
					tempShaderBox.material = meditMaterials[activeMeditSlot]	
					convertToMesh tempShaderBox
					select tempShaderBox
					WriteShaders $ temp_mat_file2
					delete tempShaderBox
					close temp_mat_file
					close temp_mat_file2
					
					templxpreviewspath = getFilenamePath (scriptsPath + "temp_matpreview.lxs")
					ShellLaunch (luxconsolepath as string)  ("\"" + (scriptsPath + "temp_matpreview.lxs") + "\"")
					print templxpreviewspath
					sleep 5
					
					bmp1.fileName = (scriptsPath + "matpreview.png")
					
				)
				
			)
			on btn3 pressed do
			(
			--browse for luxconsole
				--persistent global luxconsolepath
				f = getOpenFileName caption:"browse to luxconsole exe:" \ 
				filename:"c:/luxconsole.exe"
				btn3.text = f
				luxconsolepath = f
				--print "Debug:"
				--print (f as string)
			)
		)

		

		try(closeRolloutFloater theNewFloater)catch()
		theNewFloater = newRolloutFloater "LuxMaxscript Exporter" 250 500
		
		addRollout systemsettings theNewFloater
		addRollout luxmaxcam theNewFloater
		addRollout SceneFile theNewFloater
		addRollout luxmaxgeom theNewFloater
		addRollout preview_material theNewFloater
		addRollout about_script theNewFloater
	