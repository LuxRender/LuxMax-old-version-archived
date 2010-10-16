#include "LuxMax.h"
#include <stdmat.h>

/*
=============================================================================
WriteScaleTexture

Write a scale texture map to the output file
=============================================================================
*/
void LuxMax::WriteScaleTexture(Texmap* tex, TSTR type)
{
	// Texture "Material.002::dispmap.scale" "float" "scale" "texture tex1" ["Material.002::dispmap"] "float tex2" [0.1]
	TSTR pr0 = "color";
	TSTR pr1 = "texture1";
	TSTR pr2 = "texture2";

	Point3 val0;

	val0 = Mtl_GetColor((MtlBase*)tex, pr0, 0);

	if (!val0)
		val0 = Point3(1, 1, 1);

	fprintf(s_pStream, "Texture \"%s\" \"%s\" \"constant\" \"color value\" [%s %s %s]\n", tex->GetName(), type, Format(val0.x), Format(val0.y), Format(val0.z));
}

/*
=============================================================================
WriteConstantTexture

Write a constant texture map to the output file
=============================================================================
*/
void LuxMax::WriteConstantTexture(Texmap* tex, TSTR type)
{
	TSTR pr0 = "color";

	Point3 val0;

	val0 = Mtl_GetColor((MtlBase*)tex, pr0, 0);

	if (!val0)
		val0 = Point3(1, 1, 1);

	fprintf(s_pStream, "Texture \"%s\" \"%s\" \"constant\" \"color value\" [%s %s %s]\n", tex->GetName(), type, Format(val0.x), Format(val0.y), Format(val0.z));
}

/*
=============================================================================
WriteCheckerBoardTexture

Write a checkerboard texture map to the output file
=============================================================================
*/
void LuxMax::WriteCheckerBoardTexture(Texmap* tex, TSTR type)
{
	TSTR pr0 = "color1";
	TSTR pr1 = "color2";
	TSTR pr2 = "uscale";
	TSTR pr3 = "vscale";

	Point3 val0;
	Point3 val1;
	float val2;
	float val3;

	val0 = Mtl_GetColor((MtlBase*)tex, pr0, 0);
	val1 = Mtl_GetColor((MtlBase*)tex, pr1, 0);
	val2 = Mtl_GetFloat((MtlBase*)tex, pr2, 0);
	val3 = Mtl_GetFloat((MtlBase*)tex, pr3, 0);


	fprintf(s_pStream, "Texture \"%s\" \"%s\" \"checkerboard\" \"color tex1\" [%s %s %s] \"color tex2\" [%s %s %s]\n", tex->GetName(), type, Format(val0.x), Format(val0.y), Format(val0.z), Format(val1.x), Format(val1.y), Format(val1.z));
	fprintf(s_pStream, "\"float uscale\"  [%s] \"float vscale\" [%s]\n", Format(val2), Format(val3));
}

/*
=============================================================================
WriteImageMapTexture

Write a ImageMap texture map to the output file
=============================================================================
*/
void LuxMax::WriteImageMapTexture(Texmap* tex, TSTR type)
{
	int len = 0;
	/*tex->gettex(ID_DI);
		BitmapTex *bmt = (BitmapTex *) tex;
		MCHAR* diffname = bmt->GetMapName();
		fprintf(s_pStream, "#BitmapName:  [%s] \n", diffname);
	*/
	
	TSTR pr0 = "filename";
	TSTR pr1 = "wrap";
	TSTR pr2 = "uv";
	TSTR pr3 = "uscale";
	TSTR pr4 = "vscale";
	TSTR pr5 = "udelta";
	TSTR pr6 = "vdelta";

	TSTR val0;
	int val1;
	//int val2;
	float val3;
	float val4;
	//float val5;
	//float val6;

	val0 = Mtl_GetStr((MtlBase*)tex, pr0, 0);
	val1 = Mtl_GetInt((MtlBase*)tex, pr1, 0);
	val3 = Mtl_GetFloat((MtlBase*)tex, pr3, 0);
	val4 = Mtl_GetFloat((MtlBase*)tex, pr4, 0);

	TSTR wrap[3] = {"repeat", "black", "clamp"};
	TSTR uv[4] = {"UV", "Spherical", "Cylindrical", "Planar"};

	fprintf(s_pStream, "Texture \"%s\" \"%s\" \"imagemap\" \"string wrap\" [\"%s\"] \"string filename\" [\"%s\"]\n", tex->GetName(), type, wrap[(val1 - 1)], val0);
	fprintf(s_pStream, "\"float uscale\"  [%s] \"float vscale\" [%s]\n", Format(val3), Format(val4));
}



void LuxMax::WriteLampSpectrumTexture(Texmap* tex, TSTR type)
{
TSTR pr0 = "spectrumnamestring";
TSTR val0;
val0 = Mtl_GetStr((MtlBase*)tex, pr0, 0);
//    Texture "MyLamp" "color" "lampspectrum" "string name" ["Zn"] 
fprintf(s_pStream, "Texture \"%s\" \"color\" \"lampspectrum\" \"string name\" [\"%s\"]\n",tex->GetName(), val0);

}

/*
=============================================================================
WriteTexture

Find the right LuxRender texture for the Texmap classid
=============================================================================
*/
void LuxMax::WriteTexture(Texmap* tex, TSTR type)
{
	if (tex == NULL)
		return;

	if (tex->ClassID() == LUXRENDER_CONSTANTTEXTURE_ID)
	{
		WriteConstantTexture(tex, type);
	}
	else if (tex->ClassID() == LUXRENDER_CHECKERBOARDTEXTURE_ID)
	{
		WriteCheckerBoardTexture(tex, type);
	}
	else if (tex->ClassID() == LUXRENDER_IMAGEMAPTEXTURE_ID)
	{
		WriteImageMapTexture(tex, type);
	}
	else if(tex->ClassID()== LUXRENDER_LAMPSPECTRUM_ID)
	{
		WriteLampSpectrumTexture(tex,type);
	}

	else
	{
		WriteConstantTexture(tex, type);
	}
}