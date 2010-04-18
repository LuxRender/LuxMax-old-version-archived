static const Class_ID blurRaytrace ( 0x4fa95e9b, 0x9a26e66 );

class LuxMaxParamDlg : public RendParamDlg
{
public:
   LuxMaxParamDlg(LuxMax *r,IRendParams *i,BOOL prog);
   ~LuxMaxParamDlg();

   LuxMax *renderer;
   IRendParams *renderparam;

   HWND hOutputPanel;
   HWND hSystemPanel;
   HWND hPresetsPanel;
   HWND hAboutPanel;
   HWND hEnvMapPanel;

   BOOL prog;
   HFONT hFont;
   TSTR workFileName;
   TSTR workEnvironmentFileName;
   int SelectedPreset;

   void AcceptParams();
   void DeleteThis() {delete this;}
   void InitParamDialog(HWND hWnd);
   void InitPresetsParamDialog(HWND hWnd);
   void ReleaseControls() {}

   BOOL FileBrowse();
   INT_PTR WndProc(HWND hWnd,UINT msg,WPARAM wParam,LPARAM lParam);
};


void PresetsRollout_GetSelected(HWND hWnd, LuxMaxParamDlg* dlg);
void PresetsRollout_CreateControls(HWND hWnd, int selection);
HWND PresetsRollout_Create(LuxMax *rp, IRendParams *irp, LPARAM lParam);