read_fasta <- function(file_fasta) {

  lines <- readLines(file_fasta)
  which(grepl(">", lines))
}

sec <- read_fasta("inst/datos/ejemplo.fasta")
