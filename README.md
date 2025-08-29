Project Overview This project involves developing a simulation model
in NetLogo to analyze the spread of an infectious disease among a
population of agents over time. The model evaluates the effectiveness
of different containment measures, such as:

Local Movement Restrictions – Agents staying within their designated
region vs. free movement. Social Distancing – Maintaining a safe
distance vs. no distancing. Self-Isolation – Infected individuals
isolating vs. continuing normal movement.

Project Requirements General Model Criteria

It must not use restricted commands such as clear-all, stop, show,
print, etc. The world is a 101 x 101 patch grid with: Cyan region (one
half). Lime region (other half). Origin at the center. The simulation
must run at 20 frames per second.

Key Variables Global variables are used for simulation settings and
data collection, including:

Population sizes: cyan_population = 1000, lime_population = 500
Infection parameters: infection_rate = 15, illness_duration = 300
Survival and immunity: survival_rate = 70, immunity_duration = 250
Control measures: travel_restrictions, social_distancing,
self_isolation

Functions Implemented

setup_world Resets the tick counter. Clears existing agents. Creates
two distinct colored regions (cyan & lime). Sets student information
and default parameters.
setup_agents Creates grey-colored agents based on population size.
Places them in their respective regions. Assigns initial infection to
a subset of agents.
run_model Updates the tick counter. Implements agent movement and
infection spread mechanics. Enforces social distancing,
self-isolation, and local movement restrictions. Tracks infection
spread, deaths, and immunity percentages.
my_analysis Determines the most and least effective disease control
measures. Assesses mortality rates and immunity levels in different
populations. Evaluates the impact of population density on virus
spread. Simulation Outcomes After 5,000+ ticks, the model allows for
analyzing:

Which control measure reduces infections the most. The population
group most affected by mortality. The impact of population density on
long-term disease outcomes. How to Run the Model Open NetLogo and load
the project file. Click setup_world to initialize the simulation.
Click setup_agents to populate agents. Click run_model to start the
simulation. Observe real-time data outputs in the global variables.
Run my_analysis after sufficient ticks for final insights.

Conclusion This simulation provides a realistic representation of
disease spread under different conditions. By adjusting parameters,
users can explore how various public health strategies impact
infection rates and overall population survival.
