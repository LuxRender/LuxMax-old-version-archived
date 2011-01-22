#include "max.h"
#include "maxscript.h"

#include <fstream>
#include <iostream>
#include <cstring>

void WriteMeshes(INode* p_node, FILE* s_pStream);
void WritePLY(INode* p_node, FILE* file, bool ascii);

//
// Define Maxscript function
// LMX_ExportMesh
#include "maxscript\macros\define_instantiation_functions.h"
	def_visible_primitive_debug_ok(LMX_ExportMesh, "LMX_ExportMesh");
	def_visible_primitive_debug_ok(LMX_ExportPLY, "LMX_ExportPLY");

// Arguments are (Mesh to export, Filename to save)

Value *LMX_ExportMesh_cf(Value **arg_list, int count)
{
	TSTR Path, Filename, Extention;
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
		MessageBox( NULL, "Couldnt save to file!\nCritical Error!", "Error!", MB_OK|MB_ICONERROR );
		return &ok;
	}
	
	// We are good to go! Save the mesh

	WriteMeshes(p_snode, s_pStream);

	// Done, close the file
	fclose(s_pStream);
	return &ok;
}

Value *LMX_ExportPLY_cf(Value **arg_list, int count)
{
	TSTR Path, Filename, Extention;
	FILE* file;

	Interface *ip = GetCOREInterface();

	Value* varg_source = arg_list[0];
	Value* varg_target = arg_list[1];
	Value* varg_ascii = arg_list[2];

	// Get the mesh to export from the argument
	INode* p_snode = varg_source->to_node(); 
	// Get the filename to save
	TCHAR* s_name = varg_target->to_string();
	// Open file for write
	fopen_s(&file, s_name, "wb");
	//std::ofstream* file;
	//file = new std::ofstream(s_name, std::ofstream::binary);
	// Couldnt open file so quit
    if (!file)
	{
		MessageBox( NULL, "Couldnt save to file!\nCritical Error!", "Error!", MB_OK|MB_ICONERROR );
		return &ok;
	}
	// We are good to go! Save the mesh
	
	WritePLY(p_snode, file, varg_ascii->to_bool());

	// Done, close the file
	//file->close();
	fclose(file);
	return &ok;
}
