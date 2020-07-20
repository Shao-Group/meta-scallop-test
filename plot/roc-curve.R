draw.roc = function(listfile, texfile)
{
#pdf(pdffile, width = 5, height = 5);
	library(tikzDevice);
	tikz(texfile, width = 4.0, height = 4.0); #0.4 * n

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
	plot(-100, -100, xlim = c(xmin, xmax), ylim = c(ymin, ymax), xlab = "Precision", ylab = "Sensitivity");
	grid();
	k = 1;
	for (file in files[,1])
	{
		data = read.table(file);
		points(data[1, 16], data[1, 13] / 1.000, col = files[k, 3], pch = 16, cex = 0.5); 
		lines(data[, 16], data[, 13] / 1.000, col = files[k, 3], lty = files[k, 4], lwd = 0.75); 
		k = k + 1;
	}
	
	legend(xmax * 0.30, ymax, files[,2], col = files[,3], lty = files[,4], lwd = 1, bty='n');
	
	dev.off();
}
