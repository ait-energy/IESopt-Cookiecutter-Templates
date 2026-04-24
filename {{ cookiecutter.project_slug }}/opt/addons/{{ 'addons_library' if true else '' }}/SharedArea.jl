module SharedArea

# Limit the combined area of installed PV and solar thermal installations to the maximum roof area.

# Necessary: 
# - loading the add on in the config
#       addons: {shared_area: {}}
# - defining decision components for PV and solar thermal area
# - defining maximum roof area in the input parameters

# Tips:
# - check out example 18_addons.iesopt.yaml for the use of addons and variables for addons
# - A PV or solar thermal unit whose capacity is defined in area can be created by defining the 
#   availability factor as the normalized capacity (capacity/peak capacity) and the capacity as peak 
#   capacity per m2 times the area decison variable: 
        # pv:
        #     type: Unit
        #     outputs: { electricity: grid_el }
        #     conversion: ~ -> 1 electricity
        #     availability_factor: normalized_pv_share@secures_data 
        #     capacity: <pv_MW_peak_per_m2> * pv_area_invest:value out:electricity
        # pv_area_invest:
        #     type: Decision
        #     lb: <roof_area_min>
        #     ub: <roof_area_max>
        #     cost: <capex_per_m2_pv>


using IESopt: internal, JuMP


function initialize!(model::JuMP.Model, config::Dict{String, Any})
    @info "[GlobalAddon_SharedArea] Initializing"
    return true
end

function construct_constraints!(model::JuMP.Model, config::Dict{String, Any})
    components = internal(model).model.components

    # Check if the components are present.
    haskey(components, "pv_area_invest") || (return true)
    haskey(components, "solar_thermal_area_invest") || (return true)

    # Get the maximum roof area.
    area = internal(model).input.parameters["roof_area_max"]
    
    # Add the constraint.
    pv_decision = components["pv_area_invest"]
    solar_thermal_decision = components["solar_thermal_area_invest"]
    JuMP.@constraint(model, pv_decision.var.value + solar_thermal_decision.var.value <= area)

    return true
end

end

