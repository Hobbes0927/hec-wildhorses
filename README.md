# hec-wildhorses

### **Description**

REDM provides limited wild horse breeds to be captured and tamed across the map.  This script supplements the available horses by adding a random chance of spawning additional types of horses.


### **Features**

- Can spawn rare horses when near one of the spawn locations
- Configurable maximum number of spawned horses
- Horses randomly spawn as male or female
- Specify multiple spawn locations
- Set multiple models for each location(s) and randomly pick one to spawn
- Configure 0.25%-5% chance of rare horse spawning
- Configure how often the random roll occurs to spawn a horse
- Configure respawn delay for the player
- Optionally job lock horse spawns
- Optionally notify the player when a horse spawns
- Optionally create Discord webhook when a horse spawns


***NOTE:  This script will not work with SireVLC Stables custom horses.  Only RDR2 native horse breeds/coats are available***


### **Dependencies**

[vorp_core](https://github.com/VORPCORE/vorp-core-lua)


### **Installation**

- Download the latest release from [https://github.com/Hobbes0927/hec-wildhorses](https://github.com/Hobbes0927/hec-wildhorses/releases)
- Add hec-wildhorses folder to your resources folder
- Add ensure hec-wildhorses to your resources.cfg
- Restart server


### **GitHub**
https://github.com/Hobbes0927/hec-wildhorses

### **Versions**

1.0.0 - First Full Release

1.1.0 - Added horse gender, more spawn chance options, and better job lock checking

1.1.1 - Added configuration option for how often the random roll occurs to spawn a horse

1.2.0 - Added configuration option to spawn multiple horses simultaneously

1.2.1 - Added configurable radius for spawn chance

1.2.2 - Fixed coordinate definition in the config.lua

1.2.3 - Spawn chance and max horses now configurable per breed
