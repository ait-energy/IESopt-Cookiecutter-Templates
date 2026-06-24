# Meeting Minutes

# 14.05.2025 - Meeting on IESopt project template and IES conventions for IESopt

## IESopt project template
#### Goal
> Create an IESopt project template which allows for easy initialization and set up of a new IESopt project. This template should include for example the default folder structure, uv environment set up, and the option to also have example config files and templates.

#### Discussion outcomes on requirements/wishlist for project template
- Python environment which installs: iesopt, pandas, numpy, visualization package (matplotlib or plotly), a code formatter
- Set up of tests (hopefully encourages users to make use of tests in their project)
- Example config file 
    - Option to choose different "levels": from none,  basic, maximal where more extensive example config files include for example the reference to the correct folder path for add ons and templates, and example components
    - In one of the versions include an example of each component type
- Possibility for having example templates or template sets (ex. 'all', 'heating' etc.)
- Possibility to choose an IESopt example which gets downloaded and can just be run   
- Draw.io diagram (maybe already with the shapes for the core components or a sample diagram)
- Example visualization or visualization code

*Note: we also dicussed having a pre-set project documentation (either brouser based similar to IESopt documentation or automatic PDF generation with text and images --> but conclusion was not to implement this)*


#### Discussion outcomes - planned implementation
- "one liner" followed by a couple quesitons (i.e. project name, if example config files are desired, which set of templates are desired) 
- Remove templates from IESopt core and add to IESopt project template. That way changes/udates made to the templates will not require updating the IESopt version
- Currently only provided for python wrapper, not for julia


## IES conventions for IESopt templates
#### Provide default values? 
> No because it is easy for people to make mistakes 

#### Convention for template names:
> Use pascal case - capitals for the first letter of words, no underscores, start with the more general type and then add specialization (i.e. CHPBackpressure) this allows for easy alphabetic ordering and sorting of templates.

#### Conventions for template parameters
- parameter names are all in lower case letters with underscores for spaces
- operational costs: expressive and also starting with more general and then adding specializatiion
    - For example: opex_variable, opex_fixed 
- Switch to 'power' to describe capacity of technology
    - power (describes existing power)
    - power_lb (lower bound for investment)
    - power_ub (upper bound for investment)
    - (for something like CO2 or water, thien it is custom -- if power doesn't fit right, then don't use it)
- For connecting nodes: 
    - fuel_from, heat_to
    - follows IESopt syntax (ex. node_from, node_to) but specifies which energy carrier which is useful for example if you have more than one input/output

#### Documentation
- Have mandatory documentation for the templates that we all use
- Have validation too

## IES Convention for drawing IESopt system diagrams
#### Goal
> Clearly defined drawing convention among  IES IESopt users for consistency and clarity across IESopt projects, facillitating collaboration and communication:

#### General guidelines
- The IESopt diagram shoudl include all IESopt components in your model and the energy flows between them
- the component names should be the same as in your iesopt model
- Shapes are used to identify component types (consistent ancross projects)
- Colors are used to identify energy carriers or other additional information

#### Diagramming tool
- [draw.io](https://app.diagrams.net/) 

#### Conventions for shapes per core component
- **Profile**: diamond
- **Node**: oval (rectangle with fully rounded edges)
    - stateful node: filled in
- **Unit**: hexagon
- **Connection**:Arrow that is not dashed and labelled
- **Energy flows**: dashed arrows
- **Decision**: in automatic diagrams circle with question mark, in customizex diagram, italic text alongside/with the component the decision is relevant for
- **Template**: shape that is like a rectange with a flat top and squiggly line at the bottom
- (Please refer to example diagram)

## To be discussed further
- default colors for main energy carriers
- naming conventions for components
- excel template for input data request from project partners and clients


