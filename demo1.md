---
title: "demo1"
author: "Reinhard Simon"
date: "9/21/2018"
bibliography: "references.bib"
output:
  pdf_document: default
  html_document: default
  word_document: default
---



# Obteniendo datos


```r
term <- "Solanum tuberosum[Organism]"
```

Se realizó una busqueda en la base de datos ENTREZ [@Maglott_2004] con el 'term': *Solanum tuberosum[Organism]* y usando el paquete **rentrez** [@Winter_2017]. Además, usamos los paquetes knitr [@Xie_2018; @Xie_2015; @Xie_2014], knitcations [@Boettiger_2017], msa [@Bodenhofer_2015], seqinr [@Charif_2007] y ape [@Paradis_2004].



```r
library(rentrez)
st_search <- entrez_search(db="popset", term=term)
st_summs <- entrez_summary(db = "popset", id = st_search$ids)
titles <- extract_from_esummary(st_summs, "title")
ids <- unname(titles)
sol_id <- st_search$ids[4]
sol <- entrez_fetch(db="popset", id=sol_id, rettype="fasta")
write(sol, "inst/datos/sol.fasta")
```

Los siguients datasets son disponibles a la fecha indicada: *Solanum AT1G70770-like gene, intron., Spermatophyta 5.8S ribosomal RNA gene, partial sequence; internal transcribed spacer 2, complete sequence; and large subunit ribosomal RNA gene, partial sequence., Eukaryota phase-change related protein mRNA, complete cds., Solanales 5.8S ribosomal RNA gene, partial sequence; internal transcribed spacer 2, complete sequence; and large subunit ribosomal RNA gene, partial sequence., Magnoliophyta AT5G23040 mRNA, partial sequence., Magnoliophyta AT5G57250 mRNA, partial sequence., Magnoliophyta AT3G16840 mRNA, partial sequence., Magnoliophyta AT1G67620 mRNA, partial sequence., Magnoliophyta AT3G57180 mRNA, partial sequence., Magnoliophyta AT5G03700 mRNA, partial sequence., Magnoliophyta AT4G04930 mRNA, partial sequence., Magnoliophyta AT2G23093 mRNA, partial sequence., Magnoliophyta AT1G16070 mRNA, partial sequence., Magnoliophyta AT5G20080 mRNA, partial sequence., Magnoliophyta AT1G30290 mRNA, partial sequence., Magnoliophyta AT5G65720 mRNA, partial sequence., Magnoliophyta AT5G39980 mRNA, partial sequence., Magnoliophyta AT4G15850 mRNA, partial sequence., Magnoliophyta AT1G13120 mRNA, partial sequence., Magnoliophyta AT1G56310 mRNA, partial sequence.*.


```r
library(msa)
library(knitr)

msa_aln2 <- msa("inst/datos/sol.fasta", type = "dna")
```

```
## use default substitution matrix
```

```r
msaPrettyPrint(msa_aln2, output = "tex", askForOverwrite = FALSE)
system("pdflatex msa_aln2.tex")
include_graphics("msa_aln2.pdf")
```

![plot of chunk align](msa_aln2.pdf)



```r
library(seqinr)

msa_aln <- msaConvert(msa_aln2, type="seqinr::alignment")
d <- dist.alignment(msa_aln, "identity")
head(d)
```

```
## [1] 0.1364442 0.2529822 0.3634219 0.3639127 0.4126382 0.3242241
```




```r
library(ape)
soltree <- nj(d)

dna <- read.dna("inst/datos/sol.fasta", format = "fasta" )
species_label <- stringr::str_extract(names(dna), "(Ipomoea|Solanum|Turbina)(\\s){1}[a-z]{1,15}")

soltree$tip.label <- species_label[as.integer(soltree$tip.label)]
plot_title <- stringr::str_split(ids[4], ";")[[1]][1]
plot(soltree, main = plot_title)
```

![plot of chunk phylo_tree](figure/phylo_tree-1.png)

# Apendices


```r
sessionInfo()
```

```
## R version 3.5.1 (2018-07-02)
## Platform: x86_64-w64-mingw32/x64 (64-bit)
## Running under: Windows 10 x64 (build 17134)
## 
## Matrix products: default
## 
## locale:
## [1] LC_COLLATE=English_United States.1252 
## [2] LC_CTYPE=English_United States.1252   
## [3] LC_MONETARY=English_United States.1252
## [4] LC_NUMERIC=C                          
## [5] LC_TIME=English_United States.1252    
## 
## attached base packages:
## [1] stats4    parallel  stats     graphics  grDevices utils     datasets 
## [8] methods   base     
## 
## other attached packages:
##  [1] ape_5.1             seqinr_3.4-5        knitr_1.20         
##  [4] msa_1.12.0          Biostrings_2.48.0   XVector_0.20.0     
##  [7] IRanges_2.14.11     S4Vectors_0.18.3    BiocGenerics_0.26.0
## [10] rentrez_1.2.1       knitcitations_1.0.8
## 
## loaded via a namespace (and not attached):
##  [1] Rcpp_0.12.18     xml2_1.2.0       magrittr_1.5     MASS_7.3-50     
##  [5] zlibbioc_1.26.0  lattice_0.20-35  R6_2.2.2         bibtex_0.4.2    
##  [9] highr_0.7        stringr_1.3.1    httr_1.3.1       plyr_1.8.4      
## [13] tools_3.5.1      grid_3.5.1       nlme_3.1-137     ade4_1.7-13     
## [17] digest_0.6.17    RefManageR_1.2.0 curl_3.2         evaluate_0.11   
## [21] stringi_1.2.4    compiler_3.5.1   XML_3.98-1.16    jsonlite_1.5    
## [25] lubridate_1.7.4
```


# Referencias






