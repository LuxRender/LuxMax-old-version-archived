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
//#include "AssetManagement/iassetmanager.h"
#include "maxscrpt/maxscrpt.h"
#include <iostream>
#include <string>
#include <Path.h> 
//#include "AssetType.h"
//#include "IFileResolutionManager.h"
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
	//hides the bitmap render dialog window so that you do not have to close it all the time while exporting.
	tobm->UnDisplay();

	//set the progress to '0'
	prog->Progress(0,100);
	//set the title 
	prog->SetTitle("Starting export..");
	tobm->SetWindowTitle("LuxRender rendered to lxs file.");
	
	//makes sure it's getting closed.
	tobm->UnDisplay();

	//If it's a camera then proceed
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

//ViewExp *viewPort = GetCOREInterface()->GetActiveViewport();
////HWND hwnd = viewPort->GetHWnd();
//if( hwnd )
//{
//HDC dc = GetDC( hwnd );
//TextOut( dc, 100,100, "Done Exporting!", strlen("Done Exporting!") );
//ReleaseDC( hwnd, dc );
//}
//GetCOREInterface()->ReleaseViewport( viewPort); 

	return 0;
}
   


int LuxMax::WriteScene()
{
GenCamera* cam;// = GenCamera();

Interface* ip = GetCOREInterface();

//CurrentTime = GetCOREInterface()->GetTime();  
MSTR timestring;
TimeToString(GetCOREInterface()->GetTime(),timestring);// CurrentTime;
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
	fprintf(s_pStream, "# Slider is at frame: %s\n", MSTR(timestring)); 

	// Camera
	if (!p_camera)
	{
		MessageBox(ip->GetMAXHWnd(),"Please render through a LuxCamera!",_T("ERROR!"),MB_ICONINFORMATION);
		return 0;
		
	}
	

	// Image format
		WriteCamera();
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
	else if (selectedpreset == 4)
	{
//Get all settings from camera
		INode* node;
		MSTR userpropFileName;
		
		MSTR outputEXR;
		MSTR outputTGA;
		MSTR strhltstp;
		MSTR writePNG;
		MSTR WriteTGA ; //writeTGA
		MSTR write_resume_flm;
		MSTR displayinterval;
		MSTR writeinterval;
		MSTR Debug;
		MSTR gamma;
		MSTR filtertype;
		MSTR filtertypecompare;
		MSTR filterboxx;
		MSTR filterboxy;
		MSTR gaussianAlpha;
		MSTR rejectwarmup;

		//MSTR usereinhard;
		//int usereinhardint; //usereinhard
		BOOL usereinhard;
		MSTR tonemapkernel;
		MSTR reinhard_prescale;
		MSTR reinhard_postscale;
		MSTR reinhard_burn;

		//for linear
		BOOL uselinear;
		MSTR linear_sensitivity;
		MSTR linear_exposure;
		MSTR linear_fstop;
		MSTR linear_gamma;

		//for contrast
		BOOL usecontrast;
		MSTR contrast_ywa;
		MSTR halttime;

		BOOL usemaxwhite;
		BOOL useautolinear;

		if (ip->GetINodeByName(p_camera->GetName()))
		{
			node = ip->GetINodeByName(p_camera->GetName());

			//---------Filter types....----
			if (node->UserPropExists("hltstp"))
			{
				node->GetUserPropString("hltstp", strhltstp);

				fprintf(s_pStream, "\"integer haltspp\" [%s] \n",strhltstp);
				//integer haltspp\" [0]
			}

		if (node->UserPropExists("halttime"))
			{
				node->GetUserPropString("halttime",halttime);
				fprintf(s_pStream, "\"integer halttime\" [%s] \n",halttime);
			}

//reinhard tonemapper
if (node->UserPropExists("tonemapkernel"))
{
	node->GetUserPropString("tonemapkernel", tonemapkernel);
	
	//begin reinhard
	if (node->UserPropExists("usereinhard"))
	{
		node->GetUserPropBool("usereinhard", usereinhard);
		if (usereinhard)
		{
			fprintf(s_pStream, "\"string tonemapkernel\" [\"%s\"] \n",tonemapkernel);
			node->GetUserPropString("reinhard_prescale",reinhard_prescale);
			node->GetUserPropString("reinhard_postscale",reinhard_postscale);
			node->GetUserPropString("reinhard_burn",reinhard_burn);
			
			fprintf(s_pStream, "\"float reinhard_prescale\" [%s] \n",reinhard_prescale);
			fprintf(s_pStream, "\"float reinhard_postscale\" [%s] \n",reinhard_postscale);
			fprintf(s_pStream, "\"float reinhard_burn\" [%s] \n", reinhard_burn);
		}

	}
	//end reinhard

	//begin linear
	if (node->UserPropExists("uselinear"))
	{	
		node->GetUserPropBool("uselinear", uselinear);
		if (uselinear)
		{
			fprintf(s_pStream, "\"string tonemapkernel\" [\"%s\"] \n",tonemapkernel);
			
			node->GetUserPropString("linear_sensitivity",linear_sensitivity);
			node->GetUserPropString("linear_exposure",linear_exposure);
			node->GetUserPropString("linear_fstop",linear_fstop);
			node->GetUserPropString("linear_gamma",linear_gamma);

			fprintf(s_pStream, "\"float linear_sensitivity\" [%s] \n",linear_sensitivity);
			fprintf(s_pStream, "\"float linear_exposure\" [%s] \n",linear_exposure);
			fprintf(s_pStream, "\"float linear_fstop\" [%s] \n",linear_fstop);
			fprintf(s_pStream, "\"float linear_gamma\" [%s] \n",linear_gamma);
		}
	}

	if(node->UserPropExists("usecontrast"))
	{
		node->GetUserPropBool("usecontrast",usecontrast);
		if(usecontrast)
		{
			fprintf(s_pStream, "\"string tonemapkernel\" [\"%s\"] \n",tonemapkernel);
			node->GetUserPropString("contrast_ywa",contrast_ywa);
			fprintf(s_pStream, "\"float contrast_ywa\" [%s] \n",contrast_ywa);

		}
	}

	if(node->UserPropExists("usemaxwhite"))
	{
		node->GetUserPropBool("usemaxwhite",usemaxwhite);
		if (usemaxwhite)
		{
			fprintf(s_pStream, "\"string tonemapkernel\" [\"%s\"] \n",tonemapkernel);
		}
	}
	if(node->UserPropExists("useautolinear"))
	{
		node->GetUserPropBool("useautolinear",useautolinear);
		if (useautolinear)
		{
			fprintf(s_pStream, "\"string tonemapkernel\" [\"%s\"] \n",tonemapkernel);
		}
	}

}
	//displayinterval
			if (node->UserPropExists("displayinterval"))
			{
				node->GetUserPropString("displayinterval", displayinterval);
				fprintf(s_pStream, "\"integer displayinterval\" [%s] \n",displayinterval);
				//integer haltspp\" [0]
			}

	//writeinterval
			if (node->UserPropExists("writeinterval"))
			{
				node->GetUserPropString("writeinterval", writeinterval);
				fprintf(s_pStream, "\"integer writeinterval\" [%s] \n",writeinterval);
				//integer haltspp\" [0]
			}

			//"bool write_exr\" [\"true\"] \n
			if (node->UserPropExists("writeEXR"))
			{
				node->GetUserPropString("writeEXR", outputEXR);
				fprintf(s_pStream, "\"bool write_exr\" [\"%s\"] \n",outputEXR);
				//integer haltspp\" [0]
			}

			//Write png

			if (node->UserPropExists("writePNG"))
			{
				node->GetUserPropString("writePNG", writePNG);
				fprintf(s_pStream, "\"bool write_png\" [\"%s\"] \n",writePNG);
				//integer haltspp\" [0]
			}
			//writeTGA
			if (node->UserPropExists("writeTGA"))
			{
				node->GetUserPropString("writeTGA", WriteTGA);
				fprintf(s_pStream, "\"bool write_tga\" [\"%s\"] \n",WriteTGA);
				//integer haltspp\" [0]
			}
			//filename
			if (node->UserPropExists("FileName"))
			{
				node->GetUserPropString("FileName", userpropFileName);
				fprintf(s_pStream, "\"string filename\" [\"%s\"] \n", userpropFileName);
			}

			if (node->UserPropExists("writeResumeFilm"))
			{
				node->GetUserPropString("writeResumeFilm", write_resume_flm);
				fprintf(s_pStream, "\"bool write_resume_flm\" [\"%s\"] \n",write_resume_flm);
				//integer haltspp\" [0]
			}

			//reject warmup samples

			if (node->UserPropExists("rejectwarmup"))
			{
				node->GetUserPropString("rejectwarmup", rejectwarmup);
				fprintf(s_pStream, "\"integer reject_warmup \" [\"%s\"] \n",rejectwarmup);
				//integer haltspp\" [0]
			}
			//bool debug

			if (node->UserPropExists("Debug"))
			{
				node->GetUserPropString("Debug", Debug);
				fprintf(s_pStream, "\"bool debug\" [\"%s\"] \n",Debug);
				//integer haltspp\" [0]
			}

			if (node->GetUserPropString("gamma", gamma))
			{
				node->GetUserPropString("gamma", gamma);
				fprintf(s_pStream, "\"float gamma\" [%s] \n",gamma);
			}
//-----------------------------------

			if (node->UserPropExists("filtertype"))
			{
				node->GetUserPropString("filtertype", filtertype);
				
				if (filtertype == MSTR ("mitchell"))
				{
					node->GetUserPropString("filterboxx",filterboxx);
					node->GetUserPropString("filterboxy",filterboxx);

					fprintf(s_pStream, "PixelFilter \"%s\" \n", filtertype);
						fprintf(s_pStream, "\"integer pixelsamples\" [%s] \n", filterboxx);		

					//	fprintf(s_pStream, "\"float B\" [%s] \n", filterboxx);		
						//	fprintf(s_pStream, "\"float C\" [%s] \n", filterboxy);
				
				}
				//gaussian
				else if (filtertype == MSTR("gaussian"))
				{
				node->GetUserPropString("filterboxx",filterboxx);
					fprintf(s_pStream, "PixelFilter \"%s\" \n", filtertype);

					fprintf(s_pStream, "\"float B\" [%s] \n", filterboxx);		
					fprintf(s_pStream, "\"float C\" [%s] \n", filterboxx);
					//hardcoded for now.
					gaussianAlpha = "2.0";
					fprintf(s_pStream, "\"alpha\" [%s] \n", gaussianAlpha);
				}

				else if (filtertype == MSTR("triangle"))
					{
					node->GetUserPropString("filterboxx",filterboxx);
					fprintf(s_pStream, "PixelFilter \"%s\" \n", filtertype);
					fprintf(s_pStream, "\"float xwidth\" [%s] \n", filterboxx);
					fprintf(s_pStream, "\"float ywidth\" [%s] \n", filterboxx);

					//	fprintf(s_pStream, "\"float C\" [%s] \n", filterboxx);
					//hardcoded for now.
					//gaussianAlpha = "2.0";
					//fprintf(s_pStream, "\"alpha\" [%s] \n", gaussianAlpha);
				}
				else if (filtertype == MSTR("sinc"))
					{
					node->GetUserPropString("filterboxx",filterboxx);
					fprintf(s_pStream, "PixelFilter \"%s\" \n", filtertype);
					fprintf(s_pStream, "\"float xwidth\" [%s] \n", filterboxx);
					fprintf(s_pStream, "\"float ywidth\" [%s] \n", filterboxx);
					fprintf(s_pStream, "\"float tau\" [3.0] \n");

					//	fprintf(s_pStream, "\"float C\" [%s] \n", filterboxx);
					//hardcoded for now.
					//gaussianAlpha = "2.0";
					//fprintf(s_pStream, "\"alpha\" [%s] \n", gaussianAlpha);
					}





			}

			MSTR sampler_filter_name;
			if (node->UserPropExists("sampler_filter_name"))
			{
				node->GetUserPropString("sampler_filter_name",sampler_filter_name);

			 if (sampler_filter_name == MSTR("lowdiscrepancy"))
				{
					MSTR lowdiscrepancy_pixelsamples;
					MSTR lowdiscrepancy_pixelsampler;
					
					node->GetUserPropString("lowdiscrepancy_pixelsamples",lowdiscrepancy_pixelsamples);
					node->GetUserPropString("lowdiscrepancy_pixelsampler",lowdiscrepancy_pixelsampler);

					fprintf(s_pStream, "Sampler \"lowdiscrepancy\" \n");	
					fprintf(s_pStream, "\"integer pixelsamples\" [%s] \n", lowdiscrepancy_pixelsamples);	
					//fprintf(s_pStream, "pixelsampler \"vegas\" \n");
				}


			 else if (sampler_filter_name == MSTR("random"))
				{
				MSTR random_pixelsamples;
				MSTR random_pixelsampler;

				node->GetUserPropString("random_pixelsamples",random_pixelsamples);
				node->GetUserPropString("random_pixelsampler",random_pixelsampler);

				fprintf(s_pStream, "Sampler \"random\" \n");	
				fprintf(s_pStream, "\"integer pixelsamples\" [%s] \n", random_pixelsamples);	
				//fprintf(s_pStream, "pixelsampler \"vegas\" \n");

				}
				else if (sampler_filter_name == MSTR("metropolis"))
				{
					MSTR metropolis_initsamples;	
					MSTR metropolis_maxconsecrejects;
					MSTR metrolpolis_largemutationprob;
					MSTR metrolpolis_micromutationprob;
					MSTR metrolpolis_mutationrange;
					BOOL metrolpolis_usevariance;
					
					node->GetUserPropString("metropolis_initsamples",metropolis_initsamples);
					node->GetUserPropString("metropolis_maxconsecrejects",metropolis_maxconsecrejects);
					node->GetUserPropString("metrolpolis_largemutationprob",metrolpolis_largemutationprob);
					node->GetUserPropString("metrolpolis_micromutationprob",metrolpolis_micromutationprob);
					node->GetUserPropString("metrolpolis_mutationrange",metrolpolis_mutationrange);

					fprintf(s_pStream, "Sampler \"metropolis\" \n");
					fprintf(s_pStream, "\"integer initsamples\" [%s] \n", metropolis_initsamples);
					fprintf(s_pStream, "\"integer maxconsecrejects\" [%s] \n", metropolis_maxconsecrejects);
					fprintf(s_pStream, "\"float largemutationprob\" [%s] \n", metrolpolis_largemutationprob);
					fprintf(s_pStream, "\"float micromutationprob\" [%s] \n", metrolpolis_micromutationprob);
					fprintf(s_pStream, "\"float mutationrange\" [%s] \n", metrolpolis_mutationrange);
					
					//node->GetUserPropBool("metrolpolis_usevariance", metrolpolis_usevariance);
					//fprintf(s_pStream, "\"bool usevariance\" [%s] \n", metrolpolis_usevariance);
				}
				else if (sampler_filter_name = MSTR ("erpt"))
				{
					MSTR erpt_initsamples;
					MSTR erpt_chainlength;
					MSTR erpt_mutationrange;

					node->GetUserPropString("erpt_initsamples",erpt_initsamples);
					node->GetUserPropString("erpt_chainlength",erpt_chainlength);
					node->GetUserPropString("erpt_mutationrange",erpt_mutationrange);

					fprintf(s_pStream, "Sampler \"erpt\" \n");
					fprintf(s_pStream, "\"integer initsamples\" [%s] \n", erpt_initsamples);
					fprintf(s_pStream, "\"integer chainlength\" [%s] \n", erpt_chainlength);
					fprintf(s_pStream, "\"integer mutationrange\" [%s] \n", erpt_mutationrange);
				}

			}
			//---------Filter types....----
		}
	}

	
//fprintf(s_pStream, "#test value from camera : %s \"\" \n", filenameTemp);

	//fprintf(s_pStream, "%s", PRESET_CUSTOM());
	//	fprintf(s_pStream, "#Custom settings goes here...");
	//INode* node;
	//if (ip->GetINodeByName("LRSettings001"))
	//node = ip->GetINodeByName("LRSettings001");

	//if (node->UserPropExists("ExportEXR"))
	//{
	//	TSTR ExportEXR;
	//	TSTR test;
	//	ExportEXR = "ExportEXR";
	//	test = "asdf";
	//	
	//	BOOL ExportExrbool;
	//	//node->SetUserPropBool("ExportEXR", TRUE);
	//	//fprintf(s_pStream, "#custom userprop exists and is: %s \n", node->GetUserPropBool("ExportEXR",NULL));
	//	node->GetUserPropBool("ExportEXR", ExportExrbool);
	//	if (ExportExrbool)
	//	{
	//		fprintf(s_pStream, "#custom userprop exists and is:true \n");
	//	}
	//	

	//	TimeValue currtime;
	//	currtime = ip->GetTime();
	//	fprintf(s_pStream, "#time is: \n", currtime);
	//}
	

	//fprintf(s_pStream, "#custom node name: %s \n", node->GetName());

//	}
		
	// World

	fprintf(s_pStream, "\nWorldBegin\n\n");

//environment map begin

	//Enviroment map

	
//fprintf(s_pStream, "\"string mapping\" [\"angular\"] \n");
//--------------------------------------------------------------------------------------------------------------------

//Interface* ip2 = GetCOREInterface7();
//	Interface* ip8 = GetCOREInterface8();
//	Interface* ip9 = GetCOREInterface9();
//	
////Interface* ip = GetCOREInterface();
//	Texmap* texmap;
//
//	FilterList* filterlist;
//	BitmapManager* bmgr ;//= BitmapManager();
//	BitmapFileInputDialog* bfdlg;
//
//	BOOL two;
//   float utile, vtile , ang;
//   MCHAR* name;
//   MSTR name2;
//   TSTR buf;
//
//
//		std::string temp2 = "";
//
//	 Texmap *tmap; // = ip2->GetEnvironmentMap(); //m->GetSubTexmap(ID_DI);
//	 if (ip2->GetUseEnvironmentMap())
//	 {
//		if (tmap = ip2->GetEnvironmentMap())
//		{
//		if (tmap->ClassID() == Class_ID(BMTEX_CLASS_ID, 0))
//		{
//		
//		BitmapTex *bmt = (BitmapTex*) tmap;
//		  StdUVGen *uv = bmt->GetUVGen();
//		  
//		INT32 envRadians = uv->GetAng(0);
//		INT32 envuang = uv->GetUAng(0);
//		float vang = uv->GetVAng(0);
//		INT32 axis = uv->GetAxis();
//		
//		fprintf(s_pStream, "#\"Env radian\" [\"%i\"] \n", envRadians);
//		fprintf(s_pStream, "#\"Env uang\" [\"%i\"] \n", envuang);
//		fprintf(s_pStream, "#\"Env vang\" [\"%f\"] \n", vang);
//		fprintf(s_pStream, "#\"Env axis\" [\"%i\"] \n", axis);
//
//		name = bmt->GetMapName();
//			
//		std::string namestring = std::string(name);
//		MaxSDK::Util::Path path(_M(name));
//		std::string filePath = path.GetString();
//
//		for (int i = 0; i < filePath.length(); ++i)
//			if (filePath[i] == '\\')
//			{
//				filePath.insert(i, 1, '\\');	
//				++i; // Skip inserted char
//			}
//		fprintf(s_pStream, "\"string mapname\" [\"%s\"] \n", filePath.data());	
//	}
// }
//}
//else
//{
//
//}

//NEW ENVIRONMENT CODE
//GenCamera* cam;// = GenCamera();

INode* node;
MSTR environmentimage;
MSTR envmaptype;
MSTR envgain;
MSTR envgamma;
MSTR useenvmap;

if (ip->GetINodeByName(p_camera->GetName()))
	{
		node = ip->GetINodeByName(p_camera->GetName());
		node->GetUserPropString("environmentimage" ,environmentimage);
		node->GetUserPropString("envmaptype",envmaptype);
		node->GetUserPropString("envgamma", envgamma);
		node->GetUserPropString("envgain",envgain);
		node->GetUserPropString("useenvmap",useenvmap);
		
		fprintf(s_pStream, "#Env userprop %s\n", environmentimage);	

		std::string filePath = environmentimage;
		
		if (useenvmap == MSTR("true"))
			{
			fprintf(s_pStream, "\n# Enviromentmap goes here\n");
			fprintf(s_pStream, "AttributeBegin \n");
			fprintf(s_pStream, "# rotate image -90 degrees around Z axis to correct aligment.");
			fprintf(s_pStream, "Rotate -90.0  0 0 1");
			fprintf(s_pStream, "Scale -1 1 1");
			fprintf(s_pStream, "LightGroup \"environment\" \n");
			fprintf(s_pStream, "LightSource \"infinite\" \n");

			for (int i = 0; i < filePath.length(); ++i)
				if (filePath[i] == '\\')
					{
						filePath.insert(i, 1, '\\');	
						++i; // Skip inserted char
					}
				//envmaptype
				fprintf(s_pStream, "\"string mapping\" [\"%s\"] \n", envmaptype);	
				fprintf(s_pStream, "\"string mapname\" [\"%s\"] \n", filePath.data());	
				fprintf(s_pStream, "\"float gamma\" [%s] \n", envgamma);
				fprintf(s_pStream, "\"float gain\" [%s] \n", envgain);

				fprintf(s_pStream, "AttributeEnd \n\n");
			}
		else
			{
			fprintf(s_pStream, "#No environment map specified in 3dsmax.");
			}
	}

fprintf(s_pStream, " \n\n");

//fprintf(s_pStream, "\"float gamma\" [1.000000] \n");
//fprintf(s_pStream, "\"float gain\" [1.000000] \n");


	//environment map end

	useDefaultLights = TRUE;
	noValidLightSources(n_sceneRoot);

	if (n_defLights > 0 && useDefaultLights)
	{
		//	WriteDefaultLights();
	}
	

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