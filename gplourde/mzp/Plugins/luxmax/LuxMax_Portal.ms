plugin light luxPortal name:"LR Portal" classID:#(0x2120176, 0x5d21b0d2) extends:mr_Sky_Portal replaceUI:true version:1 category:"LuxRender"
(
	parameters pblock0 rollout:params0
	(

	)
	
	rollout params0 "Parameters"
	(
		spinner mwidth "Width:" type:#worldunits range:[0,99999999,100]
		spinner mlength "Length:" type:#worldunits range:[0,99999999,100]
		
		on mwidth changed val do delegate.light_width = val
		on mlength changed val do delegate.light_length = val
			
		on params0 open do
		(
			mwidth.value = delegate.light_width
			mlength.value = delegate.light_length
		)
	)
)