--// Get Camera FOV in luxrender expected format
function GetCameraFov fov =
(
	if (renderwidth < renderheight) then return fov
	
	r_aspect = renderwidth as float / renderheight as float
	fov = 2.0 * (RADTODEG(atan(tan(DEGTORAD(fov / 2.0)) / r_aspect)))
	return fov
)

function GetScreenWindow xr yr shiftx shifty =
(
	sw = #(0, 0, 0, 0)
	
	_scale = 1.0
	
	aspect = xr as float / yr as float
	invaspect = 1.0 / aspect
	
	if aspect > 1.0 then
	(
		sw[1] = ((2.0 * shiftx) - 1) * _scale
		sw[2] = ((2.0 * shiftx) + 1) * _scale
		sw[3] = ((2.0 * shifty) - invaspect) * _scale
		sw[4] = ((2.0 * shifty) + invaspect) * _scale
	)
	else
	(
		sw[1] = ((2.0 * shiftx) - aspect) * _scale
		sw[2] = ((2.0 * shiftx) + aspect) * _scale
		sw[3] = ((2.0 * shifty) - 1) * _scale
		sw[4] = ((2.0 * shifty) + 1) * _scale
	)
	
	return sw
)
-- // Write camera to lxs file (p_camera: camera object node, f: outputstream)
function writeCamera p_camera strout =
(
	m3_camera = undefined

	--// Check if we have a camera object. Use the current viewport if we dont
	if (p_camera == undefined) then
	(
		--// Check if we have a perspective viewport
		if (viewport.IsPerspView() == false) then
		(
			messagebox "No Camera selected of viewport is not Perspective."
			return false
		)
		
		m3_camera = Inverse(getViewTM())
	)
	else
		m3_camera = p_camera.transform
	
	--// Generate camera look at
	pos = m3_camera.row4
	up = normalize m3_camera.row2
	look = (m3_camera.row4 + -(normalize m3_camera.row3))
	format "LookAt % % % % % % % % %\n" (pos.x / 100.0) (pos.y / 100.0) (pos.z / 100.0) (look.x / 100.0) (look.y / 100.0) (look.z / 100.0) up.x up.y up.z to:strout
		
	--// Try max standard camera
	if (classof p_camera == Freecamera or classof p_camera == Targetcamera) then
	(
		format "Camera \"perspective\"\n" to:strout
		format "\t\"float fov\" [%]\n" (GetCameraFov (p_camera.fov)) to:strout
	)
	--// Try LuxRender Compatible camera
	else if ((CheckLuxRenderCompat p_camera) == true) then
	(
		format "%" (p_camera.GetLuxRenderString()) to:strout
	)
	--// No camera defined. use viewport if possible
	else
	(
		format "Camera \"perspective\"\n" to:strout
		format "\t\"float fov\" [%]" (GetCameraFov (getViewFOV())) to:strout
	)
)