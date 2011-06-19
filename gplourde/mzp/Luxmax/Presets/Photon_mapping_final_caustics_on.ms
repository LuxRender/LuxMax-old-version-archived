/*
***** BEGIN GPL LICENSE BLOCK *****

--------------------------------------------------------------------------
LuxMax Autodesk® 3ds Max® to Luxrender exporter
--------------------------------------------------------------------------

Authors:
Guillaume Plourde
Konstantinos Mourelas
Stig Atle Steffensen

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, see <http://www.gnu.org/licenses/>.

***** END GPL LICENCE BLOCK *****
*/

luxMax_Settings = #(
#("ComboBoxControl", "ddl_renderer", 1, "sampler"),
#("ComboBoxControl", "ddl_sampler", 3, "lowdiscrepancy"),
#("SpinnerControl", "haltspp", 0, undefined),
#("SpinnerControl", "halttime", 0, undefined),
#("SubRollout", "lx0", undefined, undefined),
#("ComboBoxControl", "ddl_lowsampler", 2, "hilbert"),
#("SpinnerControl", "spn_lowsamples", 256, undefined),
#("ComboBoxControl", "ddl_surface", 3, "exphotonmap"),
#("SubRollout", "lx0", undefined, undefined),
#("SpinnerControl", "maxdepth", 24, undefined),
#("SpinnerControl", "maxphotondepth", 24, undefined),
#("SpinnerControl", "directphotons", 1000000, undefined),
#("SpinnerControl", "causticphotons", 1500000, undefined),
#("SpinnerControl", "indirectphotons", 1000000, undefined),
#("SpinnerControl", "radiancephotons", 640000, undefined),
#("SpinnerControl", "nphotonsused", 50, undefined),
#("SpinnerControl", "maxphotondist", 0.10, undefined),
#("CheckBoxControl", "finalgather", true, undefined),
#("SpinnerControl", "finalgathersamples", 16, undefined),
#("SpinnerControl", "gatherangle", 5.0, undefined),
#("ComboBoxControl", "renderingmode", 2, "directlighting"),
#("ComboBoxControl", "rrstrategy", 1, "efficiency"),
#("SpinnerControl", "rrcontinueprob", 0.65, undefined),
#("CheckBoxControl", "chk_advanced", true, undefined),
#("SpinnerControl", "distancethreshold", 0.75, undefined),
#("EditTextControl", "photonmapsfile", "", undefined),
#("ComboBoxControl", "lightstrategy", 1, "auto"),
#("CheckBoxControl", "dbg_enabledirect", true, undefined),
#("CheckBoxControl", "dbg_enableradiancemap", false, undefined),
#("CheckBoxControl", "dbg_enableindircaustic", true, undefined),
#("CheckBoxControl", "dbg_enableindirdiffuse", true, undefined),
#("CheckBoxControl", "dbg_enableindirspecular", true, undefined),
#("ComboBoxControl", "ddl_volume", 1, "multi"),
#("SpinnerControl", "stepsize", 1.0, undefined),
#("ComboBoxControl", "ddl_filter", 1, "mitchell"),
#("SubRollout", "lx0", undefined, undefined),
#("CheckBoxControl", "filter_mitchell_advanced", false, undefined),
#("SpinnerControl", "filter_mitchell_x", 2.0, undefined),
#("SpinnerControl", "filter_mitchell_y", 2.0, undefined),
#("SpinnerControl", "filter_mitchell_b", 0.33, undefined),
#("SpinnerControl", "filter_mitchell_c", 0.33, undefined),
#("ComboBoxControl", "ddl_accelerator", 1, "qbvh")
)