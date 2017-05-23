# Mind_controlled_Nano_robot
Here we use Live signals from Neurosky headset and move a Nano Hex Bot by classifying brainwaves and identifying the state of the mind.

We train the model on a subject for 1-2 min, trying to understand the natural state of brain waves and fit the model for exclusive needs of the person. Once we have the basic statistics in position , we pass the samples through an adaptive window that dynamically keeps track of the recent signals and this is then passed onto a SVM classification model to identify the live brain status. 

The final classification triggers an microcontroller to move the HexBot in either forward, backward, left or right direction. 

In the big picture, this technique is and can be used in enabling the physically challenged people in meeting their needs. 
