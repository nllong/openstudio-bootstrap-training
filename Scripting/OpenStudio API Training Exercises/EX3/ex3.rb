require 'openstudio'

#specify the .osm to open 
model_path = OpenStudio::Path.new('Path/To/OSTraining/EX2/ex2_solution.osm')

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

#make expanded polystyrene and set properties

#make plywood and set properties

#make a simple glazing material and set properties

#make the exterior wall construction

#make the interior wall construction

#make the roof construction

#make the window construction

#make a default surface construction for the exterior and ground

#make a default surface construction for the interior

#make a default sub surface construction for interior and exterior

#make a default construction set

#assign the default construction set to the building

#specify where the .osm will be saved
save_path = OpenStudio::Path.new('Path/To/OSTraining/EX3/ex3.osm')

#save the model
model.save(save_path, true)

#let the user know that it finished successfully
puts "file saved to #{save_path}"
