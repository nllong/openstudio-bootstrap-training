require 'openstudio'

#create a new model
model = OpenStudio::Model::Model.new()

#specify where the .osm will be saved
save_path = OpenStudio::Path.new('ex1.osm')

#save the model, true means overwrite existing file
model.save(save_path, true)

#let the user know that it finished successfully
puts "file saved to #{save_path}"
