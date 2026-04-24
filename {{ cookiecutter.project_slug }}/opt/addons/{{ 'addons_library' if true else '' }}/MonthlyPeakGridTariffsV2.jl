module IESoptAddon_MonthlyPeakGridTariffsV2

using Dates
using JuMP
using IESopt


# Add on to reflect power component of grid tariffs (could be gas or electricity). This is the price paid for 
# the peak power consumed each month.

# Necessary
# - loading the addon in the config and specify the name of the consumption connection and year
#       addons: {MonthlyPeakGridTariffsV2: {price: 87556, year: 2024, connection: grid_buy_electricity}}
# - The add on is applied to a connection. Therefore, you create a node for the electricity grid, a and a node 
#   for your 'internal' electricity grid abd then make a connection between these two. 
# - This version of the add on assumes your modeling time frame is 1 year and that your snapshots are 1 hour long

# Comments
# - This version for grid tariffs does not require the the creation of additional components, but is a bit less 
#   straightforward to understand since it uses decision variables.
# - For result extraction, now there are variables with a length of 12, this might need to be filtered out when 
#   accessing results depending on the approach you are using.
# - In Austria, grid peaks is one price applied to the average monthls peak for the year. The add on assumes that 
#   this is the price provided (It is then divided by 12 and applied to each monthly peak, which gives the same result
#   as applying the full price to the average monthly peak at the end of the year)


# Tips
# - Check out example 18_addons.iesopt.yaml for the use of addons and variables for addons


function initialize!(model, config)
    y = config["year"]
    # Creates a vector which specifies the month for each snapshot as a value between 1 and 12
    config["snapshot_months"] = Dates.month.(DateTime(y):Hour(1):DateTime(y+1) - Hour(1))
    return true
end

function construct_variables!(model, config)
    # Create 12 new variables, which specify the peak flow in eacah month. 
    # By calling it connection.var.monthly_peaks, you can then access it like you do any other variables in the model in my result object  
    connection = get_component(model, config["connection"])
    connection.var.monthly_peaks = JuMP.@variable(model, [1:12])
    return true
end

function construct_constraints!(model, config)
    # Add a constraint that says that the flow in each month must be less than or equal to the monthly peak variable in that month
    # For this, you need to specify container = Array because jump creates a special type of variable that that is not an array but IESopt uses the array type
    connection = get_component(model, config["connection"])
    T = get_T(model)
    connection.con.monthly_peaks = JuMP.@constraint(
        model,
        [t in T],
        connection.var.flow[t] <= connection.var.monthly_peaks[config["snapshot_months"][t]],
        container=Array,
    )
    return true
end

function construct_objective!(model, config)
    # Finally, add the cost associated with the montly peaks
    # Use push! to add the cost to the existing objective, if you just create a new objective it would replace the existing one and you don't want that
    # The objective consists of many terms, each term is a variable multiplied by a price
    # In austria grid peaks is one price applied to the average monthls peak for the year, but you can just divide the price by 12 and apply it to each 
    # monthly peak and you get the same result
    connection = get_component(model, config["connection"])
    monthly_price = config["price"] / 12
    connection.obj.monthly_peaks = sum(connection.var.monthly_peaks[m] * monthly_price for m in 1:12)
    push!(internal(model).model.objectives["total_cost"].terms, connection.obj.monthly_peaks)
    @show connection.obj.monthly_peaks
    return true
end

end