function export_lxo lxo =
(
	str = stringstream ""
	
	for obj in geometry do
	(
		if (obj.ishidden) then continue
		
		--// Export ply files
		--// Skip if ply export is disabled
		if (GetLuxValue "chk_ply") then
		(
			--// Create ply saving location
			makeDir ((getFilenamePath lxo) + "/" + (getFilenameFile lxo))
			--// Ply filename
			n = ((getFilenamePath lxo) + (getFilenameFile lxo) + "/" + obj.name + ".ply")
		
			if (GetLuxValue "chk_scriptply") then (ply_export_script obj n 100) --// Force exort with script exporter
			else
			(
				--// If the c++ expoter is present, use it
				if (ply_export != undefined) then
				(
					try (ply_export obj n false 100)
					catch (ply_export_script obj n 100) --// Some mesh with weird normals do not export for some reason so fall back to the script export for those
				)
				--// No c++ exporter so use the script
				else (ply_export_script obj n 100)
			)
		)
		
		--// Relative path to the ply
		n = ("./" + (getFilenameFile lxo) + "/" + obj.name + ".ply")
		
		format "\nAttributeBegin\n" to:str
		
		r1 = obj.transform.row1
		r2 = obj.transform.row2
		r3 = obj.transform.row3
		r4 = obj.transform.row4
		
		format "\tTransform [% % % 0.0 % % % 0.0 % % % 0.0 % % % 1.0]\n" r1.x r1.y r1.z r2.x r2.y r2.z r3.x r3.y r3.z (r4.x / 100.0) (r4.y / 100.0) (r4.z / 100.0)to:str

		--// Write default material if none on the object
		if (obj.material == undefined) then
		(
			format "MakeNamedMaterial \"Wirecolor\"\n" to:str
			luxWriteString "type" "matte" str
			luxWriteColor "Kd" (obj.wirecolor / 255) str
			format "NamedMaterial \"Wirecolor\"\n" to:str
		)
		
		format "\n" to:str
		
		if (classof obj.material == LuxrenderPortal2 or classof obj.material == LuxrenderPortal) then
			format "PortalShape \"plymesh\" \"string filename\" [\"%\"]" n to:str
		else
			format "Shape \"plymesh\" \"string filename\" [\"%\"]" n to:str
		
		format "\nAttributeEnd\n" to:str
	)
	
	f = openfile lxo mode:"w"
	format "%\n" (str as string) to:f
	close f
)