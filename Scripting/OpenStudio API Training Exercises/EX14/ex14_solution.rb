require 'openstudio'

# Setup model and output paths relative to this script
model_path = OpenStudio::Path.new('./PSZExample.osm')
output_path = OpenStudio::Path.new('./EX14/')

# Load model
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

# Add a new OutputVariable object for "Total Electric Power Purchased"
output_variable = OpenStudio::Model::OutputVariable.new("Total Electric Power Purchased",model)

# Save the model as ex14.osm
new_model_path = output_path / OpenStudio::Path.new('ex14.osm')
model.save(new_model_path,true)

# Find weather file
epw_path = OpenStudio::Path.new("./USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.epw")

# Create a runmanager
db = output_path / OpenStudio::Path.new('runmanager.db')
runmanager = OpenStudio::Runmanager::RunManager.new(db,true)
runmanager.setPaused(true)

# Find EnergyPlus
config_options = runmanager.getConfigOptions()
config_options.fastFindEnergyPlus()
tools = config_options.getTools()

# Create an EnergyPlus workflow
workflow = OpenStudio::Runmanager::Workflow.new("ModelToIdf->EnergyPlus")
workflow.add(tools)

job = workflow.create(output_path,new_model_path,epw_path)

# Put the job in the run queue, start runmanager, and wait until the simulation is complete
runmanager.enqueue(job,true)
runmanager.setPaused(false);
runmanager.waitForFinished();

# Load the sqlite file which contains results from EnergyPlus
sql_path = output_path / OpenStudio::Path.new('ModelToIdf/EnergyPlus-0/eplusout.sql')

sql = OpenStudio::SqlFile.new(sql_path);

if ! sql.connectionOpen
  puts 'Unable to open Sqlite file.'
  exit
end

# Make a query
run_period = 'RUN PERIOD 1'
frequency = 'Hourly'
variable_name = 'Total Electric Power Purchased'
key = 'Whole Building'

timeseries = sql.timeSeries(run_period,frequency,variable_name,key).get

values = timeseries.values

# Output results
puts OpenStudio::minimum(values)

puts OpenStudio::maximum(values)

puts OpenStudio::mean(values)



