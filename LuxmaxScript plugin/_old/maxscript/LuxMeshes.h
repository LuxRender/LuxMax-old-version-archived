#include "LuxMax.h"

const float eps = 0.0001f;

class LuxMaxMesh
{
public:

	LuxMaxMesh(INode* p_node);
	~LuxMaxMesh();

	TSTR name;
	Mtl* material;

	int numvertices;
	Point3* vertices;
	bool* verticesIndex;
	int numfaces;
	Point3* faces;
	Point3* facesIndex;
	int numnormals;
	Point3* normals;
	int numuvs;
	Point3* uvs;

	bool isPortal;
	bool isTriMesh;

	// Methods
	int* duplicatedVertices;

	void OptimizeFaceIndices();
	Point3 GetFirstMatchingVertex(Point3 f);

	int CollectDuplicatedVertices(int idx);
	void ReplaceVertices(int idx0, int idx1);
	void IndexFaces();

	void WriteIndices(FILE* p_Stream);
	void WritePoints(FILE* p_Stream);
	void WriteNormals(FILE* p_Stream);
	void WriteUvs(FILE* p_Stream);
};