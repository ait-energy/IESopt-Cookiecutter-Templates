module IESoptAddon_ReduceUCtime

using JuMP
using IESopt


# Reduce the time resolution of the on/off decisions for the specified components 

# Necessary
# - Loading the addon in the config and specify a list of the compoenents to which it should be applied to and the new 
#   timescale for the on/off decisions 
#       addons: {ReduceUCtime: {components: [component1, component2], timescale: 24}}

# Comments
# - This add on is useful when you have exceptionally long minimum on times, then the decision can be made once a day rather than every hour for example.

# Tips
# - Check out example 18_addons.iesopt.yaml for the use of addons and variables for addons

function initialize!(model, config)
    return true
end

function construct_constraints!(model, config)
    T = get_T(model)
    
    for cname in get(config, "components", [])
        if !haskey(internal(model).model.components, cname)
            continue
        end

        component = get_component(model, cname)
        N = config["timescale"]

        for i in 1:(length(T) ÷ N)
            t0 = 1 + (i-1) * N
            t1 = i * N

            JuMP.@constraint(model, [t in T[t0+1:t1]], component.var.ison[t] == component.var.ison[T[t0]])
        end
    end

    return true
end

end

