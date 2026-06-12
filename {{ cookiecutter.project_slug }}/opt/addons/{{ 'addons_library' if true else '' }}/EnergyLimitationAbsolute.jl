module EnergyLimitationAbsolute

# Limit the aggregated output of a create-profile to a maximum value

# Necessary: 
# - loading the addon in the config, and providing the maximum output limit and relevant profile name
#       addons: {EnergyLimitationAbsolute: {max_value: 10000, profile_name: "buy_biomethane"}}

# Comments:
# - This addon is applied to the example of limiting the aggregated output of a create-profile called 'buy biomethane' which 
#   represents the biomethane market to 10000 energy units (i.e. MWh), but can be adapted to other applications.
# - Note this can also be achieved by creating a stateful node rather than a create profile with an initial state 
#   equal to the maximum output limit

# Tips:
# - check out example 18_addons.iesopt.yaml for the use of addons and variables for addons

using JuMP
using IESopt

function initialize!(model, config)
    return true
end

function construct_constraints!(model, config)
    # Get sum of profile output
    T = get_T(model)
    snapshots = internal(model).model.snapshots
    profile_to_limit = get_component(model, config["profile_name"])
    
    total_output = sum(profile_to_limit.exp.value[t]*snapshots[t].weight for t in T) 

    # Limit profile output to an absolute value
    JuMP.@constraint(
        model,
        total_output <= config["max_value"])

    return true
end

end


