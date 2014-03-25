require 'openstudio'

#specify the .osm to open 
model_path = OpenStudio::Path.new('C:/OSTraining/EX3/ex3_solution.osm')

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

#create a people definition
people_def = OpenStudio::Model::PeopleDefinition.new(model)
people_def.setName("People Def - 1 person/200sf")
people_def.setPeopleperSpaceFloorArea(0.053820) #people/m^2
people_def.setFractionRadiant(0.3)
people_def.setSensibleHeatFraction(0.1)

#create a lights definition
lights_def_a = OpenStudio::Model::LightsDefinition.new(model)
lights_def_a.setName("Lights Def - 1 W/sf")
lights_def_a.setWattsperSpaceFloorArea(11.0) #W/m^2
lights_def_a.setFractionRadiant(0.30)
lights_def_a.setFractionVisible(0.20)
lights_def_a.setReturnAirFraction(0.0)

#create a second lights definition
lights_def_b = OpenStudio::Model::LightsDefinition.new(model)
lights_def_b.setName("Lights Def - 2 W/sf")
lights_def_b.setWattsperSpaceFloorArea(22.0) #W/m^2
lights_def_b.setFractionRadiant(0.30)
lights_def_b.setFractionVisible(0.20)
lights_def_b.setReturnAirFraction(0.0)

#create a design outdoor air object
dsn_oa = OpenStudio::Model::DesignSpecificationOutdoorAir.new(model)
dsn_oa.setName("Design OA")
dsn_oa.setOutdoorAirFlowperPerson(0.010765) #m^3/s*person = 22.8 cfm/person
    
#create the first space type
space_type_a = OpenStudio::Model::SpaceType.new(model)
space_type_a.setName("Space Type A")

#create a people instance and assign to the first space type
people_a = OpenStudio::Model::People.new(people_def)
people_a.setName("People for Space Type A")
people_a.setSpaceType(space_type_a)

#create a lights instance and assign to the first space type
lights_a = OpenStudio::Model::Lights.new(lights_def_a)
lights_a.setName("Lights for Space Type A")
lights_a.setSpaceType(space_type_a)

#create the second space type
space_type_b = OpenStudio::Model::SpaceType.new(model)
space_type_b.setName("Space Type B")

#create a people instance and assign to the second space type
people_b = OpenStudio::Model::People.new(people_def)
people_b.setName("People for Space Type B")
people_b.setSpaceType(space_type_b)

#create a lights instance and assign to the second space type
lights_b = OpenStudio::Model::Lights.new(lights_def_b)
lights_b.setName("Lights for Space Type B")
lights_b.setSpaceType(space_type_b)

#assign the design outdoor air to both space types
space_type_a.setDesignSpecificationOutdoorAir(dsn_oa)
space_type_b.setDesignSpecificationOutdoorAir(dsn_oa)

#assign space type A to space 1 and space 2
if model.getSpaceByName("Space 1")
  space_1 = model.getSpaceByName("Space 1").get
  space_1.setSpaceType(space_type_a)
end

if model.getSpaceByName("Space 2")
  space_2 = model.getSpaceByName("Space 2").get
  space_2.setSpaceType(space_type_a)
end
    
#assign space type B to space 3
if model.getSpaceByName("Space 3")
  space_3 = model.getSpaceByName("Space 3").get
  space_3.setSpaceType(space_type_b)
end
    
#specify where the .osm will be saved
save_path = OpenStudio::Path.new('C:/OSTraining/EX4/ex4_solution.osm')

#save the model
model.save(save_path, true)

#let the user know that it finished successfully
puts "file saved to #{save_path}"
