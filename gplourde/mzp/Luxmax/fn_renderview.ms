(
	--// comment out for release
	include "luxmax\\fn_common.ms"
	
	global lux_renderBuffer = undefined
	global lux_outputbmp = undefined
	
	--if (lux_ConsoleProcess == undefined) then global lux_ConsoleProcess = undefined
	
	function updateRenderBuffer =
	(
		try (
			_bitmapStream = dotNetObject "System.IO.FileStream" ("c:\\tmp" + "\\" + getSceneName() + "_" + getFrame() + ".png") (dotNetClass "System.IO.FileMode").Open (dotNetClass "System.IO.FileAccess").Read (dotNetClass "System.IO.FileShare").ReadWrite
			local _bitmap = dotNetObject "System.Drawing.Bitmap" _bitmapStream

			_bitmapStream.Dispose()
			return _bitmap.Clone()
			
		
		) catch
		(
			local _bitmap = dotNetObject "System.Drawing.Bitmap" 1 1
			return _bitmap
		)
	)
	
	function writeError err =
	(
		print err
	)

	function writeOut err =
	(
		print err
	)
	
	function lux_OpenRenderBuffer _title _width _height _updateinterval _lxs =
	(
		if (lux_ConsoleProcess != undefined) then
		(
			try
			(
				lux_ConsoleProcess.Kill()
			) catch()
		)
				
		if (lux_renderBuffer != undefined) then try
		(
			lux_ConsoleProcess.Stop()
			lux_ConsoleProcess.Kill()
			lux_ConsoleProcess.Dispose()
			destrydialog lux_renderBuffer
		) catch ()
		
		if (lux_ConsoleProcess == undefined) then
			global lux_ConsoleProcess = DotNetObject "System.Diagnostics.Process"
		
		lux_ConsoleProcess.StartInfo.UseShellExecute = false
        lux_ConsoleProcess.StartInfo.FileName = "e:\\luxrender\\luxconsole.exe"
		lux_ConsoleProcess.StartInfo.Arguments = "\"c:\\tmp\\teapot & test_000000.lxs\""
        lux_ConsoleProcess.StartInfo.CreateNoWindow = false
		lux_ConsoleProcess.EnableRaisingEvents = false
		
		lux_ConsoleProcess.StartInfo.RedirectStandardInput = true
		lux_ConsoleProcess.StartInfo.RedirectStandardOutput = true
		lux_ConsoleProcess.StartInfo.RedirectStandardError = true		

		
		dotNet.addEventHandler lux_ConsoleProcess "ErrorDataReceived" writeError
		--dotNet.addEventHandler lux_ConsoleProcess "OutputDataReceived " writeOut
		
		lux_ConsoleProcess.Start()
		
		--lux_ConsoleProcess.BeginOutputReadLine()
		--lux_ConsoleProcess.BeginErrorReadLine()
		
		createdialog lux_renderBuffer (_width + 24) (_height + 24)
		
		lux_renderBuffer.title = ("LuxRender - " + _title)
		lux_renderBuffer.pictureBox1.width = _width
		lux_renderBuffer.pictureBox1.height = _height
		
		lux_renderBuffer.timer1.interval = (_updateinterval * 1000)
	)

	rollout lux_renderBuffer "LuxRender -"
	(
		dotnetControl pictureBox1 "System.Windows.Forms.PictureBox" width:1 height:1 pos:[12, 12] bgcolor:black
		timer timer1 "" interval:1000
		timer timer2 "" interval:1000
		
		on lux_renderBuffer close do
		(
			try (lux_ConsoleProcess.Kill()) catch()
		)
		on timer1 tick do
		(
			pictureBox1.Image = updateRenderBuffer()

		)
		on timer2 tick do
		(

		)
	)
		
	lux_OpenRenderBuffer "" 600 300 10 "c:\\tmp\\teapot & test_000000.lxs"
)