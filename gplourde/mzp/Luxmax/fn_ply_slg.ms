/*
 Maxscript PLY file exporter
 For use with small lux GPU
 Guillaume Plourde, gplourde@gmail.com
*/
--// ply exporter
(
	function SLG_ply_WriteString stream str =
	(
		WriteString stream str
		fseek stream -1 #seek_cur
		WriteByte stream 0x0a
	)
	function SLG_ply_WriteFaceVertex stream m idx ws =
	(
		v = getVert m idx
			
		WriteFloat stream (v[1] * ws)
		WriteFloat stream (v[2] * ws)
		WriteFloat stream (v[3] * ws)
	)
	function SLG_ply_WriteFaceVertexNormal stream n =
	(
		WriteFloat stream n[1] 
		WriteFloat stream n[2]
		WriteFloat stream n[3]
	)
	function SLG_ply_WriteFaceTVertex stream m idx =
	(
		v = getTVert m idx
		WriteFloat stream v[1]
		WriteFloat stream -v[2]
	)
	function SLG_ply_export_script o fname ws =
	(
		exportUV = false
			
		_trimsh = snapshotAsMesh o
		
		tm = o.transform
		
		if (getNumTVerts _trimsh > 0) then exportUV = true
		
		numvertices = _trimsh.numverts 
		numfaces = _trimsh.numfaces 

		stream = fopen fname "wb"
		
		if (stream == undefined) then return false
		
		try
		(
			SLG_ply_WriteString stream "ply"
			SLG_ply_WriteString stream "format binary_little_endian 1.0"
			SLG_ply_WriteString stream "comment LuxMax Maxscript PLY Exporter"
			SLG_ply_WriteString stream ("element vertex " + (numfaces *  3) as string)
			
			SLG_ply_WriteString stream "property float x"
			SLG_ply_WriteString stream "property float y"
			SLG_ply_WriteString stream "property float z"
			SLG_ply_WriteString stream "property float nx"
			SLG_ply_WriteString stream "property float ny"
			SLG_ply_WriteString stream "property float nz"
			SLG_ply_WriteString stream "property float s"
			SLG_ply_WriteString stream "property float t"
			
			SLG_ply_WriteString stream ("element face " + numfaces as string)
			SLG_ply_WriteString stream "property list int int vertex_indices"
			SLG_ply_WriteString stream "end_header"

			for i = 1 to numfaces do
			(
				tf = undefined
				f = getFace _trimsh i
				tf = getTVFace  _trimsh i
				normals = (meshop.getFaceRNormals _trimsh i)
				
				SLG_ply_WriteFaceVertex stream _trimsh f[1] ws
				SLG_ply_WriteFaceVertexNormal stream normals[1]
				SLG_ply_WriteFaceTVertex stream _trimsh tf[1] 
				
				SLG_ply_WriteFaceVertex stream _trimsh f[2] ws
				SLG_ply_WriteFaceVertexNormal stream normals[2]
				SLG_ply_WriteFaceTVertex stream _trimsh tf[2]
				
				SLG_ply_WriteFaceVertex stream _trimsh f[3] ws
				SLG_ply_WriteFaceVertexNormal stream normals[3]
				SLG_ply_WriteFaceTVertex stream _trimsh tf[3]
			)

			c = 0

			for i = 1 to numfaces do
			(
				WriteLong  stream 3
				WriteLong  stream c
				c += 1
				WriteLong  stream c
				c += 1
				WriteLong  stream c
				c += 1
			)
		)
		catch
		(
			fclose stream
			delete _trimsh
			return false
		)
		fclose stream
		delete _trimsh
		return true
	)
)