require 'openstudio'

#specify the .osm to open 
model_path = OpenStudio::Path.new('C:/OSTraining_solution/EX1/ex1_solution.osm')

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

#Create a new story for all the spaces

#create the points (all dimensions in meters)

#make the polygon for space 1

#add the points to the polygon in a clockwise direction

#create the space from the polygon

#if the space now exists, set name and story

#make the polygon for space 2

#add the points to the polygon in a clockwise direction

#create the space from the polygon

#if the space now exists, set name and story

#make the polygon for space 3

#add the points to the polygon in a clockwise direction

#create the space from the polygon

#if the space now exists, set name and story

#put all of the spaces in the model into a vector

#match surfaces for each space in the vector

#specify where the .osm will be saved
save_path = OpenStudio::Path.new('C:/OSTraining_solution/EX2/ex2.osm')

#save the model
model.save(save_path, true)

#let the user know that it finished successfully
puts "file saved to #{save_path}"
