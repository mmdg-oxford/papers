import pymatgen
from pymatgen.core.composition import Composition
from pymatgen.matproj.rest import MPRester
from pymatgen.phasediagram.maker import PhaseDiagram
from pymatgen.phasediagram.maker import CompoundPhaseDiagram
from pymatgen.phasediagram.entries import PDEntry
from pymatgen.phasediagram.entries import TransformedPDEntry
from pymatgen.phasediagram.analyzer import PDAnalyzer
from pymatgen.phasediagram.plotter import PDPlotter
from pymatgen.core.periodic_table import DummySpecie, Element
import collections
from pandas import DataFrame
import pandas as pd
import string 


pd.set_option('display.width', 400)

#reading names and energies from file - change file names to change system
file_names          = open("data/nam/bicucl.dat","r")
file_energies_lda   = open("data/lda/bicucl.dat","r")
file_energies_pbe   = open("data/pbe/bicucl.dat","r") 


#creating array with compound names
fname = file_names.read()
names       = fname.splitlines()

# creating array with energies from lda
enlda = []
for y in file_energies_lda.read().splitlines():
    enlda.append(float(y))

# creating array with energies from pbe
enpbe = []
for y in file_energies_pbe.read().splitlines():
    enpbe.append(float(y))

term_comp = [Composition(names[7]),Composition(names[11]),Composition(names[32])]


# creating entries from for the LDA phase diagram
entries_lda = []
for i in range (len(names)): 
#    entries_lda.append(PDEntry(names[i],enlda[i], names[i], "LDA"))
     entries_lda.append(PDEntry(names[i],enlda[i], " ", "LDA"))

# creating the phase diagram for LDA
pd_lda = PhaseDiagram(entries_lda)
cpd_lda = CompoundPhaseDiagram(entries_lda,term_comp, normalize_terminal_compositions=True)
a_lda  = PDAnalyzer(pd_lda)

# creating entries from for the PBE phase diagram
entries_pbe = []
for i in range (len(names)): 
#    entries_pbe.append(PDEntry(names[i],enpbe[i], names[i], "PBE"))
    entries_pbe.append(PDEntry(names[i],enpbe[i], " ", "PBE"))

# creating the phase diagram for PBE
pd_pbe = PhaseDiagram(entries_pbe)
cpd_pbe = CompoundPhaseDiagram(entries_pbe,term_comp, normalize_terminal_compositions=True)
a_pbe  = PDAnalyzer(pd_pbe)

# # visualize quaternary phase diagrams
# plotter_lda = PDPlotter(pd_lda,show_unstable = 200)
# plotter_lda.show()
# plotter_pbe = PDPlotter(pd_pbe,show_unstable = 200)
# plotter_pbe.show()
# 

# printing results of the phase diagram
data_lda = collections.defaultdict(list)
data_pbe = collections.defaultdict(list)

print("LDA Phase diagram")
for e in entries_lda:
       decomp, ehull = a_lda.get_decomp_and_e_above_hull(e)
       formen = pd_lda.get_form_energy_per_atom(e  )
       data_lda["Composition"].append(e.composition.reduced_formula)
       data_lda["Ehull (meV/atom)"].append(ehull*13.605698066*1000)
       data_lda["Decomposition"].append(" + ".join(["%.2f %s" % (v,k.composition.formula) for k, v in decomp.items()]))
       data_lda["Formation Energy (eV/atom)"].append(formen*13.605698066)

df1 = DataFrame(data_lda,columns=["Composition", "Ehull (meV/atom)", "Formation Energy (eV/atom)", "Decomposition"])

print(df1)
print(" ") 
print(" ")
print("PBE Phase diagram")
for e in entries_pbe:
       decomp, ehull = a_pbe.get_decomp_and_e_above_hull(e)
       formen = pd_pbe.get_form_energy_per_atom(e  )
       data_pbe["Composition"].append(e.composition.reduced_formula)
       data_pbe["Ehull (meV/atom)"].append(ehull*13.605698066*1000)
       data_pbe["Decomposition"].append(" + ".join(["%.2f %s" % (v,k.composition.formula) for k, v in decomp.items()]))
       data_pbe["Formation Energy (eV/atom)"].append(formen*13.605698066)

df3 = DataFrame(data_pbe,columns=["Composition", "Ehull (meV/atom)", "Formation Energy (eV/atom)", "Decomposition"])

print(df3)

# # # visualize pseudo-ternary phase diagrams
# plotter_lda = PDPlotter(cpd_lda,show_unstable = 200)
# plot_lda    = plotter_lda.get_contour_pd_plot()
# plot_lda.show()
# 
# plotter_pbe = PDPlotter(cpd_pbe,show_unstable = 200)
# plot_pbe    = plotter_pbe.get_contour_pd_plot()
# plot_pbe.show()

