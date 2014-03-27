
require 'openstudio'

#specify the .osm to open 
model_path = OpenStudio::Path.new('../EX5/ex5_solution.osm')

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

#create two new thermal zones
zone_1 = OpenStudio::Model::ThermalZone.new(model)
zone_1.setName("Zone 1")

zone_2 = OpenStudio::Model::ThermalZone.new(model)
zone_2.setName("Zone 2")

#add space 1 to thermal zone 1
if model.getSpaceByName("Space 1")
  space_1 = model.getSpaceByName("Space 1").get
  space_1.setThermalZone(zone_1)
end

#add spaces 2 and 3 to thermal zone 2
if model.getSpaceByName("Space 2")
  space_2 = model.getSpaceByName("Space 2").get
  space_2.setThermalZone(zone_2)
end
    
if model.getSpaceByName("Space 3")
  space_3 = model.getSpaceByName("Space 3").get
  space_3.setThermalZone(zone_2)
end

#specify where the .osm will be saved
save_path = OpenStudio::Path.new('ex6_solution.osm')

#save the model
model.save(save_path, true)

#let the user know that it finished successfully
puts "file saved to #{save_path}"
