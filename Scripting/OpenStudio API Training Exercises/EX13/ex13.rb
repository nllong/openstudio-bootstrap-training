require 'openstudio'

# Setup model and output paths relative to this script

# TODO Update file paths
model_path = OpenStudio::Path.new('Path/To/OSTraining/PSZExample.osm')
output_path = OpenStudio::Path.new('Path/To/OSTraining/EX13/')

# Find weather file

# TODO Update file path
epw_path = OpenStudio::Path.new("Path/To/OSTraining/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.epw")

# Note that this example already has design days imported, so you can skip the ddy file import.

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

job = workflow.create(output_path,model_path,epw_path)

# Put the job in the run queue, start runmanager, and wait until the simulation is complete

runmanager.enqueue(job,true)
runmanager.setPaused(false);
runmanager.waitForFinished();

# TODO Load the sqlite file which contains results from EnergyPlus


# TODO Retrieve the net site energy in GJ


