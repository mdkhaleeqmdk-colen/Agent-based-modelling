globals[
  ;Variables to be used for tutor marking
  student_id
  student_name
  student_score
  student_feedback

  ;Variables for your analysis
  most_effective_measure
  least_effective_measure
  population_most_affected
  population_most_immune
  self_isolation_link
  population_density

  total_infected_percentage
  cyan_infected_percentage
  lime_infected_percentage

  total_deaths
  cyan_deaths
  lime_deaths

  total_antibodies_percentage
  cyan_antibodies_percentage
  lime_antibodies_percentage

  present_active_cases
  c-t
  present_lime_population
  present_cyan_population
  buffer

  stored_settings
]

turtles-own[
  antibodies
  infected_time
  alter
  group

]

to setup_world
  set student_id 21071212 set student_name "Mohammed khaleeq"
  set cyan_population 1000 set lime_population 500
  set infection_rate 15 set survival_rate 70 set illness_duration 300 set initially_infected 20
  set immunity_duration  250 set undetected_period 70 set travel_restrictions false
  set social_distancing false set self_isolation false
  ask patches with [pycor <=  0][
    set pcolor lime]
  ask patches with [pycor >=  0][
    set pcolor cyan]
  clear-turtles
  reset-ticks

end

to setup_agents
  create-turtles lime_population[
    set size 2 set color grey
    setxy random min-pycor random-xcor
    set antibodies 0
    set alter false
    set group "lime turtle"]
  create-turtles cyan_population[
    set color grey
    set size 2
    setxy random max-pycor random-xcor
    set antibodies 0
    set alter false
    set group "cyan turtle"]
    ask n-of initially_infected turtles with [group = "lime turtle"] [ setxy 0 min-pycor
    infection ]
    ask n-of initially_infected turtles with [group = "cyan turtle"] [ setxy 2 max-pycor
    infection ]
  recurrview
end

to recurrview
  set present_lime_population count turtles with [
    group = "lime turtle"
  ]
  set present_cyan_population count turtles with [
    group = "cyan turtle"
  ]

  set c-t count turtles
  if c-t > 0 [
    set total_infected_percentage 100 *(count turtles with [ color = red ])/ c-t ]
  if present_lime_population > 0 [set lime_infected_percentage 100 *(count turtles with [color = red and group = "lime turtle"])/ present_lime_population ]
  if present_cyan_population > 0 [set cyan_infected_percentage (count turtles with [color = red and group = "cyan turtle"])* 100 / present_cyan_population ]
  if c-t > 0 [ set total_antibodies_percentage (count turtles with [ color = black])* 100 / c-t ]
  if present_lime_population > 0 [set lime_antibodies_percentage (count turtles with [color = black and group = "lime turtle"]) * 100 / present_lime_population ]
  if present_cyan_population > 0 [set cyan_antibodies_percentage (count turtles with [color = black and group = "cyan turtle"]) * 100 / present_cyan_population ]
  set present_active_cases count turtles with [alter]
end

to socialMovement
  ifelse count turtles-on patch-ahead 1 = 0 [
    m_isolate ]
   [ rt one-of (range -45 45)
  if count turtles-on patch-ahead 1 = 0 [
    m_isolate ]
  ]
end

to m_isolate
  ( ifelse
    self_isolation [
      ifelse alter [
        if (infected_time < (illness_duration - undetected_period)) [ set color orange]]
      [
        restrict_travelling
      ]
    ][
      restrict_travelling
    ] )
end
to infection
  set alter true
  set color red
    set infected_time illness_duration
end

to restrict_travelling
  if group = "lime turtle" [
    ( ifelse ycor >= 0 [ set heading 90 fd 0.2 ]
      [ifelse [pcolor] of patch-ahead 1 != lime
      [rt 180
      fd 0.2
      ][ fd 0.2]]
      )]
   if group = "cyan turtle"[
    ( ifelse ycor <= 0 [ set heading -90 fd 0.2 ]
      [ifelse [pcolor] of patch-ahead 1 != cyan
      [rt 180
      fd 0.2
      ][ fd 0.2]]
      )]
end

to turtle_motion
  rt one-of (range -20 20)
  ( ifelse social_distancing [socialMovement] self_isolation [ m_isolate ]
    travel_restrictions [ restrict_travelling ] [ fd 0.2 ] )
end

to immune_turtle
  if random-float 100 < survival_rate [ set alter false set color black set antibodies immunity_duration ]
end

to renew
  ask turtles with [color = black]
  [set antibodies antibodies - 1
    if antibodies <= 0
    [set color grey]
  ]
end
to live_leave
  if infected_time = 0 [
    ifelse random-float 100 < survival_rate [
      immune_turtle
    ][
      turtle_rip
    ]
  ]
end

to-report immune?
  report infection_rate > 0
end

to inject
  ask other turtles-here with [ not alter ]
  [ infection ]
end

to turtle_rip
  set total_deaths total_deaths + 1
  if group = "cyan turtle" [
    set cyan_deaths cyan_deaths + 1 ]
  if group = "lime turtle" [
  set lime_deaths lime_deaths + 1
  ]
  die
end
to iteration
  if color = red [ set infected_time infected_time - 1]
  if color = black[renew]
  if color = orange [set infected_time infected_time - 1]
end

to run_model
  ask turtles [
    iteration
    turtle_motion
    if color = red or color = orange [ live_leave ]
    if alter [ inject ]
  ]
  recurrview
  reset-ticks
end

to my_analysis
  set most_effective_measure 2
  set population_most_affected 2
  set least_effective_measure 3
  set population_most_immune 3
  set population_density 6
  set self_isolation_link 7
end

to checking_tool

  setup_world
  setup_agents
  run_model
  my_analysis

  print word student_id " if you see your student ID number here this is correct"
  print word student_name " if you see your student name here this is correct"
  print word student_score  " this must not contain anything only the value 0"
  print word student_feedback  " this must not contain anything only the value 0"

  ;Variables for your analysis
  ifelse most_effective_measure = 1 or most_effective_measure = 2 or most_effective_measure = 3 [
   show "you have entered a valid value for most_effective_measure"
  ][
    show "you have entered an invalid value for most_effective_measure, this needs to be set to 1, 2 or 3"
  ]

  ifelse least_effective_measure = 1 or least_effective_measure = 2 or least_effective_measure = 3 [
   show "you have entered a valid value for least_effective_measure"
  ][
    show "you have entered an invalid value for least_effective_measure, this needs to be set to 1, 2 or 3"
  ]

  ifelse population_most_affected = 1 or population_most_affected = 2 or population_most_affected = 3 [
   show "you have entered a valid value for population_most_affected"
  ][
    show "you have entered an invalid value for population_most_affected, this needs to be set to 1, 2 or 3"
  ]

  ifelse population_most_immune = 1 or population_most_immune = 2 or population_most_immune = 3 [
   show "you have entered a valid value for population_most_immune"
  ][
    show "you have entered an invalid value for population_most_immune, this needs to be set to 1, 2 or 3"
  ]

  ifelse self_isolation_link = 1 or self_isolation_link = 2 or self_isolation_link = 3 or self_isolation_link = 4 or self_isolation_link = 5 or self_isolation_link = 6 or self_isolation_link = 7 or self_isolation_link = 8 [
   show "you have entered a valid value for self_isolation_link"
  ][
    show "you have entered an invalid value for self_isolation_link, this needs to be set to 1, 2, 3, 4, 5, 6, 7 or 8"
  ]

  ifelse population_density = 1 or population_density = 2 or population_density = 3 or population_density = 4 or population_density = 5 or population_density = 6 [
   show "you have entered a valid value for population_density"
  ][
    show "you have entered an invalid value for population_density, this needs to be set to 1, 2, 3, 4, 5 or 6"
  ]

  ifelse total_infected_percentage >= 0 and total_infected_percentage <= 100 [
   show "total_infected_percentage is outputting a valid value"
  ][
    show "total_infected_percentage is not outputting a valid value, you need to check this"
  ]

  ifelse cyan_infected_percentage >= 0 and cyan_infected_percentage <= 100 [
   show "cyan_infected_percentage is outputting a valid value"
  ][
    show "cyan_infected_percentage is not outputting a valid value, you need to check this"
  ]

  ifelse lime_infected_percentage >= 0 and lime_infected_percentage <= 100 [
   show "lime_infected_percentage is outputting a valid value"
  ][
    show "lime_infected_percentage is not outputting a valid value, you need to check this"
  ]

  ifelse total_deaths >= 0 and total_deaths <= 7500 [
   show "total_deaths is outputting a valid value"
  ][
    show "total_deaths is not outputting a valid value, you need to check this"
  ]

  ifelse cyan_deaths >= 0 and cyan_deaths <= 5000 [
   show "cyan_deaths is outputting a valid value"
  ][
    show "cyan_deaths is not outputting a valid value, you need to check this"
  ]

  ifelse lime_deaths >= 0 and lime_deaths <= 2500 [
   show "lime_deaths is outputting a valid value"
  ][
    show "lime_deaths is not outputting a valid value, you need to check this"
  ]

  ifelse total_antibodies_percentage >= 0 and total_antibodies_percentage <= 100 [
   show "total_antibodies_percentage is outputting a valid value"
  ][
    show "total_antibodies_percentage is not outputting a valid value, you need to check this"
  ]

  ifelse cyan_antibodies_percentage >= 0 and cyan_antibodies_percentage <= 100 [
   show "cyan_antibodies_percentage is outputting a valid value"
  ][
    show "cyan_antibodies_percentage is not outputting a valid value, you need to check this"
  ]

  ifelse lime_antibodies_percentage >= 0 and lime_antibodies_percentage <= 100 [
   show "lime_antibodies_percentage is outputting a valid value"
  ][
    show "lime_antibodies_percentage is not outputting a valid value, you need to check this"
  ]

  ifelse cyan_population = 1000 [
    show "cyan_population is set to the correct value"
  ][
    show "cyan_population is not set to the correct value, you need to check this"
  ]

  ifelse lime_population = 500 [
    show "lime_population is set to the correct value"
  ][
    show "lime_population is not set to the correct value, you need to check this"
  ]

  ifelse initially_infected = 20 [
    show "initially_infected is set to the correct value"
  ][
    show "initially_infected is not set to the correct value, you need to check this"
  ]

  ifelse infection_rate = 15 [
    show "infection_rate is set to the correct value"
  ][
    show "infection_rate is not set to the correct value, you need to check this"
  ]

  ifelse survival_rate = 70 [
    show "survival_rate is set to the correct value"
  ][
    show "survival_rate is not set to the correct value, you need to check this"
  ]

  ifelse immunity_duration = 250 [
    show "immunity_duration is set to the correct value"
  ][
    show "immunity_duration is not set to the correct value, you need to check this"
  ]

  ifelse undetected_period = 70 [
    show "undetected_period is set to the correct value"
  ][
    show "undetected_period is not set to the correct value, you need to check this"
  ]

  ifelse illness_duration = 300 [
    show "illness_duration is set to the correct value"
  ][
    show "illness_duration is not set to the correct value, you need to check this"
  ]

  ifelse travel_restrictions = false [
    show "travel_restrictions is set to the correct value"
  ][
    show "travel_restrictions is not set to the correct value, you need to check this"
  ]

  ifelse social_distancing = false [
    show "social_distancing is set to the correct value"
  ][
    show "social_distancing is not set to the correct value, you need to check this"
  ]

  ifelse self_isolation = false [
    show "self_isolation is set to the correct value"
  ][
    show "self_isolation is not set to the correct value, you need to check this"
  ]

  ifelse world-width = 101 and world-height = 101 [
    show "World width and height correct"
  ][
    show "World width and height incorrect, you need to check this"
  ]

  ifelse patch-size = 5 [
    show "Patch size correct"
  ][
    show "Patch size incorrect, you need to check this"
  ]

  ifelse (count turtles with [group = "cyan turtle"]) = 1000 [
    show "correct number of cyan turtles found"
  ][
    show "incorrect number of cyan turtles found, you need to check this"
  ]

  ifelse (count turtles with [group = "lime turtle"]) = 500 [
    show "correct number of lime turtles found"
  ][
    show "incorrect number of lime turtles found, you need to check this"
  ]

  ifelse (count turtles with [group = "cyan turtle" and color = red]) = 20 [
    show "correct number of infected cyan turtles found"
  ][
    show "incorrect number of infected cyan turtles found, you need to check this"
  ]

  ifelse (count turtles with [group = "lime turtle" and color = red]) = 20 [
    show "correct number of infected lime turtles found"
  ][
    show "incorrect number of infected lime turtles found, you need to check this"
  ]
end
@#$#@#$#@
GRAPHICS-WINDOW
219
10
732
524
-1
-1
5.0
1
10
1
1
1
0
1
1
1
-50
50
-50
50
1
1
1
ticks
20.0

BUTTON
0
10
100
43
NIL
setup_world
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
102
10
210
43
NIL
setup_agents
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
59
50
148
83
NIL
run_model
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
3
83
175
116
cyan_population
cyan_population
0
1000
1000.0
1
1
NIL
HORIZONTAL

SLIDER
4
118
176
151
lime_population
lime_population
0
500
500.0
1
1
NIL
HORIZONTAL

SLIDER
3
154
175
187
initially_infected
initially_infected
0
100
20.0
1
1
NIL
HORIZONTAL

SLIDER
6
191
178
224
infection_rate
infection_rate
0
100
15.0
1
1
NIL
HORIZONTAL

SLIDER
7
226
179
259
survival_rate
survival_rate
0
100
70.0
1
1
NIL
HORIZONTAL

SLIDER
5
261
177
294
immunity_duration
immunity_duration
0
100
250.0
1
1
NIL
HORIZONTAL

SLIDER
5
296
177
329
undetected_period
undetected_period
0
100
70.0
1
1
NIL
HORIZONTAL

SLIDER
7
331
179
364
illness_duration
illness_duration
0
100
300.0
1
1
NIL
HORIZONTAL

SWITCH
7
373
163
406
travel_restrictions
travel_restrictions
1
1
-1000

SWITCH
8
412
135
445
self_isolation
self_isolation
1
1
-1000

SWITCH
9
454
157
487
social_distancing
social_distancing
1
1
-1000

MONITOR
829
63
990
108
total_infected_percentage
total_infected_percentage
17
1
11

MONITOR
910
119
1083
164
cyan_antibodies_percentage
cyan_antibodies_percentage
17
1
11

MONITOR
738
119
905
164
lime_antibodies_percentage
lime_antibodies_percentage
17
1
11

MONITOR
1062
11
1145
56
total_deaths
total_deaths
17
1
11

MONITOR
739
10
824
55
cyan_deaths
cyan_deaths
17
1
11

MONITOR
831
11
910
56
lime_deaths
lime_deaths
17
1
11

MONITOR
997
62
1169
107
total_antibodies_percentage
total_antibodies_percentage
17
1
11

MONITOR
1088
118
1250
163
cyan_infected_percentage
cyan_infected_percentage
17
1
11

MONITOR
740
169
896
214
lime_infected_percentage
lime_infected_percentage
17
1
11

MONITOR
919
10
1053
55
present_active_cases
present_active_cases
17
1
11

MONITOR
740
65
823
110
count turtles
count turtles
17
1
11

MONITOR
904
171
1058
216
present_cyan_population
present_cyan_population
17
1
11

MONITOR
1066
173
1239
218
current_lime_population
present_lime_population
17
1
11

PLOT
745
224
1262
374
population
hours
no of death
0.0
100.0
0.0
859.0
true
true
"" ""
PENS
"infected" 1.0 0 -2674135 true "" "plot total_infected_percentage"
"immune" 1.0 0 -16777216 true "" "plot total_antibodies_percentage"

PLOT
746
379
1264
529
populations
NIL
NIL
0.0
600.0
0.0
1100.0
true
true
"" ""
PENS
"cyan" 1.0 0 -11221820 true "" "plot cyan_population"
"mine" 1.0 0 -13840069 true "" "plot lime_population"

@#$#@#$#@
## WHAT IS IT?

(a general understanding of what the model is trying to show or explain)

## HOW IT WORKS

(what rules the agents use to create the overall behavior of the model)

## HOW TO USE IT

(how to use the model, including a description of each of the items in the Interface tab)

## THINGS TO NOTICE

(suggested things for the user to notice while running the model)

## THINGS TO TRY

(suggested things for the user to try to do (move sliders, switches, etc.) with the model)

## EXTENDING THE MODEL

(suggested things to add or change in the Code tab to make the model more complicated, detailed, accurate, etc.)

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## CREDITS AND REFERENCES

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.3.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
