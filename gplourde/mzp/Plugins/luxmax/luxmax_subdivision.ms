plugin simpleMod luxRenderSubdivision
name:"LR Subdivision"
classID:#(0x38b8fc7f, 0x78023ed2)
version:1
(
	parameters main rollout:params
	(
		subdivscheme type:#integer ui:msubdivscheme default:1
		nsubdivlevels type:#integer ui:mnsubdivlevels default:1
		dmnormalsmooth type:#boolean ui:mdmnormalsmooth default:false
		dmsharpboundary type:#boolean ui:mdmsharpboundary default:false
	)
	rollout params "Parameters"
	(
		dropdownlist msubdivscheme "Subdivision Scheme" items:#("none", "microdisplacement", "loop")
		spinner mnsubdivlevels "Level:" type:#integer range:[0,1000,1] fieldwidth:65
		checkbox mdmnormalsmooth "Normal Smoothing"
		checkbox mdmsharpboundary "Sharpen Bounds"
	)
)