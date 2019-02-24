# MsPacman-NEAT
Playing MsPacman on OpenEmu using Neuroevolution of Augmenting Topologies (NEAT) with Long Short-term Memory (LSTM) neurons.

###### Prerequisites
* [Karabiner-VirtualHIDDevice](https://github.com/tekezo/Karabiner-VirtualHIDDevice)
  - This is required for the console application to press keys that OpenEmu will register.
  - To load the driver, from a Terminal on MacOS, `sudo kextload org.pqrs.driver.Karabiner.VirtualHIDDevice.v060800.kext`
  - As you can see from this discussion on the OpenEmu Issues Github sending keyboard events is not possible. [Question: Sending Keyboard Events #3681](https://github.com/OpenEmu/OpenEmu/issues/3681).  However, this Virtual keyboard has played over 25,000 games of MsPacman pressing keys without issue.
  
### Description
The network starts out with only 1 random link from the 60 inputs to the 4 outputs and builds from there.  

The fitness is defined as the number of pellets it eats.  This was because using score would rank networks that got lucky and ate ghosts, but then sat in the corner, higher than ones that moved around.  

The levels are defined ahead of time by horizontal rectangles that MsPacman and the Ghosts can traverse through, and the location of the pellets.  The horizontal rectangles become the areas that are reviewed when looking to find the locations of MsPacman and the Ghosts.  The pellets are reviewed to determine how many are gone once MsPacman dies.

The inputs are gathered by reviewing the horizontal rectangles, one time, to find the locations of MsPacman, Blinky, Pinky, Inky and Sue.  If a Power pellet is eaten then and the ghosts disappear and become scared ghosts, then the locations of up to 4 scared ghosts are found.

To determine if MsPacman can go Up, Right, Down or Left, 4 small rectangles (5x5 pixels) are constructed around her, 10 pixels out in each direction.  When these rectangles are contained inside the horizontal level rectangles, it is determined that she can move in that direction.

After all of the inputs are gathered, all but the first 4 are ran through a scaling function to move the values between -1 and 1.  This is so that the large values do not overwhelm the network and skew the prediction.

To keep the number of inputs down, the 20 closest pellets are calculated and the X,Y distance from MsPacman are given.

Each network gets one man to do the best it can, and there are 25 networks in a population.

The network is evolved over time but the neurons consist of LSTM memory nodes that retain previous values and use for ongoing predictions. Evolution has the chance to mutate the network via adding new nodes, adding new links, changing the values on the weights, replacing the weights, turning on/off a random link, or renabling a random link. If a network differs enough from the others, it will get placed into a new species and given time to mature and see if it will result in a better network.  Species that don't get better will be killed off.

### Inputs
#### MsPacman
1.    Can Go Up - (1 or 0)
2. Can Go Right - (1 or 0)
3.  Can Go Down - (1 or 0)
4.  Can Go Left - (1 or 0)
#### Blinky Distance from MsPacman (center to center)
5.   X distance - integer
6.   Y distance - integer
#### Pinky Distance from MsPacman (center to center)
7.   X distance - integer
8.   Y distance - integer
#### Inky Distance from MsPacman (center to center)
9.   X distance - integer
10.  Y distance - integer
#### Sue Distance from MsPacman (center to center)
11.  X distance - integer
12.  Y distance - integer
#### Scared Ghost #1 Distance from MsPacman (center to center)
13.  X distance - integer
14.  Y distance - integer
#### Scared Ghost #2 Distance from MsPacman (center to center)
15.  X distance - integer
16.  Y distance - integer
#### Scared Ghost #3 Distance from MsPacman (center to center)
17.  X distance - integer
18.  Y distance - integer
#### Scared Ghost #4 Distance from MsPacman (center to center)
19.  X distance - integer
20.  Y distance - integer
#### 20 closest Pellets (21-60)
21.  X distance - integer  
22.  Y distance - integer  

...  
59.  X distance - integer  
60.  Y distance - integer  

### Thanks
Thanks to bentrewhella and his github [An Objective C implementation of the NEAT algorithm](https://github.com/bentrewhella/Objective-NEAT) which was used as a starting place to understand the NEAT algorithm.

### Results
Current results are after 650 generations, the best network has eaten 119 pellets.  There are 218 pellets on the Cherry level, so the network does about as well as a below average human.

### Possbile Improvements
I think a possible improvement could be to add in a Q-Learning peice.  This would take the fittest network from each generation, and perform Q-Learning on it.  Then use it to evolve other networks, thereby increasing the fitness of the population, but also gaining from the evolution of the others.  Then when there are times when mutations are not creating better performing networks, Q-Learning will still make the popultation more fit.

The obvious challenge around this is implementing a backpropagation funtion.  Backpropagation is challenging as it is, but then backpropagating an LSTM neuron adds even more complexity.
