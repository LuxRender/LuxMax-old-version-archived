#include "LuxMax.h"
#include "Math.h"
#include <inode.h> 
/*
	CameraState cs;
	CameraObject* cam = (CameraObject*) p_node->EvalWorldState(0).obj;

	fprintf(s_pStream, "\t\t<fov>\n");
	fprintf(s_pStream, "\t\t\t<curve name=\"fov\" type=\"none\">\n");
	currFrame = AnimationRangeStart;
	i_id = 0;
	while (currFrame < AnimationRangeEnd)
	{
		TimeValue t = ((4800/GetFrameRate())* currFrame);
		TimeValue ft = ((4800/GetFrameRate())* (currFrame + 1));

		cam->EvalCameraState(t, valid, &cs);
		float f_camFOV = cam->GetFOV(t, valid) * 360 / ( 2*PI );

		cam->EvalCameraState(ft, valid, &cs);
		float f_fcamFOV = cam->GetFOV(ft, valid) * 360 / ( 2*PI );
*/

/*
=============================================================================
Cam_GetInt
=============================================================================
*/
int Cam_GetInt(CameraObject* base, TSTR pr, TimeValue t)
{
	//IParamArray* pa = base->GetParamBlock();
	//int n = base->NumParamBlocks();

	int i, p;

	for(i = 0; i < base->NumParamBlocks(); i++)
	{
		IParamBlock2* b = base->GetParamBlockByID(i);

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
Cam_GetFloat
=============================================================================
*/
float Cam_GetFloat(CameraObject* base, TSTR pr, TimeValue t)
{
	//IParamArray* pa = base->GetParamBlock();
	//int n = base->NumParamBlocks();

	int i, p;

	for(i = 0; i < base->NumParamBlocks(); i++)
	{
		IParamBlock2* b = base->GetParamBlockByID(i);

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



void LuxMax::WriteCamera()
{
	// Camera

	//create cam if no cam exists
	

//CameraObject* cam;
	CameraObject* cam = (CameraObject*) p_camera->EvalWorldState(0).obj;
//INode* node;
Interface *ip;

//TSTR pr1 = "enableAfocus";
int	var1;


	Point3 pos, up, look;
	DOUBLE shutteropen, focaldistance;
	
	pos = ScaleVector(m3_camera.GetRow(3), 100.0f);
	up = m3_camera.GetRow(1).Normalize();
	look = ScaleVector((m3_camera.GetRow(3) + -(m3_camera.GetRow(2).Normalize())), 100.0f);

	fprintf(s_pStream, "LookAt %s %s %s %s %s %s %s %s %s\n", Format(pos.x), Format(pos.y), Format(pos.z), Format(look.x), Format(look.y), Format(look.z), Format(up.x), Format(up.y), Format(up.z));

	TSTR proj = "perspective";

		
	//focaldistance = cam->GetTDist(1);
	//CameraObject* cam = (CameraObject*) p_camera->EvalWorldState(0).obj;
	INode* node;

	
	char* camType = cam->GetObjectName();


//	char camname = node->GetName(cam);
	
	//MSTR camname = cam->NodeName();
	if (camType == "Perspective")
	{
	MessageBox(ip->GetMAXHWnd(),"Please Create a LuxCamera! this is a 'perspective'",_T("info"),MB_ICONINFORMATION);
	return;
	}

	if (camType == "Target Camera")
	{
		MessageBox(ip->GetMAXHWnd(),"Please Create a LuxCamera! this is a 'standard target camera' ",_T("info"),MB_ICONINFORMATION);
		return;
	}
	if (camType == "Free Camera")
	{
		MessageBox(ip->GetMAXHWnd(),"Please Create a LuxCamera! this is a 'standard Free camera'",_T("info"),MB_ICONINFORMATION);
		return;
	}

	if (camType = "LR Free")
	//	if (camname = "LR Free")
	{
		fprintf(s_pStream, "Camera \"%s\" \"float fov\" [%s]\n", proj, Format(GetCameraFov(width, height, FOV)));
		fprintf(s_pStream,  "#\"float focaldistance\" [%s]\n",  Format(focaldistance));


			fprintf(s_pStream,  "# from new code: %s\n", camType);
		fprintf(s_pStream,  "# It's a LR Camera\n");

		if (Cam_GetInt(cam, "enabledof", 0) == 0)
		{
			fprintf(s_pStream,  "# enabledof check = true\n");
			fprintf(s_pStream,  "\"bool autofocus\" [\"false\"]\n");
			
			float test = (Cam_GetFloat(cam, "lensradius", 0));
			fprintf(s_pStream,  "\"float lensradius\" [%s]\n",  Format(test/100)); //lensradius
			
			//0.015000 = 1.5M in 3dsmax
			float focaldistance = (Cam_GetFloat(cam, "focaldistance", 0));
			//focaldistance
			fprintf(s_pStream,  "\"float focaldistance\" [%s]\n",  Format(focaldistance/100)); //lensradius
		}
		else
		{
			fprintf(s_pStream,  "# enabledof check = false\n");
			fprintf(s_pStream,  "\"bool autofocus\" [\"false\"]\n");
		}
	}
	else
	{
		fprintf(s_pStream,  "# from new code: %s\n", camType);
		fprintf(s_pStream,  "# It's NOT a LR Camera\n");
	}
	//////	//CameraObject* cam = (CameraObject*) p_camera->EvalWorldState(0).obj;
	//	fprintf(s_pStream,  "#found cam named: %s",  camname);
	//////	// Read Luxrender params
	//////	if (Cam_GetInt(cam, "ortho", 0) == 1)
	//////		proj = "orthographic";

	////	if (Cam_GetInt(cam, "enableAfocus", 0) == 1)
	////{	
	////	fprintf(s_pStream,  "# Autofocus enabled\n");

	//}
	//	else
	//	{
	//	
	//	}

	//if (Cam_GetInt(cam, "enableAfocus", 0) == 0)
	//{	
	//	fprintf(s_pStream,  "# Autofocus disabled\n");
	//
	//}



	//}

	//if (projection == 1)
	//	proj = "orthographic";
	

	
	
	
	
	
	//if (pr0 = "false")
	//Kr = Mtl_GetColor((MtlBase*)m, pr2, 0);
	//Mtl* m = p_node->GetMtl();
	
	
	
	
	
	//------------------------
	
	//TODO: Checkbutton for enable\disable autofocus.
	//"bool autofocus" ["true"]
	//"float lensradius" [0.000500]


//	"bool autofocus" ["true"]
	
	
	//"float lensradius" [0.000500]	
//fprintf(s_pStream,  "#\"float focaldistance\" [%s]\n",  Format(focaldistance));

}