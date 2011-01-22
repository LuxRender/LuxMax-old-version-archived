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
		
	fn writeToFile string &out_Geom_file =
	(
		format string to:out_Geom_file
	)
	
		fn PbrtColor c =
	(
		return ( ((c.r / 255)) as string + " " + ((c.g / 255)) as string + " " + ((c.b / 255)) as string )
	)
	
	
	fn write_bumpmaptexture Obj &out_Geom_file =
	(
		format "Texture \"%\" \"float\" \"imagemap\" \"string wrap\" [\"repeat\"] \"string filename\" [\"%\"]\n" Obj.name obj.filename to:out_Geom_file
--		format "\"float gain\" [%] \n" Obj.material.bumpMap to:out_Geom_file
		--.bumpMap = 0.99
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
	
	fn getandwriteMaterialTexture Obj &out_Geom_file=
	(
		print "getandwriteMaterial:"
		print "material class is:"
		print (classof Obj)
		
		if ( classof Obj == LuxrenderImageMap) then
		(
			write_texturemap Obj out_Geom_file
		)
	)
	

 
	fn Pbrt_Geometry Obj  &out_Geom_file = 
	(
		addModifier obj (Edit_Mesh ())
		format "\n#**** Object: % **** \n"  Obj.name to:out_Geom_file
		format "AttributeBegin \n"  to:out_Geom_file
		Local MeshArrays = #(#(), #(), #(), #())
		num_faces = Obj.numfaces
			print (classof Obj.material)
			
			if (Obj.numfaces != 0) then
		(
			if (classof Obj.material != undefined) then
			(
			
			--MATTE MATERIAL BEGIN	
			
			if classof Obj.material == LuxrenderMatte  then 
			(
				if Obj.material.useBumpmap as string == "true" then
				(
					if (Obj.material.bumpmapTexture != undefined) do
					(
						write_bumpmaptexture Obj.material.bumpmapTexture out_Geom_file
						format "\"float gain\" [%] \n" Obj.material.bumpMap to:out_Geom_file
					)
				)
				
				if (Obj.material.kdTexture != undefined) do
				(
					getandwriteMaterialTexture Obj.material.kdTexture out_Geom_file
				)
				
				format "MakeNamedMaterial \"%\"\n" Obj.material.name to:out_Geom_file
				format "\"string type\" \"matte\"\n" to:out_Geom_file
				if (obj.material.kdTexture != undefined) do
				(
					format "\"texture Kd\" [\"%\"]\n" obj.material.kdTexture.name to:out_Geom_file
				)
				
				if (Obj.material.kdTexture == undefined) do
				(
					format "\"color Kd\" [% % %]\n" (Obj.material.kdColor.r / 255) (Obj.material.kdColor.g / 255) (Obj.material.kdColor.b / 255) to:out_Geom_file	
				)
				
				if (Obj.material.bumpmapTexture == undefined) then
				(
					if (Obj.material.useBumpmap as string == "true") then
					(
						format "\"float bumpmap\" [%]\n" Obj.material.bumpMap to:out_Geom_file
					)
				)
				if (Obj.material.bumpmapTexture != undefined) do
					(
						format "\"texture bumpmap\" [\"%\"]\n" Obj.material.bumpmapTexture.name to:out_Geom_file
						format "\"float gain\" [%] \n" Obj.material.bumpMap to:out_Geom_file
					)
				format "NamedMaterial \"%\"\n" Obj.material.name to:out_Geom_file
			)
			
			
	----METAL BEGIN
			if classOf obj.material == LuxrenderMetal then
			(
				if (Obj.material.KtTexture != undefined) do
				(
					write_bumpmaptexture Obj.material.KtTexture out_Geom_file
					format "\"float gain\" [%] \n" Obj.material.bumpMap to:out_Geom_file
				)
				
				format "MakeNamedMaterial \"%\"\n" Obj.material.name to:out_Geom_file
				format "\"string type\" \"metal\"\n" to:out_Geom_file
				
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
					format "\t\"string filename\" [\"%s\"]\n" obj.material.nkdatapath to:out_Geom_file
				)
				format "\"float vroughness\"[%]\n" obj.material.vexponent to:out_Geom_file
				format "\"float uroughness\"[%]\n" obj.material.uexponent to:out_Geom_file
					if (Obj.material.bumpmapTexture != undefined) do
					(
						format "\"texture bumpmap\" [\"%\"]\n" Obj.material.KtTexture.name to:out_Geom_file
						format "\"float gain\" [%] \n" Obj.material.bumpMap to:out_Geom_file
					)
					
				format "NamedMaterial \"%\"\n" Obj.material.name to:out_Geom_file
			)
			
			if classOf obj.material == LuxrenderGlass then
			(
				if (obj.material.KtTexture != undefined) do
				(
					getandwriteMaterialTexture Obj.material.KtTexture out_Geom_file
					
				)
				if (obj.material.KrTexture != undefined) do
				(
					getandwriteMaterialTexture Obj.material.KrTexture out_Geom_file
				)
				
				format "MakeNamedMaterial \"%\"\n" Obj.material.name to:out_Geom_file
				format "\"string type\" \"glass\"\n" to:out_Geom_file				
				if (obj.material.KtTexture != undefined) do
				(
					format "\"texture Kt\" [\"%\"]\n" obj.material.KtTexture.name to:out_Geom_file
				)
				if (obj.material.KrTexture != undefined) do
				(
					format "\"texture Kr\" [\"%\"]\n" obj.material.KrTexture.name to:out_Geom_file
				)
				
				if (obj.material.KtTexture == undefined) do
				(
					format "\"color Kt\" [% % %]\n" (Obj.material.kt.r / 255) (Obj.material.kt.g / 255) (Obj.material.kt.b / 255) to:out_Geom_file	
				)
				
				if (obj.material.iorActive as string == "on")do
				(
					format " \"bool architectural\" [\"true\"]\n" to:out_Geom_file
				)
				
				if (obj.material.iorActive as string == "off")do
				(
					format " \"bool architectural\" [\"false\"]\n" to:out_Geom_file
					format " \"float index\" [%]\n" Obj.material.ior to:out_Geom_file
				)
				format "NamedMaterial \"%\"\n" Obj.material.name to:out_Geom_file
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
				print "creating glossy material:"
				print Obj.material.useBumpmap as string
				if Obj.material.useBumpmap as string == "true" then
				(
					print "usebumpmap"
					print "checking if there's bump texture"
					print Obj.material.bumpmapTexture as string
					
					if (Obj.material.bumpmapTexture != undefined) do
					(
						print "found bumpmap texture.."
						print "Kd Texture name:"
						print Obj.material.bumpmapTexture.name as string
						write_bumpmaptexture Obj.material.bumpmapTexture out_Geom_file
						format "\"float gain\" [%] \n" Obj.material.bumpMap to:out_Geom_file
					)
				)
					
				if Obj.material.kdTexture != undefined then
				(
					print "Kd Texture name:"
					print Obj.material.kdTexture.name as string
					write_texturemap Obj.material.kdTexture out_Geom_file
				)
					
					if Obj.material.ksTexture != undefined then
					(
						print "Ks Texture name:"
						print Obj.material.ksTexture.name as string
						write_texturemap Obj.material.ksTexture out_Geom_file
					)
					
					if Obj.material.iorTexture != undefined then
					(
						print "ior Texture name:"
						print Obj.material.iorTexture.name as string
						write_texturemap Obj.material.iorTexture out_Geom_file
					)
					
					if Obj.material.katexture != undefined then
					(
						print "Ka Texture name:"
						print Obj.material.katexture.name as string
						write_texturemap Obj.material.ksTexture out_Geom_file
					)
					format "MakeNamedMaterial \"%\"\n" Obj.material.name to:out_Geom_file
					format "\"string type\" \"glossy\"\n" to:out_Geom_file
					format " \"float uroughness\" [%]\n" Obj.material.uroughness to:out_Geom_file
					format " \"float vroughness\" [%]\n" Obj.material.vroughness to:out_Geom_file
					if Obj.material.ksTexture != undefined then
					(
						format " \"texture Ks\" [\"%\"]\n" Obj.material.ksTexture.name to:out_Geom_file
					)

					if Obj.material.kdTexture != undefined then
					(
						format " \"texture Kd\" [\"%\"]\n" Obj.material.kdTexture.name to:out_Geom_file
					)
					if Obj.material.kdTexture == undefined then
					(	
						format " \"color Kd\" [% % %]\n" ((Obj.material.Kdcolor.r / 255) -255) ((Obj.material.Kdcolor.g / 255) -255) ((Obj.material.Kdcolor.b / 255)-255)  to:out_Geom_file
					)
					if Obj.material.useior as string == "off" then
					(
						if Obj.material.iorTexture != undefined then
						(
							format " \"texture index\" [\"%s\"]\n" Obj.material.iorTexture.name to:out_Geom_file
						)
						if Obj.material.iorTexture == undefined then
						(
							format " \"float index\" [%]\n" Obj.material.ior to:out_Geom_file
						)
					)
					
					if Obj.material.ksTexture == undefined then
					(
						format " \"color Ks\" [% % %]\n" (Obj.material.kscolor.r / 255) (Obj.material.kscolor.g / 255) (Obj.material.kscolor.b / 255) to:out_Geom_file
					)
					
					if Obj.material.useka as string == "on" then
					(
						if Obj.material.katexture != undefined then
						(
							format " \"texture Ka\" [\"%\"]\n" Obj.material.katexture.name to:out_Geom_file
						)
						if Obj.material.katexture == undefined then
						(
							format " \"color Ka\" [% % %]\n" (Obj.material.kacolor.r / 255) (Obj.material.kacolor.g / 255) (Obj.material.kacolor.b / 255)  to:out_Geom_file
						)
					)

					format " \"float d\" [%]\n" Obj.material.kadepth to:out_Geom_file
					
					if (Obj.material.bumpmapTexture == undefined) then
					(
						if (Obj.material.useBumpmap as string == "true") then
						(
							format "\"float bumpmap\" [%]\n" Obj.material.bumpMap to:out_Geom_file
						)
					)
					if (obj.material.useBumpmap as string == "true") then
					(
						if (Obj.material.bumpmapTexture != undefined) then
						(
							format "\"texture bumpmap\" [\"%\"]\n" Obj.material.bumpmapTexture.name to:out_Geom_file
							format "\"float gain\" [%] \n" Obj.material.bumpMap to:out_Geom_file
						)
					)
					format "NamedMaterial \"%\"\n" Obj.material.name to:out_Geom_file
			)
				
			if classOf obj.material == LuxrenderLight then
			(
				tempmap = getSubTexmap obj.material 1
				print (classOf tempmap)
				
				if (classOf tempmap == LuxrenderBlackbody) then
				(
					format "LightGroup \"%s\"\n" obj.material.AreaLightSourceMap.group to:out_Geom_file
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
				if (obj.material.kdTexture != undefined) then
				(
					write_texturemap Obj.material.kdTexture out_Geom_file
				)
				if (obj.material.KtTexture != undefined) then
				(
					write_texturemap Obj.material.ktTexture out_Geom_file
				)
				
				format "MakeNamedMaterial \"%\"\n" Obj.material.name to:out_Geom_file
				format "\"string type\" \"mattetranslucent\"\n" to:out_Geom_file
				if (obj.material.kdTexture != undefined) then
				(
					format " \"texture Kr\" [\"%\"]\n" obj.material.kdTexture.name to:out_Geom_file
				)

				if (obj.material.kdTexture == undefined) then
				(
					format "\"color Kr\" [% % %]\n" (Obj.material.diffuseColor.r / 255) (Obj.material.diffuseColor.g / 255) (Obj.material.diffuseColor.b / 255)  to:out_Geom_file
				)
				if (obj.material.KtTexture != undefined) then
				(
					format " \"texture Kt\" [\"%\"]\n" obj.material.KtTexture.name to:out_Geom_file
				)
				
				if (obj.material.KtTexture == undefined) then
				(
					format "\"color Kt\" [% % %]\n" (Obj.material.transmitivitycolor.r / 255) (Obj.material.transmitivitycolor.g / 255) (Obj.material.transmitivitycolor.b / 255)  to:out_Geom_file
				)
				format "NamedMaterial \"%\"\n" Obj.material.name to:out_Geom_file
			)
			
			if classof obj.material == LuxrenderMirror then
			(
				format "MakeNamedMaterial \"%\"\n" Obj.material.name to:out_Geom_file
				format "\"string type\" \"mirror\"\n" to:out_Geom_file
				format "\"color Kr\" [% % %]" (obj.material.mirrorkdColor.r / 255) (obj.material.mirrorkdColor.g / 255) (obj.material.mirrorkdColor.b / 255) to:out_Geom_file
				format "\"float film\" [%]\n" obj.material.mirror_film to:out_Geom_file
				format "\"float filmindex\" [%]\n" obj.material.mirror_index to:out_Geom_file
				format "NamedMaterial \"%\"\n" Obj.material.name to:out_Geom_file
			)
			
			if classof obj.material == LuxNullMaterial then
			(
				format "MakeNamedMaterial \"%\"\n" Obj.material.name to:out_Geom_file
				format "\"string type\" \"null\"\n" to:out_Geom_file
				format "NamedMaterial \"%\"\n" Obj.material.name to:out_Geom_file
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
				format "NamedMaterial \"%\"\n" Obj.material.name to:out_Geom_file
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
				format "NamedMaterial \"%\"\n" Obj.material.name to:out_Geom_file
			)
			
			if classof obj.material == LuxrenderPortal2 then
			(
				format "PortalShape \"trianglemesh\"\n" to:out_Geom_file
			)
			
			if classof obj.material == LuxrenderCarPaint then
			(
				format "MakeNamedMaterial \"%\"\n" Obj.material.name to:out_Geom_file
				format "\"string type\" \"carpaint\" \n" to:out_Geom_file
				paintnameString = ""
				--"Blue Matte", "Blue", "White", "2k Acrylack", "BMW 339", "Opel Titan", "Polaris Silber", "Ford F8"
				if obj.material.paintname == 1 do
				(
					paintnameString = toLower "Blue Matte"
					
				)
				if obj.material.paintname == toLower 2 do
				(
					paintnameString = toLower "Blue"
				)
				if obj.material.paintname == 3 do
				(
					paintnameString = toLower "White"
				)
				if obj.material.paintname == 4 do
				(
					paintnameString =toLower  "2k Acrylack"
				)
				if obj.material.paintname == 5 do
				(
					paintnameString = toLower "BMW339"
				)
				if obj.material.paintname == 6 do
				(
					paintnameString = toLower "Opel Titan"
				)
				if obj.material.paintname == 7 do
				(
					paintnameString = toLower "Polaris Silber"
				)
				if obj.material.paintname == 8 do
				(
					paintnameString = toLower "Ford F8"
				)
				
				if (obj.material.useka)do
				(
				--	if (obj.material.katexture == undefined )do
				--	(
						--apply kacolor
						format "\"color Ka\" [% % %]\n"  (Obj.material.kacolor.r / 255) (Obj.material.kacolor.g / 255) (Obj.material.kacolor.b / 255)  to:out_Geom_file
					--)
					--if (obj.material.katexture != undefined )do
					--(
						--send to write texture function
						--getandwriteMaterialTexture Obj.material.katexture out_Geom_file
					--)
					
				)
				format " \"float d\" [%]\n" obj.material.kadepth to:out_Geom_file
				format "\t\"string name\" [\"%\"]\n" paintnameString to:out_Geom_file--name from dropdown
				format "NamedMaterial \"%\"\n" Obj.material.name to:out_Geom_file
				
				
				--format "NamedMaterial \"%\"" Obj.material.name to:out_Geom_file
			)
				
				
				------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
				------------------------------EXPORT GEOMETRY BEGIN---------------------------------------------------------------------------------------------------------------------------------------------------
				------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
				
				format "\n#**** Numfaces: % **** \n"  num_faces to:out_Geom_file
				for i = 1 to num_faces do
					(
						face = getFace Obj i
						
						v1 = (MeshArrays[2].count + 1)
						v2 = (MeshArrays[2].count + 2)
						v3 = (MeshArrays[2].count + 3)
						
						append MeshArrays[1] [v1,v2,v3]
						
						v1 =  getvert Obj face.x
						v2 =  getvert Obj face.y
						v3 =  getvert Obj face.z
						
						append MeshArrays[2] v1
						append MeshArrays[2] v2
						append MeshArrays[2] v3
						
						myTransform = Obj.transform
						
						v1 = (coordsys local getnormal Obj face.x)* myTransform  - (myTransform.translationpart)	-- * theInvTM 
						v2 = (coordsys local getnormal Obj face.y)* myTransform  - (myTransform.translationpart)	--* theInvTM 
						v3 = (coordsys local getnormal Obj face.z) * myTransform - (myTransform.translationpart)	--* theInvTM 
						
						v11 = normalize v1
						v22 = normalize v2
						v33 = normalize v3
						
						append MeshArrays[4] v11
						append MeshArrays[4] v22
						append MeshArrays[4] v33
						
						if Obj.numtverts != 0 then 
						( 
							tvface = getTVFace Obj i
							v1 = getTVert Obj tvface.x
							v2 = getTVert Obj tvface.y
							v3 = getTVert Obj tvface.z
							append MeshArrays[3] v1
							append MeshArrays[3] v2	
							append MeshArrays[3] v3	
						)
					)
				-- **** Triangle Indiex *****
				format "\nShape \"trianglemesh\" \"integer indices\"\n"  to:out_Geom_file	
				format "[\n"  to:out_Geom_file					
				for f in MeshArrays[1] do
					(
						format "\t% % %\n" (f.x as integer - 1) (f.y as integer - 1) (f.z as integer - 1) to:out_Geom_file
					)					
				format "]\n"  to:out_Geom_file
					
				-- **** Points ****
				format "\"point P\" \n[ \n"  to:out_Geom_file					
				for v in MeshArrays[2] do
					(
						format "\t% % %\n" v.x v.y v.z to:out_Geom_file
					)					
				format "]\n"  to:out_Geom_file
					
				if MeshArrays[3].count != 0 then (
					format "\"float uv\"  \n[\n"  to:out_Geom_file		
					for v in MeshArrays[3] do
					(
						vert = v -- Obj.transform.row4
						format "\t% %\n" vert.x -vert.y to:out_Geom_file
					)
					format "]\n"  to:out_Geom_file
				)
				-- **** Normals ****
				format "\"normal N\" \n[\n"  to:out_Geom_file	
				for v in MeshArrays[4] do
				(
					format "\t% % %\n" v.x v.y v.z to:out_Geom_file
				)
				format "]\n"  to:out_Geom_file						
				format "\nAttributeEnd \n" to:out_Geom_file
				format "\n#**** End Object: % **** \n"  Obj.name to:out_Geom_file		
				deleteModifier obj (1)
			)
			
		)
	)
	
	fn WriteShaders Obj  &out_Geom_file = 
	(
		--addModifier obj (Edit_Mesh ())

		Local MeshArrays = #(#(), #(), #(), #())
		num_faces = Obj.numfaces
			print (classof Obj.material)
			
			if (Obj.numfaces != 0) then
		(
			if (classof Obj.material != undefined) then
			(
			
			--MATTE MATERIAL BEGIN	
			
			if classof Obj.material == LuxrenderMatte  then 
			(
				if Obj.material.useBumpmap as string == "true" then
				(
					if (Obj.material.bumpmapTexture != undefined) do
					(
						write_bumpmaptexture Obj.material.bumpmapTexture out_Geom_file
						format "\"float gain\" [%] \n" Obj.material.bumpMap to:out_Geom_file
					)
				)
				
				if (Obj.material.kdTexture != undefined) do
				(
					getandwriteMaterialTexture Obj.material.kdTexture out_Geom_file
				)
				
				format "MakeNamedMaterial \"%\"\n" Obj.material.name to:out_Geom_file
				format "\"string type\" \"matte\"\n" to:out_Geom_file
				if (obj.material.kdTexture != undefined) do
				(
					format "\"texture Kd\" [\"%\"]\n" obj.material.kdTexture.name to:out_Geom_file
				)
				
				if (Obj.material.kdTexture == undefined) do
				(
					format "\"color Kd\" [% % %]\n" (Obj.material.kdColor.r / 255) (Obj.material.kdColor.g / 255) (Obj.material.kdColor.b / 255) to:out_Geom_file	
				)
				
				if (Obj.material.bumpmapTexture == undefined) then
				(
					if (Obj.material.useBumpmap as string == "true") then
					(
						format "\"float bumpmap\" [%]\n" Obj.material.bumpMap to:out_Geom_file
					)
				)
				if (Obj.material.bumpmapTexture != undefined) do
					(
						format "\"texture bumpmap\" [\"%\"]\n" Obj.material.bumpmapTexture.name to:out_Geom_file
						format "\"float gain\" [%] \n" Obj.material.bumpMap to:out_Geom_file
					)
				format "NamedMaterial \"%\"\n" Obj.material.name to:out_Geom_file
			)
			
			
	----METAL BEGIN
			if classOf obj.material == LuxrenderMetal then
			(
				if (Obj.material.KtTexture != undefined) do
				(
					write_bumpmaptexture Obj.material.KtTexture out_Geom_file
					format "\"float gain\" [%] \n" Obj.material.bumpMap to:out_Geom_file
				)
				
				format "MakeNamedMaterial \"%\"\n" Obj.material.name to:out_Geom_file
				format "\"string type\" \"metal\"\n" to:out_Geom_file
				
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
					format "\t\"string filename\" [\"%s\"]\n" obj.material.nkdatapath to:out_Geom_file
				)
				format "\"float vroughness\"[%]\n" obj.material.vexponent to:out_Geom_file
				format "\"float uroughness\"[%]\n" obj.material.uexponent to:out_Geom_file
					if (Obj.material.bumpmapTexture != undefined) do
					(
						format "\"texture bumpmap\" [\"%\"]\n" Obj.material.KtTexture.name to:out_Geom_file
						format "\"float gain\" [%] \n" Obj.material.bumpMap to:out_Geom_file
					)
					
				format "NamedMaterial \"%\"" Obj.material.name to:out_Geom_file
			)
			
			if classOf obj.material == LuxrenderGlass then
			(
				if (obj.material.KtTexture != undefined) do
				(
					getandwriteMaterialTexture Obj.material.KtTexture out_Geom_file
					
				)
				if (obj.material.KrTexture != undefined) do
				(
					getandwriteMaterialTexture Obj.material.KrTexture out_Geom_file
				)
				
				format "MakeNamedMaterial \"%\"\n" Obj.material.name to:out_Geom_file
				format "\"string type\" \"glass\"\n" to:out_Geom_file				
				if (obj.material.KtTexture != undefined) do
				(
					format "\"texture Kt\" [\"%\"]\n" obj.material.KtTexture.name to:out_Geom_file
				)
				if (obj.material.KrTexture != undefined) do
				(
					format "\"texture Kr\" [\"%\"]\n" obj.material.KrTexture.name to:out_Geom_file
				)
				
				if (obj.material.KtTexture == undefined) do
				(
					format "\"color Kt\" [% % %]\n" (Obj.material.kt.r / 255) (Obj.material.kt.g / 255) (Obj.material.kt.b / 255) to:out_Geom_file	
				)
				
				if (obj.material.iorActive as string == "on")do
				(
					format " \"bool architectural\" [\"true\"]\n" to:out_Geom_file
				)
				
				if (obj.material.iorActive as string == "off")do
				(
					format " \"bool architectural\" [\"false\"]\n" to:out_Geom_file
					format " \"float index\" [%]\n" Obj.material.ior to:out_Geom_file
				)
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
				print "creating glossy material:"
				print Obj.material.useBumpmap as string
				if Obj.material.useBumpmap as string == "true" then
				(
					print "usebumpmap"
					print "checking if there's bump texture"
					print Obj.material.bumpmapTexture as string
					
					if (Obj.material.bumpmapTexture != undefined) do
					(
						print "found bumpmap texture.."
						print "Kd Texture name:"
						print Obj.material.bumpmapTexture.name as string
						write_bumpmaptexture Obj.material.bumpmapTexture out_Geom_file
						format "\"float gain\" [%] \n" Obj.material.bumpMap to:out_Geom_file
					)
				)
					
				if Obj.material.kdTexture != undefined then
				(
					print "Kd Texture name:"
					print Obj.material.kdTexture.name as string
					write_texturemap Obj.material.kdTexture out_Geom_file
				)
					
					if Obj.material.ksTexture != undefined then
					(
						print "Ks Texture name:"
						print Obj.material.ksTexture.name as string
						write_texturemap Obj.material.ksTexture out_Geom_file
					)
					
					if Obj.material.iorTexture != undefined then
					(
						print "ior Texture name:"
						print Obj.material.iorTexture.name as string
						write_texturemap Obj.material.iorTexture out_Geom_file
					)
					
					if Obj.material.katexture != undefined then
					(
						print "Ka Texture name:"
						print Obj.material.katexture.name as string
						write_texturemap Obj.material.ksTexture out_Geom_file
					)
					format "MakeNamedMaterial \"%\"\n" Obj.material.name to:out_Geom_file
					format "\"string type\" \"glossy\"\n" to:out_Geom_file
					format " \"float uroughness\" [%]\n" Obj.material.uroughness to:out_Geom_file
					format " \"float vroughness\" [%]\n" Obj.material.vroughness to:out_Geom_file
					if Obj.material.ksTexture != undefined then
					(
						format " \"texture Ks\" [\"%\"]\n" Obj.material.ksTexture.name to:out_Geom_file
					)

					if Obj.material.kdTexture != undefined then
					(
						format " \"texture Kd\" [\"%\"]\n" Obj.material.kdTexture.name to:out_Geom_file
					)
					if Obj.material.kdTexture == undefined then
					(	
						format " \"color Kd\" [% % %]\n" (Obj.material.Kdcolor.r / 255) (Obj.material.Kdcolor.g / 255) (Obj.material.Kdcolor.b / 255)  to:out_Geom_file
					)
					if Obj.material.useior as string == "off" then
					(
						if Obj.material.iorTexture != undefined then
						(
							format " \"texture index\" [\"%s\"]\n" Obj.material.iorTexture.name to:out_Geom_file
						)
						if Obj.material.iorTexture == undefined then
						(
							format " \"float index\" [%]\n" Obj.material.ior to:out_Geom_file
						)
					)
					
					if Obj.material.ksTexture == undefined then
					(
						format " \"color Ks\" [% % %]\n" (Obj.material.kscolor.r / 255) (Obj.material.kscolor.g / 255) (Obj.material.kscolor.b / 255) to:out_Geom_file
					)
					
					if Obj.material.useka as string == "on" then
					(
						if Obj.material.katexture != undefined then
						(
							format " \"texture Ka\" [\"%\"]\n" Obj.material.katexture.name to:out_Geom_file
						)
						if Obj.material.katexture == undefined then
						(
							format " \"color Ka\" [% % %]\n" (Obj.material.kacolor.r / 255) (Obj.material.kacolor.g / 255) (Obj.material.kacolor.b / 255)  to:out_Geom_file
						)
					)

					format " \"float d\" [%]\n" Obj.material.kadepth to:out_Geom_file
					
					if (Obj.material.bumpmapTexture == undefined) then
					(
						if (Obj.material.useBumpmap as string == "true") then
						(
							format "\"float bumpmap\" [%]\n" Obj.material.bumpMap to:out_Geom_file
						)
					)
					if (obj.material.useBumpmap as string == "true") then
					(
						if (Obj.material.bumpmapTexture != undefined) then
						(
							format "\"texture bumpmap\" [\"%\"]\n" Obj.material.bumpmapTexture.name to:out_Geom_file
							format "\"float gain\" [%] \n" Obj.material.bumpMap to:out_Geom_file
						)
					)
					format "NamedMaterial \"%\"\n" Obj.material.name to:out_Geom_file
			)
				
			if classOf obj.material == LuxrenderLight then
			(
				tempmap = getSubTexmap obj.material 1
				print (classOf tempmap)
				
				if (classOf tempmap == LuxrenderBlackbody) then
				(
					format "LightGroup \"%s\"\n" obj.material.AreaLightSourceMap.group to:out_Geom_file
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
				if (obj.material.kdTexture != undefined) then
				(
					write_texturemap Obj.material.kdTexture out_Geom_file
				)
				if (obj.material.KtTexture != undefined) then
				(
					write_texturemap Obj.material.ktTexture out_Geom_file
				)
				
				format "MakeNamedMaterial \"%\"\n" Obj.material.name to:out_Geom_file
				format "\"string type\" \"mattetranslucent\"\n" to:out_Geom_file
				if (obj.material.kdTexture != undefined) then
				(
					format " \"texture Kr\" [\"%\"]\n" obj.material.kdTexture.name to:out_Geom_file
				)

				if (obj.material.kdTexture == undefined) then
				(
					format "\"color Kr\" [% % %]\n" (Obj.material.diffuseColor.r / 255) (Obj.material.diffuseColor.g / 255) (Obj.material.diffuseColor.b / 255)  to:out_Geom_file
				)
				if (obj.material.KtTexture != undefined) then
				(
					format " \"texture Kt\" [\"%\"]\n" obj.material.KtTexture.name to:out_Geom_file
				)
				
				if (obj.material.KtTexture == undefined) then
				(
					format "\"color Kt\" [% % %]\n" (Obj.material.transmitivitycolor.r / 255) (Obj.material.transmitivitycolor.g / 255) (Obj.material.transmitivitycolor.b / 255)  to:out_Geom_file
				)
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
				format "PortalShape \"trianglemesh\"\n" to:out_Geom_file
			)
			
			if classof obj.material == LuxrenderCarPaint then
			(
				format "MakeNamedMaterial \"%\"\n" Obj.material.name to:out_Geom_file
				format "\"string type\" \"carpaint\" " to:out_Geom_file
				
				paintnameString = ""
				--"Blue Matte", "Blue", "White", "2k Acrylack", "BMW 339", "Opel Titan", "Polaris Silber", "Ford F8"
				if obj.material.paintname == 1 then
				(
					paintnameString = toLower  "Blue Matte"
				)
				if obj.material.paintname == 2 then
				(
					paintnameString = toLower  "Blue"
				)
				if obj.material.paintname == 3 then
				(
					paintnameString = toLower  "White"
				)
				if obj.material.paintname == 4 then
				(
					paintnameString = toLower  "2k Acrylack"
				)
				if obj.material.paintname == 5 then
				(
					paintnameString = toLower  "BMW339"
				)
				if obj.material.paintname == 6 then
				(
					paintnameString = toLower  "Opel Titan"
				)
				if obj.material.paintname == 7 then
				(
					paintnameString = toLower  "Polaris Silber"
				)
				if obj.material.paintname == 8 then
				(
					paintnameString = toLower "Ford F8"
				)
				
				if (obj.material.useka)do
				(
					--if (obj.material.katexture == undefined )do
					--(
						--apply kacolor
						format "\"color Ka\" [% % %]\n"  (Obj.material.kacolor.r / 255) (Obj.material.kacolor.g / 255) (Obj.material.kacolor.b / 255)  to:out_Geom_file
					--)
					--if (obj.material.katexture != undefined )do
					--(
						--send to write texture function
						--getandwriteMaterialTexture Obj.material.katexture out_Geom_file
					--)
					
				)
				
				format "\t\"string name\" [\"%\"]\n" paintnameString to:out_Geom_file--name from dropdown
				format " \"float d\" [%]\n" obj.material.kadepth to:out_Geom_file
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
			print "Exporting light..."
			print Lt.name
			print "\""
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
				format "\"vector sundir\" [% % %]" Lt.pos.x Lt.pos.y Lt.pos.z to:out_file
				format "\"float gain\" [%]\n" (getUserProp Lt "gain") to:out_file
				format "\"float relsize\" [%]\n" (getUserProp Lt "relsize") to:out_file
				format "\"float turbidity\" [%]\n" (getUserProp Lt "turbidity") to:out_file
				format "\"integer nsamples\" [%]\n" (getUserProp Lt "nsamples") to:out_file
				format "AttributeEnd # %\n\n"	 Lt.name to:out_file	
			)
			
			else if classOf Lt == LuxSky then
			(
				format "AttributeBegin # %\n"	 Lt.name to:out_file	
				format "LightGroup \"Sky\"\n" to:out_file
				format "LightSource \"sky\"\n" to:out_file
				format "\"vector sundir\" [0 0 1]" to:out_file
				format "\"float gain\" [%]\n" (getUserProp Lt "gain") to:out_file
				format "\"float relsize\" [%]\n" (getUserProp Lt "relsize") to:out_file
				format "\"float turbidity\" [%]\n" (getUserProp Lt "turbidity") to:out_file
				format "\"integer nsamples\" [%]\n" (getUserProp Lt "nsamples") to:out_file
				
				format "AttributeEnd # %\n\n"	 Lt.name to:out_file	
			)
			
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
				
				print "exporting with camera."
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
			print corrected_fov
			

				
				
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
			
			if (exportanim ==false)then
			(
				format "\"string filename\" [\"%\"] \n" 	(getUserProp $ "FileName") to:out_file
			)
			if (exportanim == true)then
			(
				tempframe +=1
				print "tempframe"
				print tempframe as string
				format "\"string filename\" [\"%\"] \n" 	("sequence_" + formattedPrint tempframe format:".4i") to:out_file
			)
			
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
				format "\"integer eyedepth\" [%] \n" (getUserProp $ "bidir_eyedepth") to:out_file
				format "\"integer lightdepth\" [%] \n" (getUserProp $ "bidir_lightdepth") to:out_file
				format "\"integer eyetrrhold\" [%] \n" (getUserProp $ "bidir_eyetrrhold") to:out_file
				format "\"integer lighttrhold\" [%] \n" (getUserProp $ "bidir_lighttrhold") to:out_file
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
				format "\"integer maxdepth\" [%] \n" $.dp_maxdepth to:out_file
				
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
		
		rollout luxmaxgeom "Scene" width:232 height:120
		(
			button btn_Export "Export" pos:[8,48] width:216 height:16
			progressBar progressBarexport "ProgressBar" pos:[8,72] width:216 height:16 color:(color 30 10 190)
		--	button btn7 "Button" pos:[8,120] width:112 height:28
			checkbox chk_use_old_script "Use old script export." pos:[8,8] width:200 height:16
			checkbox chk_ply "ply export" pos:[8,24] width:200 height:16
			
			on btn_Export pressed do
			(
				if templxssavefilepath == undefined then
				(
					messagebox "Please choose where to save lxs before export."
				)
				
				if templxssavefilepath != undefined then
				(
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
						TheObjects = for o in objects where superclassof o == GeometryClass and classof o != Targetobject and (not o.isHidden) collect o
						TheLights 	=  for o in lights where  classof o != Targetobject and (not o.isHidden) collect o
						print "Found numlights in scene:"
						print TheLights.count as string
						
						TheSun = for o in lights where  classof o == LuxSun collect o
						TheSky = for o in lights where  classof o == LuxSky collect o
						
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
							print "found sun -- exporting"
							Pbrt_Lights TheSun[o] out_Geom_file
						)
						
						for o = 1 to TheSky.count do
						(
							print "found sky -- exporting."
							Pbrt_Lights TheSky[o] out_Geom_file
						)
						
			-- 						if (exportanim) do
			--  						(
			--  							-- TODO: Create filename based on frame number.
			--  							for i = animationrange.start to animationrange.end do
			--  							(
			--  								print "exporting frame:"
			--  								print i
			--  							)
			--  						)
						
						progressBarexport.value = 0
						
						if (chk_use_old_script.state == true)then
						(
							exportwithplugin = false
							print "old script export"
							for o = 1 to TheObjects.count do
							(
								Pbrt_Geometry TheObjects[o] out_Geom_file
								progressBarexport.value = 100.*o/TheObjects.count
								progress_text =  "Exporting geometry: " + ((100.0 / TheObjects.count * o) as integer)as string  + " % done."
								pushprompt progress_text	
							)
						)
						
						if (chk_use_old_script.state == false)then
						(
							print "new plugin export"
							exportwithplugin = true
							for o = 1 to TheObjects.count do
							(
								addModifier TheObjects[o] (Edit_Mesh ())
								format "\n#**** Object: % **** \n"  TheObjects[o].name to:out_Geom_file
								format "AttributeBegin \n"  to:out_Geom_file
								WriteShaders TheObjects[o] out_Geom_file
								temppath = getFilenamePath templxssavefilepath
							
								--LMX_ExportMesh TheObjects[o] (temppath + TheObjects[o].name + ".lxm" )
									if (chk_ply.state == true)do
									(
										LMX_ExportPLY TheObjects[o] (temppath + TheObjects[o].name + ".ply" ) false--$ "c:\\luxrender\\test.ply" false
										temppathfixed = replaceChar (temppath as string) "\\" "\\\\"
										writeToFile ("Shape \"plymesh\" \"string filename\" " + "[\"" + (temppathfixed + TheObjects[o].name + ".ply\"] \n" )) out_Geom_file
									)
 									if (chk_ply.state == false)do
 									(
 										--LMX_ExportPLY TheObjects[o] (temppath + TheObjects[o].name + ".lxg" ) true--$ "c:\\luxrender\\test.ply" false
										LMX_ExportMesh TheObjects[o] (temppath + TheObjects[o].name + ".lxm" )
 										temppathfixed = replaceChar (temppath as string) "\\" "\\\\"
 										writeToFile ( "Include" + "\"" + (temppathfixed + TheObjects[o].name + ".lxm\"\n" )) out_Geom_file
 									)
								
									
									-- Shape "plymesh" "string filename" ["c:\\luxrender\\test.ply"]
								
							
								format "AttributeEnd\n" to:out_Geom_file
								progressBarexport.value = 100.*o/TheObjects.count
								progress_text =  "Exporting geometry: " + ((100.0 / TheObjects.count * o) as integer)as string  + " % done."
								pushprompt progress_text	
								deleteModifier TheObjects[o] (1)
							)
							
						)
						
						
						writeToFile "WorldEnd" out_Geom_file
						progressBarexport.value = 0
						progressended_text =  "Exporting geometry done!"
						pushprompt progressended_text	
					)
					close out_Geom_file
					if(launchafterexport == true)then
					(
						print out_Geom_file as string
						print (" \"" + templxssavefilepath + " \"")
						ShellLaunch (exefile as string)  ("\"" + templxssavefilepath + "\"")
					)
					
				)
			)
			on chk_use_old_script changed state do
			(
				print "checkbox state"
				print chk_use_old_script.state
			)
			on chk_ascii changed state do
		(
	
			)
		)
		
		rollout sequence "Export sequence" width:208 height:162 rolledup:true
		(
			GroupBox grp1 "Export directory:" pos:[8,8] width:192 height:64
			edittext edt1 "" pos:[16,24] width:176 height:16
			button btn1 "Browse" pos:[40,45] width:128 height:16
			spinner spn2 "" pos:[80,80] width:64 height:16 range:[0,1e+008,0] type:#integer
			spinner spn3 "" pos:[80,104] width:64 height:16 range:[0,1e+007,0] type:#integer
			label lbl1 "start" pos:[40,80] width:32 height:16
			label lbl2 "end" pos:[40,104] width:32 height:16
			button btn8 "Export sequence" pos:[16,127] width:176 height:16
			
			
			on sequence open do
			(
				if (sequencestart == undefined)then
				(
					sequencestart = animationrange.start
					sequenceend = animationrange.end
					spn2.value = 	sequencestart
					spn3.value = 	sequenceend
				)
				if (sequencestart != undefined)then
				(
					spn2.value = 	sequencestart
					spn3.value = 	sequenceend	
				)
				if (templxssavefilepath  != undefined) then
				(
					edt1.text = templxssavefilepath as string
				)
			)
			on btn1 pressed do
			(
				
				templxssavefilepath = getSavePath caption:"my title" initialDir:"c:\\"
				edt1.text = sequencefolder
				if (templxssavefilepath  != undefined) then
				(
					edt1.text = templxssavefilepath as string
					lxssavefilepath = templxssavefilepath
				)
			)
			on spn2 changed val do
			(
				sequencestart = spn2.value
			)
			on spn3 changed val do
			(
			 	sequenceend = spn3.value 
			)
			on btn8 pressed  do
			(
				if sequencefolder != undefined then
				(
					exportanim = true
					tempframe = 0
					for i = sequencestart to sequenceend do
					(
						print "exporting frame to:"
						temppath = (sequencefolder + "\\" + "sequence_00" + i as string + ".lxs")
						temppathfixed = replaceChar (temppath as string) "\\" "\\\\"
						lxssavefilepath = temppathfixed
						print (temppathfixed)
						--out_Geom_file = temppathfixed
						deleteFile temppathfixed
						out_Geom_file = createfile temppathfixed --out_Geom_file 
						sliderTime = i
						
						------------------------------------------------------------------------------------------------------------------------------------------------------------						
						--DIRTYFIX REMOVE CLEAN UP ETC:::::"!!!:"!#¤#"
						------------------------------------------------------------------------------------------------------------------------------------------------------------
						if (viewport.getType() !=#view_camera)do
						(
							doexport = false
							messagebox("Please render through a Luxrender camera.")
						)
						
						if (viewport.getType()  == #view_camera)do
						(
							doexport = false
							tempcam = viewport.getCamera()
							select tempcam
							if (classof $ as string == "LuxrenderCamera")then
							(
								outputCameraSettings out_Geom_file
								doexport = true
								$.filename = ("sequence_" + i as string)
							)
							else
							(
								doexport = false
								messagebox("Please render through a Luxrender camera.")
							)
						)
						
						if (doexport) do
						(
							
							TheObjects = for o in objects where superclassof o == GeometryClass and classof o != Targetobject and (not o.isHidden) collect o
							TheLights 	=  for o in lights where  classof o != Targetobject and (not o.isHidden) collect o
							TheSun = for o in objects where  classof o == LuxSun collect o
							TheSky = for o in objects where  classof o == LuxSky collect o
							
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
								print "found sun -- exporting"
								Pbrt_Lights TheSun[o] out_Geom_file
							)
							
							for o = 1 to TheSky.count do
							(
								print "found sky -- exporting."
								Pbrt_Lights TheSky[o] out_Geom_file
							)
							
							for o = 1 to TheObjects.count do
							(
								Pbrt_Geometry TheObjects[o] out_Geom_file
								progress_text =  "Exporting geometry: " + ((100.0 / TheObjects.count * o) as integer)as string  + " % done."
								pushprompt progress_text	
							)
							writeToFile "WorldEnd" out_Geom_file
							progressended_text =  "Exporting geometry done!"
							pushprompt progressended_text	
						)
						------------------------------------------------------------------------------------------------------------------------------------------------------------						
						--DIRTYFIX REMOVE CLEAN UP ETC:::::"!!!:"!#¤#"
						------------------------------------------------------------------------------------------------------------------------------------------------------------						
					)
				)
			)
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
			
			button btn2 "Open file location" pos:[16,64] width:200 height:16
			
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
					folderpath = getFilenamePath lxssavefilepath
					HiddenDOSCommand("explorer.exe " + folderpath)
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
				print exefile
				print "opening rollout"
				
				if launchafterexport as string == "true" then
				(
					chk1.state = true
					print "Debug:"
					print (exefile as string)
					
				)
			)
			
			on btn_browse_lux pressed  do
			(
				
				f = getOpenFileName caption:"browse to luxrender exe:" \ 
				filename:"c:/luxrender.exe"
				edt1.text = f
				exefile = f
				print "Debug:"
				print (f as string)
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
			label lbl4 "And big thanks for perpixel for starting the exporter (materials \ textures) so that it can be used as a base for this exporter." pos:[40,88] width:176 height:56
		)

		try(closeRolloutFloater theNewFloater)catch()
		theNewFloater = newRolloutFloater "LuxMaxscript Exporter" 250 500
		
		addRollout systemsettings theNewFloater
		addRollout luxmaxcam theNewFloater
		--addrollout sequence theNewFloater
		addRollout SceneFile theNewFloater
		addRollout luxmaxgeom theNewFloater
		addRollout about_script theNewFloater
	