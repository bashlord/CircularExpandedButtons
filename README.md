# CircularExpandedButtons

Button that expands into more depending on the parameters

Initialization: 

Required for the basic frame of the view that will be holding the button unexpanded

- CircleExpandButton(frame: CGRect)

numOfButtons: the number of buttons that will be expanded

margin: the distance between the center button's circumference and the expanded button's curcumference

startDegree: the degree offset for what direction to start at.  The default 0 parameter will cause it to expand along the x axis
- setupButton(numOfButtons: Int, margin: CGFloat, startDegree: CGFloat)

https://youtu.be/D_PRqpJzttU

If you want to dive right into the main part and mess around with parameters, simply modify/add pages to the ModelController.swift, then call func initButtons(flag:Int) in each DataViewController with different parameters.
