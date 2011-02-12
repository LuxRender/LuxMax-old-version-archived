#include "maxscript\maxscript.h"

HMODULE hInstance = NULL;

BOOL APIENTRY DllMain(HMODULE hModule, DWORD ul_reason_for_call, LPVOID lpReserved)
{
	static BOOL controlsInit = FALSE;
	switch (ul_reason_for_call)
	{
		case DLL_PROCESS_ATTACH:
			hInstance = hModule;
			break;
	}
		
	return(TRUE);
}

void InitFunction()
{

}

__declspec( dllexport ) void LibInit() { InitFunction(); }
__declspec( dllexport ) const TCHAR *LibDescription() { return _T("Maxscript extentions"); }
__declspec( dllexport ) ULONG LibVersion() {  return VERSION_3DSMAX; }

