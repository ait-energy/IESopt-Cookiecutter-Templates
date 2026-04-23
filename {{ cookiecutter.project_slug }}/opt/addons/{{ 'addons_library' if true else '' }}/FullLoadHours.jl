module IESoptAddon_FLH

# Constraint of minimum full load hours of a ranged profile or a unit, depending on whatever inout and carrier is defined.

# Necessary
# - loading the addon in the config 
#       addons: {FullLoadHours: {}}
# - giving the target the tag "FLH" in the config 
#       name: {tags: FLH}
# - giving the target the value for minimum full load hours in the config 
#       name: {config: {full_load_hours: 7000}}

# Tips
# - check out example 18_addons.iesopt.yaml for the use of addons and variables for addons


using IESopt
import JuMP

function initialize!(model::JuMP.Model, config::Dict)
    return true
end

function construct_constraints!(model::JuMP.Model, config::Dict)
    assets = get_components(model; tagged="FLH")

    for asset in assets
        if !enforce_full_load_hours(model, asset)
            return false
        end
    end

    return true
end

function enforce_full_load_hours(model::JuMP.Model, asset::Profile)
    p_max = maximum(access(asset.ub))
    flh = asset.config["full_load_hours"]

    T = get_T(model)
    snapshots = internal(model).model.snapshots

    JuMP.@constraint(asset.model,sum(asset.exp.value[t].*snapshots[t].weight for t in T) >= p_max * flh)

    return true
end

function enforce_full_load_hours(model::JuMP.Model, asset::Unit)
    if IESopt._isfixed(asset.capacity)
        p_max = access(asset.capacity)
        flh = asset.config["full_load_hours"]
        acc = asset.capacity_carrier
        load = getproperty(asset.exp, Symbol("$(acc.inout)_$(acc.carrier.name)"))

        T = get_T(model)
        snapshots = internal(model).model.snapshots

        JuMP.@constraint(asset.model, sum(load[t].*snapshots[t].weight for t in T) >= p_max * flh)

        return true

    else
        @error "FLH not possible for decision variables"
        return false
    end
end

end