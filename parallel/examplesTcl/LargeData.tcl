# This examples tests large data support in vtk
# by computing a small portion of a large data
# and rendering it in pieces
catch {load vtktcl}
if { [catch {set VTK_TCL $env(VTK_TCL)}] != 0} { set VTK_TCL "../../examplesTcl" }
if { [catch {set VTK_DATA $env(VTK_DATA)}] != 0} { set VTK_DATA "../../../vtkdata" }

set EXTENT 10000
set MEMORY_LIMIT 1000

vtkRTAnalyticSource source1
source1 SetWholeExtent [expr -1*$EXTENT] $EXTENT [expr -1*$EXTENT] $EXTENT [expr -1*$EXTENT] $EXTENT
source1 SetCenter 0 0 0
[source1 GetOutput] SetSpacing [expr 2.0/$EXTENT] [expr 2.0/$EXTENT] [expr 2.0/$EXTENT]

# Iso-surfacing
vtkContourFilter contour
contour SetInput [source1 GetOutput]
contour SetNumberOfContours 1
contour SetValue 0 220
# Reduces memory use
[contour GetOutput] ReleaseDataFlagOn

# Magnitude of the gradient vector
vtkImageGradientMagnitude magn
magn SetDimensionality 3
magn SetInput [source1 GetOutput]
# Reduces memory use
[magn GetOutput] ReleaseDataFlagOn
 
# Probe the magnitude with the iso-surface
vtkProbeFilter probe
probe SetInput [contour GetOutput]
probe SetSource [magn GetOutput]
# To avoid the use of the whole extent in gradient magnitude computation
probe SpatialMatchOn

vtkPolyDataMapper mapper
mapper SetInput [probe GetOutput]
mapper SetScalarRange 50 180

vtkActor actor
actor SetMapper mapper

vtkRenderWindow renWin
vtkRenderer ren
renWin AddRenderer ren

ren AddActor actor

ren SetBackground 0.5 0.5 0.5 

vtkPipelineSize psize
mapper SetNumberOfPieces 80000000
mapper SetNumberOfSubPieces [psize GetNumberOfSubPieces $MEMORY_LIMIT mapper]

wm withdraw .

mapper SetPiece 8698568
[ren GetActiveCamera] Zoom 0.6

for { set i 8698560 } { $i < 8698585 } { incr i 1 } {
    mapper SetPiece $i
    renWin Render
    renWin EraseOff
}


vtkWindowToImageFilter w2if
vtkTIFFWriter tw 
w2if SetInput renWin
tw SetInput [w2if GetOutput]
tw SetFileName "LargeData.tcl.tif"
tw Write
