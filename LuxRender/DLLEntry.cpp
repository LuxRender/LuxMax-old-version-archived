#include "LuxMax.h"

extern ClassDesc2* GetLuxMaxDesc();

HINSTANCE hInstance;
BOOL WINAPI DllMain(HINSTANCE hinstDLL,ULONG fdwReason,LPVOID /*lpvReserved*/)
{
	if( fdwReason == DLL_PROCESS_ATTACH )
	{
		// Hang on to this DLL's instance handle.
		hInstance = hinstDLL;
		DisableThreadLibraryCalls(hInstance);
	}
	return(TRUE);
}

__declspec( dllexport ) const TCHAR *LibDescription() { return _T("3dsmax LuxRender"); }
__declspec( dllexport ) int LibNumberClasses() { return 1; }
__declspec( dllexport ) ClassDesc* LibClassDesc(int i)
{
	switch(i)
	{
		case 0: return GetLuxMaxDesc();
		default: return 0;
	}
}

__declspec( dllexport ) ULONG LibVersion() { return VERSION_3DSMAX; }
__declspec( dllexport ) int LibInitialize(void) { return TRUE; }
__declspec( dllexport ) int LibShutdown(void) { return TRUE; }