string2vec <- function(s) {
  strsplit(s, split = "")[[1]]
}


seq1 = "acctaagg"
seq2 = "ggctcaatca"

n_r <- nchar(seq1) + 1
n_c <- nchar(seq2) + 1
smx <- matrix(0, nrow = n_r,  ncol = n_c)

gap_penalty <- -2
ltr_match <- 3
ltr_mismt <- -3

sqv1 <- c(" ", string2vec(seq1))
sqv2 <- c(" ", string2vec(seq2))

  colnames(smx) <- sqv2
  row.names(smx) <- sqv1

# calculate  scores
for (ri in 2:n_r) {
  for (ci in 2:n_c) {
    s_s <- smx[ri - 1, ci - 1] + ifelse(sqv1[ri] == sqv2[ci], ltr_match, ltr_mismt)
    s_r <- smx[ri - 1, ci] + gap_penalty
    s_c <- smx[ri, ci - 1] + gap_penalty
    s_a <- max(s_s, s_r, s_c, 0)
    smx[ri, ci] <- s_a
  }
}

# traceback

max_val <- max(smx)
coords <- which(smx == max_val, arr.ind = TRUE)

ri <- coords[1, 1]
ci <- coords[1, 2]
s <- ""

while(smx[ri, ci] > 1) {
  s <- paste0(s, sqv2[ci])

  # next cell coordinates where max
  if (smx[ri - 1, ci - 1] > smx[ri - 1, ci] && smx[ri - 1, ci - 1] > smx[ri, ci - 1]) {
    ri <- ri - 1
    ci <- ci - 1
  }

  if (smx[ri - 1, ci - 1] == 0) {
    s <- paste0(s, sqv2[ci])
    break
  }

  if (smx[ri, ci - 1] > smx[ri - 1, ci - 1] && smx[ri, ci - 1] > smx[ri - 1, ci]) {
    ci <- ci - 1
    s <- paste0(s, "-")
  }

}

# build the reverse string
s <- string2vec(s)
s <- paste(rev(s), collapse = "")


# build emppty prefix string and prepend
s <- paste0(paste(rep(" ", ci - 2), collapse = ""), s)

s

