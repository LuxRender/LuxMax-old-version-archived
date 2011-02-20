/*
 Maxscript PLY file exporter
 Guillaume Plourde, gplourde@gmail.com
*/
--// ply exporter
(
	function ply_WriteString stream str =
	(
		WriteString stream str
		fseek stream -1 #seek_cur
		WriteByte stream 0x0a
	)
	function ply_WriteFaceVertex stream m idx ws =
	(
		v = getVert m idx

		WriteFloat stream (v[1] / ws)
		WriteFloat stream (v[2] / ws)
		WriteFloat stream (v[3] / ws)
	)
	function ply_WriteFaceVertexNormal stream n =
	(
		n = normalize n
		
		WriteFloat stream n[1] 
		WriteFloat stream n[2]
		WriteFloat stream n[3]
	)
	function ply_WriteFaceTVertex stream m idx =
	(
		v = getTVert m idx
		WriteFloat stream v[1]
		WriteFloat stream -v[2]
	)
	function ply_export o fname ws =
	(
		numvertices = o.mesh.numverts 
		numfaces = o.mesh.numfaces 

		stream = fopen fname "wb"

		ply_WriteString stream "ply"
		ply_WriteString stream "format binary_little_endian 1.0"
		ply_WriteString stream "comment LuxMax PLY Exporter"
		ply_WriteString stream ("element vertex " + (numfaces *  3) as string)
		ply_WriteString stream "property float x"
		ply_WriteString stream "property float y"
		ply_WriteString stream "property float z"
		ply_WriteString stream "property float nx"
		ply_WriteString stream "property float ny"
		ply_WriteString stream "property float nz"
		ply_WriteString stream "property float s"
		ply_WriteString stream "property float t"
		ply_WriteString stream ("element face " + numfaces as string)
		ply_WriteString stream "property list int int vertex_indices"
		ply_WriteString stream "end_header"

		for i = 1 to numfaces do
		(
			f = getFace o.mesh i
			tf = getTVFace  o.mesh i
			normals = (meshop.getFaceRNormals o.mesh i)
			
			ply_WriteFaceVertex stream o.mesh f[1] ws
			ply_WriteFaceVertexNormal stream normals[1]
			ply_WriteFaceTVertex stream o.mesh tf[1] 
			
			ply_WriteFaceVertex stream o.mesh f[2] ws
			ply_WriteFaceVertexNormal stream normals[2]
			ply_WriteFaceTVertex stream o.mesh tf[2]
			
			ply_WriteFaceVertex stream o.mesh f[3] ws
			ply_WriteFaceVertexNormal stream normals[3]
			ply_WriteFaceTVertex stream o.mesh tf[3]
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
		fclose stream
	)
)