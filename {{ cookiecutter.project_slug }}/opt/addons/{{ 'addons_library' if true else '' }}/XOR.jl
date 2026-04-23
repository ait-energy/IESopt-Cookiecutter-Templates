module IESoptAddon_XOR

# Creates constraints of using only one of multiple components at a time = exclusive operation of components.

# Necessary
# - loading the addon in the config and specifying the tags it should use
#       addons: {XOR: {tags: [xor_1, xor_2]}}
# - setting the parameter bigM to the capacity of the components
#       component: {config: 1000}
# - decision: switching to MILP or staying at LP

# Comments
# For each tag provided, an XOR constraint will be created which applies to all components with that tag.
# LP: the components share 100% of operation in one timestep (variable is 0-1), an interpretation of 25% and 75% capacity over one timestep is: 15min and 45min full load operation of the components.
# MILP: the constraint is enforced fully for one timestep (variable is a bool, 0 or 1)


# Tips
# - check out example 18_addons.iesopt.yaml for the use of addons and variables for addons


using IESopt
import JuMP

function initialize!(model::JuMP.Model, config::Dict)
    @info "[IESoptAddon_XOR] Initializing"

    if config["tags"] isa String
        config["tags"] = [config["tags"]]
    end


    return true
end

function construct_variables!(model, config)
    T = IESopt.get_T(model)
    for tag in config["tags"]
        for component in IESopt.get_components(model; tagged=tag)
            if :xor_ison ∉ keys(component.var)
                component.var.xor_ison = JuMP.@variable(
                    model,
                    [t in T],
                    Bin,
                    base_name = IESopt.make_base_name(component, "xor_ison"),
                    container = Array,
                )
            end
        end
    end
    return true
end

function construct_constraints!(model, config)
    T = IESopt.get_T(model)
    for tag in config["tags"]
        components = IESopt.get_components(model; tagged=tag)
        for component in components
            if !haskey(component.config, "bigM")
                @error "[IESoptAddon_XOR] Missing <bigM> parameter for component $(component.name)" 
                return false
            end
            bigM = component.config["bigM"]
            component.con.xor_ison = JuMP.@constraint(
                model,
                [t in T],
                get_variable(component)[t] <= bigM * component.var.xor_ison[t],
                container = Array,
            )
        end
        JuMP.@constraint(
            model, [t in T], sum(component.var.xor_ison[t] for component in components) <= 1
        )
    end
    return true
end

get_variable(connection::IESopt.Connection) = connection.var.flow
get_variable(unit::IESopt.Unit) = unit.var.conversion
get_variable(profile::IESopt.Profile) = profile.var.aux_value

end
