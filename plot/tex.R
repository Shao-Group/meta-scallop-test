draw.roc = function(listfile, texfile)
{
#pdf(pdffile, width = 5, height = 5);
	library(tikzDevice);
	tikz(texfile, width = 2.8, height = 2.8); #0.4 * n

	files = read.table(listfile);
	
	n = length(files[,1]);
	
	xmin = 100;
	ymin = 100;
	xmax = 0;
	ymax = 0;
	for (file in files[,1])
	{
		data = read.table(file);
		xmin = min(xmin, min(data[, 16]));
		xmax = max(xmax, max(data[, 16]));
		ymin = min(ymin, min(data[, 13] / 1.000));
		ymax = max(ymax, max(data[, 13] / 1.000));
	}
	
	par(mar=c(2.6,2.6,0.1,0.1));
	par(mgp=c(1.6, 0.5, 0));
	plot(0, 0, xlim = c(xmin, xmax), ylim = c(ymin, ymax), xlab = "Precision", ylab = "Sensitivity");
	k = 1;
	for (file in files[,1])
	{
		data = read.table(file);
		lines(data[, 16], data[, 13] / 1.000, col = files[k, 3], lty = files[k, 4], lwd = 1); 
		k = k + 1;
	}
	
	legend(xmax * 0.28, ymax, files[,2], col = files[,3], lty = files[,4], lwd = 1, bty='n');
	
	dev.off();
}

draw.roc("AAA", "BBB");
q();

draw.roc("egeuv6.100.list", "egeuv6.100.pdf");
draw.roc("compare.list", "compare.pdf");
draw.roc("egeuv6.100.list", "egeuv6.100.pdf");
draw.roc("roc-10.list", "roc-10.pdf");
draw.roc("roc-50.list", "roc-50.pdf");
draw.roc("roc-100.list", "roc-100.pdf");
draw.roc("roc-all.list", "roc-all.pdf");
draw.roc("graphmerge.list", "graphmerge.pdf");
