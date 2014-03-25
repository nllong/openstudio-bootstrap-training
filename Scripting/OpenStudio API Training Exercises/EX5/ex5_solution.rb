
require 'openstudio'

#specify the .osm to open 
model_path = OpenStudio::Path.new('C:/OSTraining/EX4/ex4_solution.osm')

#load the model, version translating if necessary
if OpenStudio::exists(model_path)
  versionTranslator = OpenStudio::OSVersion::VersionTranslator.new 
  model = versionTranslator.loadModel(model_path)
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

#create some schedule type limits for
frac_sch_lim = OpenStudio::Model::ScheduleTypeLimits.new(model)
frac_sch_lim.setName("Fractional Sch Limits")
frac_sch_lim.setLowerLimitValue(0.0)
frac_sch_lim.setUpperLimitValue(1.0)
frac_sch_lim.setNumericType("Continuous")

temp_sch_lim = OpenStudio::Model::ScheduleTypeLimits.new(model)
temp_sch_lim.setName("Temperature Sch Limits")
temp_sch_lim.setLowerLimitValue(0.0)
temp_sch_lim.setUpperLimitValue(50.0)
temp_sch_lim.setNumericType("Continuous")
temp_sch_lim.setUnitType("Temperature")

activity_sch_lim = OpenStudio::Model::ScheduleTypeLimits.new(model)
activity_sch_lim.setName("Activity Level Sch Limits")
activity_sch_lim.setLowerLimitValue(0.0)
activity_sch_lim.setUpperLimitValue(600.0)
activity_sch_lim.setNumericType("Continuous")
activity_sch_lim.setUnitType("ActivityLevel")

#make a new schedule ruleset for occupancy
occ_sch = OpenStudio::Model::ScheduleRuleset.new(model)
occ_sch.setName("Occupancy Schedule")
occ_sch.setScheduleTypeLimits(frac_sch_lim)   

#weekdays
occ_week_day = occ_sch.defaultDaySchedule  
occ_week_day.setName("Occupancy Schedule Week Day")
occ_week_day.addValue(OpenStudio::Time.new(0, 9, 0, 0), 0.0) 
occ_week_day.addValue(OpenStudio::Time.new(0, 18, 0, 0), 0.90)     
occ_week_day.addValue(OpenStudio::Time.new(0, 24, 0, 0), 0.0)

#saturdays
occ_sat_rule = OpenStudio::Model::ScheduleRule.new(occ_sch)
occ_sat_rule.setName("Occupancy Schedule Saturday Rule")
occ_sat_rule.setApplySaturday(true)
occ_sat_rule.setStartDate(OpenStudio::Date.new(OpenStudio::MonthOfYear.new("May"), 4))
occ_sat_rule.setEndDate(OpenStudio::Date.new(OpenStudio::MonthOfYear.new("June"), 4))   
occ_sat = occ_sat_rule.daySchedule  
occ_sat.setName("Occupancy Schedule Saturday")
occ_sat.addValue(OpenStudio::Time.new(0, 9, 0, 0), 0.0) 
occ_sat.addValue(OpenStudio::Time.new(0, 17, 0, 0), 0.50)     
occ_sat.addValue(OpenStudio::Time.new(0, 24, 0, 0), 0.0)

#sundays
occ_sun_rule = OpenStudio::Model::ScheduleRule.new(occ_sch)
occ_sun_rule.setName("Occupancy Schedule Sunday Rule")
occ_sun_rule.setApplySunday(true)   
occ_sun = occ_sun_rule.daySchedule  
occ_sun.setName("Occupancy Schedule Sunday")
occ_sun.addValue(OpenStudio::Time.new(0, 9, 0, 0), 0.0) 
occ_sun.addValue(OpenStudio::Time.new(0, 17, 0, 0), 0.50)     
occ_sun.addValue(OpenStudio::Time.new(0, 24, 0, 0), 0.0)


#make a new schedule ruleset for lighting
lts_sch = OpenStudio::Model::ScheduleRuleset.new(model)
lts_sch.setName("Lighting Schedule")
lts_sch.setScheduleTypeLimits(frac_sch_lim)  

#weekdays
lts_week_day = lts_sch.defaultDaySchedule  
lts_week_day.setName("Lighting Schedule Week Day")
lts_week_day.addValue(OpenStudio::Time.new(0, 9, 0, 0), 0.0) 
lts_week_day.addValue(OpenStudio::Time.new(0, 18, 0, 0), 0.90)     
lts_week_day.addValue(OpenStudio::Time.new(0, 24, 0, 0), 0.0)

#saturdays
lts_sat_rule = OpenStudio::Model::ScheduleRule.new(lts_sch)
lts_sat_rule.setName("Lighting Schedule Saturday Rule")
lts_sat_rule.setApplySaturday(true)   
lts_sat = lts_sat_rule.daySchedule  
lts_sat.setName("Lighting Schedule Saturday")
lts_sat.addValue(OpenStudio::Time.new(0, 9, 0, 0), 0.0) 
lts_sat.addValue(OpenStudio::Time.new(0, 17, 0, 0), 0.50)     
lts_sat.addValue(OpenStudio::Time.new(0, 24, 0, 0), 0.0)

#sundays
lts_sun_rule = OpenStudio::Model::ScheduleRule.new(lts_sch)
lts_sun_rule.setName("Lighting Schedule Sunday Rule")
lts_sun_rule.setApplySunday(true)   
lts_sun = lts_sun_rule.daySchedule  
lts_sun.setName("Lighting Schedule Sunday")
lts_sun.addValue(OpenStudio::Time.new(0, 9, 0, 0), 0.0) 
lts_sun.addValue(OpenStudio::Time.new(0, 17, 0, 0), 0.50)     
lts_sun.addValue(OpenStudio::Time.new(0, 24, 0, 0), 0.0)


#make a new schedule ruleset for heating setpoint
htg_setpoint_sch = OpenStudio::Model::ScheduleRuleset.new(model)
htg_setpoint_sch.setName("Heating Setpoint Schedule")
htg_setpoint_sch.setScheduleTypeLimits(temp_sch_lim)  

#all days
htg_setpoint_all_days = htg_setpoint_sch.defaultDaySchedule  
htg_setpoint_all_days.setName("Heating Setpoint Schedule All Days")   
htg_setpoint_all_days.addValue(OpenStudio::Time.new(0, 7, 0, 0), 18.33) #65F
htg_setpoint_all_days.addValue(OpenStudio::Time.new(0, 20, 0, 0), 21.11) #70F 
htg_setpoint_all_days.addValue(OpenStudio::Time.new(0, 24, 0, 0), 18.33) #65F


#make a new schedule ruleset for cooling setpoint
clg_setpoint_sch = OpenStudio::Model::ScheduleRuleset.new(model)
clg_setpoint_sch.setName("Cooling Setpoint Schedule")
clg_setpoint_sch.setScheduleTypeLimits(temp_sch_lim)  

#all days
clg_setpoint_all_days = clg_setpoint_sch.defaultDaySchedule  
clg_setpoint_all_days.setName("Cooling Setpoint Schedule All Days")
clg_setpoint_all_days.addValue(OpenStudio::Time.new(0, 7, 0, 0), 26.67) #80F
clg_setpoint_all_days.addValue(OpenStudio::Time.new(0, 20, 0, 0), 23.89) #75F    
clg_setpoint_all_days.addValue(OpenStudio::Time.new(0, 24, 0, 0), 26.67) #80F   

#make a new schedule ruleset for people activity
people_activity_sch = OpenStudio::Model::ScheduleRuleset.new(model)
people_activity_sch.setName("People Activity Schedule")
people_activity_sch.setScheduleTypeLimits(activity_sch_lim)      

#all days
people_activity_all_days = people_activity_sch.defaultDaySchedule  
people_activity_all_days.setName("People Activity Schedule All Days")      
people_activity_all_days.addValue(OpenStudio::Time.new(0, 24, 0, 0), 120.0) #120 W


#make a default schedule set object
default_sch_set = OpenStudio::Model::DefaultScheduleSet.new(model)
default_sch_set.setName("Building Default Schedule Set")

#assign occupancy, lighting, and activity schedules to the default schedule set
default_sch_set.setNumberofPeopleSchedule(occ_sch)
default_sch_set.setLightingSchedule(lts_sch)
default_sch_set.setPeopleActivityLevelSchedule(people_activity_sch)

#assign this default schedule set to the two space types created earlier
if model.getSpaceTypeByName("Space Type A")
  space_type_a = model.getSpaceTypeByName("Space Type A").get
  space_type_a.setDefaultScheduleSet(default_sch_set)
end

if model.getSpaceTypeByName("Space Type B")
  space_type_b = model.getSpaceTypeByName("Space Type B").get
  space_type_b.setDefaultScheduleSet(default_sch_set)
end


#specify where the .osm will be saved
save_path = OpenStudio::Path.new('C:/OSTraining/EX5/ex5_solution.osm')

#save the model
model.save(save_path, true)

#let the user know that it finished successfully
puts "file saved to #{save_path}"
