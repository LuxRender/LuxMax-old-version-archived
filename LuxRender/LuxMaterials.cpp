#include "LuxMax.h"

class LuxMaxMaterial
{
public:
	
	Mtl* material;
	TSTR name;
	TSTR type;

	TSTR* params;

	static void WriteBumpmap(FILE* s_pStream, Mtl* p_material);
};

void LuxMaxMaterial::WriteBumpmap(FILE* s_pStream, Mtl* p_material)
{
	int	var0;
	float var1;
	Texmap*	var2 = NULL;

	TSTR pr0 = "usebumpmap";
	TSTR pr1 = "bumpmap";
	TSTR pr2 = "bumpmaptexture";

	var0 = Mtl_GetInt((MtlBase*)p_material, pr0, 0);
	var1 = Mtl_GetFloat((MtlBase*)p_material, pr1, 0);
	var2 = Mtl_GetTexmap((MtlBase*)p_material, pr2, 0);

	// Bumpmap
	if (var0)
	{
		if (var2)
			fprintf(s_pStream, "\"texture bumpmap\" [\"%s\"]\n", var2->GetName());
		else
			fprintf(s_pStream, "\"float bumpmap\" [%s]\n", Format(var1));
	}
}

/*
=============================================================================
WriteLightMaterial


=============================================================================
*/

void LuxMax::WriteLightMaterial(INode* p_node)
{
	TSTR pr0 = "arealightsourcemap";
	TSTR pr1 = "temperature";
	TSTR pr2 = "power";
	TSTR pr3 = "efficacy";
	TSTR pr4 = "gain";
	TSTR pr5 = "group";

	float val0;
	float val1;
	float val2;
	float val3;

	TSTR val4 = "default";

	Texmap* tex0 = NULL;

	Mtl* m = p_node->GetMtl();

	tex0 = Mtl_GetTexmap((MtlBase*)m, pr0, 0);

	if (!tex0)
		return;

	if (tex0->ClassID() == LUXRENDER_BLACKBODY_ID)
	{
		val0 = Mtl_GetFloat((MtlBase*)tex0, pr1, 0);
		val1 = Mtl_GetFloat((MtlBase*)tex0, pr2, 0);
		val2 = Mtl_GetFloat((MtlBase*)tex0, pr3, 0);
		val3 = Mtl_GetFloat((MtlBase*)tex0, pr4, 0);

		val4 = Mtl_GetStr((MtlBase*)tex0, pr5, 0);

		// TODO: Do not hardcode the texture name
		fprintf(s_pStream, "LightGroup \"%s\"\n", val4);
		fprintf(s_pStream, "Texture \"area:light\" \"color\" \"blackbody\" \"float temperature\" [%s]\n", Format(val0));
		fprintf(s_pStream, "AreaLightSource \"area\" \"texture L\" [\"area:light\"]\n");

		fprintf(s_pStream, "\"float power\" [%s]\n", Format(val1));
		fprintf(s_pStream, "\"float efficacy\" [%s]\n", Format(val2));
		fprintf(s_pStream, "\"float gain\" [%s]\n", Format(val3));
	}
}

/*
=============================================================================
WriteMatteMaterial


=============================================================================
*/

void LuxMax::WriteMatteMaterial(INode* p_node)
{
	TSTR pr0 = "kdcolor";
	TSTR pr1 = "kdtexture";
	TSTR pr2 = "usesigma";
	TSTR pr3 = "sigma";
	TSTR pr4 = "sigmatexture";
	TSTR pr5 = "usebumpmap";
	TSTR pr6 = "bumpmap";
	TSTR pr7 = "bumpmaptexture";
	TSTR pr8 = "emission";
	TSTR pr9 = "emissiontexture";

	TSTR pr10 = "usetranslucency";
	TSTR pr11 = "krcolor";
	TSTR pr12 = "krtexture";
	TSTR pr13 = "ktcolor";
	TSTR pr14 = "kttexture";

	Point3	var0;
	Texmap*	var1 = NULL;
	int	var2;
	float	var3;
	Texmap*	var4 = NULL;
	int	var5;
	float	var6;
	Texmap*	var7 = NULL;
	int	var8;
	Texmap*	var9 = NULL;

	int	var10;
	Point3	var11;
	Texmap*	var12 = NULL;
	Point3	var13;
	Texmap*	var14 = NULL;

	Mtl* m = p_node->GetMtl();

	var0 = Mtl_GetColor((MtlBase*)m, pr0, 0);
	var1 = Mtl_GetTexmap((MtlBase*)m, pr1, 0);
	var2 = Mtl_GetInt((MtlBase*)m, pr2, 0);
	var3 = Mtl_GetFloat((MtlBase*)m, pr3, 0);
	var4 = Mtl_GetTexmap((MtlBase*)m, pr4, 0);
	var5 = Mtl_GetInt((MtlBase*)m, pr5, 0);
	var6 = Mtl_GetFloat((MtlBase*)m, pr6, 0);
	var7 = Mtl_GetTexmap((MtlBase*)m, pr7, 0);
	var8 = Mtl_GetInt((MtlBase*)m, pr8, 0);
	var9 = Mtl_GetTexmap((MtlBase*)m, pr9, 0);

	var10 = Mtl_GetInt((MtlBase*)m, pr10, 0);
	var11 = Mtl_GetColor((MtlBase*)m, pr11, 0);
	var12 = Mtl_GetTexmap((MtlBase*)m, pr12, 0);
	var13 = Mtl_GetColor((MtlBase*)m, pr13, 0);
	var14 = Mtl_GetTexmap((MtlBase*)m, pr14, 0);

	if (var1)
		WriteTexture(var1, "color");

	if (var2 == 1)
		WriteTexture(var4, "float");

	if (var5 == 1)
		WriteTexture(var7, "float");

	// Matte Diffuse

	if (!var10)
	{
		if (var1)
			fprintf(s_pStream, "Material \"matte\" \"texture Kd\" [\"%s\"]\n", var1->GetName());
		else
			fprintf(s_pStream, "Material \"matte\" \"color Kd\" [%s %s %s]\n", Format(var0.x), Format(var0.y), Format(var0.z));
	}
	else
	{
		if (var12)
			fprintf(s_pStream, "Material \"mattetranslucent\" \"texture Kr\" [\"%s\"]\n", var12->GetName());
		else
			fprintf(s_pStream, "Material \"mattetranslucent\" \"color Kr\" [%s %s %s]\n", Format(var11.x), Format(var11.y), Format(var11.z));
		if (var14)
			fprintf(s_pStream, "\"texture Kt\" [\"%s\"]\n", var14->GetName());
		else
			fprintf(s_pStream, "\"color Kt\" [%s %s %s]\n", Format(var13.x), Format(var13.y), Format(var13.z));
	}
	// Oren-Nayar
	if (var2)
	{
		if (var4)
			fprintf(s_pStream, "\"texture sigma\" [\"%s\"]\n", var4->GetName());
		else
			fprintf(s_pStream, "\"float sigma\" [%s]\n", Format(var3));
	}

	LuxMaxMaterial::WriteBumpmap(s_pStream, m);
}

/*
=============================================================================
WriteGlossyMaterial



=============================================================================
*/

void LuxMax::WriteGlossyMaterial(INode* p_node)
{
	TSTR pr0 = "kdcolor";
	TSTR pr1 = "kdtexture";
	TSTR pr2 = "kscolor";
	TSTR pr3 = "kstexture";
	TSTR pr4 = "useka";
	TSTR pr5 = "kacolor";
	TSTR pr6 = "katexture";
	TSTR pr7 = "useior";
	TSTR pr8 = "ior";
	TSTR pr9 = "iortexture";
	TSTR pr10 = "kadepth";

	Point3 Kd;
	Point3 Ks;
	Point3 Ka;
	float val8;
	float d;

	Texmap* tex0 = NULL;
	Texmap* tex1 = NULL;
	Texmap* tex2 = NULL;
	Texmap* tex3 = NULL;

	Mtl* m = p_node->GetMtl();

	Kd = Mtl_GetColor((MtlBase*)m, pr0, 0);
	tex0 = Mtl_GetTexmap((MtlBase*)m, pr1, 0);

	Ks = Mtl_GetColor((MtlBase*)m, pr2, 0);
	tex1 = Mtl_GetTexmap((MtlBase*)m, pr3, 0);

	Ka = Mtl_GetColor((MtlBase*)m, pr4, 0);
	tex2 = Mtl_GetTexmap((MtlBase*)m, pr5, 0);
	d = Mtl_GetFloat((MtlBase*)m, pr10, 0);

	int val4 = Mtl_GetInt((MtlBase*)m, pr4, 0);
	int val7 = Mtl_GetInt((MtlBase*)m, pr7, 0);

	val8 = Mtl_GetFloat((MtlBase*)m, pr8, 0);
	tex3 = Mtl_GetTexmap((MtlBase*)m, pr9, 0);

	if (tex0)
		WriteTexture(tex0, "color");
	if (tex1)
		WriteTexture(tex1, "color");
	if (tex2)
		WriteTexture(tex2, "float");
	if (tex3)
		WriteTexture(tex3, "float");

	fprintf(s_pStream, "Material \"glossy\" ");

	if (tex0)
		fprintf(s_pStream, " \"texture Kd\" [\"%s\"]\n", tex0->GetName());
	else
		fprintf(s_pStream, " \"color Kd\" [%s %s %s]\n", Format(Kd.x), Format(Kd.y), Format(Kd.z));

	if (!val7)
	{
		if (tex1)
			fprintf(s_pStream, " \"texture Ks\" [\"%s\"]\n", tex1->GetName());
		else
			fprintf(s_pStream, " \"color Ks\" [%s %s %s]\n", Format(Ks.x), Format(Ks.y), Format(Ks.z));
	}

	if (val4)
	{
		if (tex2)
			fprintf(s_pStream, " \"texture Ka\" [\"%s\"]\n", tex2->GetName());
		else
			fprintf(s_pStream, " \"color Ka\" [%s %s %s]\n", Format(Ka.x), Format(Ka.y), Format(Ka.z));

		fprintf(s_pStream, " \"float d\" [%s]\n", Format(d));
	}
	if (val7)
	{
		if (tex3)
			fprintf(s_pStream, " \"texture index\" [\"%s\"]\n", tex3->GetName());
		else
			fprintf(s_pStream, " \"float index\" [%s]\n", Format(val8));
	}
}

/*
=============================================================================
WriteGlassMaterial

=============================================================================
*/

void LuxMax::WriteGlassMaterial(INode* p_node)
{
	TSTR pr0 = "kt";
	TSTR pr1 = "kttexture";
	TSTR pr2 = "kr";
	TSTR pr3 = "krtexture";
	TSTR pr4 = "ior";
	TSTR pr5 = "iorActive";

	
	Point3 Kt;
	Point3 Kr;
	float val4;
	int	var5;
	
	Texmap* tex0 = NULL;
	Texmap* tex1 = NULL;

	Mtl* m = p_node->GetMtl();

	Kt = Mtl_GetColor((MtlBase*)m, pr0, 0);
	tex0 = Mtl_GetTexmap((MtlBase*)m, pr1, 0);

	Kr = Mtl_GetColor((MtlBase*)m, pr2, 0);
	tex1 = Mtl_GetTexmap((MtlBase*)m, pr3, 0);

	if (tex0)
		WriteTexture(tex0, "color");
	if (tex1)
		WriteTexture(tex1, "color");

	fprintf(s_pStream, "Material \"glass\"");

	if (tex0)
		fprintf(s_pStream, " \"texture Kt\" [\"%s\"]\n", tex0->GetName());
	else
		fprintf(s_pStream, " \"color Kr\" [%s %s %s]\n", Format(Kt.x), Format(Kt.y), Format(Kt.z));

	if (tex1)
		fprintf(s_pStream, " \"texture Kr\" [\"%s\"]\n", tex1->GetName());
	else//KT was KR
		fprintf(s_pStream, " \"color Kt\" [%s %s %s]\n", Format(Kr.x), Format(Kr.y), Format(Kr.z));

//	fprintf(s_pStream, " \"float index\" [1.500000]\n");
	val4 = Mtl_GetFloat((MtlBase*)m, pr4, 0);
	fprintf(s_pStream, " \"float index\" [%s]\n", Format(val4));
	
	var5 = Mtl_GetInt((MtlBase*)m, pr5, 0);
	//code for checkbox goes here..
	if (var5 == 1)
	{
		fprintf(s_pStream, " \"bool architectural\" [\"true\"]\n");
	}
	else
	{
		fprintf(s_pStream, " \"bool architectural\" [\"false\"]\n");
	}
}

/*
=============================================================================
WriteWireColorMaterial

Default material. Use object wirecolor as matte color value
=============================================================================
*/

void LuxMax::WriteWireColorMaterial(INode* p_node)
{
	DWORD Kd = p_node->GetWireColor();

	float r = (float)((int)GetRValue(Kd)) / 255.0f;
	float g = (float)((int)GetGValue(Kd)) / 255.0f;
	float b = (float)((int)GetBValue(Kd)) / 255.0f;

	fprintf(s_pStream, "Material \"matte\" \"color Kd\" [%s %s %s]\n", Format(r), Format(g), Format(b));
}



/*
=============================================================================
WriteMetalMaterial

=============================================================================
*/
void LuxMax::WriteMetalMaterial(INode* p_node)
{
	TSTR pr0 = "metalname";

	int val0;

	TSTR names[4] = {"aluminium", "amorphous carbon", "gold", "copper"};

	Mtl* m = p_node->GetMtl();

	val0 = Mtl_GetInt((MtlBase*)m, pr0, 0);

	fprintf(s_pStream, "Material \"metal\" \n");
	fprintf(s_pStream, "\t\"string name\" [\"%s\"]\n", names[val0 - 1]);
}

/*
=============================================================================
WriteEnviromentMap

=============================================================================
*/
void LuxMax::WriteEnviromentMaterial(INode* p_node){ fprintf(s_pStream, "test"); }

	//TSTR pr0 = "enviroment";

	//int val0;

	//TSTR names[4] = {"aluminium", "amorphous carbon", "gold", "copper"};

	//Mtl* m = "test"; //p_node->GetMtl();

	//val0 = Mtl_GetInt((MtlBase*)m, pr0, 0);


/*
=============================================================================
WriteCarPaintMaterial

=============================================================================
*/
void LuxMax::WriteCarPaintMaterial(INode* p_node)
{
	TSTR pr0 = "useka";
	TSTR pr1 = "kacolor";
	TSTR pr2 = "katexture";
	TSTR pr3 = "kadepth";
	TSTR pr4 = "paintname";

	int val0;
	Point3 val1;
	Texmap* val2;
	float val3;
	int val4;

	TSTR names[8] = {"blue matte", "blue", "white", "2k acrylack", "bmw339", "opel titan", "polaris silber", "ford f8"};

	Mtl* m = p_node->GetMtl();

	val0 = Mtl_GetInt((MtlBase*)m, pr0, 0);
	val1 = Mtl_GetColor((MtlBase*)m, pr1, 0);
	val2 = Mtl_GetTexmap((MtlBase*)m, pr2, 0);
	val3 = Mtl_GetFloat((MtlBase*)m, pr3, 0);
	val4 = Mtl_GetInt((MtlBase*)m, pr4, 0);

	fprintf(s_pStream, "Material \"carpaint\" \n");
	fprintf(s_pStream, "\t\"string name\" [\"%s\"]\n", names[val4 - 1]);

	if (val0)
	{
		if (val2)
			fprintf(s_pStream, "\t\"texture Ka\" [\"%s\"]\n", val2->GetName());
		else
			fprintf(s_pStream, "\t\"color Ka\" [%s %s %s]\n", Format(val1.x), Format(val1.y), Format(val1.z));

		fprintf(s_pStream, " \"float d\" [%s]\n", Format(val3));
	}
}


void LuxMax::WriteNullMaterial(INode* p_node){ fprintf(s_pStream, "Material \"null\" \n"); }
void LuxMax::WriteRoughGlassMaterial(INode* p_node){ fprintf(s_pStream, "Material \"roughglass\" \n"); }

void LuxMax::WriteMaterials(INode* p_node)
{
	Mtl *p_material = p_node->GetMtl();
	
	


	if (p_material)
	{
		if (p_material->ClassID() == LUXRENDER_LIGHTMATERIAL_ID)
			WriteLightMaterial(p_node);
		else if (p_material->ClassID() == LUXRENDER_MATTEMATERIAL_ID)
			WriteMatteMaterial(p_node);
		else if (p_material->ClassID() == LUXRENDER_GLOSSYMATERIAL_ID)
			WriteGlossyMaterial(p_node);
		else if (p_material->ClassID() == LUXRENDER_GLASSMATERIAL_ID)
			WriteGlassMaterial(p_node);
		else if (p_material->ClassID() == LUXRENDER_ROUGHGLASSMATERIAL_ID)
			WriteRoughGlassMaterial(p_node);
		else if (p_material->ClassID() == LUXRENDER_METALMATERIAL_ID)
			WriteMetalMaterial(p_node);
		else if (p_material->ClassID() == LUXRENDER_NULLMATERIAL_ID)
			WriteNullMaterial(p_node);
		else if (p_material->ClassID() == LUXRENDER_CARPAINTMATERIAL_ID)
			WriteCarPaintMaterial(p_node);
		else if (p_material->ClassID() == LUXRENDER_PORTALMATERIAL_ID)
		
			return;
		else

			fprintf(s_pStream, "Material \"matte\" \"color Kd\" [1 1 1]\n");
		
	}
	else
		WriteWireColorMaterial(p_node);
		
}