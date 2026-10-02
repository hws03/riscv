#python (n=5)

#n=5
#result=1
#while n!=0
#  result= result * n
#  n= n-1


#translate to assembly

#n=5
addi x1, x0, 5
#result=1
addi x2, x0, 1
#start loop 1
loop1:
  #while n!= 0
  beq x1, x0, finished
  #temp hold 0 in new reg
  addi x3, x0, 0
  #k =n
  addi x4, x1, 0
#start loop 2
loop2:
  #temp += result
  add  x3, x3, x2
  #k--       
  addi x4, x4, -1     
  #repeat n times  
  bne  x4, x0, loop2    
  #result = temp (result * n)
  addi x2, x3, 0
  #n = n - 1        
  addi x1, x1, -1
  #back to the while check
  jal  x0, loop1
#end
finished:
  jal  x0, finished