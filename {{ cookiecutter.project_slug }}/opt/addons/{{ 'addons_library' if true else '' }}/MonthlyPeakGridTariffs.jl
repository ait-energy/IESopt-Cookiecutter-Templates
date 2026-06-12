module IESoptAddon_MonthlyPeakGridTariffs

# Creates constraints to reflect power component of grid tariffs (could be gas or electricity) by implementing a 
# decision variable for the maximum power flow in each month associated with a cost

# Necessary
# - loading the addon in the config and specify the name of the consumption connection and year
#       addons: {MonthlyPeakGridTariffs: {consumption_connection: grid_conn_electricity, year: 2023}}
# - creating a decision variable for each month with the name 'grid_tariff_max_power_consumption_$m', where m is
#   the month number (1-12). 'lb' should be set to 0, 'cost' needs to be set to the yearly price-value/12 (which 
#   is the value given in Austria) If you use different names, don't forget to update the name in the addon code too
# - The addon is applied to a connection. Therefore, you create a node for the electricity grid, a node for your
#   'internal' electricity grid (that includes the tariff) and then make a connection between these two. 

# Comments
# - This version for grid tariffs requires the creation of additional components, but is more straightforward to 
# understand since it uses decision variables.

# Tips
# - Check out example 18_addons.iesopt.yaml for the use of addons and variables for addons
# - The creation of the monthly decision variables can be done efficiently by using a csv file. Check out example 
#   09_csv_only_iesop.yaml for how to load components in a csv file


using IESopt
using Dates
import JuMP

function initialize!(model::JuMP.Model, config::Dict)
    return true
end

function construct_constraints!(model::JuMP.Model, config::Dict)
    # Get the consumption grid connection.
    conn = get_component(model, config["consumption_connection"])

    # Get the year from the config.
    year = config["year"]

    # Apply the monthly varying power consumption tariffs as "upper bounds".
    for m in 1:12
        decision = get_component(model, "grid_tariff_max_power_consumption_$m")


        hours_per_month = get_hours_per_month_list(year)
        cumulative_hours = vcat(0,cumsum(hours_per_month))
        
        JuMP.@constraint(
            model,
            [t = 1:hours_per_month[m]],
            conn.var.flow[t + cumulative_hours[m]] <= decision.var.value,
            base_name = "grid_tariff_month_$m",
        )
    end

    return true
end

end


function get_hours_per_month_list(year::Integer)
    days = [31, isleapyear(year) ? 29 : 28, 31, 30, 31, 30,
            31, 31, 30, 31, 30, 31]

# Tips
# - Check out example 59_monthly_grid_tariffs.iesopt.yaml for the use of monthly decision variables in a csv
# - The creation of the monthly decision variables can be done efficiently by using a csv file. Check out example 
#   09_csv_only_iesop.yaml for how to load components in a csv file
# - Check out example 18_addons.iesopt.yaml for the use of addons and variables for addons
end