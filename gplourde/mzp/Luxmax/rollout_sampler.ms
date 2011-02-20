( --// Samplers
	rollout lux_Sampler_Random "random"
	(
		spinner spn_haltspp "Halt SPP:" type:#integer range:[0,999999,0] width:100 align:#left across:2
		spinner spn_halttime "Halt Time:" type:#integer range:[0,999999,0] width:100 align:#right
		dropdownlist ddl_sampler "Pixel Sampler:" items:#("Hilbert", "Low Discrepancy", "Vegas" ,"Tile", "Linear")
		spinner spn_samples "Pixel Samples:" type:#integer range:[1,999999,4]
	)
	rollout lux_Sampler_LowDiscrepancy "lowdiscrepancy"
	(
		spinner spn_haltspp "Halt SPP:" type:#integer range:[0,999999,0] width:100 align:#left across:2
		spinner spn_halttime "Halt Time:" type:#integer range:[0,999999,0] width:100 align:#right
		dropdownlist ddl_sampler "Pixel Sampler:" items:#("Hilbert", "Low Discrepancy", "Vegas" ,"Tile", "Linear")
		spinner spn_samples "Pixel Samples:" type:#integer range:[1,999999,4]
	)
	rollout lux_Sampler_ERPT "erpt"
	(
		spinner spn_haltspp "Halt SPP:" type:#integer range:[0,999999,0] width:100 align:#left across:2
		spinner spn_halttime "Halt Time:" type:#integer range:[0,999999,0] width:100 align:#right
		spinner spn_chainlength "Chain Length:" type:#integer range:[0,999999,512] width:90 align:#right
		
		dropdownlist ddl_basesampler "Base Sampler:" items:#("Metropolis", "Low Discrepancy", "Random")
		
		--// Metropolis
		group "Metropolis Params"
		(
			spinner spn_mutation "Large Mutation Probability:" type:#float range:[0,1,0.4] width:150 align:#right enabled:false
			spinner spn_rejections "Max Consecutive Rejections:" type:#integer range:[0,999999,512] width:156 align:#right enabled:false
			checkbox chk_variance "Variance" enabled:false
		)
		--// Other
		group "Other Params"
		(
			dropdownlist ddl_sampler "Pixel Sampler:" items:#("Hilbert", "Low Discrepancy", "Vegas" ,"Tile", "Linear") enabled:false
			spinner spn_samples "Pixel Samples:" type:#integer range:[1,999999,4] enabled:false
		)
		
		on ddl_basesampler selected val do
		(
			if (val == 1) then
			(
				spn_mutation.enabled = true
				spn_rejections.enabled = true
				chk_variance.enabled = true
				ddl_sampler.enabled = false
				spn_samples.enabled = false
			)
			else
			(
				spn_mutation.enabled = false
				spn_rejections.enabled = false
				chk_variance.enabled = false
				ddl_sampler.enabled = true
				spn_samples.enabled = true
			)
		)
		
		on lux_Sampler_ERPT open do
		(
			if (ddl_basesampler.selection == 1) then
			(
				spn_mutation.enabled = true
				spn_rejections.enabled = true
				chk_variance.enabled = true
				ddl_sampler.enabled = false
				spn_samples.enabled = false
			)
			else
			(
				spn_mutation.enabled = false
				spn_rejections.enabled = false
				chk_variance.enabled = false
				ddl_sampler.enabled = true
				spn_samples.enabled = true
			)
		)
	)
	rollout lux_Sampler_Metropolis "metropolis"
	(
		spinner largemutationprob "Large Mutation Probability:" type:#float range:[0,1,0.4] width:150 align:#right fieldwidth:50
		checkbox usevariance "Use Variance"
		group "Advanced"
		(
			checkbox sampler_metropolis_adv ". . " across:2
			spinner maxconsecrejects "Max Consecutive Rejections:" type:#integer range:[0,999999,512] width:156 align:#right fieldwidth:50
		)
		
		function GetLuxRenderString =
		(
			str = stringstream ""
			format "\nSampler \"metropolis\"\n" to:str
			format "\t\"float largemutationprob\" [%]\n" (getLuxValue "largemutationprob") to:str
			format "\t\"bool usevariance\" [\"%\"]\n" (getLuxValue "usevariance") to:str
			if (sampler_metropolis_adv.state == true) then
				format "\t\"integer maxconsecrejects\" [%]\n"  (getLuxValue "maxconsecrejects") to:str
			return (str as string)
		)
	
		on lux_Sampler_Metropolis open do (GetControlParams(lux_Sampler_Metropolis))
	)
	-- Add new sampler at the end of this list for compatibility reasons
	--SamplerRollouts = #(lux_Sampler_Random, lux_Sampler_LowDiscrepancy, lux_Sampler_ERPT, lux_Sampler_Metropolis)
	SamplerRollouts = #(lux_Sampler_Metropolis)
)