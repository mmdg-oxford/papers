#!/bin/bash

energy=22

#
# Figure 1(a)
#
python step.py --temp 1 --method 1 --vb --energy 115 > data/new_model/step_vb_RS.dat
python step.py --temp 1 --method 2 --vb --energy 115 > data/new_model/step_vb_BW.dat
python step.py --temp 1 --method 1 --cb --energy 115 > data/new_model/step_cb_RS.dat
python step.py --temp 1 --method 2 --cb --energy 115 > data/new_model/step_cb_BW.dat

python epw_step.py --temp 1 --method 2 --vb --direction gx --energy $energy > data/new_model/epw_step_vb_gx.dat 
python epw_step.py --temp 1 --method 2 --vb --direction gy --energy $energy > data/new_model/epw_step_vb_gy.dat 
python epw_step.py --temp 1 --method 2 --vb --direction gz --energy $energy > data/new_model/epw_step_vb_gz.dat 
python epw_step.py --temp 1 --method 2 --cb --direction gx --energy $energy > data/new_model/epw_step_cb_gx.dat 
python epw_step.py --temp 1 --method 2 --cb --direction gy --energy $energy > data/new_model/epw_step_cb_gy.dat 
python epw_step.py --temp 1 --method 2 --cb --direction gz --energy $energy > data/new_model/epw_step_cb_gz.dat 

#
# Figure 1(b)
#
python lifetime.py --method 2 --vb > foo
python lifetime.py --method 2 --cb > bar
paste foo bar > data/new_model/lifetime_BW.dat
python lifetime.py --method 2 --vb --energy $energy > foo
python lifetime.py --method 2 --cb --energy $energy > bar
paste foo bar > data/new_model/lifetime_BW_above.dat

function parse_lifetime {
  echo "$tmp" | awk '
BEGIN{
  min[0] = 1e6
  min[1] = 1e6
}
{
  if ($2 < min[NR % 2]) {
    min[NR % 2] = $2
  }
}
END {
  print $1, min[1], min[0]
}'
}
tmp=$(python epw_lifetime.py --temp 1 --method 2 --vb --energy $energy)
parse_lifetime > data/new_model/epw_lifetime_vb.dat
#tmp=$(python epw_lifetime.py --temp 50 --method 2 --vb --energy $energy)
#parse_lifetime >> data/new_model/epw_lifetime_vb.dat
tmp=$(python epw_lifetime.py --temp 150 --method 2 --vb --energy $energy)
parse_lifetime >> data/new_model/epw_lifetime_vb.dat
tmp=$(python epw_lifetime.py --temp 300 --method 2 --vb --energy $energy)
parse_lifetime >> data/new_model/epw_lifetime_vb.dat

tmp=$(python epw_lifetime.py --temp 1 --method 2 --cb --energy $energy)
parse_lifetime > data/new_model/epw_lifetime_cb.dat
#tmp=$(python epw_lifetime.py --temp 50 --method 2 --cb --energy $energy)
#parse_lifetime >> data/new_model/epw_lifetime_cb.dat
tmp=$(python epw_lifetime.py --temp 150 --method 2 --cb --energy $energy)
parse_lifetime >> data/new_model/epw_lifetime_cb.dat
tmp=$(python epw_lifetime.py --temp 300 --method 2 --cb --energy $energy)
parse_lifetime >> data/new_model/epw_lifetime_cb.dat

tmp=$(python epw_lifetime.py --temp 1 --method 1 --vb --energy $energy --acoustic)
parse_lifetime > data/new_model/epw_lifetime_vb_acoustic.dat
tmp=$(python epw_lifetime.py --temp 300 --method 1 --vb --energy $energy --acoustic)
parse_lifetime >> data/new_model/epw_lifetime_vb_acoustic.dat

#
# Figure 1(c)
#
python mass.py --method 1 --energy 1e-3 --vb > foo
python mass.py --method 1 --energy 1e-3 --cb > bar
paste foo bar > data/new_model/mass_RS.dat
python mass.py --method 2 --energy 1e-3 --vb > foo
python mass.py --method 2 --energy 1e-3 --cb > bar
paste foo bar > data/new_model/mass_BW.dat

function parse_mass {
  echo "$tmp" | awk '
BEGIN{
  num_val = 0
}
{
  val[num_val] = $2
  sum_val += $2
  num_val++
}
END{
  avg = sum_val / num_val
  err = 0
  for (i = 0; i < num_val; i++) {
    err += (val[i] - avg)^2
  }
  stdev = sqrt(err / (num_val - 1))
  print $1, avg, 2.0*stdev
}'
}
tmp=$(python epw_mass.py --temp 1 --method 2 --vb)
parse_mass > data/new_model/epw_mass_vb.dat
tmp=$(python epw_mass.py --temp 150 --method 2 --vb)
parse_mass >> data/new_model/epw_mass_vb.dat
tmp=$(python epw_mass.py --temp 300 --method 2 --vb)
parse_mass >> data/new_model/epw_mass_vb.dat

tmp=$(python epw_mass.py --temp 1 --method 2 --cb)
parse_mass > data/new_model/epw_mass_cb.dat
tmp=$(python epw_mass.py --temp 150 --method 2 --cb)
parse_mass >> data/new_model/epw_mass_cb.dat
tmp=$(python epw_mass.py --temp 300 --method 2 --cb)
parse_mass >> data/new_model/epw_mass_cb.dat
#
#tmp=$(python epw_mass.py --temp 1 --method 1 --cb --acoustic)
#parse_mass > data/new_model/epw_mass_cb_acoustic.dat
#tmp=$(python epw_mass.py --temp 300 --method 1 --cb --acoustic)
#parse_mass >> data/new_model/epw_mass_cb_acoustic.dat

#
# decomposition in modes for Fig 1(a) - (c)
#
cp eff_coupl_sphere.dat eff_coupl_sphere.bak

function resolve_contribution {
  step_vb=$step_vb$(python step.py --temp 1 --method 2 --vb --energy 115 | grep '50\.5')" "
  step_cb=$step_cb$(python step.py --temp 1 --method 2 --cb --energy 115 | grep '50\.5')" "

  lifetime=$lifetime$(python lifetime.py --method 2 --vb | grep '300\.0')" "
  lifetime=$lifetime$(python lifetime.py --method 2 --cb | grep '300\.0')" "

  mass_1K=$mass_1K$(python mass.py --method 2 --energy 1e-3 --vb | grep '^1\.0')" "
  mass_1K=$mass_1K$(python mass.py --method 2 --energy 1e-3 --cb | grep '^1\.0')" "
  mass_RT=$mass_RT$(python mass.py --method 2 --energy 1e-3 --vb | grep '300\.0')" "
  mass_RT=$mass_RT$(python mass.py --method 2 --energy 1e-3 --cb | grep '300\.0')" "
}

# Mode 1
awk 'NR == 1 { print }' eff_coupl_sphere.bak > eff_coupl_sphere.dat
resolve_contribution
# Mode 2
awk 'NR == 2 { print }' eff_coupl_sphere.bak > eff_coupl_sphere.dat
resolve_contribution
# Mode 3
awk 'NR == 3 { print }' eff_coupl_sphere.bak > eff_coupl_sphere.dat
resolve_contribution
mv eff_coupl_sphere.bak eff_coupl_sphere.dat

format=" %8.3f %8.3f %8.3f %8.3f\n"
echo "$step_vb"  | awk "{ printf \"step VB: $format\", \$1, \$2, \$5, \$8 }" > data/new_model/decomposition.dat
echo "$step_cb"  | awk "{ printf \"step CB: $format\", \$1, \$2, \$5, \$8 }" >> data/new_model/decomposition.dat
echo "$lifetime" | awk "{ printf \"lifetime:$format\", \$1, 0.5 * (\$2 + \$6), 0.5 * (\$10 + \$14), 0.5 * (\$18 + \$22) }" >> data/new_model/decomposition.dat
echo "$mass_1K"  | awk "{ printf \"mass 1K: $format\", \$1, 0.5 * (\$2 + \$5), 0.5 * (\$8 + \$11), 0.5 * (\$14 + \$17) }" >> data/new_model/decomposition.dat
echo "$mass_RT"  | awk "{ printf \"mass RT: $format\", \$1, 0.5 * (\$2 + \$5), 0.5 * (\$8 + \$11), 0.5 * (\$14 + \$17) }" >> data/new_model/decomposition.dat
#
#
# Figure 3
#
python spec_2d.py --temp   1 --energy 105 --vb > data/new_model/spec_vb_1K.dat
python spec_2d.py --temp 300 --energy 105 --vb > data/new_model/spec_vb_300K.dat
python spec_2d.py --temp   1 --energy 105 --cb > data/new_model/spec_cb_1K.dat
python spec_2d.py --temp 300 --energy 105 --cb > data/new_model/spec_cb_300K.dat
gnuplot < spectral.gnu

#
# Impact of GW on results
#
python lifetime.py --method 2 --vb --gw > foo
python lifetime.py --method 2 --cb --gw > bar
paste foo bar > data/new_model/lifetime_GW.dat
python mass.py --method 2 --energy 1e-3 --vb --gw > foo
python mass.py --method 2 --energy 1e-3 --cb --gw > bar
paste foo bar > data/new_model/mass_GW.dat

#
# Figure Suppl 3
#
python step.py --temp 1 --method 1 --vb --energy 225 > data/new_model/step_vb_suppl.dat
python step.py --temp 1 --method 1 --cb --energy 225 > data/new_model/step_cb_suppl.dat
python stepDOS.py --temp 1 --method 1 --vb --energy 225 > data/new_model/step_vb_dos.dat
python stepDOS.py --temp 1 --method 1 --cb --energy 225 > data/new_model/step_cb_dos.dat
python avg_time.py --method 1 --vb > data/new_model/avg_time_vb.dat
python avg_time.py --method 1 --cb > data/new_model/avg_time_cb.dat

#
# Figure Suppl 4
#
python step.py --temp 300 --method 1 --vb --energy 115 > data/new_model/step_vb_RS_300K.dat
python step.py --temp 300 --method 2 --vb --energy 115 > data/new_model/step_vb_BW_300K.dat
python step.py --temp 300 --method 1 --cb --energy 115 > data/new_model/step_cb_RS_300K.dat
python step.py --temp 300 --method 2 --cb --energy 115 > data/new_model/step_cb_BW_300K.dat

python epw_step.py --temp 300 --method 2 --vb --direction gx --energy $energy > data/new_model/epw_step_vb_gx_300K.dat 
python epw_step.py --temp 300 --method 2 --vb --direction gy --energy $energy > data/new_model/epw_step_vb_gy_300K.dat 
python epw_step.py --temp 300 --method 2 --vb --direction gz --energy $energy > data/new_model/epw_step_vb_gz_300K.dat 
python epw_step.py --temp 300 --method 2 --cb --direction gx --energy $energy > data/new_model/epw_step_cb_gx_300K.dat 
python epw_step.py --temp 300 --method 2 --cb --direction gy --energy $energy > data/new_model/epw_step_cb_gy_300K.dat 
python epw_step.py --temp 300 --method 2 --cb --direction gz --energy $energy > data/new_model/epw_step_cb_gz_300K.dat 


rm foo bar 2> /dev/null
