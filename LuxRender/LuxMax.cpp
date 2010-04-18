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

using namespace MaxSDK::AssetManagement;



static LuxMaxClassDesc LuxMaxDesc;
ClassDesc2* GetLuxMaxDesc() { return &LuxMaxDesc; }
FILE* LuxMax::s_pStream = NULL;

RefResult LuxMax::NotifyRefChanged( Interval changeInt, RefTargetHandle hTarget, PartID& partID, RefMessage message) 
{
	return (REF_SUCCEED);
}

//RendParamDlg* LuxMax::CreateParamDialog(IRendParams *ir, BOOL prog)
//{
//	return 0;
//}

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

	//close
	//for (idx=0; idx<lightTab.Count(); idx++) {
	//delete lightTab[idx];
	//}
	//lightTab.ZeroCount();
	//lightTab.Shrink();

	// Setup Scene

	if (_tcslen(FileName)==0) return 0;

	n_sceneRoot = scene;
	p_camera = vnode; 
	view = *viewPar;

	width = rp.width;
	height = rp.height;

	//defLights = defaultLights;
	n_defLights = numDefLights;

	if (deflights.Count() == 0 && defaultLights)
	{
		for (i = 0; i < numDefLights; i++) {
			LuxMaxDefaultLight* l = new LuxMaxDefaultLight(&defaultLights[i]);
			deflights.Append(1, &l);
		}
	}

	//RP = rp;	
	//vuefile = NULL;
	//if (_tcslen(vueFileName)==0) return 0;
	//if (FileExists(vueFileName)) {
	//	TSTR buf;
	//	buf.printf(GetString(IDS_FILE_ALREADY_EXISTS),vueFileName);
	//	int ret = MessageBox(NULL, buf, GetString(IDS_VRENDTITLE), MB_YESNO|MB_ICONEXCLAMATION|MB_TASKMODAL);
	//	if (ret!=IDYES)  return 0;  
	//	}
	//vuefile =(FILE *)fopen(vueFileName,"w");
	//if (vuefile==0) {
	//	TSTR buf;
	//	buf.printf(GetString(IDS_CANT_OPEN),vueFileName);
	//	MessageBox(NULL, buf, GetString(IDS_RENDER_ERR), MB_OK|MB_ICONEXCLAMATION|MB_TASKMODAL);
	//	return(0);
	//	}

	return 1;
}

int LuxMax::Render(TimeValue t, Bitmap *tobm, FrameRendParams &frp, HWND hwnd, RendProgressCallback *prog, ViewParams *viewPar)
{
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
					break;
				}
		}
	}
	//else
	//{
	//	/*Matrix3 worldToCam = view.affineTM;
	//	m3_camera = Inverse(worldToCam);

	//	FOV = (view.fov * 360 / ( 2*PI ));
	//	
	//	projection = view.projType;
	//	std::cout << ("Projection: " + projection);*/
	//	Interface *ip;
	//	MessageBox(ip->GetMAXHWnd(),"Please Create a LuxCamera!",_T("info"),MB_ICONINFORMATION);
	//	end;
	//	return 1;
	//}

	// Check if we are rendering a material

	if (n_sceneRoot)
	{
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

	if (!WriteScene())
	{
		fclose(s_pStream);
		return 0;
	}

	fclose(s_pStream);

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
//fprintf(s_pStream, "\"string mapname\" [\"[%i]\"] \n", my_String);

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
   float utile, vtile;
   MCHAR* name;
   MSTR name2;
   TSTR buf;


		std::string temp2 = "";

	 Texmap *tmap; // = ip2->GetEnvironmentMap(); //m->GetSubTexmap(ID_DI);
	 if (ip2->GetUseEnvironmentMap())
	 {
//		tmap = ip2->GetEnvironmentMap();
		if (tmap = ip2->GetEnvironmentMap())
		{
		//MessageBox(ip->GetMAXHWnd(),"EnvironmentMap = active",_T("info"),MB_ICONINFORMATION);
			//}
		//      cout << "Exception raised: " << str << '\n';

		if (tmap->ClassID() == Class_ID(BMTEX_CLASS_ID, 0))
		{
		// It is -- Access the UV tiling settings at time 0.
		BitmapTex *bmt = (BitmapTex*) tmap;
		  StdUVGen *uv = bmt->GetUVGen();
		// utile = uv->GetUScl(0);
		//vtile = uv->GetVScl(0);
		INT32	envRadians = uv->GetAng(0);


		name = bmt->GetMapName();
			
		std::string namestring = std::string(name);

		//std::string tempNameString = namestring;
		//for (int i = 0; i < tempNameString.length(); ++i)
		//if (tempNameString[i] == '\\')
		//{
		//	tempNameString.insert(i, 1, '//');
		//++i; // Skip inserted char
		//temp2 = temp;
		//}

		//buf.printf(_T("Two sided=%d, U Tile = %.1f, V Tile = %.1f, Name = %s"),
		//two, utile, vtile, temp2); // name works..
		//MessageBox(ip->GetMAXHWnd(), buf, _T("Info..."),
		//MB_ICONINFORMATION);

//buf.printf(_T("EnvMapangle in radians = %s"),
//		envRadians); // name works..
//		MessageBox(ip->GetMAXHWnd(), buf, _T("Info..."),
//		MB_ICONINFORMATION);


		MaxSDK::Util::Path path(_M(name));
		std::string filePath = path.GetString();

		for (int i = 0; i < filePath.length(); ++i)
		if (filePath[i] == '\\')
		{
			filePath.insert(i, 1, '\\');	
		++i; // Skip inserted char
		//temp2 = temp;

		}
		//fprintf(s_pStream, "#path test after replace %s\n", test4.data());

		fprintf(s_pStream, "\"string mapname\" [\"%s\"] \n", filePath.data());
		}
	 }
	  
	// else if {fprintf(s_pStream, "#No environmentmap\n");};
	 
		}
		else
		{
		//MessageBox(ip->GetMAXHWnd(),"EnvironmentMap = cannot get",_T("info"),MB_ICONINFORMATION);
		}
		//{
		//MessageBox(ip->GetMAXHWnd(),"error",_T("info"),MB_ICONINFORMATION);

		
	
	
//--------------------------------------------------------------------------------------------------------------------

	 

//fprintf(s_pStream, "\"string mapname\" [\"EnvironmentMap.jpg\"] \n");

//UtilExport::printf(s_pStream, concatStr);
//fprintf(s_pStream, string_x);

fprintf(s_pStream, " \n\n");
fprintf(s_pStream, "\"float gamma\" [1.000000] \n");
fprintf(s_pStream, "\"float gain\" [1.000000] \n");
fprintf(s_pStream, "AttributeEnd \n\n");


	//AttributeBegin
//    LightGroup "environment"
//    LightSource "infinite"
//        "string mapping" ["angular"]
//        "string mapname" ["..\\textures\\rnl_probe.exr"]
//        "float gamma" [1.000000]
//        "float gain" [1.00000]
//AttributeEnd


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