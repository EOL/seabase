Seabase
=======

A tool for searching, analysing and sharing gene expression data of marine
organisms.


Transcriptomic repository for multiple species

Schema:

taxons:
	int id
	scientific_name string 256 # "Human", "Mouse", "Nematostella" ? Should this be restricted to a latin name?
	common_name string 256
rails generate scaffold Taxon scientific_name:string common_name:string

condition:
	id int
	description text
rails generate scaffold Condition description:text

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

    rails generate scaffold Replicate taxon:references name:string:80 stage:int condition:references technical_replicate:int lane_replicate:int y_intercept:float slope:float total_mapping:int

transcripts:
	id int
	name string 20 # comp100008_c0_seq1
	isogroup int # 1000080
	length int # 254
	transcript_sequence text

    rails generate scaffold Transcript name:string:20 isogroup:int length:int transcript_sequence:text

mapping_counts:
	id int
	replicate_id int
	transcript_id int
	mapping_count int # 3

    rails generate scaffold MappingCount replicate:references transcript:references mapping_count:int

external_sources:
	id int
	name string 256
	
	rails generate scaffold ExternalSource name:string

external_identifiers:
	id int
	external_source_id int
	name string 6 # Q14738
	
	  rails generate scaffold ExternalIdentifier external_source:references name:string:6

# Comes from BLASTing mouse, human and searching UNIPROT
external_matches: ? Is this a reasonable name?
	id int
	external_name_id int
	paralog int # 1
	transcript_id int
	length int # 602
	query_from int # 65
	query_to int # 138
	isoform int # 1

external_names:
  id int
  taxon_id int
  external_identifier_id int
  gene_name string
  functional_name text
  
  
    rails generate scaffold ExternalMatch taxon:references external_identifier:references transcript:references gene_name:string function_name:text length:int query_from:int query_to:int paralog:int isoform:int

    rails generate scaffold ExternalName taxon:references external_identifier:references gene_name:string function_name:text

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


	id = comp824_c0_seq1 (transcript)
	sample = |  9h_A_L2 |  -4.4469180 | 15899.5300 |      16450010 |     0 | (half_sample?)
	sequence_length = 2323
	hour = 9
	raw_expression = get_hour_expression(sample, id) = 3070
	per_embryo(raw_expression, sample, sequence_length)

	get_fpkm(sequence_length, raw_expression, total_mapping)
	(2323, 3070, 16450010)

	(3070 * 1000 * 1000 * 1000)/(2323 * 16450010)
	fpkm = 80.33836692516454

	normalize_rpkm(80.33836692516454, -4.4469180, 15899.5300, 0)

	(/ (/ (+ (* 80.33836692516454 15899.5300) -4.4469180) 300) 0.1)
	[Should be / 10]
	42577.92760532204

	(/ (* 3070 1000 1000 1000.0) (* 2323 16450010.0))
	80.33836692516454

	(/ (/ (+ (* 80.33836692516454 15899.5300) -4.4469180) 300) 0.1)
	42577.92760532204


	3106
	(/ (* 3106 1000 1000 1000.0) (* 2323 16530015.0))
	80.88704947918852

	(/ (/ (+ (* 80.88704947918852 14489.8700) -1.7842870) 300) 0.1)
	39068.03491166698

	(/ (+ 39068.03491166698 42577.92760532204) 2)

	40822.98125849451 (Hooray!)


	(m(c * 10e9/(l * n))+b)/(300 * 0.1)


	select * from normalization where id like ' 9%';                                
	select mapping_count from 9h_A_L2 where id = 'comp824_c0_seq1';                 
	SELECT length FROM Sequences where id = 'comp824_c0_seq1';                      
