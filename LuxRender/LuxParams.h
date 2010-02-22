#define LXS_FILENAME_CHUNKID 001
#define LXS_PRESET_CHUNKID 002

#define LXS_FILM_CHUNKID 0
#define LXS_HALTSPP_CHUNKID 0
#define LXS_USEPARAMKEYS_CHUNKID 0

#define LXS_SAMPLER_TYPE_CHUNKID 0
#define LXS_SAMPLER_LOWDISC_PIXELSAMPLES_CHUNKID 0
#define LXS_SAMPLER_LOWDISC_PIXELSAMPLER_CHUNKID 0
#define LXS_SAMPLER_METRO_STRENGTH_CHUNKID 0
#define LXS_SAMPLER_METRO_LMPROB_CHUNKID 0
#define LXS_SAMPLER_METRO_MAXREJECTS_CHUNKID 0
#define LXS_SAMPLER_METRO_INITSAMPLES_CHUNKID 0
#define LXS_SAMPLER_METRO_USEVARIANCE_CHUNKID 0

#define LXS_SINTEGRATOR_TYPE_CHUNKID 0
#define LXS_SINTEGRATOR_DLIGHTING_MAXDEPTH_CHUNKID 0
#define LXS_SINTEGRATOR_BIDIR_BOUNCES_CHUNKID 0
#define LXS_SINTEGRATOR_BIDIR_EYEDEPTH_CHUNKID 0
#define LXS_SINTEGRATOR_BIDIR_LIGHTDEPTH_CHUNKID 0
#define LXS_SINTEGRATOR_DISTRIBUTEDPATH_CAUSTICSONGGLOSSY_CHUNKID 0
#define LXS_SINTEGRATOR_DISTRIBUTEDPATH_DIFFUSEREFRACTDEPTH_CHUNKID 0
#define LXS_SINTEGRATOR_DISTRIBUTEDPATH_INDIRECTGLOSSY_CHUNKID 0
#define LXS_SINTEGRATOR_DISTRIBUTEDPATH_DIRECTSAMPLES_CHUNKID 0
#define LXS_SINTEGRATOR_DISTRIBUTEDPATH_DIFFUSEREFRACTSAMPLES_CHUNKID 0
#define LXS_SINTEGRATOR_DISTRIBUTEDPATH_GLOSSYREFLECTDEPTH_CHUNKID 0
#define LXS_SINTEGRATOR_DISTRIBUTEDPATH_DIRECTSAMPLEALL_CHUNKID 0
#define LXS_SINTEGRATOR_DISTRIBUTEDPATH_INDIRECTDIFFUSE_CHUNKID 0
#define LXS_SINTEGRATOR_DISTRIBUTEDPATH_SPECULARREFLECTDEPTH_CHUNKID 0
#define LXS_SINTEGRATOR_DISTRIBUTEDPATH_DIFFUSEREFLECTSAMPLES_CHUNKID 0
#define LXS_SINTEGRATOR_DISTRIBUTEDPATH_GLOSSYREFLECTSAMPLES_CHUNKID 0
#define LXS_SINTEGRATOR_DISTRIBUTEDPATH_GLOSSYREFRACTDEPTH_CHUNKID 0
#define LXS_SINTEGRATOR_DISTRIBUTEDPATH_DIFFUSEREFLECTDEPTH_CHUNKID 0
#define LXS_SINTEGRATOR_DISTRIBUTEDPATH_INDIRECTSAMPLES_CHUNKID 0
#define LXS_SINTEGRATOR_DISTRIBUTEDPATH_INDIRECTSAMPLEALL_CHUNKID 0
#define LXS_SINTEGRATOR_DISTRIBUTEDPATH_GLOSSYREFRECTSAMPLES_CHUNKID 0
#define LXS_SINTEGRATOR_DISTRIBUTEDPATH_DIRECTDIFFUSE_CHUNKID 0
#define LXS_SINTEGRATOR_DISTRIBUTEDPATH_DIRECTGLOSSY_CHUNKID 0
#define LXS_SINTEGRATOR_DISTRIBUTEDPATH_STRATEGY_CHUNKID 0
#define LXS_SINTEGRATOR_DISTRIBUTEDPATH_SPECULARREFRACTDEPTH_CHUNKID 0

#define LXS_PIXELFILTER_TYPE_CHUNKID 0
#define LXS_PIXELFILTER_MITCHELL_SHARP_CHUNKID 0
#define LXS_PIXELFILTER_MITCHELL_XWIDTH_CHUNKID 0
#define LXS_PIXELFILTER_MITCHELL_YWIDTH_CHUNKID 0
#define LXS_PIXELFILTER_MITCHELL_OPTMODE_CHUNKID 0


// 0 Preview - Direct Lighting

/*
presets['0 Preview - Direct Lighting'] = {
'film.displayinterval': 4,
'haltspp': 0,
'useparamkeys': 'false',
'sampler.showadvanced': 'false',
'sintegrator.showadvanced': 'false',
'pixelfilter.showadvanced': 'false',

'sampler.type': 'lowdiscrepancy',
'sampler.lowdisc.pixelsamples': 1,
'sampler.lowdisc.pixelsampler': 'lowdiscrepancy',

'sintegrator.type': 'directlighting',
'sintegrator.dlighting.maxdepth': 5,

'pixelfilter.type': 'mitchell',
'pixelfilter.mitchell.sharp': 0.250, 
'pixelfilter.mitchell.xwidth': 2.0, 
'pixelfilter.mitchell.ywidth': 2.0, 
'pixelfilter.mitchell.optmode': "slider" }

presets['1 Final - MLT/Bidir Path Tracing (interior) (recommended)'] =  {
'film.displayinterval': 8,
'haltspp': 0,
'useparamkeys': 'false',
'sampler.showadvanced': 'false',
'sintegrator.showadvanced': 'false',
'pixelfilter.showadvanced': 'false',

'sampler.type': 'metropolis',
'sampler.metro.strength': 0.6,
'sampler.metro.lmprob': 0.4,
'sampler.metro.maxrejects': 512,
'sampler.metro.initsamples': 262144,
'sampler.metro.usevariance': "false",

'sintegrator.type': 'bidirectional',
'sintegrator.bidir.bounces': 16,
'sintegrator.bidir.eyedepth': 16,
'sintegrator.bidir.lightdepth': 16,

'pixelfilter.type': 'mitchell',
'pixelfilter.mitchell.sharp': 0.250, 
'pixelfilter.mitchell.xwidth': 2.0, 
'pixelfilter.mitchell.ywidth': 2.0, 
'pixelfilter.mitchell.optmode': "slider" }

presets['2 Final - MLT/Path Tracing (exterior)'] =  {
'film.displayinterval': 8,
'haltspp': 0,
'useparamkeys': 'false',
'sampler.showadvanced': 'false',
'sintegrator.showadvanced': 'false',
'pixelfilter.showadvanced': 'false',

'sampler.type': 'metropolis',
'sampler.metro.strength': 0.6,
'sampler.metro.lmprob': 0.4,
'sampler.metro.maxrejects': 512,
'sampler.metro.initsamples': 262144,
'sampler.metro.usevariance': "false",

'sintegrator.type': 'path',
'sintegrator.bidir.bounces': 10,
'sintegrator.bidir.maxdepth': 10,

'pixelfilter.type': 'mitchell',
'pixelfilter.mitchell.sharp': 0.250, 
'pixelfilter.mitchell.xwidth': 2.0, 
'pixelfilter.mitchell.ywidth': 2.0, 
'pixelfilter.mitchell.optmode': "slider" }

presets['4 '] = { }

presets['5 Progressive - Bidir Path Tracing (interior)'] =  {
'film.displayinterval': 8,
'haltspp': 0,
'useparamkeys': 'false',
'sampler.showadvanced': 'false',
'sintegrator.showadvanced': 'false',
'pixelfilter.showadvanced': 'false',

'sampler.type': 'lowdiscrepancy',
'sampler.lowdisc.pixelsamples': 1,
'sampler.lowdisc.pixelsampler': 'lowdiscrepancy',

'sintegrator.type': 'bidirectional',
'sintegrator.bidir.bounces': 16,
'sintegrator.bidir.eyedepth': 16,
'sintegrator.bidir.lightdepth': 16,

'pixelfilter.type': 'mitchell',
'pixelfilter.mitchell.sharp': 0.250, 
'pixelfilter.mitchell.xwidth': 2.0, 
'pixelfilter.mitchell.ywidth': 2.0, 
'pixelfilter.mitchell.optmode': "slider" }

presets['6 Progressive - Path Tracing (exterior)'] =  {
'film.displayinterval': 8,
'haltspp': 0,
'useparamkeys': 'false',
'sampler.showadvanced': 'false',
'sintegrator.showadvanced': 'false',
'pixelfilter.showadvanced': 'false',

'sampler.type': 'lowdiscrepancy',
'sampler.lowdisc.pixelsamples': 1,
'sampler.lowdisc.pixelsampler': 'lowdiscrepancy',

'sintegrator.type': 'path',
'sintegrator.bidir.bounces': 10,
'sintegrator.bidir.maxdepth': 10,

'pixelfilter.type': 'mitchell',
'pixelfilter.mitchell.sharp': 0.250, 
'pixelfilter.mitchell.xwidth': 2.0, 
'pixelfilter.mitchell.ywidth': 2.0, 
'pixelfilter.mitchell.optmode': "slider" }

presets['7 '] = { }

presets['8 Bucket - Bidir Path Tracing (interior)'] =  {
'film.displayinterval': 8,
'haltspp': 0,
'useparamkeys': 'false',
'sampler.showadvanced': 'false',
'sintegrator.showadvanced': 'false',
'pixelfilter.showadvanced': 'false',

'sampler.type': 'lowdiscrepancy',
'sampler.lowdisc.pixelsamples': 64,
'sampler.lowdisc.pixelsampler': 'hilbert',

'sintegrator.type': 'bidirectional',
'sintegrator.bidir.bounces': 8,
'sintegrator.bidir.eyedepth': 8,
'sintegrator.bidir.lightdepth': 10,

'pixelfilter.type': 'mitchell',
'pixelfilter.mitchell.sharp': 0.250, 
'pixelfilter.mitchell.xwidth': 2.0, 
'pixelfilter.mitchell.ywidth': 2.0, 
'pixelfilter.mitchell.optmode': "slider" }

presets['9 Bucket - Path Tracing (exterior)'] =  {
'film.displayinterval': 8,
'haltspp': 0,
'useparamkeys': 'false',
'sampler.showadvanced': 'false',
'sintegrator.showadvanced': 'false',
'pixelfilter.showadvanced': 'false',

'sampler.type': 'lowdiscrepancy',
'sampler.lowdisc.pixelsamples': 64,
'sampler.lowdisc.pixelsampler': 'hilbert',

'sintegrator.type': 'path',
'sintegrator.bidir.bounces': 8,
'sintegrator.bidir.maxdepth': 8,

'pixelfilter.type': 'mitchell',
'pixelfilter.mitchell.sharp': 0.333, 
'pixelfilter.mitchell.xwidth': 2.0, 
'pixelfilter.mitchell.ywidth': 2.0, 
'pixelfilter.mitchell.optmode': "slider" }

presets['A '] = { }

presets['B Anim - Distributed/GI low Q'] =  {
'film.displayinterval': 8,
'haltspp': 1,
'useparamkeys': 'false',
'sampler.showadvanced': 'false',
'sintegrator.showadvanced': 'false',
'pixelfilter.showadvanced': 'false',

'sampler.type': 'lowdiscrepancy',
'sampler.lowdisc.pixelsamples': 16,
'sampler.lowdisc.pixelsampler': 'hilbert',

'sintegrator.type': 'distributedpath',
'sintegrator.distributedpath.causticsonglossy': 'true',
'sintegrator.distributedpath.diffuserefractdepth': 5,
'sintegrator.distributedpath.indirectglossy': 'true',
'sintegrator.distributedpath.directsamples': 1,
'sintegrator.distributedpath.diffuserefractsamples': 1,
'sintegrator.distributedpath.glossyreflectdepth': 2,
'sintegrator.distributedpath.causticsondiffuse': 'false',
'sintegrator.distributedpath.directsampleall': 'true',
'sintegrator.distributedpath.indirectdiffuse': 'true',
'sintegrator.distributedpath.specularreflectdepth': 3,
'sintegrator.distributedpath.diffusereflectsamples': 1,
'sintegrator.distributedpath.glossyreflectsamples': 1,
'sintegrator.distributedpath.glossyrefractdepth': 5,
'sintegrator.distributedpath.diffusereflectdepth': '2',
'sintegrator.distributedpath.indirectsamples': 1,
'sintegrator.distributedpath.indirectsampleall': 'false',
'sintegrator.distributedpath.glossyrefractsamples': 1,
'sintegrator.distributedpath.directdiffuse': 'true',
'sintegrator.distributedpath.directglossy': 'true',
'sintegrator.distributedpath.strategy': 'auto',
'sintegrator.distributedpath.specularrefractdepth': 5,

'pixelfilter.type': 'mitchell',
'pixelfilter.mitchell.sharp': 0.333, 
'pixelfilter.mitchell.xwidth': 2.0, 
'pixelfilter.mitchell.ywidth': 2.0, 
'pixelfilter.mitchell.optmode': "slider" }

presets['C Anim - Distributed/GI medium Q'] =  {
'film.displayinterval': 8,
'haltspp': 1,
'useparamkeys': 'false',
'sampler.showadvanced': 'false',
'sintegrator.showadvanced': 'false',
'pixelfilter.showadvanced': 'false',

'sampler.type': 'lowdiscrepancy',
'sampler.lowdisc.pixelsamples': 64,
'sampler.lowdisc.pixelsampler': 'hilbert',

'sintegrator.type': 'distributedpath',
'sintegrator.distributedpath.causticsonglossy': 'true',
'sintegrator.distributedpath.diffuserefractdepth': 5,
'sintegrator.distributedpath.indirectglossy': 'true',
'sintegrator.distributedpath.directsamples': 1,
'sintegrator.distributedpath.diffuserefractsamples': 1,
'sintegrator.distributedpath.glossyreflectdepth': 2,
'sintegrator.distributedpath.causticsondiffuse': 'false',
'sintegrator.distributedpath.directsampleall': 'true',
'sintegrator.distributedpath.indirectdiffuse': 'true',
'sintegrator.distributedpath.specularreflectdepth': 3,
'sintegrator.distributedpath.diffusereflectsamples': 1,
'sintegrator.distributedpath.glossyreflectsamples': 1,
'sintegrator.distributedpath.glossyrefractdepth': 5,
'sintegrator.distributedpath.diffusereflectdepth': '2',
'sintegrator.distributedpath.indirectsamples': 1,
'sintegrator.distributedpath.indirectsampleall': 'false',
'sintegrator.distributedpath.glossyrefractsamples': 1,
'sintegrator.distributedpath.directdiffuse': 'true',
'sintegrator.distributedpath.directglossy': 'true',
'sintegrator.distributedpath.strategy': 'auto',
'sintegrator.distributedpath.specularrefractdepth': 5,

'pixelfilter.type': 'mitchell',
'pixelfilter.mitchell.sharp': 0.333, 
'pixelfilter.mitchell.xwidth': 2.0, 
'pixelfilter.mitchell.ywidth': 2.0, 
'pixelfilter.mitchell.optmode': "slider" }

presets['D Anim - Distributed/GI high Q'] =  {
'film.displayinterval': 8,
'haltspp': 1,
'useparamkeys': 'false',
'sampler.showadvanced': 'false',
'sintegrator.showadvanced': 'false',
'pixelfilter.showadvanced': 'false',

'sampler.type': 'lowdiscrepancy',
'sampler.lowdisc.pixelsamples': 256,
'sampler.lowdisc.pixelsampler': 'hilbert',

'sintegrator.type': 'distributedpath',
'sintegrator.distributedpath.causticsonglossy': 'true',
'sintegrator.distributedpath.diffuserefractdepth': 5,
'sintegrator.distributedpath.indirectglossy': 'true',
'sintegrator.distributedpath.directsamples': 1,
'sintegrator.distributedpath.diffuserefractsamples': 1,
'sintegrator.distributedpath.glossyreflectdepth': 2,
'sintegrator.distributedpath.causticsondiffuse': 'false',
'sintegrator.distributedpath.directsampleall': 'true',
'sintegrator.distributedpath.indirectdiffuse': 'true',
'sintegrator.distributedpath.specularreflectdepth': 3,
'sintegrator.distributedpath.diffusereflectsamples': 1,
'sintegrator.distributedpath.glossyreflectsamples': 1,
'sintegrator.distributedpath.glossyrefractdepth': 5,
'sintegrator.distributedpath.diffusereflectdepth': '2',
'sintegrator.distributedpath.indirectsamples': 1,
'sintegrator.distributedpath.indirectsampleall': 'false',
'sintegrator.distributedpath.glossyrefractsamples': 1,
'sintegrator.distributedpath.directdiffuse': 'true',
'sintegrator.distributedpath.directglossy': 'true',
'sintegrator.distributedpath.strategy': 'auto',
'sintegrator.distributedpath.specularrefractdepth': 5,

'pixelfilter.type': 'mitchell',
'pixelfilter.mitchell.sharp': 0.333, 
'pixelfilter.mitchell.xwidth': 2.0, 
'pixelfilter.mitchell.ywidth': 2.0, 
'pixelfilter.mitchell.optmode': "slider" }

presets['E Anim - Distributed/GI very high Q'] =  {
'film.displayinterval': 8,
'haltspp': 1,
'useparamkeys': 'false',
'sampler.showadvanced': 'false',
'sintegrator.showadvanced': 'false',
'pixelfilter.showadvanced': 'false',

'sampler.type': 'lowdiscrepancy',
'sampler.lowdisc.pixelsamples': 512,
'sampler.lowdisc.pixelsampler': 'hilbert',

'sintegrator.type': 'distributedpath',
'sintegrator.distributedpath.causticsonglossy': 'true',
'sintegrator.distributedpath.diffuserefractdepth': 5,
'sintegrator.distributedpath.indirectglossy': 'true',
'sintegrator.distributedpath.directsamples': 1,
'sintegrator.distributedpath.diffuserefractsamples': 1,
'sintegrator.distributedpath.glossyreflectdepth': 2,
'sintegrator.distributedpath.causticsondiffuse': 'false',
'sintegrator.distributedpath.directsampleall': 'true',
'sintegrator.distributedpath.indirectdiffuse': 'true',
'sintegrator.distributedpath.specularreflectdepth': 3,
'sintegrator.distributedpath.diffusereflectsamples': 1,
'sintegrator.distributedpath.glossyreflectsamples': 1,
'sintegrator.distributedpath.glossyrefractdepth': 5,
'sintegrator.distributedpath.diffusereflectdepth': '2',
'sintegrator.distributedpath.indirectsamples': 1,
'sintegrator.distributedpath.indirectsampleall': 'false',
'sintegrator.distributedpath.glossyrefractsamples': 1,
'sintegrator.distributedpath.directdiffuse': 'true',
'sintegrator.distributedpath.directglossy': 'true',
'sintegrator.distributedpath.strategy': 'auto',
'sintegrator.distributedpath.specularrefractdepth': 5,

'pixelfilter.type': 'mitchell',
'pixelfilter.mitchell.sharp': 0.333, 
'pixelfilter.mitchell.xwidth': 2.0, 
'pixelfilter.mitchell.ywidth': 2.0, 
'pixelfilter.mitchell.optmode': "slider" }
*/