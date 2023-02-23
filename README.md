# Scatter-Plot-App-BigWig-Summary

Sharing high-throughput data with other colleagues can be challenging at times due to its complex nature.. However, creating a Shiny app provides an excellent opportunity to empower them to explore the data independently, without being influenced by you. With a Shiny app, your colleagues can delve into the data, make their own discoveries, and draw their own conclusions. This not only promotes greater collaboration and understanding, but also helps to facilitate more meaningful and accurate analyses.

## What is BigWig summary table

A BigWig summary table is a type of table that provides a summary of the data contained in a BigWig file. A BigWig file is a binary file format used to store dense, continuous data tracks, such as genome-wide sequencing data or signal intensity data from microarrays. It is possible to o read a BigWig file, extract specific regions of interest, compute average signals, and store the results in a table. Or you can do it for the whole genome.

For example:
```{r }
# In python
import pyBigWig
import pandas as pd

bw = pyBigWig.open("example.bw") # Open the BigWig file
chrom = "chr1"
start = 1000000
end = 2000000
step = 10000

# Extract the signal values for the specified region and step size
values = bw.values(chrom, start, end, numpy=True, zoomlvl=None, oob=np.nan, numpy_func=None, keep=False, with_start=None, with_end=None, with_summary=None, summary='mean', bases_as_fraction=False, strand=None, return_as='array', validate=True, downsample_ratio=None)
bins = range(start, end, step)
averages = [np.nanmean(values[i:i+step]) for i in bins]

# Create a table to store the results
df = pd.DataFrame({'start': bins, 'end': [i+step for i in bins], 'average_signal': averages})

# Save the table to a file
df.to_csv("results.csv", index=False)
```
## Changing codes:

There are many places in the code that you can change it to make it more suitble for your data particularly minimum and maximum values.

```{r }
# Sliders for min and max values of inputs and color intensity
            sliderInput("xmin", "X-axis Min", min = 0, max = 1, value = 0 , step = 0.01),
            sliderInput("xmax", "X-axis Max", min = 0, max = 10, value = 10, step = 0.5),
            sliderInput("ymin", "Y-axis Min", min = 0, max = 1, value = 0 , step = 0.01),
            sliderInput("ymax", "Y-axis Max", min = 0, max = 10, value = 10 , step = 0.5),
            sliderInput("colorIntensity", "Color Intensity", min = 0, max = 1, value = 0.5, step = 0.01),
            sliderInput("colormin", "Color Min", min = 0, max = 1, value = 0 , step = 0.01),
            sliderInput("colormax", "Color Max", min = 0, max = 10, value = 10 , step = 0.5)
```

### https://arahjou.shinyapps.io/Bigwig_scatter_plot/
