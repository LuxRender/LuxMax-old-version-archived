#include "LuxMax.h"

#define DEGTORAD(Deg) ((Deg * 3.141592653589793238) / 180.0)
#define RADTODEG(Rad) ((180.0 * Rad) / 3.141592653589793238)

// Scale point3 to world scale. LuxRender 1 unit = 1 meters.

Point3 ScaleVector(Point3 p, float scale)
{
	p.x /= scale;
	p.y /= scale;
	p.z /= scale;

	return p;
}

float GetCameraFov(int width, int height, float f)
{

	if (width <= height)
		return f;

	float r_aspect = (float)width / height;
	double fov = 2.0f * (RADTODEG(atan(tan(DEGTORAD(f / 2.0f)) / r_aspect)));

	return (float)fov;
}

Point3 GetVertexNormal(Mesh* mesh, int faceNo, RVertex* rv)
{
	Face* f = &mesh->faces[faceNo];
	DWORD smGroup = f->smGroup;
	int numNormals;
	Point3 vertexNormal;

	if (rv->rFlags & SPECIFIED_NORMAL)
	{
		vertexNormal = rv->rn.getNormal();
	}
	else if ((numNormals = rv->rFlags & NORCT_MASK) && smGroup)
	{
		if (numNormals == 1)
		{
			vertexNormal = rv->rn.getNormal();
		}
		else
		{
			for (int i = 0; i < numNormals; i++)
			{
				if (rv->ern[i].getSmGroup() & smGroup)
				{
					vertexNormal = rv->ern[i].getNormal();
				}
			}
		}
	}
	else
	{
		vertexNormal = mesh->getFaceNormal(faceNo);
	}

	return vertexNormal;
}
