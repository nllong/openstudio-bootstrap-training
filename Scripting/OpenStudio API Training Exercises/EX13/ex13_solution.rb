require 'openstudio'

# Setup model and output paths relative to this script
model_path = OpenStudio::Path.new('C:/OSTraining/PSZExample.osm')
output_path = OpenStudio::Path.new('C:/OSTraining/EX13/')

# Find weather file
epw_path = OpenStudio::Path.new("C:/OSTraining/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.epw")

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

# Load the sqlite file which contains results from EnergyPlus
sql_path = output_path / OpenStudio::Path.new('ModelToIdf/EnergyPlus-0/eplusout.sql')

sql = OpenStudio::SqlFile.new(sql_path);

if ! sql.connectionOpen
  puts 'Unable to open Sqlite file.'
  exit
end

# Retrieve the net site energy in GJ
query = "SELECT Value FROM tabulardatawithstrings WHERE "
query << "ReportName='SystemSummary' and " # Notice no space in SystemSummary
query << "ReportForString='Entire Facility' and "
query << "TableName='Time Setpoint Not Met' and "
query << "RowName='Facility' and "
query << "ColumnName='During Occupied Cooling' and "
query << "Units='hr';"

unmet_heating_hours = sql.execAndReturnFirstDouble(query)

if unmet_heating_hours.empty?
  puts 'No Value'
else
  puts unmet_heating_hours.get
end
