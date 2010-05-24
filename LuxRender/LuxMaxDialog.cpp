#include "LuxMax.h"
#include "resource.h"
#include "3dsmaxport.h"
#include <string>
#include "LuxMaxDialog.h"
#include "stdmat.h"


LuxMaxParamDlg::~LuxMaxParamDlg()
{
	DeleteObject(hFont);
	renderparam->DeleteRollupPage(hOutputPanel);
	renderparam->DeleteRollupPage(hSystemPanel);
}

INT_PTR LuxMaxParamDlg::WndProc(HWND hWnd,UINT msg,WPARAM wParam,LPARAM lParam)
{
	switch (msg)
	{
		case WM_INITDIALOG:
			//if (prog)
			//	InitProgDialog(hWnd);
			//else
			InitParamDialog(hWnd);
			break;

		case WM_DESTROY:
			if (!prog) ReleaseControls();
				break;
		default:
			return FALSE;
	}
	return TRUE;
}

static INT_PTR CALLBACK LuxMaxOutputParamDlgProc(HWND hWnd,UINT msg,WPARAM wParam,LPARAM lParam)
{
	Interface* ip2 = GetCOREInterface7();
	Interface* ip8 = GetCOREInterface8();
	Interface* ip9 = GetCOREInterface9();
	Interface* ip = GetCOREInterface();
	Texmap* texmap;

	FilterList* filterlist;
	BitmapManager* bmgr ;//= BitmapManager();
	BitmapFileInputDialog* bfdlg;

	LuxMaxParamDlg *dlg = DLGetWindowLongPtr<LuxMaxParamDlg*>(hWnd);
	switch (msg)
	{

		 if ( LOWORD( wParam ) == IDC_AUTOFOCUS ) 
        {
          TSTR buf;
		buf.printf(_T("test"));
       MessageBox(ip->GetMAXHWnd(), buf, _T("Info..."),
       MB_ICONINFORMATION);

        }
		break;
	
	case IDC_LXSENV_BUTTON:
			SetDlgItemText(hWnd, IDC_LXSENV, dlg->workFileName.data());
				ip2->FileOpen();
			break;


	case WM_INITDIALOG:
			{
			dlg = (LuxMaxParamDlg*)lParam;
			DLSetWindowLongPtr(hWnd, lParam);
			//ip2->FileOpen();
			}
			break;
		case WM_LBUTTONDOWN:
		case WM_MOUSEMOVE:
		
		case WM_LBUTTONUP:
			dlg->renderparam->RollupMouseMessage(hWnd,msg,wParam,lParam);	
			break;

		case WM_COMMAND:
			{
				if (wParam == 1001)
				{
					if (dlg->FileBrowse())
					{
						SetDlgItemText(hWnd, IDC_LXSOUTPUT, dlg->workFileName.data());
						//ip2->FileOpen();
					}
				//ip2->FileOpen();
					//ip2->FileSaveAs();
				break;
				}

				if (wParam == 1011)
				{
				//	SetDlgItemText(hWnd, IDC_LXSOUTPUT, dlg->workFileName.data());
				//This is the button for choosing environment map..
					
//DoMaxOpenDialog (HWND parentWnd, const MSTR &title, MSTR &filename, MSTR &initialDir, FilterList &extensionList)=0 
//  Opens a max-style Open dialog for generic file types.  
					

	//BOOL two;
 //  float utile, vtile;
 //  MCHAR* name;
 //  TSTR buf;
	// Texmap *tmap = ip2->GetEnvironmentMap(); //m->GetSubTexmap(ID_DI);
 //    if (tmap->ClassID() == Class_ID(BMTEX_CLASS_ID, 0))
 //    {
 //      // It is -- Access the UV tiling settings at time 0.
 //      BitmapTex *bmt = (BitmapTex*) tmap;
 //      StdUVGen *uv = bmt->GetUVGen();
 //      utile = uv->GetUScl(0);
 //      vtile = uv->GetVScl(0);
	//	name = bmt->GetMapName();
 //      buf.printf(_T("Two sided=%d, U Tile = %.1f, V Tile = %.1f, Name = %s"),
 //      two, utile, vtile, name);
 //      MessageBox(ip->GetMAXHWnd(), buf, _T("Info..."),
 //      MB_ICONINFORMATION);
	}
break;				
}

if (wParam == 1013)
{
//	//ip2->FileOpen();
	   TSTR buf;
		buf.printf(_T("test"));
       MessageBox(ip->GetMAXHWnd(), buf, _T("Info..."),
       MB_ICONINFORMATION);

	break;
}
//else
//{
//	break;
//}
//			}
//break;
	

		case IDC_LXSOUTPUT_BUTTON:
			//ip2->FileOpen();
			if (dlg->FileBrowse())
			{
				SetDlgItemText(hWnd, IDC_LXSOUTPUT, dlg->workFileName.data());
			//ip2->FileOpen();
			}
			break;

		case IDC_AUTOFOCUS:
			{
				
			}
			break;
			
		 default:
			{
			        return DefWindowProc(hWnd, msg, wParam, lParam);
			}
			break;

		case CC_SPINNER_CHANGE:   
		{
		}
		break;
	}  
	if (dlg)
		return dlg->WndProc(hWnd,msg,wParam,lParam);
	else
		//return dlg->WndProc(hWnd,msg,wParam,lParam);
		return FALSE;
}

static INT_PTR CALLBACK LuxMaxSystemParamDlgProc(HWND hWnd,UINT msg,WPARAM wParam,LPARAM lParam)
{
	return FALSE;
}

LuxMaxParamDlg::LuxMaxParamDlg(LuxMax *rdr, IRendParams *irp, BOOL prog)
{
	hFont = hFont = CreateFont(14,0,0,0,FW_BOLD,0,0,0,0,0,0,0, VARIABLE_PITCH | FF_SWISS, _T(""));
	
	renderer = rdr;
	renderparam = irp;

	this->prog = prog;
	if (prog)
	{    
		//hPanel = ir->AddRollupPage(hInstance, MAKEINTRESOURCE(IDD_RENDVUE_PROG), RendVueParamDlgProc, GetString(IDS_VRENDTITLE), (LPARAM)this);
	}
	else
	{
		hPresetsPanel = PresetsRollout_Create(rdr, irp, (LPARAM)this); // Add preset rollout
		//hEnvMapPanel = irp->AddRollupPage(hInstance, MAKEINTRESOURCE(IDD_ENV_PARAMS), LuxMaxOutputParamDlgProc, _T("Environment"), (LPARAM)this);//IDD_ENV_PARAMS
		//hSystemPanel = irp->AddTabRollupPage(LUXRENDER_LUXSYSTEM_ID, hInstance, MAKEINTRESOURCE(IDD_SYSTEM_PARAMS), LuxMaxSystemParamDlgProc, _T("System"), (LPARAM)this);
		hOutputPanel = irp->AddRollupPage(hInstance, MAKEINTRESOURCE(IDD_OUTPUT_PARAMS), LuxMaxOutputParamDlgProc, _T("Output"), (LPARAM)this);
		hAboutPanel = irp->AddRollupPage(hInstance, MAKEINTRESOURCE(IDD_ABOUT_PARAMS), LuxMaxOutputParamDlgProc, _T("About Luxrender"), (LPARAM)this);

		//hserverPanel = irp->AddRollupPage(hInstance, MAKEINTRESOURCE(IDD_SRV_PARAMS), LuxMaxOutputParamDlgProc, _T("Network render"), (LPARAM)this);
	}
}

void LuxMaxParamDlg::InitParamDialog(HWND hWnd)
{
	workFileName = renderer->FileName;
	SetDlgItemText(hWnd, IDC_LXSOUTPUT, workFileName);
	//SetDlgItemText(hWnd, IDC_STATIC_ENV_MAP_PATH, workFileName);
	// Init all the rollouts
	PresetsRollout_CreateControls(hWnd, renderer->selectedpreset);
}

void LuxMaxParamDlg::AcceptParams()
{
	renderer->FileName = workFileName;
	renderer->selectedpreset = SelectedPreset;
}

RendParamDlg * LuxMax::CreateParamDialog(IRendParams *ir,BOOL prog)
{
	return new LuxMaxParamDlg(this,ir,prog);
}

// File Browse ------------------------------------------------------------
BOOL FileExists(TCHAR *filename)
{
     HANDLE findhandle;
     WIN32_FIND_DATA file;
     findhandle = FindFirstFile(filename,&file);
     FindClose(findhandle);
     if (findhandle == INVALID_HANDLE_VALUE)
        return(FALSE);
     else
        return(TRUE);
}

BOOL RunningNewShell() 
{
	OSVERSIONINFO os;
	os.dwOSVersionInfoSize = sizeof(OSVERSIONINFO);
	GetVersionEx(&os);
	if (os.dwPlatformId == VER_PLATFORM_WIN32_NT && os.dwMajorVersion < 4)
		return FALSE;
	return TRUE;
}
   

#define VUEEXT _T(".lxs")
#define VUEFILTER _T("*.lxs")


void FixFileExt(OPENFILENAME &ofn, TCHAR* ext = VUEEXT)
{
	int l = static_cast<int>(_tcslen(ofn.lpstrFile));  // SR DCAST64: Downcast to 2G limit.
	int e = static_cast<int>(_tcslen(ext));   // SR DCAST64: Downcast to 2G limit.
	if (_tcsicmp(ofn.lpstrFile+l-e, ext))
	{
		_tcscat(ofn.lpstrFile,ext);   
	}
}


BOOL LuxMaxParamDlg::FileBrowse()
{
	int tried = 0;
	FilterList filterList;
	HWND hWnd = hOutputPanel;
	//HWND hWnd =hEnvMapPanel;
	static int filterIndex = 1;
	OPENFILENAME  ofn;
	TSTR filename;
	TCHAR fname[512];
	TCHAR saveDir[1024];
	{
		TSTR dir;
		SplitFilename(workFileName, &dir, &filename,NULL);
		_tcscpy(saveDir,dir.data());
	}
	_tcscpy(fname,filename.data());
	_tcscat(fname, VUEEXT);

	filterList.Append(_T("LXS File"));
	
	filterList.Append(VUEFILTER);

	memset(&ofn, 0, sizeof(ofn));

	ofn.lStructSize      = sizeof(OPENFILENAME);  // No OFN_ENABLEHOOK
	ofn.hwndOwner        = hWnd;
	ofn.hInstance        = hInstance;   


	ofn.nFilterIndex = filterIndex;
	ofn.lpstrFilter  = filterList;

	ofn.lpstrTitle   = _T("Select lxs file to write"); 
	ofn.lpstrFile    = fname;
	ofn.nMaxFile     = sizeof(fname) / sizeof(TCHAR);      

	Interface *iface = GetCOREInterface();

	if(saveDir[0])
		ofn.lpstrInitialDir = saveDir;
	else
		ofn.lpstrInitialDir = iface->GetDir(APP_SCENE_DIR);

	if(RunningNewShell())
	{
		ofn.Flags = OFN_HIDEREADONLY | OFN_EXPLORER /* | OFN_ENABLEHOOK | OFN_ENABLETEMPLATE*/;  // OFN_OVERWRITEPROMPT;
		ofn.lpfnHook = NULL;// (LPOFNHOOKPROC)FileHook;
		ofn.lCustData = 1;      // 0 for save, 1 for open
		
		//    ofn.lpTemplateName = MAKEINTRESOURCE(IDD_EXT_FILE);
	}
	else
	{
		ofn.Flags           =   OFN_HIDEREADONLY | OFN_PATHMUSTEXIST /* |OFN_ENABLEHOOK  | OFN_ENABLETEMPLATE */;
		ofn.lpfnHook        =   NULL; // (LPOFNHOOKPROC)PMFileHook;
		ofn.lCustData       =   1;
		//    ofn.lpTemplateName     =   MAKEINTRESOURCE(IDD_PM_EXT_FILE);
	}

	ofn.FlagsEx = OFN_EX_NOPLACESBAR;

	FixFileExt(ofn,VUEEXT); // add ".vue" if absent

	while (GetSaveFileName(&ofn))
	{
		FixFileExt(ofn,VUEEXT); // add ".vue" if absent
		workFileName = ofn.lpstrFile;
		return TRUE;
	}
	return FALSE;
}

// Return the extension interfaces for the renderer.
// This returns ITabDialogObject interface, so the render
// dialog can interact with the mental ray renderer.
BaseInterface* LuxMax::GetInterface ( Interface_ID id )
{
   if ( id == TAB_DIALOG_OBJECT_INTERFACE_ID ) {
      ITabDialogObject* r = this;
      return r;
   }
   else {
      return Renderer::GetInterface ( id );
   }
}

void LuxMax::AddTabToDialog ( ITabbedDialog* dialog, ITabDialogPluginTab* tab )
{
   dialog->AddRollout ( _T("Luxrender"), NULL, LUXRENDER_LUXRENDER_ID, tab, -1, 222, 0, 0, ITabbedDialog::kSystemPage );
   //dialog->AddRollout ( _T("Environment"), NULL, LUXRENDER_LUXCAMENV_ID, tab, -1, 222, 0, 0, ITabbedDialog::kSystemPage );
   //dialog->AddRollout ( _T("Output"), NULL, LUXRENDER_LUXOUTPUT_ID, tab, -1, 222, 0, 0, ITabbedDialog::kSystemPage );
   //dialog->AddRollout ( _T("System"), NULL, LUXRENDER_LUXSYSTEM_ID, tab, -1, 222, 0, 0, ITabbedDialog::kSystemPage );
}


// Return a combination of TAB_DIALOG_ADD_TAB and TAB_DIALOG_REMOVE_TAB
// to indicate whether the pages for the plugin tab are to be
// added or removed. TAB_DIALOG_REMOVE_TAB is only needed to
// both remove and add the plugin tab's pages. If the pages
// are not added, they will be removed.
int LuxMax::AcceptTab ( ITabDialogPluginTab* tab )
{
   switch ( tab->GetSuperClassID ( ) ) {
   case RADIOSITY_CLASS_ID:
      return 0;         // Don't show the advanced lighting tab
   }

   Class_ID id = tab->GetClassID ( );
   if ( id == blurRaytrace )
      return 0;         // Don't show the blur raytracer tab

   // Accept all other tabs
   return TAB_DIALOG_ADD_TAB;
}
