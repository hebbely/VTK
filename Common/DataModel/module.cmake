set(TEST_DEPENDS_MODULES
    vtkTestingCore
    vtkTestingRendering
    vtkInteractionStyle
    vtkCommonExecutionModel
    vtkCommonColor
    vtkFiltersGeneric
    vtkFiltersModeling
    vtkIOGeometry
    vtkIOLegacy
    vtkIOXML
    vtkTestingGenericBridge
    vtkChartsCore
    vtkViewsContext2D
    vtkRenderingCore
    vtkRenderingContextOpenGL2
    vtkRenderingOpenGL2
  )
if(VTK_WRAP_PYTHON)
    list(APPEND TEST_DEPENDS_MODULES vtkFiltersPython)
endif()

vtk_module(vtkCommonDataModel
  GROUPS
    StandAlone
  TEST_DEPENDS
    ${TEST_DEPENDS_MODULES}
  KIT
    vtkCommon
  DEPENDS
    vtkCommonCore
    vtkCommonMath
    vtkCommonTransforms
  PRIVATE_DEPENDS
    vtkCommonMisc
    vtkCommonSystem
    vtksys
  )
