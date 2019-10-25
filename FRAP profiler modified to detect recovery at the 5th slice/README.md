This is a quick hack of the FRAP_Profiler plugin ( <a href="http://worms.zoology.wisc.edu/research/4d/4d.html"> developed by Jeff Hardin </a>). The hack changes the strategy for the recovery curve fit, i.e. instead of starting the fit at a timeframe with the lowest intensity the fit ALWAYS starts at the frame #5. This hack allows FRAP analysis of tiny wiggle plant vacuoles in meristematic cells that swim in and out of focus. Sic! If the vacuole wiggled out of focus at early stage of recovery you will get falsely low % of mobile fraction!

<b>sic! This hack of the FRAP_profiler is currently applicable only for FRAP series containing 4 frames before photobleaching.  I will maybe make this parameter tunable later.
</b>
