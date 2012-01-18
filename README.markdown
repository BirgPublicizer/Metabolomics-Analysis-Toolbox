# Introduction #

Metabolomics Analysis Toolbox is a collection of software developed by
the [Wright State University Bioinformatics Research
Group](http://birg.cs.wright.edu/) and the [College of Charleston Bioinformatics Research Group](http://birg.cs.cofc.edu/index.php/Bioinformatics_Research_Group) to help in metabolomics research.

Right now, it mainly consists of GUI software to help in various
phases of the analysis of the complex NMR spectra produced by
biofluids (blood, urine, cerebrospinal fluid, tissue homogenates,
etc).

Much of what we write is dependent on [Matlab](http://www.mathworks.com/products/matlab/)

# Contributing #

The code in this repository is derived from a private repository
contiaining unpublished research code and experiments.  To avoid
accidentally sharing unpublished research, the two repositories don't
share history.  If you fork this repository and send us a pull request
it may be hard to reintegrate it.  However, if that is the best way
for you to contribute, we will figure out how to reintegrate your
changes.

Probably the easiest to use for reintegrating into the main repository
is emailing patch requests.  `git format-patch -o filename origin`
will put patches with the changes between your repository and origin
into `filename`.  You can then send `filename` as an attachment.

Try and keep the patches small and well focused since we will have to
review them manually.
