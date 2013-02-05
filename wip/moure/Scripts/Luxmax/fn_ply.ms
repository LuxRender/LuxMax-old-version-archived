/*
***** BEGIN GPL LICENSE BLOCK *****

--------------------------------------------------------------------------
LuxMax Autodesk® 3ds Max® to Luxrender exporter
--------------------------------------------------------------------------

Authors:
Guillaume Plourde
Konstantinos Mourelas
Stig Atle Steffensen

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, see <http://www.gnu.org/licenses/>.

***** END GPL LICENCE BLOCK *****
*/
--// ply exporter
(
	function ply_WriteString stream str =
	(
		WriteString stream str
		fseek stream -1 #seek_cur
		WriteByte stream 0x0a
	)
	function ply_WriteFaceVertex stream m idx tm ws =
	(
		v = getVert m idx
		
		v = v * (inverse tm)
		
		WriteFloat stream (v[1] * ws)
		WriteFloat stream (v[2] * ws)
		WriteFloat stream (v[3] * ws)
	)
	function ply_WriteFaceVertexNormal stream n tm =
	(
		normalTransform = copy tm
		normalTransform.position = [0,0,0]
		n = n * (inverse) normalTransform
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
	function ply_export_script o fname ws =
	(
		exportUV = false
		
		--if (heapSize < 30000000) then heapSize += 10000000
		
		_trimsh = snapshotAsMesh o
		
		tm = o.transform
		
		if (getNumTVerts _trimsh > 0) then exportUV = true
		
		--buildTVFaces _trimsh true
		
		numvertices = _trimsh.numverts 
		numfaces = _trimsh.numfaces 

		stream = fopen fname "wb"
		
		if (stream == undefined) then return false
		
		try
		(
			ply_WriteString stream "ply"
			ply_WriteString stream "format binary_little_endian 1.0"
			ply_WriteString stream "comment LuxMax Maxscript PLY Exporter"
			ply_WriteString stream ("element vertex " + (numfaces *  3) as string)
			ply_WriteString stream "property float x"
			ply_WriteString stream "property float y"
			ply_WriteString stream "property float z"
			ply_WriteString stream "property float nx"
			ply_WriteString stream "property float ny"
			ply_WriteString stream "property float nz"
			
			if (exportUV == true) then
			(
				ply_WriteString stream "property float s"
				ply_WriteString stream "property float t"
			)
			
			ply_WriteString stream ("element face " + numfaces as string)
			ply_WriteString stream "property list int int vertex_indices"
			ply_WriteString stream "end_header"

			for i = 1 to numfaces do
			(
				tf = undefined
				f = getFace _trimsh i
				
				if (exportUV == true) then tf = getTVFace  _trimsh i
				
				normals = (meshop.getFaceRNormals _trimsh i)
				
				ply_WriteFaceVertex stream _trimsh f[1] tm ws
				ply_WriteFaceVertexNormal stream normals[1] tm
				if (exportUV == true) then ply_WriteFaceTVertex stream _trimsh tf[1] 
				
				ply_WriteFaceVertex stream _trimsh f[2] tm ws
				ply_WriteFaceVertexNormal stream normals[2] tm
				if (exportUV == true) then ply_WriteFaceTVertex stream _trimsh tf[2]
				
				ply_WriteFaceVertex stream _trimsh f[3] tm ws
				ply_WriteFaceVertexNormal stream normals[3] tm
				if (exportUV == true) then ply_WriteFaceTVertex stream _trimsh tf[3]
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