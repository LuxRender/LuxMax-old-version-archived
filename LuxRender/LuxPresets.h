TSTR PRESET_PREVIEW()
{
	return	"\t\"integer haltspp\" [0]\n\t\
\"bool premultiplyalpha\" [\"false\"]\n\t\
\"string tonemapkernel\" [\"reinhard\"]\n\t\
\"float reinhard_prescale\" [1.000000]\n\t\
\"float reinhard_postscale\" [1.200000]\n\t\
\"float reinhard_burn\" [6.000000]\n\t\
\"integer displayinterval\" [4]\n\t\
\"integer writeinterval\" [120]\n\t\
\"string ldr_clamp_method\" [\"lum\"]\n\t\
\"bool write_exr\" [\"true\"]\n\t\
\"bool write_png\" [\"true\"]\n\t\
\"string write_png_channels\" [\"RGB\"]\n\t\
\"bool write_png_16bit\" [\"false\"]\n\t\
\"bool write_png_gamutclamp\" [\"true\"]\n\t\
\"bool write_tga\" [\"false\"]\n\t\
\"string filename\" [\"C:\\LuxRender\\\\default\"]\n\t\
\"bool write_resume_flm\" [\"false\"]\n\t\
\"bool restart_resume_flm\" [\"true\"]\n\t\
\"integer reject_warmup\" [128]\n\t\
\"bool debug\" [\"false\"]\n\t\
\"float colorspace_white\" [0.314275 0.329411]\n\t\
\"float colorspace_red\" [0.630000 0.340000]\n\t\
\"float colorspace_green\" [0.310000 0.595000]\n\t\
\"float colorspace_blue\" [0.155000 0.070000]\n\t\
\"float gamma\" [2.200000] \n\t\
\n\t\
PixelFilter \"mitchell\" \n\t\
\"float B\" [0.750000]\n\t\
\"float C\" [0.125000]\n\t\
\n\t\
Sampler \"lowdiscrepancy\"\n\t\
\"string pixelsampler\" [\"lowdiscrepancy\"]\n\t\
\"integer pixelsamples\" [1]\n\t\
\n\t\
SurfaceIntegrator \"directlighting\"\n\t\
\"integer maxdepth\" [5]\n\t\
\n\t\
VolumeIntegrator \"single\"\n\t\
\"float stepsize\" [1.000000]\n\t\
\n\t\
Accelerator \"tabreckdtree\"\n\t\
\"integer intersectcost\" [80]\n\t\
\"integer traversalcost\" [1]\n\t\
\"float emptybonus\" [0.200000]\n\t\
\"integer maxprims\" [1]\n\t\
\"integer maxdepth\" [-1]\n ";
}

TSTR PRESET_FINAL_INTERIOR()
{
	return	"\t\"integer haltspp\" [0] \n\t\
\"bool premultiplyalpha\" [\"false\"] \n\t\
\"string tonemapkernel\" [\"reinhard\"] \n\t\
\"float reinhard_prescale\" [1.000000] \n\t\
\"float reinhard_postscale\" [1.200000] \n\t\
\"float reinhard_burn\" [6.000000] \n\t\
\"integer displayinterval\" [8] \n\t\
\"integer writeinterval\" [120] \n\t\
\"string ldr_clamp_method\" [\"lum\"] \n\t\
\"bool write_exr\" [\"true\"] \n\t\
\"bool write_png\" [\"true\"] \n\t\
\"string write_png_channels\" [\"RGB\"] \n\t\
\"bool write_png_16bit\" [\"false\"] \n\t\
\"bool write_png_gamutclamp\" [\"true\"] \n\t\
\"bool write_tga\" [\"false\"] \n\t\
\"string filename\" [\"C:\\LuxRender\\\\default\"] \n\t\
\"bool write_resume_flm\" [\"false\"] \n\t\
\"bool restart_resume_flm\" [\"true\"] \n\t\
\"integer reject_warmup\" [128] \n\t\
\"bool debug\" [\"false\"] \n\t\
\"float colorspace_white\" [0.314275 0.329411] \n\t\
\"float colorspace_red\" [0.630000 0.340000] \n\t\
\"float colorspace_green\" [0.310000 0.595000] \n\t\
\"float colorspace_blue\" [0.155000 0.070000] \n\t\
\"float gamma\" [2.200000] \n\t\
\n\t\
PixelFilter \"mitchell\" \n\t\
\"float B\" [0.750000] \n\t\
\"float C\" [0.125000] \n\t\
\n\t\
Sampler \"metropolis\" \n\t\
\"float largemutationprob\" [0.400000] \n\t\
\n\t\
SurfaceIntegrator \"bidirectional\" \n\t\
\"integer eyedepth\" [16] \n\t\
\"integer lightdepth\" [16] \n\t\
\n\t\
VolumeIntegrator \"single\" \n\t\
\"float stepsize\" [1.000000] \n\t\
\n\t\
Accelerator \"tabreckdtree\" \n\t\
\"integer intersectcost\" [80] \n\t\
\"integer traversalcost\" [1] \n\t\
\"float emptybonus\" [0.200000] \n\t\
\"integer maxprims\" [1] \n\t\
\"integer maxdepth\" [-1] \n";
}

TSTR PRESET_FINAL_EXTERIOR()
{
	return	"\t\"integer haltspp\" [0] \n\t\
\"bool premultiplyalpha\" [\"false\"] \n\t\
\"string tonemapkernel\" [\"reinhard\"] \n\t\
\"float reinhard_prescale\" [1.000000] \n\t\
\"float reinhard_postscale\" [1.200000] \n\t\
\"float reinhard_burn\" [6.000000] \n\t\
\"integer displayinterval\" [8] \n\t\
\"integer writeinterval\" [120] \n\t\
\"string ldr_clamp_method\" [\"lum\"] \n\t\
\"bool write_exr\" [\"true\"] \n\t\
\"bool write_png\" [\"true\"] \n\t\
\"string write_png_channels\" [\"RGB\"] \n\t\
\"bool write_png_16bit\" [\"false\"] \n\t\
\"bool write_png_gamutclamp\" [\"true\"] \n\t\
\"bool write_tga\" [\"false\"] \n\t\
\"string filename\" [\"C:\\LuxRender\\\\default\"] \n\t\
\"bool write_resume_flm\" [\"false\"] \n\t\
\"bool restart_resume_flm\" [\"true\"] \n\t\
\"integer reject_warmup\" [128] \n\t\
\"bool debug\" [\"false\"] \n\t\
\"float colorspace_white\" [0.314275 0.329411] \n\t\
\"float colorspace_red\" [0.630000 0.340000] \n\t\
\"float colorspace_green\" [0.310000 0.595000] \n\t\
\"float colorspace_blue\" [0.155000 0.070000] \n\t\
\"float gamma\" [2.200000] \n\t\
 \n\t\
PixelFilter \"mitchell\" \n\t\
\"float B\" [0.750000] \n\t\
\"float C\" [0.125000] \n\t\
 \n\t\
Sampler \"metropolis\" \n\t\
\"float largemutationprob\" [0.400000] \n\t\
 \n\t\
SurfaceIntegrator \"path\" \n\t\
\"integer maxdepth\" [10] \n\t\
\"bool includeenvironment\" [\"true\"] \n\t\
 \n\t\
VolumeIntegrator \"single\" \n\t\
\"float stepsize\" [1.000000] \n\t\
 \n\t\
Accelerator \"tabreckdtree\" \n\t\
\"integer intersectcost\" [80] \n\t\
\"integer traversalcost\" [1] \n\t\
\"float emptybonus\" [0.200000] \n\t\
\"integer maxprims\" [1] \n\t\
\"integer maxdepth\" [-1] \n";
}