#include "LuxMax.h"
#include "Math.h"

void LuxMax::noValidLightSources(INode* p_node)
{
	int i, c;

	if (!p_node->IsRootNode())
	{
		const ObjectState& os = p_node->EvalWorldState(0);

		switch (os.obj->SuperClassID())
		{
			case LIGHT_CLASS_ID:
				useDefaultLights = FALSE;
				break;
		}
		// Check if light class or as Light material
		Mtl *p_material = p_node->GetMtl();
			
		if (p_material)
		{
			if (p_material->ClassID() == LUXRENDER_LIGHTMATERIAL_ID)
				useDefaultLights = FALSE;
		}
	}

	c = p_node->NumberOfChildren();

	for (i = 0; i < c; i++)
	{
		noValidLightSources(p_node->GetChildNode(i));
	}
}

void LuxMax::WriteDefaultLights()
{
	int i;

	for (i = 0; i < n_defLights; i++)
	{
		LuxMaxDefaultLight* light = (LuxMaxDefaultLight*)deflights[i];

		if (light->Type == DIRECT_LGT)
		{
			Matrix3 tm = light->worldToLight;

			fprintf(s_pStream, "TransformBegin\n");		
			fprintf(s_pStream, "Transform [%s %s %s %s  %s %s %s %s  %s %s %s %s  %s %s %s %s]\n", Format(tm.GetRow(0).x), Format(tm.GetRow(0).y), Format(tm.GetRow(0).z), Format(0.0f), Format(tm.GetRow(1).x), Format(tm.GetRow(1).y), Format(tm.GetRow(1).z), Format(0.0f), Format(tm.GetRow(2).x), Format(tm.GetRow(2).y), Format(tm.GetRow(2).z), Format(0.0f), Format(tm.GetRow(3).x), Format(tm.GetRow(3).y), Format(tm.GetRow(3).z), Format(1.0f));
			fprintf(s_pStream, "LightGroup \"default\"\n");
			fprintf(s_pStream, "LightSource \"infinite\" \"color L\" [%s %s %s] \"float gain\" [%s]\n", Format(light->Color.x), Format(light->Color.y), Format(light->Color.z), Format(1.0f));
			WritePortals(n_sceneRoot);
			fprintf(s_pStream, "TransformEnd\n");
		}
		else if (light->Type == OMNI_LGT)
		{
			Matrix3 tm = light->worldToLight;

			Point3 Position = ScaleVector(tm.GetTrans(), 100.0f);

			fprintf(s_pStream, "TransformBegin\n");		
			fprintf(s_pStream, "Translate %s %s %s\n", Format(Position.x), Format(Position.y), Format(Position.z));
			fprintf(s_pStream, "LightGroup \"default\"\n");
			fprintf(s_pStream, "LightSource \"point\" \"point from\" [0 0 0] \"color L\" [%s %s %s]\n", Format(light->Color.x), Format(light->Color.y), Format(light->Color.z));
			fprintf(s_pStream, "TransformEnd\n");
		}
	}
}

void LuxMax::WritePointLight(INode* n)
{
	Interval iv;
	iv.SetInfinite();
	LightState ls;
	LightObject* obj = (LightObject*) n->EvalWorldState(0).obj;
	obj->EvalLightState(0,iv,&ls);

	Matrix3 tm = n->GetNodeTM(0);
	Point3 position = ScaleVector(tm.GetTrans(), 100.0f);

	fprintf(s_pStream, "TransformBegin # %s\n", n->GetName());		
	fprintf(s_pStream, "Translate %s %s %s\n", Format(position.x), Format(position.y), Format(position.z));
	fprintf(s_pStream, "LightGroup \"%s\"\n", n->GetName());
	fprintf(s_pStream, "LightSource \"point\" \"point from\" [0 0 0] \"color L\" [%s %s %s] \"float gain\" [%s]\n", Format(ls.color.r / 255), Format(ls.color.g / 255), Format(ls.color.g / 255), Format(ls.intens));
	fprintf(s_pStream, "TransformEnd\n");
}

void LuxMax::WriteSpotLight(INode* n)
{
	BOOL spotlightenabled = false;
	Interval iv;
	iv.SetInfinite();
	LightState ls;
	LightObject* obj = (LightObject*) n->EvalWorldState(0).obj;
	obj->EvalLightState(0,iv,&ls);

	Matrix3 tm = n->GetNodeTM(0);
	tm.SetTrans(ScaleVector(tm.GetTrans(), 100.0f));

	if (n->IsNodeHidden() == true)
		{
			fprintf(s_pStream, "#Lighthidden %s\n \n", n->GetName());
			spotlightenabled = false;
		}
	if (n->IsNodeHidden() == false)
		{
			spotlightenabled = true;
		}
	
	 if (spotlightenabled)
		{
		fprintf(s_pStream, "TransformBegin # %s\n", n->GetName());		
		fprintf(s_pStream, "Transform [%s %s %s %s  %s %s %s %s  %s %s %s %s  %s %s %s %s]\n", Format(tm.GetRow(0).x), Format(tm.GetRow(0).y), Format(tm.GetRow(0).z), Format(0.0f), Format(tm.GetRow(1).x), Format(tm.GetRow(1).y), Format(tm.GetRow(1).z), Format(0.0f), Format(tm.GetRow(2).x), Format(tm.GetRow(2).y), Format(tm.GetRow(2).z), Format(0.0f), Format(tm.GetRow(3).x), Format(tm.GetRow(3).y), Format(tm.GetRow(3).z), Format(1.0f));
		fprintf(s_pStream, "LightGroup \"%s\"\n", n->GetName());
		fprintf(s_pStream, "LightSource \"spot\" \"point from\" [0 0 0] \"point to\" [0 0 -1] \"color L\" [%s %s %s] \"float gain\" [%s]\n", Format(ls.color.r / 255), Format(ls.color.g / 255), Format(ls.color.g / 255), Format(ls.intens));
		fprintf(s_pStream, "TransformEnd\n");
		}
	else
		{

		}
}


void LuxMax::WriteDirectLight(INode* n)
{
	//Rotate 77 0 0 1
	BOOL LightEnabled = false;

	Interval iv;
	iv.SetInfinite();
	LightState ls;
	LightObject* obj = (LightObject*) n->EvalWorldState(0).obj;
	obj->EvalLightState(0,iv,&ls);

	Matrix3 tm = n->GetNodeTM(0);
	tm.SetTrans(ScaleVector(tm.GetTrans(), 100.0f));
	
	if (n->IsNodeHidden() == false)
	{
		LightEnabled = true;
	}
	
	if (n->IsNodeHidden() == true)
	{
		LightEnabled = false;
	}


if (LightEnabled)
	{
	fprintf(s_pStream, "TransformBegin # %s\n", n->GetName());		
	fprintf(s_pStream, "Transform [%s %s %s %s  %s %s %s %s  %s %s %s %s  %s %s %s %s]\n", Format(tm.GetRow(0).x), Format(tm.GetRow(0).y), Format(tm.GetRow(0).z), Format(0.0f), Format(tm.GetRow(1).x), Format(tm.GetRow(1).y), Format(tm.GetRow(1).z), Format(0.0f), Format(tm.GetRow(2).x), Format(tm.GetRow(2).y), Format(tm.GetRow(2).z), Format(0.0f), Format(tm.GetRow(3).x), Format(tm.GetRow(3).y), Format(tm.GetRow(3).z), Format(1.0f));
	fprintf(s_pStream, "LightGroup \"%s\"\n", n->GetName());
	fprintf(s_pStream, "LightSource \"infinite\" \"color L\" [%s %s %s] \"float gain\" [%s]\n", Format(ls.color.r / 255), Format(ls.color.g / 255), Format(ls.color.g / 255), Format(ls.intens));
	WritePortals(n_sceneRoot);
	fprintf(s_pStream, "TransformEnd\n");
	}
else
	{

	}
	
}
void LuxMax::WriteSky(INode* n)
{
	MSTR isLuxSky;
	MSTR isLuxSun;

	if (n->UserPropExists("isLuxSky"))
	{
		n->GetUserPropString("isLuxSky" ,isLuxSky);
		
			if (isLuxSky == MSTR("true"))
			{
				// fprintf(s_pStream, "Transform [%s %s %s %s  %s %s %s %s  %s %s %s %s  %s %s %s %s]\n", Format(tm.GetRow(0).x), Format(tm.GetRow(0).y), Format(tm.GetRow(0).z), Format(0.0f), Format(tm.GetRow(1).x), Format(tm.GetRow(1).y), Format(tm.GetRow(1).z), Format(0.0f), Format(tm.GetRow(2).x), Format(tm.GetRow(2).y), Format(tm.GetRow(2).z), Format(0.0f), Format(tm.GetRow(3).x), Format(tm.GetRow(3).y), Format(tm.GetRow(3).z), Format(1.0f));
				BOOL LightEnabled = false;
				Interval iv;
				iv.SetInfinite();
				LightState ls;
				LightObject* obj = (LightObject*) n->EvalWorldState(0).obj;
				obj->EvalLightState(0,iv,&ls);
		
				Matrix3 tm = n->GetNodeTM(0);
				Point3 sundir = tm.GetRow(2).Normalize();
				
				MSTR gain;
				MSTR turbidity;
				MSTR nsamples;
				MSTR relsize;
				
				n->GetUserPropString("gain" ,gain);
				n->GetUserPropString("turbidity" ,turbidity);
				n->GetUserPropString("nsamples" ,nsamples);
				n->GetUserPropString("relsize" ,relsize);
		
				fprintf(s_pStream, "AttributeBegin # %s\n", n->GetName());
				fprintf(s_pStream, "LightGroup \"Sky\"\n");
				fprintf(s_pStream, "LightSource \"sky\" \"vector sundir\" [%s %s %s] \"float gain\" [%s] \"float relsize\" [%s] \"float turbidity\" [%s] \"integer nsamples\" [%s]\n", Format(sundir.x), Format(sundir.y), Format(sundir.z), gain, relsize, turbidity, nsamples);
				
				fprintf(s_pStream, "AttributeEnd\n\n");
				return;
			}
}
			 if(n->UserPropExists("isLuxSun"))
			{
				n->GetUserPropString("isLuxSun" ,isLuxSun);
				if(isLuxSun == MSTR("true"))
				{
					Interval iv;
					iv.SetInfinite();
					LightState ls;
					LightObject* obj = (LightObject*) n->EvalWorldState(0).obj;
					obj->EvalLightState(0,iv,&ls);

					Matrix3 tm = n->GetNodeTM(0);
					Point3 sundir = tm.GetRow(2).Normalize();

					MSTR gain;
					MSTR turbidity;
					MSTR nsamples;
					MSTR relsize;

					n->GetUserPropString("gain" ,gain);
					n->GetUserPropString("turbidity" ,turbidity);
					n->GetUserPropString("nsamples" ,nsamples);
					n->GetUserPropString("relsize" ,relsize);

					fprintf(s_pStream, "AttributeBegin # %s\n", n->GetName());
					fprintf(s_pStream, "LightGroup \"Sun\"\n");
					fprintf(s_pStream, "Transform [%s %s %s %s  %s %s %s %s  %s %s %s %s  %s %s %s %s]\n", Format(tm.GetRow(0).x), Format(tm.GetRow(0).y), Format(tm.GetRow(0).z), Format(0.0f), Format(tm.GetRow(1).x), Format(tm.GetRow(1).y), Format(tm.GetRow(1).z), Format(0.0f), Format(tm.GetRow(2).x), Format(tm.GetRow(2).y), Format(tm.GetRow(2).z), Format(0.0f), Format(tm.GetRow(3).x), Format(tm.GetRow(3).y), Format(tm.GetRow(3).z), Format(1.0f));
					fprintf(s_pStream, "LightSource \"sun\" \"vector sundir\" [%s %s %s] \"float gain\" [%s] \"float relsize\" [%s] \"float turbidity\" [%s] \"integer nsamples\" [%s]\n", Format(sundir.x), Format(sundir.y), Format(sundir.z), gain, relsize, turbidity, nsamples);
					fprintf(s_pStream, "AttributeEnd\n\n");
					return;
				}

			}

	

				
}




void LuxMax::WriteLights(INode* n)
{
	Interval iv;

	int i, c;

	if (!n->IsRootNode())
	{
		const ObjectState& os = n->EvalWorldState(0);

		switch (os.obj->SuperClassID())
		{
			case LIGHT_CLASS_ID:
				{
					iv.SetInfinite();
					LightState ls;
					LightObject* obj = (LightObject*) n->EvalWorldState(0).obj;
					obj->EvalLightState(0,iv,&ls);

					switch(ls.type)
					{
					case OMNI_LGT:
						WritePointLight(n);
						break;
					case SPOT_LGT:
						WriteSpotLight(n);
						break;
					case DIRECT_LGT:
						WriteDirectLight(n);
						break;
					case AMBIENT_LGT:
						WriteSky(n);
						break;
					}

				}
				break;
		}
	}

	c = n->NumberOfChildren();

	for (i = 0; i < c; i++)
		WriteLights(n->GetChildNode(i));
}