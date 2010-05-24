#include "windows.h"
#include "LuxMeshes.h"
#include "Math.h"

LuxMaxMesh::LuxMaxMesh(INode* p_node)
{
	int i, c;

	// init
	numfaces = 0;
	isPortal = false;
	isTriMesh = false;

	faces = NULL;
	vertices = NULL;
	verticesIndex = NULL;
	normals = NULL;
	uvs = NULL;

	Object*	obj;
	ObjectState os = p_node->EvalWorldState(0);
	obj = os.obj;

	switch(os.obj->SuperClassID())
	{
	case GEOMOBJECT_CLASS_ID:

		TSTR s_nName(p_node->GetName());

		// Convert the node geometry to a triangle based mesh

		TriObject *p_triobj;

		BOOL fConvertedToTriObject = obj->CanConvertToType(triObjectClassID) && (p_triobj = (TriObject*)obj->ConvertToType(0, triObjectClassID)) != NULL;

		if (!fConvertedToTriObject)
			return;

		Mesh *p_trimesh = &p_triobj->mesh;
		p_trimesh->buildNormals();									// just make sure we have vertex normals
		int i_faceCount = p_trimesh->getNumFaces();					// Check how many face we have to loop for
		Matrix3 m3_nodeTransform = p_node->GetObjectTM(0);			// Get the node transform at frame 0
		DWORD triIndex = 0;

		if (i_faceCount < 1)
			return;

		isTriMesh = true;

		name = s_nName;
		material = p_node->GetMtl();
		numfaces = i_faceCount;
		numvertices = i_faceCount * 3;
		numnormals = i_faceCount * 3;
		numuvs = i_faceCount * 3;

		faces = new Point3[i_faceCount];
		vertices = new Point3[i_faceCount * 3];
		verticesIndex = new bool[i_faceCount * 3];
		normals = new Point3[i_faceCount * 3];
		uvs = new Point3[i_faceCount * 3];

		isPortal = false;

		if (material)
		{
			if (material->ClassID() == LUXRENDER_PORTALMATERIAL_ID)
				isPortal = true;
		}

		c = 0;

		for (i = 0; i < i_faceCount; i++)
		{
			int vert;
			Point3 v;

			// fill face index
			faces[i] = Point3(c , c + 1, c + 2);
			
			Face* p_face = &p_trimesh->faces[i];
			TVFace*	p_tvface = &p_trimesh->tvFace[i];

			for(vert = 0; vert < 3; vert++)
			{
				int id = (c + vert);

				int i_vertex = p_face->getVert(vert);
				vertices[id] = (p_trimesh->getVert(i_vertex)) * m3_nodeTransform;

				normals[id] = GetVertexNormal(p_trimesh, i, p_trimesh->getRVertPtr(i_vertex));
				normals[id].Normalize();

				if (p_trimesh->numTVerts > 0)
					uvs[id] = p_trimesh->getTVert(p_tvface->getTVert(vert));
			}

			c += 3;
		}

		//OptimizeFaceIndices();
	
	}
}

LuxMaxMesh::~LuxMaxMesh()
{
		delete faces;
		delete vertices;
		delete verticesIndex;
		delete normals;
		delete uvs;
		//delete this;
}
Point3 LuxMaxMesh::GetFirstMatchingVertex(Point3 f)
{
	int i;

	int v0 = (int)f.x;
	int v1 = (int)f.y;
	int v2 = (int)f.z;

	Point3 indices(-1.0f, -1.0f, -1.0f);

	for (i = 0; i < numvertices; i++)
	{
		if (indices.x > -1.0f && indices.y > -1.0f && indices.z > -1.0f)
			return indices;

		if (vertices[i].Equals(vertices[v0], eps) && indices.x == -1.0f)
		{
			if (normals[i].Equals(normals[v0], eps) && uvs[i].Equals(uvs[v0], eps))
			{
				verticesIndex[i] = true;
				indices.x = (float)i;
			}
		}
		else if (vertices[i].Equals(vertices[v1], eps) && indices.y == -1.0f)
		{
			if (normals[i].Equals(normals[v1], eps) && uvs[i].Equals(uvs[v1], eps))
			{
				verticesIndex[i] = true;
				indices.y = (float)i;
			}
		}
		else if (vertices[i].Equals(vertices[v2], eps) && indices.z == -1.0f)
		{
			if (normals[i].Equals(normals[v2], eps) && uvs[i].Equals(uvs[v2], eps))
			{
				verticesIndex[i] = true;
				indices.z = (float)i;
			}
		}
	}

	return indices;
}

void LuxMaxMesh::OptimizeFaceIndices()
{
	int i;

	for (i = 0; i < numvertices; i++)
		verticesIndex[i] = false;

	for (i = 0; i < numfaces; i++)
		faces[i] = GetFirstMatchingVertex(faces[i]);
}

void LuxMaxMesh::IndexFaces()
{
	int i, j, c;

	c = 0;

	for (i = 0; i < numvertices; i++)
	{
		if (verticesIndex[i])
		{
			vertices[c] = vertices[i];
			normals[c] = normals[i];
			uvs[c] = uvs[i];

			for (j = 0; j < numfaces; j++)
			{
				Point3 f = faces[j];

				if (f.x == i)
					faces[j].x = (float)c;
				if (f.y == i)
					faces[j].y = (float)c;
				if (f.z == i)
					faces[j].z = (float)c;
			}
			c++;
		}
	}

	numvertices = c;
	numnormals = c;
	numvertices = c;
}


void LuxMaxMesh::WriteIndices(FILE* p_Stream)
{
	int i;

	// Face indices
	fprintf(p_Stream, "\"integer indices\"[\n");

	for (i = 0; i < numfaces; i++)
		fprintf(p_Stream, "%i %i %i\n", (int)faces[i].x, (int)faces[i].y, (int)faces[i].z);

	fprintf(p_Stream, "]\n");
}
void LuxMaxMesh::WritePoints(FILE* p_Stream)
{
	int i;

	// Vertex coord
	fprintf(p_Stream, "\"point P\"[\n");

	for (i = 0; i < numvertices; i++)
	{
		Point3 v = vertices[i];
		v = ScaleVector(v, 100.0f);

		fprintf(p_Stream, "%s %s %s\n", Format(v.x), Format(v.y), Format(v.z));
	}

	fprintf(p_Stream, "]\n");
}
void LuxMaxMesh::WriteNormals(FILE* p_Stream)
{
	int i;

	// Vertex normals
	
	fprintf(p_Stream, "\"normal N\"[\n");
	for (i = 0; i < numnormals; i++)
	{
		Point3 v = normals[i];

		fprintf(p_Stream, "%s %s %s\n", Format(v.x), Format(v.y), Format(v.z));
	}
	fprintf(p_Stream, "]\n");
}
void LuxMaxMesh::WriteUvs(FILE* p_Stream)
{
	int i;
	// UV
	fprintf(p_Stream, "\"float uv\"[\n");
	//for (i = 0; i < numuvs; i++)
		for (i = 0; i < numuvs; i++)
	{
		Point3 v = uvs[i];
//		fprintf(p_Stream, "%s %s\n", Format(v.x), Format(v.y));
		//To fix this i turned the v.y to a negative number.
		fprintf(p_Stream, "%s %s\n", Format(v.x), Format(-1 * v.y));
		

	}
	fprintf(p_Stream, "]\n");
}

void LuxMax::WritePortals(INode* p_node)
{
	int i, c;

	if (!p_node->IsRootNode() && !p_node->IsNodeHidden())
	{
		LuxMaxMesh lxmesh(p_node);

		if (lxmesh.numfaces > 0 && lxmesh.isPortal)
		{
			fprintf(s_pStream, "# %s\nPortalShape \"trianglemesh\" ", p_node->GetName()); // Portal Name

			lxmesh.WriteIndices(s_pStream);
			lxmesh.WritePoints(s_pStream);
		}
	}

	c = p_node->NumberOfChildren();

	for (i = 0; i < c; i++)
	{
		WritePortals(p_node->GetChildNode(i));
	}
}

void LuxMax::WriteMeshesProc(INode* p_node)
{
	int i, c;

	if (!p_node->IsRootNode() && !p_node->IsHidden())
	{
		//WriteTriMesh(p_node);
		LuxMaxMesh lxmesh(p_node);

		if (lxmesh.numfaces > 0 && !lxmesh.isPortal && lxmesh.isTriMesh)
		{
			fprintf(s_pStream, "# %s\nAttributeBegin\n\n", p_node->GetName());

			WriteMaterials(p_node);

			TSTR pr0 = "usesubdivision";
			TSTR pr1 = "subdivision";
			TSTR pr2 = "issmooth";
			TSTR pr3 = "issharpen";
			TSTR pr4 = "usedisplacement";
			TSTR pr5 = "displacement";
			TSTR pr6 = "displacementtexture";

			if (lxmesh.material)
			{
				int var0 = Mtl_GetInt((MtlBase*)lxmesh.material, pr0, 0);
				int var1 = Mtl_GetInt((MtlBase*)lxmesh.material, pr1, 0); 
				int var2 = Mtl_GetInt((MtlBase*)lxmesh.material, pr2, 0);
				int var3 = Mtl_GetInt((MtlBase*)lxmesh.material, pr3, 0);

				int var4 = Mtl_GetInt((MtlBase*)lxmesh.material, pr4, 0);
				float var5 = Mtl_GetFloat((MtlBase*)lxmesh.material, pr5, 0);
				Texmap* var6 = Mtl_GetTexmap((MtlBase*)lxmesh.material, pr6, 0);

				if (var0 && var4 && var6)
				{
					WriteTexture(var6, "float");
					fprintf(s_pStream, "Texture \"%s::Displacement::Scale\" \"float\" \"scale\" \"texture tex1\" [\"%s\"] \"float tex2\" [%s]\n", var6->GetName(), var6->GetName(), Format(var5));
				}

				if (var0)
				{
					lxmesh.IndexFaces();

					fprintf(s_pStream, "Shape \"loopsubdiv\" \"integer nlevels\" [%i] ", var1);
					
					if (var2)
						fprintf(s_pStream, "\"bool dmnormalsmooth\" [\"true\"] ");
					else
						fprintf(s_pStream, "\"bool dmnormalsmooth\" [\"false\"] ");

					if (var3)
						fprintf(s_pStream, "\"bool dmsharpboundary\" [\"true\"] ");
					else
						fprintf(s_pStream, "\"bool dmsharpboundary\" [\"false\"] ");

					if (var4 && var6)
					{
						fprintf(s_pStream, "\"string displacementmap\" [\"%s::Displacement::Scale\"] \"float dmscale\" [-1.0] \"float dmoffset\" [0.000000] ", var6->GetName());
					}

				}
				else
					fprintf(s_pStream, "Shape \"trianglemesh\" ");
			}
			else
				fprintf(s_pStream, "Shape \"trianglemesh\" ");

			lxmesh.WriteIndices(s_pStream);
			lxmesh.WritePoints(s_pStream);
			lxmesh.WriteNormals(s_pStream);
			lxmesh.WriteUvs(s_pStream);

			fprintf(s_pStream, "AttributeEnd\n\n");
		}
	}

	c = p_node->NumberOfChildren();

	for (i = 0; i < c; i++)
	{
		WriteMeshesProc(p_node->GetChildNode(i));
	}
}
