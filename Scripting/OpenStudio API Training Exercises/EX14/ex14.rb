require 'openstudio'

# Setup model and output paths relative to this script

# TODO Update file paths
model_path = OpenStudio::Path.new('Path/To/OSTraining/PSZExample.osm')
output_path = OpenStudio::Path.new('Path/To/OSTraining/EX14/')

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

# TODO Add a new OutputVariable object for "Total Electric Power Purchased"

# TODO Save the model as ex14.osm

# Find weather file

# TODO Update file path
epw_path = OpenStudio::Path.new("/Users/kbenne/Documents/OpenStudio API Documentation/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.epw")

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

# TODO Load the sqlite file which contains results from EnergyPlus


# TODO Make a query


# TODO Output results

