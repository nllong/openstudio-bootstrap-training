require 'openstudio'

# Setup model and output paths relative to this script
model_path = OpenStudio::Path.new('C:/OSTraining/NoHVACExample.osm')
output_path = OpenStudio::Path.new('C:/OSTraining/EX8/')

# Find weather file
epw_path = OpenStudio::Path.new("C:/OSTraining/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.epw")

# add design days to model
ddy_path = OpenStudio::Path.new("C:/OSTraining/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.ddy")
ddy_file = OpenStudio::IdfFile::load(ddy_path).get
ddy_workspace = OpenStudio::Workspace.new(ddy_file)
reverse_translator = OpenStudio::EnergyPlus::ReverseTranslator.new
ddy_model = reverse_translator.translateWorkspace(ddy_workspace);
design_days = ddy_model.getDesignDays

version_translator = OpenStudio::OSVersion::VersionTranslator.new 
model = version_translator.loadModel(model_path).get

model.addObjects(design_days)

new_model_path = OpenStudio::Path.new("C:/OSTraining/EX8/ex8.osm")
model.save(new_model_path)

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

# Create a job
job = workflow.create(output_path,new_model_path,epw_path)

# Put the job in the run queue, start runmanager, and wait until the simulation is complete
runmanager.enqueue(job,true)
runmanager.setPaused(false)
runmanager.waitForFinished()
