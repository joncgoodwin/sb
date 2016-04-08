# Sleeping Beauties

This R and javascript code reads a citation report from Web of Science that has been manually processed (header removed, graphs removed) and creates d3.js graph intended to show "sleeping beauties," articles that go a relatively long time before starting to accumulate citations.

For more detail, see [this post](http://jgoodwin.net/blog/sleeping-beauties) and [Kieran Healy's post](https://kieranhealy.org/blog/archives/2015/06/27/sleeping-beauties-in-philosophy/).

#Usage

Create a citation report from journals of interest in web of science. Save the top 500 results or so as a text file. Open the text file (usually named "savedrecs.txt") and delete the header. Save it as "journal.csv" or similar in the sb directory.

From R, evaluate the **write_sleeping_beauty** and **plotgraph** functions.
```R
sb <- write_sleeping_beauty("citations.csv", 20)
```
will return a dataframe that can be passed to **plotgraph**. It will also save a file named "data.csv" Open the sb.html file in your browser to see the d3.js visualization.

To make a plot from R, use:
```R
gg <- plotgraph(sb,1,10)
```
This will return a ggplot object that highlights articles that went ten years with no citations. Adjust parameters to suit.

See [here](http://jgoodwin.net/sb), [here](http://jgoodwin.net/sb/hist.html),
[here](http://jgoodwin.net/sb/folk.html), [here](http://jgoodwin.net/sb/signs.html), and [here](http://jgoodwin.net/sb/rhet.html) for examples.


# Acknowledgments

The d3.js visualization is based on this [example](http://bl.ocks.org/mbostock/8033015) by Mike Bostock. Lynn Cherny's [code](http://arnicas.github.io/interactive-vis-course/Week7/multiple_lines_voronoi.html) was also used. This [stackoverflow question and answer](http://stackoverflow.com/questions/31507611/d3-multi-line-voronoi-trouble-with-showing-data-on-mouseover) was also helpful.

I also got valuable feedback from a conversation with PJ Trainor, Nabil Kashyap, and Rachel Buurma. 

# TODO

1. Automate read procedure so that it doesn't require manual spreadsheet tweaking. Still have to delete small header.
2. Regularize capitalization of titles. 
3. Clean and indent js code properly.


