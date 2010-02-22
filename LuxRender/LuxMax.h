#pragma once

#include "Max.h"
#include "istdplug.h"
#include "iparamb2.h"
#include "iparamm2.h"
#include "render.h"
#include "Common.h"
#include "ITabDialog.h"

#define LUXRENDER_CLASS_ID Class_ID(0x4846f675, 0x50f35930)

// Material types
#define LUXRENDER_LIGHTMATERIAL_ID Class_ID(0x23131fb9, 0x5134a570)
#define LUXRENDER_MATTEMATERIAL_ID Class_ID(0x61108483, 0x4d218a72)
#define LUXRENDER_GLOSSYMATERIAL_ID Class_ID(0xfe1ebdc, 0x3b7b37e6)
#define LUXRENDER_GLASSMATERIAL_ID Class_ID(0x1416e9d, 0x5f7312b0)
#define LUXRENDER_ROUGHGLASSMATERIAL_ID Class_ID(0x24fa894, 0x727a5aca)
#define LUXRENDER_METALMATERIAL_ID Class_ID(0x26705ce9, 0x4c088767)
#define LUXRENDER_NULLMATERIAL_ID Class_ID(0x128af87a, 0x6e0169dc)
#define LUXRENDER_CARPAINTMATERIAL_ID Class_ID(0x4d900917, 0x6546d259)
#define LUXRENDER_PORTALMATERIAL_ID Class_ID(0x6b0906a2, 0x159a3fc0)

// Texture map types
#define LUXRENDER_CONSTANTTEXTURE_ID Class_ID(0x251e0d83, 0x7d6a5c67)
#define LUXRENDER_CHECKERBOARDTEXTURE_ID Class_ID(0x6be51c96, 0x5fe65d5e)
#define LUXRENDER_IMAGEMAPTEXTURE_ID Class_ID(0x1bbf1b50, 0x39e50806)
#define LUXRENDER_BLACKBODY_ID Class_ID(0x48d3ea0a, 0x760c9178)

// Camera types
#define LUXRENDER_FREECAMERA_ID Class_ID(0x3465725b, 0x7a7b54a6)
#define LUXRENDER_TARGETCAMERA_ID Class_ID(0x3465725b, 0x7a7b54a6)

// UI Tabs
#define LUXRENDER_LUXRENDER_ID Class_ID(0x28e30337, 0x2b1f3b6c)
#define LUXRENDER_LUXSYSTEM_ID Class_ID(0x22910308, 0x57825ba6)
#define LUXRENDER_LUXOUTPUT_ID Class_ID(0x4b8f0b9b, 0x36de4710)
#define LUXRENDER_LUXCAMENV_ID Class_ID(0x6c253ce3, 0x4b742b51)

class LuxMaxDefaultLight
{
public:
	LuxMaxDefaultLight(DefaultLight* l);

	bool bViewOriented;

	LightType Type;
	Point3 Color;
	Matrix3 Transform;

	Matrix3 lightToWorld;
	Matrix3 worldToLight;
};

class LuxMax : public Renderer, public ITabDialogObject
{
public:

	// Plug-in stuff
	Class_ID ClassID() {return LUXRENDER_CLASS_ID;}		
	void GetClassName(TSTR& s) {s = _T("Luxrender");}

	// Renderer required
	LuxMax() { file = NULL; n_sceneRoot = NULL; p_camera = NULL; useDefaultLights = TRUE; selectedpreset = 0; isMaterialSlot = FALSE;}

	int Open(INode *scene, INode *vnode, ViewParams *viewPar, RendParams &rp, HWND hwnd, DefaultLight* defaultLights, int numDefLights, RendProgressCallback* prog);
	int Render(TimeValue t, Bitmap *tobm, FrameRendParams &frp, HWND hwnd, RendProgressCallback *prog, ViewParams *viewPar);
	void Close(	HWND hwnd, RendProgressCallback* prog) {}
	RendParamDlg *CreateParamDialog(IRendParams *ir, BOOL prog);
	void ResetParams() {};

	// UI

    using Renderer::GetInterface;
	BaseInterface* GetInterface ( Interface_ID id );
	virtual void AddTabToDialog ( ITabbedDialog* dialog, ITabDialogPluginTab* tab );
	virtual int AcceptTab ( ITabDialogPluginTab* tab );

	// Renderparams
	
	INode* n_sceneRoot;
	INode* p_camera;

	Matrix3 m3_camera;
	short projection;

	float FOV;
	int width;
	int height;

	TSTR FileName;
	FILE *file;
	
	ViewParams	view; // View parameters

	void noValidLightSources(INode* p_node);

	int selectedpreset;

	// 3dsmax lights

	Tab<LuxMaxDefaultLight *> deflights;

	//DefaultLight* defLights;
	int n_defLights;
	bool useDefaultLights;

	void WritePointLight(INode* p_node);
	void WriteSpotLight(INode* p_node);
	void WriteDirectLight(INode* p_node);
	void WriteLights(INode* p_node);
	void WriteSunSky(INode* n);

	// Lxs output functions
	static FILE* s_pStream;
	int WriteScene();

	void CheckMaterialSlot(INode* root);
	bool isMaterialSlot;
	void WriteMaterials(INode* p_node);

	void WriteCamera();
	void WriteDefaultLights();

	void WriteMeshesProc(INode* root);

	void WriteLightMaterial(INode* p_node);
	void WriteMatteMaterial(INode* p_node);
	void WriteGlossyMaterial(INode* p_node);
	void WriteGlassMaterial(INode* p_node);
	void WriteRoughGlassMaterial(INode* p_node);
	void WriteMetalMaterial(INode* p_node);
	void WriteNullMaterial(INode* p_node);
	void WriteCarPaintMaterial(INode* p_node);
	void WriteWireColorMaterial(INode* p_node);

	void WritePortals(INode* p_node);

	void WriteTexture(Texmap* tex, TSTR type);

	void WriteConstantTexture(Texmap* tex, TSTR type);
	void WriteCheckerBoardTexture(Texmap* tex, TSTR type);
	void WriteImageMapTexture(Texmap* tex, TSTR type);
	void WriteScaleTexture(Texmap* tex, TSTR type);

	// IO
	IOResult Save(ISave *isave);
	IOResult Load(ILoad *iload);

	// Remove comma from floats
	//void CommaScan(TCHAR* buf);
	//TSTR Format(float value);

private:
	RefResult NotifyRefChanged(	Interval changeInt, RefTargetHandle hTarget, PartID& partID, RefMessage message );
};

class LuxMaxClassDesc : public ClassDesc2 
{
public:
	int				IsPublic() 						{ return TRUE; }
	void*			Create(BOOL loading = FALSE)	{ return new LuxMax(); }
	const TCHAR *	ClassName() 					{ return _T("Luxrender"); }
	SClass_ID		SuperClassID() 					{ return RENDERER_CLASS_ID; }
	Class_ID		ClassID() 						{ return LUXRENDER_CLASS_ID; }
	const TCHAR*	Category() 						{ return _T("Luxrender"); }
	const TCHAR*	InternalName() 					{ return _T("Luxrender"); }
	HINSTANCE		HInstance() 					{ return hInstance; }
};

