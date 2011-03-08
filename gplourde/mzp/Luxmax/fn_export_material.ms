function export_texturemaps =
(
	str = stringstream ""
	
	texturemaps = #()
	
	for obj in geometry do
	(
		if (obj.ishidden) then continue
	
		try
		(
			_texturemaps = obj.material.GetTextureMaps()
			if (_texturemaps.count > 0) then
			(
				for _t in _texturemaps do
				(
					if (_t == undefined) then continue
						append texturemaps _t
				)
			)
		)
		catch (print (getCurrentException()))
	)
	
	texturemaps = makeUniqueArray  texturemaps
	
	for _t in texturemaps do
	(
		format "%\n" (_t.GetLuxRenderString()) to:str
	)
	return str as string
)

function export_volumes =
(
	str = stringstream ""
	
	for obj in helpers do
	(
		if (classof obj == LuxRenderVolume) then
		(
			_absorption = #(0, 0, 0)
			
			_absorption[1] = (-log(amax #(obj.absorption.r / 255, 1e-30) )/(obj.absdepth * obj.absscale) * 1)
			_absorption[2] = (-log(amax #(obj.absorption.g / 255, 1e-30) )/(obj.absdepth * obj.absscale) * 1)
			_absorption[3] = (-log(amax #(obj.absorption.b / 255, 1e-30) )/(obj.absdepth * obj.absscale) * 1)
			
			format "MakeNamedVolume \"%\" \"clear\"\n" obj.name to:str
			luxWriteFloat "fresnel" obj.ior str
			format "\t\"color absorption\" [% % %]\n" _absorption[1] _absorption[2] _absorption[3] to:str
			format "\n" to:str
		)
	)
	
	return str as string
)

function export_lxm lxm =
(
	str = stringstream ""
	
	format "%" (export_volumes()) to:str
	format "%" (export_texturemaps()) to:str
	
	materials = #()
	
	for obj in geometry do
	(
		if (obj.ishidden) then continue
		
		appendifunique materials obj.material
	)
	
	materials = makeUniqueArray materials
	
	for _m in materials do
	(
		try (format "%\n" (_m.GetLuxRenderString()) to:str) catch (print (getCurrentException()))
	)
	
	f = openfile lxm mode:"w"
	format "%\n" (str as string) to:f
	close f
)