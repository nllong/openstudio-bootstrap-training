require 'openstudio'

#create a new model
model = OpenStudio::Model::Model.new()

#specify where the .osm will be saved
save_path = OpenStudio::Path.new('ex1_solution.osm')

#save the model
model.save(save_path, true)

#let the user know that it finished successfully
puts "file saved to #{save_path}"
