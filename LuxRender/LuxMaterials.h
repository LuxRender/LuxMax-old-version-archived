#include "LuxMax.h"

class LuxMaxMaterial
{
public:

	static LuxMaxMaterial* Materials;
	static void CollectMaterials();

	USHORT MaterialId;
	Class_ID ClassId;

	Mtl* Material;

	TSTR Name;
	TSTR Type;
};

class LuxMatte : public LuxMaxMaterial
{
public:

	Point3 GetKdColor() {return Mtl_GetColor((MtlBase*)Material, "kdcolor", 0);};
	Texmap* GetKdTexture() {return Mtl_GetTexmap((MtlBase*)Material, "kdtexture", 0);};

	int GetUseSigma() {return Mtl_GetInt((MtlBase*)Material, "usesigma", 0);};
	float GetSigma() {return Mtl_GetFloat((MtlBase*)Material, "sigma", 0);};
	Texmap* GetSigmaTexture() {return Mtl_GetTexmap((MtlBase*)Material, "sigmatexture", 0);};

	int GetUseBumpmap() {return Mtl_GetInt((MtlBase*)Material, "usebumpmap", 0);};
	float GetBumpmap() {return Mtl_GetFloat((MtlBase*)Material, "bumpmap", 0);};
	Texmap* GetBumpmapTexture() {return Mtl_GetTexmap((MtlBase*)Material, "bumpmaptexture", 0);};

	void WriteTextureProc();
};

class LuxMatteTranslucent : public LuxMaxMaterial
{
public:

	int GetUseTranslucency() {return Mtl_GetInt((MtlBase*)Material, "usetranslucency", 0);};
	Point3 GetKrColor() {return Mtl_GetColor((MtlBase*)Material, "krcolor", 0);};
	Texmap* GetKrTexture() {return Mtl_GetTexmap((MtlBase*)Material, "krtexture", 0);};
	Point3 GetKtColor() {return Mtl_GetColor((MtlBase*)Material, "ktcolor", 0);};
	Texmap* GetKtTexture() {return Mtl_GetTexmap((MtlBase*)Material, "kttexture", 0);};

	int GetUseSigma() {return Mtl_GetInt((MtlBase*)Material, "usesigma", 0);};
	float GetSigma() {return Mtl_GetFloat((MtlBase*)Material, "sigma", 0);};
	Texmap* GetSigmaTexture() {return Mtl_GetTexmap((MtlBase*)Material, "sigmatexture", 0);};

	int GetUseBumpmap() {return Mtl_GetInt((MtlBase*)Material, "usebumpmap", 0);};
	float GetBumpmap() {return Mtl_GetFloat((MtlBase*)Material, "bumpmap", 0);};
	Texmap* GetBumpmapTexture() {return Mtl_GetTexmap((MtlBase*)Material, "bumpmaptexture", 0);};
};