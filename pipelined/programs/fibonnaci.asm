# python:

# a=0 b=1 n=9
# while(n!=0):
#   c = a + b	
#   a = b
#   b = c
#   n = n - 1

#---------------------

#translate to assembly:

#a=0
addi x1, x0, 0
#b=1
addi x2, x0, 1
#n=9
addi x4, x0, 9
#start loop here
loop:
  #c=a+b
  add x3, x1, x2
  #a=b
  addi x1, x2, 0
  #b=c
  addi x2, x3, 0
  #n=n-1
  addi x4, x4, -1
  #while loop (n != 0)
  bne x4, x0, loop
#end loop here
done:
  jal x0, done