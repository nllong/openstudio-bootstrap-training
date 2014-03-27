require 'openstudio'

# Setup model and output paths relative to this script

# TODO Edit paths for your computer

model_path = OpenStudio::Path.new('../NoHVACExample.osm')
output_path = OpenStudio::Path.new('.')

# Find weather file

# TODO Edit paths for your computer

epw_path = OpenStudio::Path.new("../USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.epw")

# Add design days to model

# TODO Edit paths to your computer

ddy_path = OpenStudio::Path.new("../USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.ddy")

new_model_path = OpenStudio::Path.new("ex8.osm")

# TODO Load ddy file as using OpenStudio::IdfFile

# TODO Create a runmanager

# TODO Find EnergyPlus

# TODO Create a workflow

# TODO Create a job 

# TODO Put the job in the queue, start runmanager, and wait until the simulation is complete

