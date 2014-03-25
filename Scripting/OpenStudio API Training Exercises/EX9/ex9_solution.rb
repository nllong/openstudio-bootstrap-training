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

# Retrieve the thermal zones
zones = model.getThermalZones

# Add a new HVAC system and thermostat to each zone
heating_schedule = model.getScheduleRulesetByName('Heating Setpoint Schedule').get
cooling_schedule = model.getScheduleRulesetByName('Cooling Setpoint Schedule').get

zones.each do |zone|
  air_loop_hvac = OpenStudio::Model::addSystemType3(model).to_AirLoopHVAC.get
  air_loop_hvac.addBranchForZone(zone)

  thermostat = OpenStudio::Model::ThermostatSetpointDualSetpoint.new(model)
  thermostat.setHeatingSetpointTemperatureSchedule(heating_schedule)
  thermostat.setCoolingSetpointTemperatureSchedule(cooling_schedule)
  zone.setThermostatSetpointDualSetpoint(thermostat)
end

# Save the model as ex9.osm

## The ex9.osm file will be saved to the folder you are in when you execute Ruby.
## We are assuming the EX9 folder.

save_path = OpenStudio::Path.new('ex9.osm')

model.save(save_path,true)

#let the user know that it finished successfully
puts "file saved to #{save_path}"
