seabase
=======

Transcriptomic repository for multiple species

Schema:

taxons:
	int id
	scientific_name string 256 # "Human", "Mouse", "Nematostella" ? Should this be restricted to a latin name?
	common_name string 256

replicates:
	id int
	taxon_id int
	name string 80 # "18h_B_L2"
	stage int # 18
	condition_id int
	technical_replicate int # B Distinct extracted sample
	lane_replicate int # Read of a sample L1-L7 (is this adding anything not already covered by id and name?)
	y_intercept float
	slope float
	total_mapping int

condition:
	id int
	description text

mapping_counts:
	id int
	replicate_id int
	transcript_id int
	mapping_count int # 3

transcripts:
	id int
	name string 20 # comp100008_c0_seq1
	isogroup int # 1000080
	length int # 254
	transcript_sequence text

# Comes from BLASTing mouse, human and searching UNIPROT
predictions: ? Is this a reasonable name?
	id int
	taxon_id int
	external_identifier_id int # Q14738
	paralog int # 1
	transcript_id int
	gene_name string 255 # Hibadh
	function_name text # Serine/threonine-protein phosphatase 2A 56 kDa regulatory subunit epsilon isoform ? Just how long can these get?
	length int # 602
	query_from int # 65
	query_to int # 138
	isoform int # 1

external_identifiers:
	id int
	external_source_id int
	name string 6 # Q14738

external_sources:
	id int
	name string 256



Queries from Perl:
autoComplete.cgi:my $sql = "SELECT DISTINCT(acc), gn, fn from $form_input{'type'}Name WHERE acc LIKE '%$form_input{'term'}%' OR gn LIKE '%$form_input{'term'}%' OR fn LIKE '%$form_input{'term'}%' LIMIT 10";
graph.cgi:my $sql = "SELECT * FROM normalization";
graph.cgi:	my $sql = "SELECT mapping_count FROM $table where id = '$id' LIMIT 1";
graph.cgi:	my $sql = "SELECT length FROM Sequences where id = '$id' LIMIT 1";
graph.cgi:	my $sql = "SELECT sequence FROM $database"."_prediction WHERE gene = '$id'";
graph.cgi:	my $sql = "SELECT length, sequence FROM Sequences WHERE id = '$input'";
graph.cgi:	my $sql = "SELECT gn, fn FROM $database where acc = '$input'";
graph.cgi:	my $sql = "SELECT acc, gn, fn FROM mouseName WHERE sequence ='$input'";
graph.cgi:        my $sql = "SELECT acc, gn, fn FROM humanName WHERE sequence ='$input'";
graph.cgi:        my $sql = "SELECT acc, gn, fn FROM nematostellaName WHERE sequence ='$input'";
orthologSearch.cgi:my $sql = "SELECT DISTINCT(acc) from $form_input{'type'}Name WHERE acc = '$form_input{'term'}' or gn = '$form_input{'term'}'";
orthologSearch.cgi:my $sql = "SELECT DISTINCT(acc), gn, fn from $form_input{'type'}Name WHERE acc LIKE '%$form_input{'term'}%' OR gn LIKE '%$form_input{'term'}%' OR fn LIKE '%$form_input{'term'}%' LIMIT 100";


Trying to install DBD::mysql.  Prolly need to add to INC.


mapping_count => fpkm(($map_count * 1000 * 1000 * 1000) / ($length * $total_mapping))

1B * c / (length * n)
554

3845
3974
3070
3106

)
4.0)
3498.75

mapping_count for comp824_c0_seq1
| 9h_A_L2                 | 3070
| 9h_A_L5                 | 3106
| 9h_B_L2                 | 3974
| 9h_B_L4                 | 3845

length 554

b, m, total_mapping:
	|  9h_A_L2 |  -4.4469180 | 15899.5300 |      16450010 |

	|  9h_A_L5 |  -1.7842870 | 14489.8700 |      16530015 |

(def molecules (mapping_count intercept slope total)
  (/ (* mapping_count 1000000000) ())


	| 9h_B_L2                 | 21284032
	| 9h_B_L4                 | 19586443

(/ (* 3070 1000000000) (* 554 16450010))

comp824_c0_seq1