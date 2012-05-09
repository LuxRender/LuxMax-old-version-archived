#include "windows.h"
#include "LuxMeshes.h"
#include "Math.h"
#include <fstream>
#include <iostream>
#include <cstring>
#include <maxscript.h>
void CommaScan(TCHAR* buf)
{
    for(; *buf; buf++) if (*buf == ',') *buf = '.';
}

TSTR Format(float value)
{
	TCHAR buf[40];
	
	sprintf_s(buf, "%f", value);
	CommaScan(buf);
	return TSTR(buf);
}

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
		p_trimesh->buildNormals();									
		int i_faceCount = p_trimesh->getNumFaces();
		Matrix3 m3_nodeTransform = p_node->GetObjectTM(GetCOREInterface()->GetTime());
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
			faces[i] = Point3(c , c + 1, c + 2);
			
			Face* p_face = &p_trimesh->faces[i];
			TVFace*	p_tvface = &p_trimesh->tvFace[i];

			for(vert = 0; vert < 3; vert++)
			{
				int id = (c + vert);

				int i_vertex = p_face->getVert(vert);
				vertices[id] = (p_trimesh->getVert(i_vertex)) * m3_nodeTransform;

				normals[id] = GetVertexNormal(p_trimesh, i, p_trimesh->getRVertPtr(i_vertex)) * m3_nodeTransform;
				normals[id] = normals[id] - m3_nodeTransform.GetTrans();
				normals[id] = normals[id].Normalize();

				if (p_trimesh->numTVerts > 0)
					uvs[id] = p_trimesh->getTVert(p_tvface->getTVert(vert));
			}

			c += 3;
		}	
	}
}

LuxMaxMesh::~LuxMaxMesh()
{
		delete faces;
		delete vertices;
		delete verticesIndex;
		delete normals;
		delete uvs;
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
		v = ScaleVector(v, 1.0f);

		fprintf(p_Stream, "%s %s %s\n", Format(v.x), Format(v.y), Format(v.z));
	}

	fprintf(p_Stream, "]\n");
}
void LuxMaxMesh::WriteNormals(FILE* p_Stream)
{
	int i;
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
	fprintf(p_Stream, "\"float uv\"[\n");
		for (i = 0; i < numuvs; i++)
	{
		Point3 v = uvs[i];
		fprintf(p_Stream, "%s %s\n", Format(v.x), Format(-1 * v.y));
	}
	fprintf(p_Stream, "]\n");
}

void WritePortals(INode* p_node, FILE* s_pStream)
{
	int i, c;

	if (!p_node->IsRootNode() && !p_node->IsNodeHidden())
	{
		LuxMaxMesh lxmesh(p_node);

		if (lxmesh.numfaces > 0 && lxmesh.isPortal)
		{
			fprintf(s_pStream, "PortalShape \"trianglemesh\" ", p_node->GetName()); // Portal Name
			lxmesh.WriteIndices(s_pStream);
			lxmesh.WritePoints(s_pStream);
		}
	}

	c = p_node->NumberOfChildren();

	for (i = 0; i < c; i++)
	{
		WritePortals(p_node->GetChildNode(i), s_pStream);
	}
}

void WriteMeshes(INode* p_node, FILE* s_pStream)
{
	if (!p_node->IsRootNode() && !p_node->IsHidden())
	{
		LuxMaxMesh lxmesh(p_node);

		if (lxmesh.numfaces > 0 && lxmesh.isTriMesh)
		{
			
			if(lxmesh.isPortal)
			{
				fprintf(s_pStream, "PortalShape \"trianglemesh\" ");
			}
			
			
			if( !lxmesh.isPortal)
			{
				fprintf(s_pStream, "Shape \"trianglemesh\" ");
			}

			lxmesh.WriteIndices(s_pStream);
			lxmesh.WritePoints(s_pStream);
			lxmesh.WriteNormals(s_pStream);
			lxmesh.WriteUvs(s_pStream);

			if( !lxmesh.isPortal)
			{
				fprintf(s_pStream, "AttributeEnd\n\n");
			}
			
		}
	}
}

void WritePLYString(char* str, std::ofstream* file)
{
	file->write(str, strlen(str));
}

void WritePLY(INode* p_node, FILE* file, bool ascii)
{
	int i;
	if (!p_node->IsRootNode() && !p_node->IsHidden())
	{
		LuxMaxMesh lxmesh(p_node);

		if (lxmesh.numfaces > 0 && !lxmesh.isPortal && lxmesh.isTriMesh)
		{
			fprintf(file, "ply\n");

			if (ascii)
				fprintf(file, "format ascii 1.0\n");
			else
				fprintf(file, "format binary_little_endian 1.0\n");

			fprintf(file, "comment LuxMax PLY Exporter\n");
			fprintf(file, "comment %s\n", lxmesh.name);
			fprintf(file, "element vertex %d\n", lxmesh.numvertices);
			fprintf(file, "property float x\n");
			fprintf(file, "property float y\n");
			fprintf(file, "property float z\n");
			fprintf(file, "property float nx\n");
			fprintf(file, "property float ny\n");
			fprintf(file, "property float nz\n");
			fprintf(file, "property float s\n");
			fprintf(file, "property float t\n");
			fprintf(file, "element face %d\n", lxmesh.numfaces);
			fprintf(file, "property list int int vertex_indices\n");
			fprintf(file, "end_header\n");

			// Write Vertices
			for (i = 0; i < lxmesh.numvertices; i++)
			{
				if (ascii)
					fprintf(file, "%.6f %.6f %.6f %.6f %.6f %.6f\n",lxmesh.vertices[i].x, (-1 * lxmesh.vertices[i].y), lxmesh.vertices[i].z, lxmesh.normals[i].x, lxmesh.normals[i].y, lxmesh.normals[i].z);
				else
				{
					fwrite (&lxmesh.vertices[i].x, 4, 1, file);
					fwrite (&lxmesh.vertices[i].y, 4, 1, file);
					fwrite (&lxmesh.vertices[i].z, 4, 1, file);
					fwrite (&lxmesh.normals[i].x, 4, 1, file);
					fwrite (&lxmesh.normals[i].y, 4, 1, file);
					fwrite (&lxmesh.normals[i].z, 4, 1, file);
					fwrite (&lxmesh.uvs[i].x, 4, 1, file);
					float temp;
					temp = (-1 * lxmesh.uvs[i].y);
					fwrite (&temp, 4, 1, file);
				}
			}

			// Write Faces
			for (i = 0; i < lxmesh.numfaces; i++)
			{
				if (ascii)
					fprintf(file, "3 %d %d %d\n", (int)lxmesh.faces[i].x, (int)lxmesh.faces[i].y, (int)lxmesh.faces[i].z);
				else
				{
					int c = 3;
					int x = (int)lxmesh.faces[i].x;
					int y = (int)lxmesh.faces[i].y;
					int z = (int)lxmesh.faces[i].z;

					fwrite (&c, 4, 1, file);
					fwrite (&x, 4, 1, file);
					fwrite (&y, 4, 1, file);
					fwrite (&z, 4, 1, file);
				}
			}
		}
	}
}
