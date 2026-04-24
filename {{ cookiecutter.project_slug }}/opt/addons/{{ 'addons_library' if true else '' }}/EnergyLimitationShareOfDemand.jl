module EnergyLimitationShareOfDemand

# Limit the output of units tagged with the provided tag to a maximum share of the total heat demand.
# Here it is applied to the example of limitting heat output from components with biomass as a fuels source.

# Necessary: 
# - loading the add on in the config, and providing the maximum output limit
#       addons: {EnergyLimitationShareOfDemand: {max_share: 0.5, tag: "Biomass"}}
# - tagging all components that are being targetted with a common tag, e.g. "Biomass"
# - the model assumes the use of templates with heat output units and profiles labelled 'unit' (see those in invest folder)

# Tips:
# - check out example 18_addons.iesopt.yaml for the use of addons and variables for addons

using JuMP
using IESopt

function initialize!(model, config)
    return true
end

function construct_constraints!(model, config)
    # Get timesteps 
    T = get_T(model)

    # Get all templates tagged with the tag provided
    tagged_components = get_components(model, tagged=config["tag"])
    demand = get_component(model, "demand_heat")

    # Get total heat output from tagged components
    total_heat_out_from_tagged_components = 0.0

    # Apply get heat out function to component labeled 'unit' in the templates tagged 
    for component in tagged_components
        total_heat_out_from_tagged_components += get_heat_out(component.unit)
    end

    # Get total heat demand
    total_heat_demand = sum(demand.exp.value)

    # Add constraint to limit heat out from tagged componentns to maximum share of heat demand
    JuMP.@constraint(
        model,
        total_heat_out_from_tagged_components <= config["max_share"] * total_heat_demand)

    return true
end

# the function get_heat_out works differently depending on the input type
function get_heat_out(unit::Profile)
    return sum(unit.exp.value)
end

function get_heat_out(unit::Unit)
    return sum(unit.exp.out_heat)
end

end

