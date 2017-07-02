import sys
inFile = sys.argv[1]
with open(inFile,'r') as f:
	cnt=0
	var=0.0
	sum=0.0
	avg=0.0
	for line in f:
		
		if "total_rss" in line:
			
			l1=line.split()
			
			if int(l1[1])!=0:
				cnt=cnt+1
				#print l1[1]
			var=float(l1[1])/(1048576)
			print var;
			sum=sum+var
			 #print sum
	print cnt
	avg=sum/cnt          
	print avg

