#see the URL below for information on how to write OpenStudio measures
# http://openstudio.nrel.gov/openstudio-measure-writing-guide

#see the URL below for access to C++ documentation on model objects (click on "model" in the main window to view model objects)
# http://openstudio.nrel.gov/sites/openstudio.nrel.gov/files/nv_data/cpp_documentation_it/model/html/namespaces.html

#start the measure
class AddVAV < OpenStudio::Ruleset::ModelUserScript
  
  #define the name that a user will see, this method may be deprecated as
  #the display name in PAT comes from the name field in measure.xml
  def name
    return "AddVAV"
  end
  
  #define the arguments that the user will input
  def arguments(model)
    args = OpenStudio::Ruleset::OSArgumentVector.new
    
    return args
  end #end the arguments method

  #define what happens when the measure is run
  def run(model, runner, user_arguments)
    super(model, runner, user_arguments)
    new_vav_system = OpenStudio::Model::addSystemType7(model).to_AirLoopHVAC.get
    # Get all of the thermal zones, we are going to remove the current PSZ system
    # and add each zone to the VAV system
    zones = model.getThermalZones
    zones.each do |zone|
      # Get the current system for each zone
      old_system = zone.airLoopHVAC 
      # Figure out if the current system is PSZ
      old_system_is_psz = false
      if old_system.is_initialized 
        old_system = old_system.get
        old_systems_zones = old_system.thermalZones
        if old_systems_zones.size == 1
          constant_speed_fans = old_system.supplyComponents(OpenStudio::Model::FanConstantVolume::iddObjectType)
          dx_coils = old_system.supplyComponents(OpenStudio::Model::CoilCoolingDXSingleSpeed::iddObjectType)
          if constant_speed_fans.size >= 1 and dx_coils.size >= 1
            old_system_is_psz = true
          end
        end
      end
      #  Remove the old system if it is PSZ
      if old_system_is_psz
        old_system.remove
      end
      # Add zone to new VAV
      new_vav_system.addBranchForZone(zone)
    end
    return true
  end #end the run method

end #end the measure

#this allows the measure to be use by the application
AddVAV.new.registerWithApplication
