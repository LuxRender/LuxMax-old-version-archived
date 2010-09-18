#include "Common.h"

/*
=============================================================================
MatBase IParamBlock2 functions
=============================================================================
*/

/*
=============================================================================
Mtl_GetFloat
=============================================================================
*/
float Mtl_GetFloat(MtlBase* base, TSTR pr, TimeValue t)
{
	int i, p;

	for(i = 0; i < base->NumParamBlocks(); i++)
	{
		IParamBlock2* b = base->GetParamBlock(i);

		for(p = 0; p < b->NumParams(); p++)
		{
			TSTR pname = b->GetLocalName(p);
			
			pname.toLower();

			if (pname == pr)
				return b->GetFloat(p, t);
		}
	}

	return 0.0f;
}

/*
=============================================================================
Mtl_GetInt
=============================================================================
*/
int Mtl_GetInt(MtlBase* base, TSTR pr, TimeValue t)
{
	int i, p;

	for(i = 0; i < base->NumParamBlocks(); i++)
	{
		IParamBlock2* b = base->GetParamBlock(i);

		for(p = 0; p < b->NumParams(); p++)
		{
			TSTR pname = b->GetLocalName(p);

			pname.toLower();

			if (pname == pr)
				return b->GetInt(p, t);
		}
	}

	return 0;
}

/*
=============================================================================
Mtl_GetStr
=============================================================================
*/
TSTR Mtl_GetStr(MtlBase* base, TSTR pr, TimeValue t)
{
	int i, p;

	for(i = 0; i < base->NumParamBlocks(); i++)
	{
		IParamBlock2* b = base->GetParamBlock(i);

		for(p = 0; p < b->NumParams(); p++)
		{
			TSTR pname = b->GetLocalName(p);
			pname.toLower();

			if (pname == pr)
				return b->GetStr(p, t);
		}
	}

	return "";
}

/*
=============================================================================
Mtl_GetColor
=============================================================================
*/
Point3 Mtl_GetColor(MtlBase* base, TSTR pr, TimeValue t)
{
	int i, p;
	Point3 c;

	for(i = 0; i < base->NumParamBlocks(); i++)
	{
		IParamBlock2* b = base->GetParamBlock(i);

		for(p = 0; p < b->NumParams(); p++)
		{
			TSTR pname = b->GetLocalName(p);
			pname.toLower();

			if (pname == pr)
				return b->GetPoint3(p, t);
		}
	}

	return c;
}

/*
=============================================================================
Mtl_GetTexmap
=============================================================================
*/

Texmap* Mtl_GetTexmap(MtlBase* base, TSTR pr, TimeValue t)
{
	int i, p;
	Texmap* tm = NULL;

	for(i = 0; i < base->NumParamBlocks(); i++)
	{
		IParamBlock2* b = base->GetParamBlock(i);

		for(p = 0; p < b->NumParams(); p++)
		{
			TSTR pname = b->GetLocalName(p);
			pname.toLower();

			if (pname == pr)
				return b->GetTexmap(p, t);
		}
	}
	return tm;
}


TSTR Obj_GetStr(Object* base, TSTR pr, TimeValue t)
{

}



void LuxMax::CheckMaterialSlot(INode* n)
{
	int i, c;

	TSTR mnode = "MNode";
	TSTR nname = n->GetName();

	if (nname == mnode)
		isMaterialSlot = TRUE;

	c = n->NumberOfChildren();

	for (i = 0; i < c; i++)
		CheckMaterialSlot(n->GetChildNode(i));
}

void CommaScan(TCHAR* buf)
{
    for(; *buf; buf++) if (*buf == ',') *buf = '.';
}

TSTR Format(float value)
{
	TCHAR buf[40];
	
	sprintf(buf, "%f", value);
	CommaScan(buf);
	return TSTR(buf);
}
