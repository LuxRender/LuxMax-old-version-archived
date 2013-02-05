#include "max.h"
#include "maxscript.h"
#include <fstream>
#include <iostream>
#include <cstring>
#include "maxscript\macros\define_instantiation_functions.h"
#include <tchar.h>
void WriteMeshes(INode* p_node, FILE* s_pStream);
void WritePLY(INode* p_node, FILE* file, bool ascii);

def_visible_primitive_debug_ok(LMX_ExportMesh, "LMX_ExportMesh");
def_visible_primitive_debug_ok(LMX_ExportPLY, "LMX_ExportPLY");

//Version 15 is 3dsmax 2013
//MAX_VERSION_MAJOR
#if MAX_VERSION_MAJOR < 15
const std::string & getstring(const char* str)
{
	return str;	
}
#else
const std::string & getstring(const wchar_t* wstr)
{
	std::wstring ws(wstr);
	return std::string( ws.begin(), ws.end() );
	
}
#endif


Value *LMX_ExportMesh_cf(Value **arg_list, int count)
{
	TSTR Path, Filename, Extention;
	FILE* s_pStream;

	Interface *ip = GetCOREInterface();

	Value* varg_source =arg_list[0];
	Value* varg_target = arg_list[1];

	INode* p_snode = varg_source->to_node(); 


			//Max 2013 SDK
		std::wstring ws(arg_list[1]->to_string());
		std::string str( ws.begin(), ws.end() );
		TCHAR *param=new TCHAR[str.size()+1];
		param[str.size()]=0;
		TCHAR* s_name = param;

		#if MAX_VERSION_MAJOR < 15
			char* newString = new char[200]; 
			std::strcpy(newString, s_name);
			//WriteMeshBinary(varg_source->to_node(), newString);
			delete [] newString;
	#else
			std::string newString = getstring(s_name);
			//WriteMeshBinary(varg_source->to_node(), newString.c_str());
	#endif
	
	// Open file for write
	fopen_s(&s_pStream, newString.c_str(), "w");
	// Couldnt open file so quit
    if ( s_pStream == NULL )
	{
		//mprintf(L"!!ERROR from c++ plugin!! %s \n", ex.message);
		MessageBox( NULL, L"Couldnt save to file!\nCritical Error!", L"Error!", MB_OK|MB_ICONERROR );
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
	
		std::wstring ws(arg_list[1]->to_string());
		std::string str( ws.begin(), ws.end() );
		TCHAR *param=new TCHAR[str.size()+1];
		param[str.size()]=0;
		TCHAR* s_name = param;


//	TCHAR* s_name = param;

	#if MAX_VERSION_MAJOR < 15
			char* newString = new char[200]; 
			std::strcpy(newString, s_name);
			WriteMeshBinary(varg_source->to_node(), newString);
			delete [] newString;
	#else
			std::string newString = getstring(s_name);
			//WriteMeshBinary(varg_source->to_node(), newString.c_str());
	#endif
	fopen_s(&file, newString.c_str(), "wb");

    if (!file)
	{
		MessageBox( NULL, L"Couldnt save to file!\nCritical Error!", L"Error!", MB_OK|MB_ICONERROR );
		return &ok;
	}
	
	WritePLY(p_snode, file, varg_ascii->to_bool());

	fclose(file);
	return &ok;
}
