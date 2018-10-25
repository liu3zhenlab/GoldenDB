### maize_gene2go
Data downloaded from "ftp://ftp.ensemblgenomes.org/pub/plants/release-32/mysql/zea_mays_core_32_85_7/"
Three data were downloaded
1. gene.txt.gz
2. object_xref.txt.gz
3. xref.txt.gz
Header description of these files can be referred to https://uswest.ensembl.org/info/docs/api/core/core_schema.html#object_xref

```
inwd <- "/home/liu3zhen/references/B73refgen4/genemodel/"
genes <- read.delim(paste0(inwd, "gene.txt"), header = F)
colnames(genes) <- c("gene_id", "biotype", "analysis_id", "seq_region_id", "seq_region_start",
                     "seq_region_end", "seq_region_strand", "display_xref_id", "source", "description",
                     "genename", "is_current", "canonical_transcript_id", "stable_id", "version",
                     "created_date", "modified_date")
genes2 <- genes[, c("stable_id", "canonical_transcript_id")]

objxref <- read.delim(paste0(inwd, "object_xref.txt"), header = F)
colnames(objxref) <- c("object_xref_id", "ensembl_id", "ensembl_object_type", "xref_id",
                       "linkage_annotation", "analysis_id")
objxref2 <- objxref[, c(2,4)]

xref <- read.delim(paste0(inwd, "xref.txt"), header = F)
colnames(xref) <- c("xref_id", "external_db_id", "dbprimary_acc", "display_label",
                    "version", "description", "info_type", "info_text")
xref2 <- xref[, c("xref_id", "dbprimary_acc")]
### genes match objxref


genes2xrefid <- merge(genes2, objxref2, by.x = "canonical_transcript_id", by.y = "ensembl_id")
head(genes2xrefid)
genes2xref <- merge(genes2xrefid, xref2, by = "xref_id")
nrow(genes2xref)
head(genes2xref)
go <- genes2xref[grepl("GO", genes2xref$dbprimary_acc), c("stable_id", "dbprimary_acc")]
colnames(go) <- c("Gene", "GO")
write.table(go, "B73Ref4.gene2go.v1.0.txt", sep = "\t", quote = F, row.names = F)
```
