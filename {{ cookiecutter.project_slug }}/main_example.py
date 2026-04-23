import iesopt


# Fetch the example
config_file = iesopt.make_example("01_basic_single_node", dst_dir="example")

# Parse, build, and solve the model.
model = iesopt.run(config_file)

# Get the results as a pandas DataFrame.
df = model.results.to_pandas()

# Print the first 5 rows of a sub-part of the DataFrame.
print(df[df["field"] == "value"].head(5))
