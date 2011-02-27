( --// material export functions

getandwriteMaterialTexture = undefined
	
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
	
	fn load_film Obj &out_Geom_file =
	(
		if Obj.material.usefilm as string == "true" then
		(
			if (Obj.material.filmTexture != undefined) do
				(
				format "Texture \"%\" \"float\" \"imagemap\" \"string wrap\" [\"repeat\"] \"string filename\" [\"%\"]\n" Obj.material.filmtexture.name obj.material.filmtexture.filename to:out_Geom_file
				format "Texture \"%.scale\" \"float\" \"scale\" \"texture tex1\" [\"%\"] \"float tex2\" [%]\n" Obj.material.filmtexture.name Obj.material.filmtexture.name Obj.material.film to:out_Geom_file
				)
		)
	)
	
	fn write_film Obj &out_Geom_file =
	(	if Obj.material.usefilm as string == "true" then
		(
			if (Obj.material.filmTexture != undefined) then
			(
				format "\"texture film\" \"%.scale\"\n" Obj.material.filmtexture.name to:out_Geom_file
			)
			else
			(
				format "\"float film\" [%]\n" Obj.material.film to:out_Geom_file
			)
		)	
	)
	
	fn load_filmindex Obj &out_Geom_file =
	(
		if Obj.material.usefilm as string == "true" then
		(
			if (Obj.material.filmiorTexture != undefined) do
				(
				format "Texture \"%\" \"float\" \"imagemap\" \"string wrap\" [\"repeat\"] \"string filename\" [\"%\"]\n" Obj.material.filmiortexture.name obj.material.filmiortexture.filename to:out_Geom_file
				format "Texture \"%.scale\" \"float\" \"scale\" \"texture tex1\" [\"%\"] \"float tex2\" [%]\n" Obj.material.filmiortexture.name Obj.material.filmiortexture.name Obj.material.filmior to:out_Geom_file
				)
		)
	)
	
	fn write_filmindex Obj &out_Geom_file =
	(	if Obj.material.usefilm as string == "true" then
		(
			if (Obj.material.filmiorTexture != undefined) then
			(
				format "\"texture filmindex\" \"%.scale\"\n" Obj.material.filmiortexture.name to:out_Geom_file
			)
			else
			(
				format "\"float filmindex\" [%]\n" Obj.material.filmior to:out_Geom_file
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
	
--MATERIALS ATTRIBUTES FUNCTIONS FINISH	

	
	fn WriteShaders Obj  &out_Geom_file = 
	(
		--addModifier obj (Edit_Mesh ())

		Local MeshArrays = #(#(), #(), #(), #())

		--	print (classof Obj.material)
			
		if (true) then
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
			
			
--METAL MATERIAL BEGIN
			
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
			
--SHINY METAL MATERIAL BEGIN
			
			if classof obj.material == LuxrenderShinyMetal then
			(
			load_reflection Obj out_Geom_file
			load_specular Obj out_Geom_file
			load_uroughness Obj out_Geom_file
			load_vroughness Obj out_Geom_file
			load_bump Obj out_Geom_file
			load_film Obj out_Geom_file
			load_filmindex Obj out_Geom_file
			format "MakeNamedMaterial \"%\"\n" Obj.material.name to:out_Geom_file
			format "\"string type\" \"shinymetal\"\n" to:out_Geom_file
			write_reflection Obj out_Geom_file
			write_specular Obj out_Geom_file
			write_uroughness Obj out_Geom_file
			write_vroughness Obj out_Geom_file
			write_bump Obj out_Geom_file
			write_film Obj out_Geom_file
			write_filmindex Obj out_Geom_file
			format "NamedMaterial \"%\"" Obj.material.name to:out_Geom_file
			)
--GLASS MATERIAL BEGIN
			
			if classOf obj.material == LuxrenderGlass then
			(
				load_transmission Obj out_Geom_file
				load_reflection Obj out_Geom_file
				load_bump Obj out_Geom_file
				load_film Obj out_Geom_file
				load_filmindex Obj out_Geom_file
				format "MakeNamedMaterial \"%\"\n" Obj.material.name to:out_Geom_file
				format "\"string type\" \"glass\"\n" to:out_Geom_file
				write_transmission Obj out_Geom_file
				write_reflection Obj out_Geom_file
				write_film Obj out_Geom_file
				write_filmindex Obj out_Geom_file
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
			
--GLASS2 MATERIAL BEGIN
			
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
			
--GLOSSY,GLOSSY LOSSY MATERIAL BEGIN
			
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
			
--GLOSSY TRANSLUCENT MATERIAL BEGIN
				
			if classOf obj.material == LuxrenderGlossyTranslucent then
			(
				load_diffuse Obj out_Geom_file
				load_transmission Obj out_Geom_file
				load_emissiontexture Obj out_Geom_file
				load_bump Obj out_Geom_file
				load_uroughness Obj out_Geom_file
				load_vroughness Obj out_Geom_file
				load_specular Obj out_Geom_file
				load_absorption Obj out_Geom_file
				format "MakeNamedMaterial \"%\"\n" Obj.material.name to:out_Geom_file
				format "\"string type\" \"glossytranslucent\"\n" to:out_Geom_file
				write_diffuse Obj out_Geom_file
				write_transmission Obj out_Geom_file
				write_specular Obj out_Geom_file
				write_bump Obj out_Geom_file
				write_uroughness Obj out_Geom_file
				write_vroughness Obj out_Geom_file
				write_absorption Obj out_Geom_file
				format "NamedMaterial \"%\"\n" Obj.material.name to:out_Geom_file					
					

			)
			
--LIGHT MATERIAL BEGIN			
			
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
			
--MATTE TRANSLUCENT MATERIAL BEGIN
				
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
				format "NamedMaterial \"%\"\n" Obj.material.name to:out_Geom_file
			)
			
--MIRROR MATERIAL BEGIN			
			
			if classof obj.material == LuxrenderMirror then
			(
				format "MakeNamedMaterial \"%\"\n" Obj.material.name to:out_Geom_file
				format "\"string type\" \"mirror\"\n" to:out_Geom_file
				format "\"color Kr\" [% % %]" (obj.material.mirrorkdColor.r / 255) (obj.material.mirrorkdColor.g / 255) (obj.material.mirrorkdColor.b / 255) to:out_Geom_file
				format "\"float film\" [%]\n" obj.material.mirror_film to:out_Geom_file
				format "\"float filmindex\" [%]\n" obj.material.mirror_index to:out_Geom_file
				format "NamedMaterial \"%\"" Obj.material.name to:out_Geom_file
			)
			
--NULL MATERIAL BEGIN			
			
			if classof obj.material == LuxNullMaterial then
			(
				format "MakeNamedMaterial \"%\"\n" Obj.material.name to:out_Geom_file
				format "\"string type\" \"null\"\n" to:out_Geom_file
				format "NamedMaterial \"%\"" Obj.material.name to:out_Geom_file
			)
			
--ROUGH GLASS			
			
			if classof obj.material == LuxRoughGlass then
			(
				load_transmission Obj out_Geom_file
				load_reflection Obj out_Geom_file
				load_uroughness Obj out_Geom_file
				load_vroughness Obj out_Geom_file
				load_bump Obj out_Geom_file
				format "MakeNamedMaterial \"%\"\n" Obj.material.name to:out_Geom_file
				format "\"string type\" \"roughglass\"\n" to:out_Geom_file
				write_transmission Obj out_Geom_file
				write_reflection Obj out_Geom_file
				write_uroughness Obj out_Geom_file
				write_vroughness Obj out_Geom_file
				
				format " \"float index\" [%]\n" Obj.material.ior to:out_Geom_file
				if (obj.material.usedispersive as string == "true") do
				(
					format "\"float cauchyb\" [%]\n" Obj.material.cauchyb to:out_Geom_file
				)
				write_bump Obj out_Geom_file
				format "NamedMaterial \"%\"" Obj.material.name to:out_Geom_file
			)
			
--LUXMIX MATERIAL BEGIN			
			if  classof obj.material == LuxMix then
			(
			
	
			
			if (Obj.material.mixvalueTexture != undefined) do
				(
				format "Texture \"%\" \"float\" \"imagemap\" \"string wrap\" [\"repeat\"] \"string filename\" [\"%\"]\n" Obj.material.mixvalueTexture.name obj.material.mixvalueTexture.filename to:out_Geom_file
				format "Texture \"%.scale\" \"float\" \"scale\" \"texture tex1\" [\"%\"] \"float tex2\" [%]\n" Obj.material.mixvalueTexture.name Obj.material.mixvalueTexture.name Obj.material.mixvalue to:out_Geom_file
				)
			
		
			--store whole material
			originalMaterial = obj.material
			--store slot 1
			originalMaterial1 = obj.material.material1
			--store slot2
			originalMaterial2 = obj.material.material2

			--apply slot1 material to object
			obj.material = originalMaterial1
			--write out
			format "MakeNamedMaterial \"%\"\n" originalmaterial1.name to:out_Geom_file
				
			writeshaders obj out_geom_file
				
			format "NamedMaterial \"%\"\n" originalmaterial1.name to:out_Geom_file

			--apply slot2 material
			obj.material = originalMaterial2
			--write out
			format "MakeNamedMaterial \"%\"\n" originalmaterial2.name to:out_Geom_file
			writeshaders obj out_geom_file
			
			format "NamedMaterial \"%\"\n" originalmaterial2.name to:out_Geom_file

			--apply original material back to object
			obj.material = originalMaterial
			format "MakeNamedMaterial \"%\"\n" Obj.material.name to:out_Geom_file
			format "\"string type\" \"mix\"\n" to:out_Geom_file
			
			if (Obj.material.mixvalueTexture != undefined) then
			(
				format "\"texture amount\" \"%.scale\"\n" Obj.material.mixvaluetexture.name to:out_Geom_file
			)
			else
			(
				format "\"float amount\" [%]\n" Obj.material.mixvalue to:out_Geom_file
			)
			
			format "\"string namedmaterial1\" [\"%\"] \"string namedmaterial2\" [\"%\"]\n" originalMaterial1.name originalMaterial2.name to:out_Geom_file
			format "NamedMaterial \"%\"\n" Obj.material.name to:out_Geom_file
		
			)
			
			
			
			

			
			
--VELVET MATERIAL BEGIN			
			
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
			
--PORTAL2 MATERIAL BEGIN 			
			
			if classof obj.material == LuxrenderPortal2 then
			(
				--format "PortalShape \"trianglemesh\"\n" to:out_Geom_file
			)
			
--CARPAINT MATERIAL BEGIN			
			
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
				
			)
		)
	)
)