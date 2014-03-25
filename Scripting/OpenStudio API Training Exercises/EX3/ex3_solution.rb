require 'openstudio'

#specify the .osm to open 
model_path = OpenStudio::Path.new('C:/OSTraining/EX2/ex2_solution.osm')

#load the model, version translating if necessary
if OpenStudio::exists(model_path)
  versionTranslator = OpenStudio::OSVersion::VersionTranslator.new 
  model = versionTranslator.loadModel(model_path)
  if model.empty?
    puts "Version translation failed for #{model_path_string}"
    exit
  else
    model = model.get
  end
else
  puts "The model couldn't be found"
  exit
end

#make plywood and set properties
plywd = OpenStudio::Model::StandardOpaqueMaterial.new(model)
plywd.setName("Plywood - 5/8in")
plywd.setThickness(0.015875) #meters
plywd.setThermalConductivity(0.12) #W/m*K
plywd.setDensity(544.0) #kg/m^3
plywd.setSpecificHeat(1210.0) #J/kg*K

#make expanded polystyrene and set properties
eps = OpenStudio::Model::StandardOpaqueMaterial.new(model)
eps.setName("Expanded Polystyrene - 2in")
eps.setThickness(0.0508) #meters
eps.setThermalConductivity(0.0352) #W/m*K
eps.setDensity(24.0) #kg/m^3
eps.setSpecificHeat(1210.0) #J/kg*K

#make plywood and set properties
concrete = OpenStudio::Model::StandardOpaqueMaterial.new(model)
concrete.setName("Heavyweight Concrete – 6in")
concrete.setThickness(0.1524) #meters
concrete.setThermalConductivity(1.95) #W/m*K
concrete.setDensity(2242.6) #kg/m^3
concrete.setSpecificHeat(900.0) #J/kg*K

#make a simple glazing material and set properties
glass = OpenStudio::Model::SimpleGlazing.new(model)
glass.setName("Glass")
glass.setUFactor(0.1) #W/m^2*K
glass.setSolarHeatGainCoefficient(0.3)
glass.setVisibleTransmittance(0.7)

#make the exterior wall construction
ext_wall_const = OpenStudio::Model::Construction.new(model)
ext_wall_const.setName("Ext Wall Construction")
ext_wall_const.insertLayer(0,plywd)
ext_wall_const.insertLayer(1,eps)
ext_wall_const.insertLayer(2,concrete)

#make the interior wall construction
int_wall_const = OpenStudio::Model::Construction.new(model)
int_wall_const.setName("Int Wall Construction")
int_wall_const.insertLayer(0,plywd)
int_wall_const.insertLayer(1,plywd)

#make the roof construction
roof_const = OpenStudio::Model::Construction.new(model)
roof_const.setName("Roof Construction")
roof_const.insertLayer(0,plywd)
roof_const.insertLayer(1,eps)
roof_const.insertLayer(2,eps)
roof_const.insertLayer(3,plywd)

#make the window construction
window_const = OpenStudio::Model::Construction.new(model)
window_const.setName("Window Construction")
window_const.insertLayer(0,glass)

#make a default surface construction for the exterior and ground
default_ext_surface_consts = OpenStudio::Model::DefaultSurfaceConstructions.new(model)
default_ext_surface_consts.setFloorConstruction(ext_wall_const)
default_ext_surface_consts.setWallConstruction(ext_wall_const)
default_ext_surface_consts.setRoofCeilingConstruction(roof_const)

#make a default surface construction for the interior
default_int_surface_consts = OpenStudio::Model::DefaultSurfaceConstructions.new(model)
default_int_surface_consts.setFloorConstruction(int_wall_const)
default_int_surface_consts.setWallConstruction(int_wall_const)

#make a default sub surface construction for interior and exterior
default_subsurface_consts = OpenStudio::Model::DefaultSubSurfaceConstructions.new(model)
default_subsurface_consts.setFixedWindowConstruction(window_const)
default_subsurface_consts.setDoorConstruction(window_const)

#make a default construction set
default_const_set = OpenStudio::Model::DefaultConstructionSet.new(model)
default_const_set.setName("Building Default Constructions")
default_const_set.setDefaultExteriorSurfaceConstructions(default_ext_surface_consts)
default_const_set.setDefaultExteriorSubSurfaceConstructions(default_subsurface_consts)
default_const_set.setDefaultInteriorSurfaceConstructions(default_int_surface_consts)
default_const_set.setDefaultInteriorSubSurfaceConstructions(default_subsurface_consts)
default_const_set.setDefaultGroundContactSurfaceConstructions(default_ext_surface_consts)

#assign the default construction set to the building
model.getBuilding.setDefaultConstructionSet(default_const_set)

#specify where the .osm will be saved
save_path = OpenStudio::Path.new('C:/OSTraining/EX3/ex3_solution.osm')

#save the model
model.save(save_path, true)

#let the user know that it finished successfully
puts "file saved to #{save_path}"




 


