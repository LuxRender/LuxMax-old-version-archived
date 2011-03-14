-- Luxrender Materials plug-ins for 3dsmax

--// Include texture maps
try (include "luxmax\\plugins\\LuxMax_imagemap.ms") catch (print "LuxMax Error: Failed to load LuxMax_imagemap")
try (include "luxmax\\plugins\\LuxMax_colorscale.ms") catch (print "LuxMax Error: Failed to load LuxMax_colorscale")
try (include "luxmax\\plugins\\LuxMax_floatscale.ms") catch (print "LuxMax Error: Failed to load LuxMax_floatscale")

--// Include Materials
try (include "luxmax\\plugins\\LuxMax_matte.ms") catch (print "LuxMax Error: Failed to load LuxMax_matte")
try (include "luxmax\\plugins\\LuxMax_mix.ms") catch (print "LuxMax Error: Failed to load LuxMax_mix")
try (include "luxmax\\plugins\\LuxMax_glass2.ms") catch (print "LuxMax Error: Failed to load LuxMax_glass2")
try (include "luxmax\\plugins\\LuxMax_glass.ms") catch (print "LuxMax Error: Failed to load LuxMax_glass")
try (include "luxmax\\plugins\\LuxMax_glossy.ms") catch (print "LuxMax Error: Failed to load LuxMax_glossy")
try (include "luxmax\\plugins\\LuxMax_glossylossy.ms") catch (print "LuxMax Error: Failed to load LuxMax_glossylossy")
try (include "luxmax\\plugins\\LuxMax_glossytranslucent.ms") catch (print "LuxMax Error: Failed to load LuxMax_glossytranslucent")
try (include "luxmax\\plugins\\LuxMax_mattetranslucent.ms") catch (print "LuxMax Error: Failed to load LuxMax_mattetranslucent")
try (include "luxmax\\plugins\\LuxMax_metal.ms") catch (print "LuxMax Error: Failed to load LuxMax_metal")
try (include "luxmax\\plugins\\LuxMax_shinymetal.ms") catch (print "LuxMax Error: Failed to load LuxMax_shinymetal")
try (include "luxmax\\plugins\\LuxMax_mirror.ms") catch (print "LuxMax Error: Failed to load LuxMax_mirror")
try (include "luxmax\\plugins\\LuxMax_velvet.ms") catch (print "LuxMax Error: Failed to load LuxMax_velvet")
try (include "luxmax\\plugins\\LuxMax_roughglass.ms") catch (print "LuxMax Error: Failed to load LuxMax_roughglass")
try (include "luxmax\\plugins\\LuxMax_scatter.ms") catch (print "LuxMax Error: Failed to load LuxMax_scatter")
try (include "luxmax\\plugins\\LuxMax_carpaint.ms") catch (print "LuxMax Error: Failed to load LuxMax_carpaint")
try (include "luxmax\\plugins\\LuxMax_null.ms") catch (print "LuxMax Error: Failed to load LuxMax_null")

--// Helper
try (include "luxmax\\plugins\\LuxMax_volume.ms") catch (print "LuxMax Error: Failed to load LuxMax_volume")

