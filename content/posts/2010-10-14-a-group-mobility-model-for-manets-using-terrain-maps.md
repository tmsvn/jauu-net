---
title: "A Group Mobility Model for MANETs Using Terrain Maps"
date: 2010-10-14T17:59:28+02:00
draft: false
---

Due to the lack of money some month ago - now sounds funny - I skipped a conference
where I wanted to present an approach to model group mobility of nodes. The
idea is to use a form of terrain map (normally used to generate landscape
models) as a basis to emulate real world motion characteristics similar. The
focus are groups and their motion characterstic within the group. The terrain
map is interpreted as what I called penalty map: the object wish is to evade
areas with higher penalties to move from start to end. The intra-group mobility
is minted through a "virtual magnet". Nodes are placed in a position around a
virtual center of the nodes. Nodes are appointed to stay there but the terrain
map will also shift nodes to a more penalty free zone. For example: within a
valley all nodes will come closer to each other because the hill have a higher
penalty. In a flat environemt all nodes will stay at the pre-defined relative
position because all penalty factors are equal.


![images/penalty-map-3d.png](images/penalty-map-3d.png)
The previous section is a summary of the algorithm. See


[A-Mobility-Model-for-MANETs-Using-Terrain-Maps.pdf](http://blog.jauu.net/2010/10/14/A-Group-Mobility-Model-for-MANETs-Using-Terrain-Maps/grmoge.pdf)


