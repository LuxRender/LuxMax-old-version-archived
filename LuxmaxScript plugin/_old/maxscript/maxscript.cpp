#include "max.h"
#include "maxscrpt.h"
#include "definsfn.h"

void WriteMeshes(INode* p_node, FILE* s_pStream);

//
// Define Maxscript function
// LMX_ExportMesh

def_visible_primitive(LMX_ExportMesh, "LMX_ExportMesh");

// Arguments are (Mesh to export, Filename to save)

Value *LMX_ExportMesh_cf(Value **arg_list, int count)
{
	TSTR Path, Filename, Extention;
	TCHAR f[MAX_PATH];
	FILE* s_pStream;

	Interface *ip = GetCOREInterface();

	Value* varg_source = arg_list[0];
	Value* varg_target = arg_list[1];

	// Get the mesh to export from the argument
	INode* p_snode = varg_source->to_node(); 
	// Get the filename to save
	TCHAR* s_name = varg_target->to_string();
	// Open file for write
	fopen_s(&s_pStream, s_name, "w");
	// Couldnt open file so quit
    if ( s_pStream == NULL )
	{
		remove(f);
		MessageBox( NULL, "Couldnt save to file!\nCritical Error!", "Error!", MB_OK|MB_ICONERROR );
		return &ok;
	}
	
	// We are good to go! Save the mesh

	WriteMeshes(p_snode, s_pStream);

	// Done, close the file
	fclose(s_pStream);
	return &ok;
}

// LMX_ExportMesh END
