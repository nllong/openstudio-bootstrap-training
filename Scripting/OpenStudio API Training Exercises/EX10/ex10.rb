require 'openstudio'

# Load the existing model 

## This file path assumes that you are in the EX10 folder when you execute Ruby.

model_path = '../PSZExample.osm'

if File.exists?(model_path)
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

# TODO Create a new VAV System, see vav_example file

# Get all of the thermal zones, we are going to remove the current PSZ system
# and add each zone to the VAV system

# TODO Get all of the zones in the model and save them to an array

# TODO Loop over each zone in the zones array

  # TODO Get the current system for each zone

  # TODO Figure out if the current system is PSZ

  # TODO Remove the old system if it is PSZ

  # TODO Add zone to new VAV

# TODO Dont forget to end the zone loop here

# Save the model as ex10.osm

## The ex10.osm file will be saved to the folder you are in when you execute Ruby.
## We are assuming the EX10 folder.

save_path = OpenStudio::Path.new('ex10.osm')

model.save(save_path,true)

