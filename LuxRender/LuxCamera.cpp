#include "LuxMax.h"
#include "Math.h"

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

	Point3 pos, up, look;

	pos = ScaleVector(m3_camera.GetRow(3), 100.0f);
	up = m3_camera.GetRow(1).Normalize();
	look = ScaleVector((m3_camera.GetRow(3) + -(m3_camera.GetRow(2).Normalize())), 100.0f);

	fprintf(s_pStream, "LookAt %s %s %s %s %s %s %s %s %s\n", Format(pos.x), Format(pos.y), Format(pos.z), Format(look.x), Format(look.y), Format(look.z), Format(up.x), Format(up.y), Format(up.z));

	TSTR proj = "perspective";
	
	//CameraObject* cam = (CameraObject*) p_camera->EvalWorldState(0).obj;

	//if (cname == "LR Free")
	//{
	//	//CameraObject* cam = (CameraObject*) p_camera->EvalWorldState(0).obj;

	//	// Read Luxrender params
	//	if (Cam_GetInt(cam, "ortho", 0) == 1)
	//		proj = "orthographic";

	//}

	//if (projection == 1)
	//	proj = "orthographic";

	fprintf(s_pStream, "Camera \"%s\" \"float fov\" [%s]\n", proj, Format(GetCameraFov(width, height, FOV)));


}