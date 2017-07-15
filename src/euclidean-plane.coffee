module.exports = ({turnAngle=PI/4, stepWidth=1, handedness= "left"})->
  {sin,cos,PI}=Math
  orientation = if handedness == "left" then -1 else 1
  normalize = (theta0)->
    theta = theta0 % (2*Math.PI)
    if theta < 0 then theta + 2*Math.PI else theta

  initialState: [0,0,0]
  move: ([x,y,theta])->
    [
      x  +  sin(theta) * stepWidth
      y  +  orientation * cos(theta) * stepWidth
      theta
    ]
  position: ([x,y])->[x,y]
  left: ([x,y,theta]) -> [x,y, normalize(theta-turnAngle)]
  right: ([x,y,theta]) -> [x,y, normalize(theta+turnAngle)]
  
