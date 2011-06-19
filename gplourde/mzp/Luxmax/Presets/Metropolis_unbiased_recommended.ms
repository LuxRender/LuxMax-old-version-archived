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
#("ComboBoxControl", "ddl_sampler", 1, "metropolis"),
#("SpinnerControl", "haltspp", 0, undefined),
#("SpinnerControl", "halttime", 0, undefined),
#("SubRollout", "lx0", undefined, undefined),
#("SpinnerControl", "largemutationprob", 0.4, undefined),
#("CheckBoxControl", "usevariance", false, undefined),
#("CheckBoxControl", "sampler_metropolis_adv", true, undefined),
#("SpinnerControl", "maxconsecrejects", 512, undefined),
#("ComboBoxControl", "ddl_surface", 1, "bidirectional"),
#("SubRollout", "lx0", undefined, undefined),
#("SpinnerControl", "eyedepth", 48, undefined),
#("SpinnerControl", "lightdepth", 48, undefined),
#("SpinnerControl", "eyerrthreshold", 0.0, undefined),
#("SpinnerControl", "lightrrthreshold", 0.0, undefined),
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