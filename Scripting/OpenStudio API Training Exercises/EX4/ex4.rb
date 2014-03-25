require 'openstudio'

#specify the .osm to open 
model_path = OpenStudio::Path.new('Path/To/OSTraining/EX3/ex3_solution.osm')

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

#create a lights definition

#create a second lights definition

#create a design outdoor air object
    
#create the first space type

#create a people instance and assign to the first space type

#create a lights instance and assign to the first space type

#create the second space type

#create a people instance and assign to the second space type

#create a lights instance and assign to the second space type

#assign the design outdoor air to both space types

#assign space type A to space 1 and space 2
   
#assign space type B to space 3

#specify where the .osm will be saved
save_path = OpenStudio::Path.new('Path/To/OSTraining/EX4/ex4.osm')

#save the model
model.save(save_path, true)

#let the user know that it finished successfully
puts "file saved to #{save_path}"
