require 'openstudio'

#specify the .osm to open 
model_path = OpenStudio::Path.new('../EX4/ex4_solution.osm')

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

#create some schedule type limits

#make a new schedule ruleset for occupancy
  
#weekdays

#saturdays
  
#sundays

#make a new schedule ruleset for lighting
    
#weekdays

#saturdays
  
#sundays

#make a new schedule ruleset for heating setpoint
    
#all days

#make a new schedule ruleset for cooling setpoint
    
#all days

#make a new schedule ruleset for people activity
    
#all days

#make a default schedule set object

#assign occupancy, lighting, and activity schedules to the default schedule set

#assign this default schedule set to the two space types created earlier

#specify where the .osm will be saved
save_path = OpenStudio::Path.new('ex5.osm')

#save the model
model.save(save_path, true)

#let the user know that it finished successfully
puts "file saved to #{save_path}"
