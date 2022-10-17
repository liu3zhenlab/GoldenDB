# R script to find gene-GO pairs of B73v5
# Sanzhen Liu
# 10/17/2022

url_dir <- "http://ftp.ensemblgenomes.org/pub/plants/release-54/mysql/zea_mays_core_54_107_8/"
ref <- "B73v5"
go_version <- "v0.1"

# ENSEMBLE_54
system(paste0("wget ", url_dir, "/gene.txt.gz"))
system(paste0("wget ", url_dir, "/xref.txt.gz"))
system(paste0("wget ", url_dir, "/object_xref.txt.gz"))
system("gunzip *gz")

genes <- read.delim("gene.txt", header = F)
colnames(genes) <- c("gene_id", "biotype", "analysis_id", "seq_region_id", "seq_region_start",
		"seq_region_end", "seq_region_strand", "display_xref_id", "source", "description",
		"is_current", "canonical_transcript_id", "stable_id", "version",
		"created_date", "modified_date")
genes2 <- genes[, c("stable_id", "canonical_transcript_id")]

# xref IDs
objxref <- read.delim("object_xref.txt", header = F)
colnames(objxref) <- c("object_xref_id", "ensembl_id", "ensembl_object_type", "xref_id",
		"linkage_annotation", "analysis_id")
objxref2 <- objxref[, c(2,4)]

# xref information
xref <- read.delim("xref.txt", header = F)
colnames(xref) <- c("xref_id", "external_db_id", "dbprimary_acc", "display_label",
		"version", "description", "info_type", "info_text")
xref2 <- xref[, c("xref_id", "dbprimary_acc")]

# connect gene IDs to xref IDs
genes2xrefid <- merge(genes2, objxref2, by.x = "canonical_transcript_id", by.y = "ensembl_id")

# connect xref IDs to xref information
genes2xref <- merge(genes2xrefid, xref2, by = "xref_id")

# select GO for output
go <- genes2xref[grepl("GO", genes2xref$dbprimary_acc), c("stable_id", "dbprimary_acc")]
colnames(go) <- c("Gene", "GO")
go <- go[!duplicated(paste(go$Gene, go$GO)), ] # remove redundancy
go_outfile <- paste0(ref, ".gene2go.", go_version, ".txt")
write.table(go, go_outfile, sep = "\t", quote = F, row.names = F)

# cleanup
system("rm gene.txt")
system("rm object_xref.txt")
system("rm xref.txt")

