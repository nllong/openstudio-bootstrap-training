require 'openstudio'

#specify the .osm to open 
model_path = OpenStudio::Path.new('../EX1/ex1_solution.osm')

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

#set the space height (meters)
height = 5

#Create a new story for all the spaces
first_story = OpenStudio::Model::BuildingStory.new(model)
first_story.setNominalFloortoFloorHeight(height)
first_story.setName("First Floor")

#create the points (all dimensions in meters)
point_a = OpenStudio::Point3d.new(0,0,0)
point_b = OpenStudio::Point3d.new(0,20,0)
point_c = OpenStudio::Point3d.new(20,20,0)
point_d = OpenStudio::Point3d.new(20,10,0)
point_e = OpenStudio::Point3d.new(20,0,0)
point_f = OpenStudio::Point3d.new(30,20,0)
point_g = OpenStudio::Point3d.new(30,10,0)
point_h = OpenStudio::Point3d.new(30,0,0)

#make the polygon for space 1
space_1_polygon = OpenStudio::Point3dVector.new

#add the points to the polygon in a clockwise direction
space_1_polygon << point_a
space_1_polygon << point_b
space_1_polygon << point_c
space_1_polygon << point_d
space_1_polygon << point_e

#create the space from the polygon
opt_space_1 = OpenStudio::Model::Space::fromFloorPrint(space_1_polygon, height, model)

#if the space now exists, set name and story
if opt_space_1.is_initialized
  space_1 = opt_space_1.get
  space_1.setName("Space 1")  
  space_1.setBuildingStory(first_story)  
else
  puts "erros, no space created"
  exit
end

#make the polygon for space 2
space_2_polygon = OpenStudio::Point3dVector.new

#add the points to the polygon in a clockwise direction
space_2_polygon << point_d
space_2_polygon << point_c
space_2_polygon << point_f
space_2_polygon << point_g

#create the space from the polygon
opt_space_2 = OpenStudio::Model::Space::fromFloorPrint(space_2_polygon, height, model)

#if the space now exists, set name and story
if not opt_space_2.empty?
  space_2 = opt_space_2.get
  space_2.setName("Space 2")  
  space_2.setBuildingStory(first_story)  
end

#make the polygon for space 3
space_3_polygon = OpenStudio::Point3dVector.new

#add the points to the polygon in a clockwise direction
space_3_polygon << point_e
space_3_polygon << point_d
space_3_polygon << point_g
space_3_polygon << point_h

#create the space from the polygon
opt_space_3 = OpenStudio::Model::Space::fromFloorPrint(space_3_polygon, height, model)

#if the space now exists, set name and story
if not opt_space_3.empty?
  space_3 = opt_space_3.get
  space_3.setName("Space 3")  
  space_3.setBuildingStory(first_story)  
end

#put all of the spaces in the model into a vector
spaces = OpenStudio::Model::SpaceVector.new
model.getSpaces.each do |space|
  spaces << space
end

#match surfaces for each space in the vector
OpenStudio::Model.matchSurfaces(spaces)

#specify where the .osm will be saved
save_path = OpenStudio::Path.new('ex2_solution.osm')

#save the model
model.save(save_path, true)

#let the user know that it finished successfully
puts "file saved to #{save_path}"




 


