(
	global lux_renderBuffer = undefined
	global lux_outputbmp = undefined
	
	rollout lux_renderBuffer "LuxRender -"
	(
		dotnetControl pictureBox1 "System.Windows.Forms.PictureBox" width:1 height:1 pos:[12, 12] bgcolor:black
		timer timer1 "" interval:1000
		
		function updateRenderBuffer =
		(
			try (
				_bitmapStream = dotNetObject "System.IO.FileStream" ((getLuxValue "btn_outputpath") + "\\" + getSceneName() + "_" + getFrame() + ".png") (dotNetClass "System.IO.FileMode").Open (dotNetClass "System.IO.FileAccess").Read (dotNetClass "System.IO.FileShare").ReadWrite
				_bitmap = dotNetObject "System.Drawing.Bitmap" _bitmapStream
				
				pictureBox1.Image =_bitmap.Clone()
				
				_bitmapStream.Close()
				_bitmap.Dispose()
				_bitmapStream.Dispose()
			) catch ()
		)
		
		on timer1 tick do
		(
			updateRenderBuffer()
		)
	)
	
	function lux_OpenRenderBuffer _title _width _height _updateinterval =
	(
		if (lux_renderBuffer != undefined) then try (destrydialog lux_renderBuffer) catch ()
		createdialog lux_renderBuffer (_width + 24) (_height + 24)
		lux_renderBuffer.title = ("LuxRender - " + _title)
		lux_renderBuffer.pictureBox1.width = _width
		lux_renderBuffer.pictureBox1.height = _height
		
		lux_renderBuffer.timer1.interval = (_updateinterval * 1000)
	)
)