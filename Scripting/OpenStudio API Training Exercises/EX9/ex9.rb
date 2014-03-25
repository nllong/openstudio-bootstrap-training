require 'openstudio'

# Load the existing model 

## Note that this file path assumes that you are in the EX9 folder when you execute Ruby.

model_path = OpenStudio::Path.new('../NoHVACExample.osm')

if OpenStudio::exists(model_path)
  version_translator = OpenStudio::OSVersion::VersionTranslator.new 
  model = version_translator.loadModel(model_path)
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

# TODO Retrieve the thermal zones from model

# TODO Retrieve the heating and cooling schedules

# TODO Add a new HVAC system type 3 to each zone using the OpenStudio template
# TODO Add a new thermostat for each zone, set the heating and cooling schedules

#      Step 1 Loop over each zone

#      Step 2 For each zone create a new system type 3 

#      Step 3 Add the zone to the the new system created in the previous step

#      Step 4 Create a new thermostate for each zone and set the heating and cooling schedules

# Save the model as ex9.osm

# The ex9.osm file will be saved to the folder you are in when you execute Ruby.
# We are assuming the EX9 folder.

save_path = OpenStudio::Path.new('ex9.osm')

model.save(save_path,true)

