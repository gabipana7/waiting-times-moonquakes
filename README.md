## Waiting times for moonquakes and marsquakes

This project represents an application of the waiting times analysis technique for quake data coming from extraplanetary sources.

The only available sources of reliable quake data other than earthquakes are:
- Moon: the Apollo missions
- Mars: the InSight mission
- Venus: the Venera 14 lander

In the case of Venus, the lander survived only for about an hour, transmiting seismic data that has been deemed unreliable.

The quake data analysed in this project are the moonquakes and marsquakes.

## Moonquakes

Exploratory data analysis
![moonquakes_eda1](results/moonquakes_all_stations/eda/moonquakes_all_stations_amplitude_distribution_pdf.png)
![moonquakes_eda2](results/moonquakes_all_stations/eda/moonquakes_all_stations_amplitude_distribution_cdf.png)

Power-law parameter dependence
![moonquakes_par_dep](results/moonquakes_all_stations/powerlaw/moonquakes_all_stations_par_dep.png)

Power-law fit for small waiting times
![moonquakes_powlaw](results/moonquakes_all_stations/powerlaw/wt_moonquakes_all_stations_best_fits.png)

Pareto-Tsallis transition tested for high waiting times
![moonquakes_PT](results/moonquakes_all_stations/tsallis/wt_tsallis_moonquakes_all_stations_overlayed.png)


## Marsquakes

Power-law parameter dependence
![marsquakes_par_dep](results/marsquakes_mw/powerlaw/marsquakes_mw_par_dep.png)

Exploratory data analysis
![marsquakes_eda1](results/marsquakes_mw/eda/marsquakes_mw_mw_distribution_pdf.png)
![marsquakes_eda2](results/marsquakes_mw/eda/marsquakes_mw_mw_distribution_cdf.png)

Power-law fit for small waiting times
![marsquakes_powlaw](results/marsquakes_mw/powerlaw/wt_marsquakes_mw_best_fits.png)

Pareto-Tsallis transition tested for high waiting times
![marsquakes_PT](results/marsquakes_mw/tsallis/wt_tsallis_marsquakes_mw_overlayed.png)

---

- This toolbox comes as support in part for the conference proceeding: [Waiting times distributions for moonquakes and marsquakes](https://doi.org/10.1063/5.0150572)
- Cite the proceeding as: G. T. Pana, S. Zgura, V. Baran and A. Nicolin, Waiting times distributions for moonquakes and marsquakes, AIP Conf. Proc. 2843, 020004 (2023), https://doi.org/10.1063/5.0150572.


Note: the results presented here are more advanced than those in the proceeding. The technique has been improved, and data re-analyzed. The basic waiting times principle remains.