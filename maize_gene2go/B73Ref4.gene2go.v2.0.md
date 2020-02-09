### maize_gene2go v2.0
Data were downloaded from "ftp://ftp.ensemblgenomes.org/pub/plants/release-46/mysql/zea_mays_core_46_99_7/"  
Three datasets were downloaded:

gene.txt.gz
object_xref.txt.gz
xref.txt.gz

Header description of these files can be referred to https://uswest.ensembl.org/info/docs/api/core/core_schema.html#object_xref

```
inwd <- "/homes/liu3zhen/references/B73Ref4/genemodel2/"
# gene IDs
# ENSEMBLE_46
genes <- read.delim(paste0(inwd, "gene.txt"), header = F)
dim(genes)
head(genes)
colnames(genes) <- c("gene_id", "biotype", "analysis_id", "seq_region_id", "seq_region_start",
		"seq_region_end", "seq_region_strand", "display_xref_id", "source", "description",
		"is_current", "canonical_transcript_id", "stable_id", "version",
		"created_date", "modified_date")
genes2 <- genes[, c("stable_id", "canonical_transcript_id")]

# xref IDs
objxref <- read.delim(paste0(inwd, "object_xref.txt"), header = F)
colnames(objxref) <- c("object_xref_id", "ensembl_id", "ensembl_object_type", "xref_id",
		"linkage_annotation", "analysis_id")
objxref2 <- objxref[, c(2,4)]

# xref information
xref <- read.delim(paste0(inwd, "xref.txt"), header = F)
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
write.table(go, "B73Ref4.gene2go.v2.0.txt", sep = "\t", quote = F, row.names = F)
```
