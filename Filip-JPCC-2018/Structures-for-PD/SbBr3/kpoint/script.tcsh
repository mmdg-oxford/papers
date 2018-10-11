rm tmp.dat

set file = "../structure/*_primitive"

set nel = `head -6 $file.vasp  | tail -1 | awk '{ FS = "|" } ; { print NF}'`

set ntot = "0"

foreach i ( `seq 1 $nel` )

	set el = `head -6 $file.vasp  | tail -1 | awk '{print $'$i'}'` 
	set n  = `head -7 $file.vasp  | tail -1 | awk '{print $'$i'}'` 
	
	@ ntot = $ntot + $n
	
	echo $el $n $ntot
	
	foreach j (`seq 1 $n`)
	
		echo $el >> tmp.dat
	
	end

end

tail -$ntot $file.vasp > tmp2.dat

paste tmp.dat tmp2.dat > tmp4.dat 

head -5 ../structure/*.vasp | tail -3 > cell_real.txt

cat na-scf.in cell_real.txt atomicpos.in tmp4.dat tail.in > sbbr3-scf.in

rm na-scf.in tmp.dat tmp2.dat atomicpos.in tmp4.dat tail.in
