myfun=function(x)
{
  if (x<1e-6) x=0
  else if (x<0.02) x=0.02
  else if (x<0.04) x=0.04
  else if (x<0.06) x=0.06
  else if (x<0.08) x=0.08
  else if (x<0.1) x=0.1
  else if (x<0.2) x=0.2
  else if (x<0.4) x=0.4
  else if (x<0.6) x=0.6
  else if (x<0.8) x=0.8
  else if (x<1.0) x=1.0
      
}