# Make schedules that the new VAV system will use

midnight = OpenStudio::Time.new(0,24,0,0)

# Get the always on schedule that is built into the model

always_on_schedule = model.alwaysOnDiscreteSchedule

# Create a deck temperature schedule

deck_temp_schedule = OpenStudio::Model::ScheduleRuleset.new(model)
deck_temp_schedule.setName('Deck Temperature')
winter_designday_deck_temp = OpenStudio::Model::ScheduleDay.new(model)
deck_temp_schedule.setWinterDesignDaySchedule(winter_designday_deck_temp)
deck_temp_schedule.winterDesignDaySchedule.setName('Deck Temperature Winter Design Day')
deck_temp_schedule.winterDesignDaySchedule.addValue(midnight,12.8)
summer_designday_deck_temp = OpenStudio::Model::ScheduleDay.new(model)
deck_temp_schedule.setSummerDesignDaySchedule(summer_designday_deck_temp)
deck_temp_schedule.summerDesignDaySchedule.setName('Deck Temperature Summer Design Day')
deck_temp_schedule.summerDesignDaySchedule.addValue(midnight,12.8)
deck_temp_schedule.defaultDaySchedule.setName('Deck Temperature Default')
deck_temp_schedule.defaultDaySchedule.addValue(midnight,12.8)

# Create a hot water temperature schedule

hot_water_schedule = OpenStudio::Model::ScheduleRuleset.new(model)
hot_water_schedule.setName('Hot Water Temperature')
hot_water_winter_designday_temp = OpenStudio::Model::ScheduleDay.new(model)
hot_water_schedule.setWinterDesignDaySchedule(hot_water_winter_designday_temp)
hot_water_schedule.winterDesignDaySchedule().setName('Hot Water Temperature Winter Design Day')
hot_water_schedule.winterDesignDaySchedule().addValue(midnight,67)
hot_water_summer_designday_temp = OpenStudio::Model::ScheduleDay.new(model)
hot_water_schedule.setSummerDesignDaySchedule(hot_water_summer_designday_temp)
hot_water_schedule.summerDesignDaySchedule().setName('Hot Water Temperature Summer Design Day')
hot_water_schedule.summerDesignDaySchedule().addValue(midnight,67)
hot_water_schedule.defaultDaySchedule().setName('Hot Water Temperature Default')
hot_water_schedule.defaultDaySchedule().addValue(midnight,67)

# Create a chilled water temperature schedule
 
chilled_water_schedule = OpenStudio::Model::ScheduleRuleset.new(model)
chilled_water_schedule.setName('Chilled Water Temperature')
chilled_water_winter_designday_temp = OpenStudio::Model::ScheduleDay.new(model)
chilled_water_schedule.setWinterDesignDaySchedule(hot_water_winter_designday_temp)
chilled_water_schedule.winterDesignDaySchedule().setName('Chilled Water Temperature Winter Design Day')
chilled_water_schedule.winterDesignDaySchedule().addValue(midnight,6.7)
chilled_water_summer_designday_temp = OpenStudio::Model::ScheduleDay.new(model)
chilled_water_schedule.setSummerDesignDaySchedule(hot_water_summer_designday_temp)
chilled_water_schedule.summerDesignDaySchedule().setName('Chilled Water Temperature Summer Design Day')
chilled_water_schedule.summerDesignDaySchedule().addValue(midnight,6.7)
chilled_water_schedule.defaultDaySchedule().setName('Chilled Water Temperature Default')
chilled_water_schedule.defaultDaySchedule().addValue(midnight,6.7)

# Create the air handler

new_vav_system = OpenStudio::Model::AirLoopHVAC.new(model)
new_vav_system.setName("VAV with Reheat")

# Set the system sizing parameters

sizing_system = new_vav_system.sizingSystem()
sizing_system.setCentralCoolingDesignSupplyAirTemperature(12.8)
sizing_system.setCentralHeatingDesignSupplyAirTemperature(12.8)

# Create a fan

fan = OpenStudio::Model::FanVariableVolume.new(model,always_on_schedule)
fan.setPressureRise(500)

# Create a heating coil

coil_heating_water = OpenStudio::Model::CoilHeatingWater.new(model,always_on_schedule)

# Create a cooling coil

coil_cooling_water = OpenStudio::Model::CoilCoolingWater.new(model,always_on_schedule)

# Create setpoint managers to control the system

mixed_air_spm1 = OpenStudio::Model::SetpointManagerMixedAir.new(model)

mixed_air_spm2 = OpenStudio::Model::SetpointManagerMixedAir.new(model)

mixed_air_spm3 = OpenStudio::Model::SetpointManagerMixedAir.new(model)

deck_temp_spm = OpenStudio::Model::SetpointManagerScheduled.new(model,deck_temp_schedule)

# Create an outdoor air controller

controller_outdoor_air = OpenStudio::Model::ControllerOutdoorAir.new(model)

# Create an outdoor air system

outdoor_air_system = OpenStudio::Model::AirLoopHVACOutdoorAirSystem.new(model,controller_outdoor_air)

# Get the supply outlet node

supply_outlet_node = new_vav_system.supplyOutletNode()

# Add the components to the system by dropping on the supply outlet node

outdoor_air_system.addToNode(supply_outlet_node)
coil_cooling_water.addToNode(supply_outlet_node)
coil_heating_water.addToNode(supply_outlet_node)
fan.addToNode(supply_outlet_node)

# Get the component outlet nodes and add setpoint managers

node1 = fan.outletModelObject().get.to_Node.get
deck_temp_spm.addToNode(node1)
node2 = coil_heating_water.airOutletModelObject().get.to_Node.get
mixed_air_spm1.addToNode(node2)
node3 = coil_cooling_water.airOutletModelObject().get.to_Node.get
mixed_air_spm2.addToNode(node3)
node4 = outdoor_air_system.mixedAirModelObject().get.to_Node.get
mixed_air_spm3.addToNode(node4)

# Create a hot water plant

hot_water_plant = OpenStudio::Model::PlantLoop.new(model)
hot_water_plant.setName("Hot Water Loop")

# Set the plant sizing parameters

sizing_plant = hot_water_plant.sizingPlant()
sizing_plant.setLoopType("Heating")
sizing_plant.setDesignLoopExitTemperature(82.0)
sizing_plant.setLoopDesignTemperatureDifference(11.0)

# Get the inlet and outlet nodes

hot_water_outlet_node = hot_water_plant.supplyOutletNode()
hot_water_inlet_node = hot_water_plant.supplyInletNode()
hot_water_demand_outlet_node = hot_water_plant.demandOutletNode()
hot_water_demand_inlet_node = hot_water_plant.demandInletNode()

# Create a pump

pump = OpenStudio::Model::PumpVariableSpeed.new(model)

# Create a boiler

boiler = OpenStudio::Model::BoilerHotWater.new(model)

boiler_curve = OpenStudio::Model::CurveBiquadratic.new(model)
boiler_curve.setName("Boiler Efficiency")
boiler_curve.setCoefficient1Constant(1.0)
boiler_curve.setInputUnitTypeforX("Dimensionless")
boiler_curve.setInputUnitTypeforY("Dimensionless")
boiler_curve.setOutputUnitType("Dimensionless")

boiler.setNormalizedBoilerEfficiencyCurve(boiler_curve)
boiler.setEfficiencyCurveTemperatureEvaluationVariable("LeavingBoiler")

# Add the pump to the hot water plant

pump.addToNode(hot_water_inlet_node)

# Add the boiler to the hot water plant

node = hot_water_plant.supplySplitter().lastOutletModelObject().get.to_Node.get
boiler.addToNode(node)

# Create and add pipes

pipe = OpenStudio::Model::PipeAdiabatic.new(model)
hot_water_plant.addSupplyBranchForComponent(pipe)

hot_water_bypass = OpenStudio::Model::PipeAdiabatic.new(model)
hot_water_plant.addDemandBranchForComponent(hot_water_bypass)

# Add the hot water coil

hot_water_plant.addDemandBranchForComponent(coil_heating_water)

hot_water_demand_inlet = OpenStudio::Model::PipeAdiabatic.new(model)
hot_water_demand_outlet = OpenStudio::Model::PipeAdiabatic.new(model)

hot_water_demand_outlet.addToNode(hot_water_demand_outlet_node)
hot_water_demand_inlet.addToNode(hot_water_demand_inlet_node)
  
pipe2 = OpenStudio::Model::PipeAdiabatic.new(model)
pipe2.addToNode(hot_water_outlet_node)

# Create and had a hot water scheduled setpoint manager to the supply outlet node

hot_water_spm = OpenStudio::Model::SetpointManagerScheduled.new(model,hot_water_schedule)
hot_water_spm.addToNode(hot_water_outlet_node)

# Create a chilled water plant

chilled_water_plant = OpenStudio::Model::PlantLoop.new(model)
chilled_water_plant.setName("Chilled Water Loop")

# Set the plant sizing parameters

chilled_water_sizing = chilled_water_plant.sizingPlant()
chilled_water_sizing.setLoopType("Cooling")
chilled_water_sizing.setDesignLoopExitTemperature(7.22)
chilled_water_sizing.setLoopDesignTemperatureDifference(6.67)

# Get the inlet and outlet nodes

chilled_water_outlet_node = chilled_water_plant.supplyOutletNode()
chilled_water_inlet_node = chilled_water_plant.supplyInletNode()
chilled_water_demand_outlet_node = chilled_water_plant.demandOutletNode()
chilled_water_demand_inlet_node = chilled_water_plant.demandInletNode()

# Create and add a pump

pump2 = OpenStudio::Model::PumpVariableSpeed.new(model)
pump2.addToNode(chilled_water_inlet_node)

# Create chiller curves

ccFofT = OpenStudio::Model::CurveBiquadratic.new(model)
ccFofT.setCoefficient1Constant(1.0215158)
ccFofT.setCoefficient2x(0.037035864)
ccFofT.setCoefficient3xPOW2(0.0002332476)
ccFofT.setCoefficient4y(-0.003894048)
ccFofT.setCoefficient5yPOW2(-6.52536e-005)
ccFofT.setCoefficient6xTIMESY(-0.0002680452)
ccFofT.setMinimumValueofx(5.0)
ccFofT.setMaximumValueofx(10.0)
ccFofT.setMinimumValueofy(24.0)
ccFofT.setMaximumValueofy(35.0)

eirToCorfOfT = OpenStudio::Model::CurveBiquadratic.new(model)
eirToCorfOfT.setCoefficient1Constant(0.70176857)
eirToCorfOfT.setCoefficient2x(-0.00452016)
eirToCorfOfT.setCoefficient3xPOW2(0.0005331096)
eirToCorfOfT.setCoefficient4y(-0.005498208)
eirToCorfOfT.setCoefficient5yPOW2(0.0005445792)
eirToCorfOfT.setCoefficient6xTIMESY(-0.0007290324)
eirToCorfOfT.setMinimumValueofx(5.0)
eirToCorfOfT.setMaximumValueofx(10.0)
eirToCorfOfT.setMinimumValueofy(24.0)
eirToCorfOfT.setMaximumValueofy(35.0)

eirToCorfOfPlr = OpenStudio::Model::CurveQuadratic.new(model)
eirToCorfOfPlr.setCoefficient1Constant(0.06369119)
eirToCorfOfPlr.setCoefficient2x(0.58488832)
eirToCorfOfPlr.setCoefficient3xPOW2(0.35280274)
eirToCorfOfPlr.setMinimumValueofx(0.0)
eirToCorfOfPlr.setMaximumValueofx(1.0)

# Create and add a chiller

chiller = OpenStudio::Model::ChillerElectricEIR.new(model,ccFofT,eirToCorfOfT,eirToCorfOfPlr)

node = chilled_water_plant.supplySplitter().lastOutletModelObject().get.to_Node.get
chiller.addToNode(node)

# Create and add pipes

pipe3 = OpenStudio::Model::PipeAdiabatic.new(model)
chilled_water_plant.addSupplyBranchForComponent(pipe3)
  
pipe4 = OpenStudio::Model::PipeAdiabatic.new(model)
pipe4.addToNode(chilled_water_outlet_node)

# Add the chilled water coil to the plant

chilled_water_plant.addDemandBranchForComponent(coil_cooling_water)

# Create and add a chilled water setpoint manager

chilled_water_spm = OpenStudio::Model::SetpointManagerScheduled.new(model,chilled_water_schedule)
chilled_water_spm.addToNode(chilled_water_outlet_node)

chilled_water_demand_bypass = OpenStudio::Model::PipeAdiabatic.new(model)
chilled_water_plant.addDemandBranchForComponent(chilled_water_demand_bypass)

chilled_water_demand_inlet = OpenStudio::Model::PipeAdiabatic.new(model)
chilled_water_demand_inlet.addToNode(chilled_water_demand_inlet_node)

chilled_water_demand_outlet = OpenStudio::Model::PipeAdiabatic.new(model)
chilled_water_demand_outlet.addToNode(chilled_water_demand_outlet_node)
  
# Create a condenser system

condenser_system = OpenStudio::Model::PlantLoop.new(model)
condenser_system.setName("Condenser Water System")

# Set the plant sizing parameters

condenser_sizing = condenser_system.sizingPlant()
condenser_sizing.setLoopType("Condenser")
condenser_sizing.setDesignLoopExitTemperature(29.4)
condenser_sizing.setLoopDesignTemperatureDifference(5.6)

# Create and add a cooling tower

tower = OpenStudio::Model::CoolingTowerSingleSpeed.new(model)
condenser_system.addSupplyBranchForComponent(tower)

# Create and add a supply bypass

condenser_supply_bypass = OpenStudio::Model::PipeAdiabatic.new(model)
condenser_system.addSupplyBranchForComponent(condenser_supply_bypass)

# Get the inlet and outlet nodes

condenser_system_demand_outlet_node = condenser_system.demandOutletNode()
condenser_system_demand_inlet_node = condenser_system.demandInletNode()
condenser_system_supply_outlet_node = condenser_system.supplyOutletNode()
condenser_system_supply_inlet_node = condenser_system.supplyInletNode()

# Create and add a supply outlet pipe

condenser_supply_outlet = OpenStudio::Model::PipeAdiabatic.new(model)
condenser_supply_outlet.addToNode(condenser_system_supply_outlet_node)

# Create and add a pump

pump3 = OpenStudio::Model::PumpVariableSpeed.new(model)
pump3.addToNode(condenser_system_supply_inlet_node)

# Add the chiller as a demand component

condenser_system.addDemandBranchForComponent(chiller)

# Create and add demand pipes

condenser_demand_bypass = OpenStudio::Model::PipeAdiabatic.new(model)
condenser_system.addDemandBranchForComponent(condenser_demand_bypass)

condenser_demand_inlet = OpenStudio::Model::PipeAdiabatic.new(model)
condenser_demand_inlet.addToNode(condenser_system_demand_inlet_node)

condenser_demand_outlet = OpenStudio::Model::PipeAdiabatic.new(model)
condenser_demand_outlet.addToNode(condenser_system_demand_outlet_node)

# Create and add a SetpointManagerFollowOutdoorAirTemperature object.

spm = OpenStudio::Model::SetpointManagerFollowOutdoorAirTemperature.new(model)
spm.addToNode(condenser_system_supply_outlet_node)

# Create an air terminal.  This will be automatically copied for each zone that is added.

water_reheat_coil = OpenStudio::Model::CoilHeatingWater.new(model,always_on_schedule)
water_terminal = OpenStudio::Model::AirTerminalSingleDuctVAVReheat.new(model,always_on_schedule,water_reheat_coil)
new_vav_system.addBranchForHVACComponent(water_terminal)
hot_water_plant.addDemandBranchForComponent(water_reheat_coil)
