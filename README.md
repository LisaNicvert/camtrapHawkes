# Using the multivariate Hawkes process to study interactions between multiple species from camera trap data

This repository contains the code and data to reproduce the analyses and figures from the following article:

> Nicvert, L., S. Donnet, M. Keith, M. Peel, M. J. Somers, L. H.
> Swanepoel, J. Venter, H. Fritz, and S. Dray. 2024. Using the
> Multivariate Hawkes Process to Study Interactions between Multiple
> Species from Camera Trap Data. Ecology. <https://doi.org/10.1002/ecy.4237>

The dataset published in this repository is a subset of the larger dataset described in Pardo et al. (2021) (see [data/camtrap_data/README.md](data/camtrap_data/README.md) for more details).

To run the analyses, you can install the packages via R (Linux and Mac OS users) or via Docker (Linux, Mac OS and Windows users). The installation procedure is detailed in the [Packages installation](#packages-installation) section.

## Contents

-   `analyses/` contains all scripts to reproduce the analyses of the article.
-   `R/` contains the R functions developed for this project (as a R package).
-   `camtrapHawkes_1.0.0.pdf` contains the PDF documentation of the functions written in `R/`.
-   `data/` contains the camera trap data and species silhouettes used for plotting.
-   `figures/` contains the high-quality figures used in the article generated by the analyses.
-   `man/` contains the .Rd documentation for the functions written in `R/`.
-   `outputs/` contains the outputs generated during the analyses.
-   `DESCRIPTION` contains the project metadata (author, date, dependencies, etc.)
-   `NAMESPACE` contains the namespace information for the functions in the `R/` folder.
-   `LICENCE.md` contains the full licence for the R code.
-   `install_dependencies.R` is a R script to install all R libraries.
-   `UnitEvents_0.0.8.tar.gz` is the source package for `UnitEvents`.
-   `Dockerfile` is the file to create a Docker environment.

## Packages installation {#packages-installation}

In order to install the environment needed to run the analyses, you have two choices:

-   **Install packages via R directly on your OS:** This option works only if you use Linux of Mac OS, as the R package `UnitEvents` is not avaliable on Windows.
-   **Install packages via [Docker](https://www.docker.com/):** this option allows you to reproduce the analyses on Linux, Mac OS or Windows.

### Install packages via R directly on your OS

#### Install `UnitEvents` dependencies

In order to run the analyses, some dependencies must be installed outside R for the package `UnitEvents` (Albert et al., 2021).

-   **Installing dependencies on Linux:** run the following command in the terminal:

```{bash}
sudo apt install cmake g++ git subversion
```

-   **Installing dependencies on Mac OS**: you will need to configure a command line installer like [MacPorts](https://www.macports.org/) of [Homebrew](https://brew.sh/). A C++ compiler should also have been installed before (through Xcode for example). Assuming MacPorts is installed, run:

```{bash}
sudo port install cmake subversion git
```

The up-to-date repository and instructions to install to install `UnitEvents` can also be found on [the development team repository](https://sourcesup.renater.fr/frs/?group_id=3267).

#### Install other packages

To install the needed R packages (including `UnitEvents`, once the dependencies above have been installed), you can run the script `install_dependencies.R`. The required packages are sorted by analysis, so you can choose which packages to install depending on your needs.

### Install packages via Docker

#### Build the Docker

The `Dockerfile` provided at the root of the repository allows to build a Docker installing the required dependencies.

*NB: You need admin privileges to run Docker; either add your user to the Docker group (`sudo groupadd docker`), use `sudo` or run as `root`.*

In order to build the Docker, navigate to the directory containing the Dockerfile and use:

```{bash}
docker build . -t camtrap_hawkes_docker
```

Then, install required R packages. For that, connect to the interactive Docker interface:

```{bash}
docker run -it -v $HOME/:/home/ubuntu camtrap_hawkes_docker bash
```

Then, inside Docker, set the default library path for R packages. Here, we will use (`/home/ubuntu/R_camtrapHawkes` but you can use a different path (only make sure the directory already exists):

```{bash}
> mkdir /home/ubuntu/R_camtrapHawkes
> export R_LIBS="/home/ubuntu/R_camtrapHawkes"
```

Finally, run the `install_dependencies.R` script inside the Docker in order to install the required R packages :

```{bash}
> cd /opt/camtrapHawkes
> Rscript install_dependencies.R
```

### Details

The functions written for this article are organized in a R package (`camtrapHawkes`). This package can be installed with `devtools::install_local` and loaded with `library(camtrapHawkes)`.

Other needed packages are loaded (and if needed, installed) for each analysis script with a custom `camtrapHawkes::require` function.


## Run analyses

All analysis scripts are in the `analyses` folder. You can refer to [analyses/README.md](analyses/README.md) for more details about the function of each script.

### Directly on your OS (Mac OS/Linux users)

If you are running on Mac OS or Linux, you can run the files directly with the version of R installed on your computer.

### If you use Docker (all users)

If you are running on Windows, you need to run the analyses through Docker (for instance, with the interactive mode of Docker `it` as exemplified below).

Note: you will need to specify the library to use each time you run the Docker using `export R_LIBS="/home/ubuntu/R_camtrapHawkes"`.

-   To run all scripts (except the simulation of inter-event times in `analyses/02_simulation_interevent_times/` that cannot be run locally):

```{bash}
docker run -it -v $HOME/:/home/ubuntu camtrap_hawkes_docker bash
> export R_LIBS="/home/ubuntu/R_camtrapHawkes"
> Rscript camtrapHawkes/analyses/run_all.R
```

-   To render Quarto documents:

```{bash}
docker run -it -v $HOME/:/home/ubuntu camtrap_hawkes_docker bash
> export R_LIBS="/home/ubuntu/R_camtrapHawkes"
> R
> quarto::quarto_render([path_to_qmd])
```

-   To run R scripts:

```{bash}
docker run -it -v $HOME/:/home/ubuntu camtrap_hawkes_docker bash
> export R_LIBS="/home/ubuntu/R_camtrapHawkes"
> Rscript [path_to_script]
```

## Licences

The code used to perform analyses and produce figures of this project is licensed under the [Creative Commons Attribution 4.0 International License](http://creativecommons.org/licenses/by/4.0/).

The underlying source code used generate content (contained in the `R/` folder and associated to the package) is licensed under the [GPL \>= 2 licence](https://www.gnu.org/licenses/old-licenses/gpl-2.0.html).

The raw data in `data/camtrap_data/data.csv` is licensed under the [Creative Commons Attribution 4.0 International License](http://creativecommons.org/licenses/by/4.0/).

## Session info

Here is the output of the `SessionInfo` on the computer used to run the analyses:

```         
> sessionInfo()
R version 4.3.0 (2023-04-21)
Platform: x86_64-pc-linux-gnu (64-bit)
Running under: Ubuntu 20.04.6 LTS

Matrix products: default
BLAS:   /usr/lib/x86_64-linux-gnu/blas/libblas.so.3.9.0 
LAPACK: /usr/lib/x86_64-linux-gnu/lapack/liblapack.so.3.9.0

locale:
 [1] LC_CTYPE=fr_FR.UTF-8       LC_NUMERIC=C              
 [3] LC_TIME=fr_FR.UTF-8        LC_COLLATE=fr_FR.UTF-8    
 [5] LC_MONETARY=fr_FR.UTF-8    LC_MESSAGES=fr_FR.UTF-8   
 [7] LC_PAPER=fr_FR.UTF-8       LC_NAME=C                 
 [9] LC_ADDRESS=C               LC_TELEPHONE=C            
[11] LC_MEASUREMENT=fr_FR.UTF-8 LC_IDENTIFICATION=C       

time zone: Europe/Paris
tzcode source: system (glibc)

attached base packages:
[1] stats4    parallel  stats     graphics  grDevices utils     datasets 
[8] methods   base     

other attached packages:
 [1] tidygraph_1.2.3     UnitEvents_0.0.8    igraph_1.5.0       
 [4] quarto_1.2          NHPoisson_3.3       lubridate_1.9.2    
 [7] ggspatial_1.1.8     osmdata_0.2.3       sf_1.0-13          
[10] tibble_3.2.1        gridExtra_2.3       tidyr_1.3.0        
[13] dplyr_1.1.2         magrittr_2.0.3      doParallel_1.0.17  
[16] iterators_1.0.14    foreach_1.5.2       ggplot2_3.4.2      
[19] RColorBrewer_1.1-3  here_1.0.1          camtrapHawkes_1.0.0

loaded via a namespace (and not attached):
 [1] DBI_1.1.3          remotes_2.4.2      rlang_1.1.1        e1071_1.7-13      
 [5] compiler_4.3.0     callr_3.7.3        vctrs_0.6.3        stringr_1.5.0     
 [9] profvis_0.3.8      pkgconfig_2.0.3    crayon_1.5.2       fastmap_1.1.1     
[13] ellipsis_0.3.2     ggraph_2.1.0       utf8_1.2.3         promises_1.2.0.1  
[17] rmarkdown_2.22     sessioninfo_1.2.2  ps_1.7.5           purrr_1.0.1       
[21] xfun_0.39          cachem_1.0.8       jsonlite_1.8.5     later_1.3.1       
[25] tweenr_2.0.2       prettyunits_1.1.1  R6_2.5.1           stringi_1.7.12    
[29] car_3.1-2          pkgload_1.3.2      Rcpp_1.0.10        knitr_1.43        
[33] usethis_2.2.1      httpuv_1.6.11      timechange_0.2.0   tidyselect_1.2.0  
[37] rstudioapi_0.14    abind_1.4-5        yaml_2.3.7         viridis_0.6.3     
[41] ggtext_0.1.2       codetools_0.2-19   miniUI_0.1.1.1     processx_3.8.1    
[45] pkgbuild_1.4.2     shiny_1.7.4        withr_2.5.0        evaluate_0.21     
[49] units_0.8-2        proxy_0.4-27       urlchecker_1.0.1   polyclip_1.10-4   
[53] xml2_1.3.4         pillar_1.9.0       carData_3.0-5      KernSmooth_2.23-21
[57] generics_0.1.3     rprojroot_2.0.3    munsell_0.5.0      scales_1.2.1      
[61] xtable_1.8-4       class_7.3-22       glue_1.6.2         tools_4.3.0       
[65] fs_1.6.2           graphlayouts_1.0.0 grid_4.3.0         devtools_2.4.5    
[69] colorspace_2.1-0   ggforce_0.4.1      cli_3.6.1          fansi_1.0.4       
[73] viridisLite_0.4.2  gtable_0.3.3       digest_0.6.32      classInt_0.4-9    
[77] ggrepel_0.9.3      htmlwidgets_1.6.2  farver_2.1.1       memoise_2.0.1     
[81] htmltools_0.5.5    lifecycle_1.0.3    mime_0.12          gridtext_0.1.5    
[85] MASS_7.3-60  
```

## References

Albert, M., Bouret, Y., Chevallier, J., Fromont, M., Grammont, F., Laloe, T., Mascart, C., Reynaud-Bouret, P., Rouis, A., Scarella, G., & Tuleau-Malot, C. (2021). UnitEvents: Unitary Events Method with Delayed Coincidence Count (MTGAUE or Permutation Method) and Bernstein Lasso method for Hawkes processes. <https://sourcesup.renater.fr/frs/?group_id=3267>

Nicvert, L., S. Donnet, M. Keith, M. Peel, M. J. Somers, L. H.
Swanepoel, J. Venter, H. Fritz, and S. Dray. 2024. Using the
Multivariate Hawkes Process to Study Interactions between Multiple
Species from Camera Trap Data. Ecology. <https://doi.org/10.1002/ecy.4237>

Pardo, L. E., S. P. Bombaci, S. Huebner, M. J. Somers, H. Fritz, C. Downs, A. Guthmann, R. S. Hetem, M. Keith, A. le Roux, N. Mgqatsa, C. Packer, M. S. Palmer, D. M. Parker, M. Peel, R. Slotow, W. M. Strauss, L. Swanepoel, C. Tambling, N. Tsie, M. Vermeulen, M. Willi, D. S. Jachowski, and J. A. Venter. 2021. Snapshot Safari: a large-scale collaborative to monitor Africa’s remarkable biodiversity. South African Journal of Science **117**:1–4. <https://doi.org/10.17159/sajs.2021/8134>
