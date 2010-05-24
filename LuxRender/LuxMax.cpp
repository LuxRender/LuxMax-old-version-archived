#include "windows.h"
#include "LuxMax.h"
#include "Math.h"
#include "LuxParams.h"
#include "LuxPresets.h"
//#include "util.h"
#include "utilapi.h"
#include "istdplug.h"
#include "modstack.h"
#include "stdmat.h"
#include "bmmlib.h"
#include "SetKeyMode.h"
#include "iparamb2.h"
#include "AssetManagement/iassetmanager.h"
#include "maxscrpt/maxscrpt.h"
#include <iostream>
#include <string>
#include <iostream>
#include <Path.h> 
//#include "AssetType.h"
#include "IFileResolutionManager.h"
#include "render.h"

using namespace MaxSDK::AssetManagement;



static LuxMaxClassDesc LuxMaxDesc;
ClassDesc2* GetLuxMaxDesc() { return &LuxMaxDesc; }
FILE* LuxMax::s_pStream = NULL;

RefResult LuxMax::NotifyRefChanged( Interval changeInt, RefTargetHandle hTarget, PartID& partID, RefMessage message) 
{
	return (REF_SUCCEED);
}

LuxMaxDefaultLight::LuxMaxDefaultLight(DefaultLight* l)
{
	Type = l->ls.type;
	Transform = l->ls.tm;
	Color = Point3(l->ls.color.r, l->ls.color.g, l->ls.color.b);

	bViewOriented = true;

	for (int i=0; i<4; i++)
	{
		Point3 p = l->tm.GetRow(i);
		if (p.x != 0 || p.y != 0 || p.z != 0)
			bViewOriented = false;
	}

	if (!bViewOriented)
	{
		lightToWorld = l->tm;
		worldToLight = Inverse(lightToWorld);
	}
}

int LuxMax::Open(INode *scene, INode *vnode, ViewParams *viewPar, RendParams &rp, HWND hwnd, DefaultLight* defaultLights, int numDefLights, RendProgressCallback* prog)
{
	int i;
	
	deflights.ZeroCount();
	deflights.Shrink();

	if (_tcslen(FileName)==0) return 0;

	n_sceneRoot = scene;
	p_camera = vnode; 
	view = *viewPar;

	width = rp.width;
	height = rp.height;
	n_defLights = numDefLights;

	if (deflights.Count() == 0 && defaultLights)
	{
		for (i = 0; i < numDefLights; i++) {
			LuxMaxDefaultLight* l = new LuxMaxDefaultLight(&defaultLights[i]);
			deflights.Append(1, &l);
		}
	}

	return 1;
}

int LuxMax::Render(TimeValue t, Bitmap *tobm, FrameRendParams &frp, HWND hwnd, RendProgressCallback *prog, ViewParams *viewPar)
{
	tobm->UnDisplay();
	prog->Progress(0,100);
	prog->SetTitle("Starting export..");
	tobm->SetWindowTitle("LuxRender rendered to lxs file.");
tobm->UnDisplay();
		if (p_camera)
	{
		const ObjectState& os = p_camera->EvalWorldState(t);

		switch (os.obj->SuperClassID())
		{
			case CAMERA_CLASS_ID:
				{
					CameraState cs;
					CameraObject* cam = (CameraObject*) p_camera->EvalWorldState(0).obj;
					m3_camera = p_camera->GetNodeTM(t);

					FOV = cam->GetFOV(t) * 360 / ( 2*PI );
					prog->SetTitle("Getting FOV from camera.");
					prog->Progress(5,100);
					break;
				}
		}
	}

	if (n_sceneRoot)
	{
		prog->Progress(10,100);
		prog->SetTitle("Checking materials..");

		isMaterialSlot = FALSE;

		CheckMaterialSlot(n_sceneRoot);

		if (isMaterialSlot)
			return 0;
	}
	
	// Write LXS

	// Export to
	TSTR _Path, _Filename, _Extention;
	TCHAR f[MAX_PATH];
	SplitFilename(FileName, &_Path, &_Filename, &_Extention);

	sprintf(f,  "%s\\%s%s",  (char*)_Path, (char*)_Filename, (char*)_Extention);

	if ((s_pStream = fopen(f, "w")) == NULL)
		return 0;

	prog->Progress(20,100);
	prog->SetTitle("Exporting models..");
	
	if (!WriteScene())
	{
		prog->Progress(70,100);
		prog->SetTitle("Done exporting models..");
		
		fclose(s_pStream);
		return 0;
	}

	fclose(s_pStream);
	prog->Progress(100,100);
	prog->SetTitle("Done exporting..");
	return 0;
}
   


int LuxMax::WriteScene()
{
GenCamera* cam;// = GenCamera();

Interface* ip = GetCOREInterface();


	time_t aclock;
	time(&aclock); // get time in seconds
	char username[20];
	DWORD nUserName = sizeof(username);

	// Write header
	fprintf(s_pStream, "# LuxMax, Autodesk 3dsmax exporter for LuxRender\n");

	if (GetUserName(username, &nUserName))

		fprintf(s_pStream, "# Author: %s\n", username);
	else
		fprintf(s_pStream, "Author: unknown\n");
	
	fprintf(s_pStream, "# Date: %s\n", asctime(localtime(&aclock)));

	// Camera
	if (!p_camera)
	{
		MessageBox(ip->GetMAXHWnd(),"Please Create a LuxCamera!",_T("ERROR!"),MB_ICONINFORMATION);
		return 0;
		
	}
	WriteCamera();

	// Image format

	fprintf(s_pStream, "Film \"fleximage\" \"integer xresolution\" [%i] \"integer yresolution\" [%i]\n", width, height);


	// Insert preset
	if (selectedpreset == 0)
	{
		// Preview default
	}
	else if (selectedpreset == 1)
		fprintf(s_pStream, "%s", PRESET_PREVIEW());
	else if (selectedpreset == 2)
		fprintf(s_pStream, "%s", PRESET_FINAL_INTERIOR());
	else if (selectedpreset == 3)
		fprintf(s_pStream, "%s", PRESET_FINAL_EXTERIOR());

	// World

	fprintf(s_pStream, "\nWorldBegin\n\n");



//environment map begin

	//Enviroment map

	fprintf(s_pStream, "\n# Enviromentmap goes here\n");
fprintf(s_pStream, "AttributeBegin \n");
fprintf(s_pStream, "LightGroup \"environment\" \n");
fprintf(s_pStream, "LightSource \"infinite\" \n");
fprintf(s_pStream, "\"string mapping\" [\"angular\"] \n");
//--------------------------------------------------------------------------------------------------------------------

Interface* ip2 = GetCOREInterface7();
	Interface* ip8 = GetCOREInterface8();
	Interface* ip9 = GetCOREInterface9();
	
//Interface* ip = GetCOREInterface();
	Texmap* texmap;

	FilterList* filterlist;
	BitmapManager* bmgr ;//= BitmapManager();
	BitmapFileInputDialog* bfdlg;

	BOOL two;
   float utile, vtile , ang;
   MCHAR* name;
   MSTR name2;
   TSTR buf;


		std::string temp2 = "";

	 Texmap *tmap; // = ip2->GetEnvironmentMap(); //m->GetSubTexmap(ID_DI);
	 if (ip2->GetUseEnvironmentMap())
	 {
		if (tmap = ip2->GetEnvironmentMap())
		{
		if (tmap->ClassID() == Class_ID(BMTEX_CLASS_ID, 0))
		{
		
		BitmapTex *bmt = (BitmapTex*) tmap;
		  StdUVGen *uv = bmt->GetUVGen();
		  
		INT32	envRadians = uv->GetAng(0);
		INT32 envuang = uv->GetUAng(0);
		float vang = uv->GetVAng(0);
		INT32 axis = uv->GetAxis();
		
		fprintf(s_pStream, "#\"Env radian\" [\"%i\"] \n", envRadians);
		fprintf(s_pStream, "#\"Env uang\" [\"%i\"] \n", envuang);
		fprintf(s_pStream, "#\"Env vang\" [\"%f\"] \n", vang);
		fprintf(s_pStream, "#\"Env axis\" [\"%i\"] \n", axis);

		name = bmt->GetMapName();
			
		std::string namestring = std::string(name);
		MaxSDK::Util::Path path(_M(name));
		std::string filePath = path.GetString();

		for (int i = 0; i < filePath.length(); ++i)
			if (filePath[i] == '\\')
			{
				filePath.insert(i, 1, '\\');	
				++i; // Skip inserted char
			}
		fprintf(s_pStream, "\"string mapname\" [\"%s\"] \n", filePath.data());	
	}
 }
}
else
{

}

fprintf(s_pStream, " \n\n");
fprintf(s_pStream, "\"float gamma\" [1.000000] \n");
fprintf(s_pStream, "\"float gain\" [1.000000] \n");
fprintf(s_pStream, "AttributeEnd \n\n");

	//environment map end

	useDefaultLights = TRUE;
	noValidLightSources(n_sceneRoot);

	if (n_defLights > 0 && useDefaultLights)
		WriteDefaultLights();

	WriteLights(n_sceneRoot);
	WriteMeshesProc(n_sceneRoot);

	fprintf(s_pStream, "\nWorldEnd\n");
	
	return 1;
}

IOResult LuxMax::Save(ISave *isave)
{
	ULONG nb;

	if (_tcslen(FileName)>0)
	{	
		isave->BeginChunk(LXS_FILENAME_CHUNKID);
		isave->WriteWString(FileName);
		isave->EndChunk();
	}

	isave->BeginChunk(LXS_PRESET_CHUNKID);
	isave->Write(&selectedpreset, sizeof(int), &nb);
	isave->EndChunk();

	return IO_OK;
}



IOResult LuxMax::Load(ILoad *iload)
{
	int id;
	TCHAR *buf;
	IOResult res;
	ULONG nb;

	while (IO_OK==(res=iload->OpenChunk()))
	{
		Interface* ip = GetCOREInterface();
		//MessageBox(ip->GetMAXHWnd(),"Loading Luxmax plugin..",_T("info"),MB_ICONINFORMATION);

//------------create menu...-----
// http://area.autodesk.com/forum/autodesk-3ds-max/sdk/how-to-create-menu-with-the-sdk/	

//------------create menu...-----

		switch(id = iload->CurChunkID())
		{
			case LXS_FILENAME_CHUNKID:	
				if (IO_OK == iload->ReadWStringChunk(&buf)) 
					FileName = buf;
				break;
			case LXS_PRESET_CHUNKID:
				res = iload->Read(&selectedpreset, sizeof(int), &nb);
				break;
		}
		iload->CloseChunk();
		if (res!=IO_OK) 
			return res;
	}
	return IO_OK;
}