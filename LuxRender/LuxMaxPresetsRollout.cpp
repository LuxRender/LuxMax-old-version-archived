/*
==============================================================================

LuxMaxPresetsRollout.cpp, Preset selection rollout.

Author: Guillaume Plourde,

==============================================================================
*/

#include "LuxMax.h"
#include "resource.h"
#include "3dsmaxport.h"
#include "LuxMaxDialog.h"

void PresetsRollout_GetSelected(HWND hWnd, LuxMaxParamDlg* dlg)
{
	HWND dd = GetDlgItem(hWnd,IDC_PRESETS);
	dlg->SelectedPreset = (int)SendMessage(dd,CB_GETCURSEL, 0,0);
}

void PresetsRollout_CreateControls(HWND hWnd, int selection)
{
	HWND cb_preset = GetDlgItem(hWnd, IDC_PRESETS);

	SendMessage(cb_preset, CB_RESETCONTENT,(WPARAM)0,(LPARAM)0);
	SendMessage(cb_preset, CB_ADDSTRING,0,(LPARAM)"Preview - Default");
	SendMessage(cb_preset, CB_ADDSTRING,0,(LPARAM)"Preview - Direct Lighting");
	SendMessage(cb_preset, CB_ADDSTRING,0,(LPARAM)"Final - MLT/BIDIR Path Tracing (interior) (Recommended)");
	SendMessage(cb_preset, CB_ADDSTRING,0,(LPARAM)"Final - MLT/BIDIR Path Tracing (exterior)");
	SendMessage(cb_preset, CB_ADDSTRING,0,(LPARAM)"Custom Settings");
	SendMessage(cb_preset, CB_SETCURSEL, selection, 0);
}

static INT_PTR CALLBACK LuxMaxPresetsRolloutProc(HWND hWnd,UINT msg,WPARAM wParam,LPARAM lParam)
{
	LuxMaxParamDlg *dlg = DLGetWindowLongPtr<LuxMaxParamDlg*>(hWnd);

	switch (msg)
	{
		case WM_INITDIALOG:
			dlg = (LuxMaxParamDlg*)lParam;
			DLSetWindowLongPtr(hWnd, lParam);
			break;
		case WM_LBUTTONDOWN:
		case WM_MOUSEMOVE:
		case WM_LBUTTONUP:
			dlg->renderparam->RollupMouseMessage(hWnd,msg,wParam,lParam);
			break;
		case WM_COMMAND:
		case IDC_PRESETS:
			PresetsRollout_GetSelected(hWnd, dlg);
			break;
		case CC_SPINNER_CHANGE:   
		{
		}
		break;
	}  
	if (dlg)
		return dlg->WndProc(hWnd,msg,wParam,lParam);
	else
		return FALSE;
}
HWND PresetsRollout_Create(LuxMax *rp, IRendParams *irp, LPARAM lParam)
{
	return irp->AddRollupPage(hInstance, MAKEINTRESOURCE(IDD_PRESETS_PARAMS), LuxMaxPresetsRolloutProc, _T("Presets"), lParam);
}