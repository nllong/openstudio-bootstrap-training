require 'openstudio'

#specify the .osm to open 
model_path = OpenStudio::Path.new('Path/To/OSTraining/EX5/ex5_solution.osm')

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

#add space 1 to thermal zone 1

#add spaces 2 and 3 to thermal zone 2

#specify where the .osm will be saved
save_path = OpenStudio::Path.new('Path/To/OSTraining/EX6/ex6.osm')

#save the model
model.save(save_path, true)

#let the user know that it finished successfully
puts "file saved to #{save_path}"
