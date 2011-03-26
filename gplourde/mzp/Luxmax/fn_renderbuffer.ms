(
	global lux_outputbmp = undefined
	
	function lux_OpenRenderBuffer =
	(
		theFrm = dotNetObject "MaxCustomControls.MaxForm"
		theFrm.width = 1280
		theFrm.height = 720
		theFrm.text = "LuxRender"
		
		pictureBox1 =dotNetObject "System.Windows.Forms.PictureBox"
		
		pictureBox1.Image = dotNetObject "System.Drawing.Bitmap" ("c:\\tmp\\teapot.png")
		pictureBox1.width = 1280
		pictureBox1.height = 720
		pictureBox1.location = dotNetObject "System.Drawing.Point" 0 0
	
		theFrm.controls.add(pictureBox1)
		
		thePtr = DotNetObject "System.IntPtr" (windows.getMAXHWND())
		theHwnd = DotNetObject "MaxCustomControls.Win32HandleWrapper" thePtr
		theFrm.Show(theHwnd)
	)
	
	lux_OpenRenderBuffer()
)