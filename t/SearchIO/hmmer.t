# -*-Perl-*- Test Harness script for Bioperl

use strict;

BEGIN {
    use lib '.';
    use Bio::Root::Test;

    test_begin( -tests => 502 );

    use_ok('Bio::SearchIO');
}

my $searchio = Bio::SearchIO->new(
    -format => 'hmmer',
    -file   => test_input_file('hmmpfam.out')
);
my $result;

while ( $result = $searchio->next_result ) {
    is( ref($result),
        'Bio::Search::Result::HMMERResult',
        'Check for the correct result reference type'
    );
    is( $result->algorithm,         'HMMPFAM', 'Check algorithm' );
    is( $result->algorithm_version, '2.1.1',   'Check algorithm version' );
    is( $result->hmm_name,          'pfam',    'Check hmm_name' );
    is( $result->sequence_file,
        '/home/birney/src/wise2/example/road.pep',
        'Check sequence_file'
    );
    is( $result->query_name,        'roa1_drome', 'Check query_name' );
    is( $result->query_description, '',           'Check query_description' );
    is( $result->num_hits(),        2,            'Check num_hits' );
    my ( $hsp, $hit );

    if ( $hit = $result->next_model ) {
        is( $hit->name,      'SEED',  'Check hit name' );
        is( $hit->raw_score, '146.1', 'Check hit raw_score' );
        float_is( $hit->significance, 6.3e-40, 'Check hit significance' );
        is( ref($hit), 'Bio::Search::Hit::HMMERHit',
            'Check for the correct hit reference type' );
        is( $hit->num_hsps, 1, 'Check num_hsps' );

        if ( defined( $hsp = $hit->next_domain ) ) {
            is( $hsp->hit->start,   1,    'Check for hit hmmfrom value' );
            is( $hsp->hit->end,     77,   'Check for hit hmm to value' );
            is( $hsp->query->start, 33,   'Check for query alifrom value' );
            is( $hsp->query->end,   103,  'Check for query ali to value' );
            is( $hsp->score,        71.2, 'Check for hsp score' );
            float_is( $hsp->evalue, 2.2e-17, 'Check for hsp c-Evalue' );
            is( $hsp->query_string,
                'LFIGGLDYRTTDENLKAHFEKWGNIVDVVVMKD-----PRTKRSRGFGFITYSHSSMIDEAQK--SRpHKIDGRVVEP',
                'Check for query string'
            );
            is( $hsp->gaps('query'), 7, 'Check for number of gaps in query' );
            is( $hsp->hit_string,
                'lfVgNLppdvteedLkdlFskfGpivsikivrDiiekpketgkskGfaFVeFeseedAekAlealnG-kelggrklrv',
                'Check for hit string'
            );
            is( $hsp->homology_string,
                'lf+g+L + +t+e Lk++F+k G iv++ +++D     + t++s+Gf+F+++  ++  + A +    +++++gr+++ ',
                'Check for homology string'
            );
            is( length( $hsp->homology_string ),
                length( $hsp->hit_string ),
                'Check if homology string and hit string have an equal length'
            );
            is( length( $hsp->query_string ),
                length( $hsp->homology_string ),
                'Check if query string and homology string have an equal length'
            );
            # Hmmpfam don't have PP or CS strings, these are tests to check for side effects
            is( $hsp->posterior_string,    '' );
            is( $hsp->consensus_structure, '' );
        }
    }
    if ( defined( $hit = $result->next_model ) ) {
        if ( defined( $hsp = $hit->next_domain ) ) {
            is( $hsp->hit->start,   1,       'Check for hit hmmfrom value' );
            is( $hsp->hit->end,     77,      'Check for hit hmm to value' );
            is( $hsp->query->start, 124,     'Check for query alifrom value' );
            is( $hsp->query->end,   194,     'Check for query ali to value' );
            is( $hsp->score,        75.5,    'Check for hsp score' );
            float_is( $hsp->evalue, 1.1e-18, 'Check for hsp c-Evalue' );
            is( $hsp->query_string,
                'LFVGALKDDHDEQSIRDYFQHFGNIVDINIVID-----KETGKKRGFAFVEFDDYDPVDKVVL-QKQHQLNGKMVDV',
                'Check for query string'
            );
            is( $hsp->gaps('query'), 6, 'Check for number of gaps in query' );
            is( $hsp->hit_string,
                'lfVgNLppdvteedLkdlFskfGpivsikivrDiiekpketgkskGfaFVeFeseedAekAlealnGkelggrklrv',
                'Check for hit string'
            );
            is( $hsp->homology_string,
                'lfVg L  d +e+ ++d+F++fG iv+i+iv+D     ketgk +GfaFVeF++++ ++k +     ++l+g+ + v',
                'Check for homology string'
            );
            is( length( $hsp->homology_string ),
                length( $hsp->hit_string ),
                'Check if homology string and hit string have an equal length'
            );
            is( length( $hsp->query_string ),
                length( $hsp->homology_string ),
                'Check if query string and homology string have an equal length'
            );
        }
        last;
    }
}

$searchio = Bio::SearchIO->new(
    -format => 'hmmer',
    -file   => test_input_file('hmmsearch.out')
);
while ( $result = $searchio->next_result ) {
    is( ref($result),
        'Bio::Search::Result::HMMERResult',
        'Check for the correct result reference type'
    );
    is( $result->algorithm,         'HMMSEARCH',  'Check algorithm' );
    is( $result->algorithm_version, '2.0',        'Check algorithm version' );
    is( $result->hmm_name,          'HMM [SEED]', 'Check hmm_name' );
    is( $result->sequence_file, 'HMM.dbtemp.29591', 'Check sequence_file' );
    is( $result->database_name, 'HMM.dbtemp.29591', 'Check database_name' );
    is( $result->query_name,    'SEED',             'Check query_name' );
    is( $result->query_description, '',   'Check query_description' );
    is( $result->num_hits(),        1215, 'Check num_hits' );
    my $hit = $result->next_model;
    is( $hit->name, 'Q91581', 'Check hit name' );
    is( $hit->description,
        'Q91581 POLYADENYLATION FACTOR 64 KDA SUBUN',
        'Check for hit description'
    );
    float_is( $hit->significance, 2e-31, 'Check hit significance' );
    is( $hit->raw_score, 119.7, 'Check hit raw_score' );
    my $hsp = $hit->next_domain;
    is( $hsp->score, 119.7, 'Check for hsp score' );
    float_is( $hsp->evalue, 2e-31, 'Check for hsp c-Evalue' );
    is( $hsp->query->start,    18,       'Check for query alifrom value' );
    is( $hsp->query->end,      89,       'Check for query ali to value' );
    is( $hsp->hit->start,      1,        'Check for hit hmmfrom value' );
    is( $hsp->hit->end,        77,       'Check for hit hmm to value' );
    is( $hsp->query->seq_id(), 'SEED',   'Check for query seq_id' );
    is( $hsp->hit->seq_id(),   'Q91581', 'Check for hit seq_id' );
}

$searchio = Bio::SearchIO->new(
    -format => 'hmmer',
    -file   => test_input_file('L77119.hmmer')
);

while ( $result = $searchio->next_result ) {
    is( ref($result),
        'Bio::Search::Result::HMMERResult',
        'Check for the correct result reference type'
    );
    is( $result->algorithm,         'HMMPFAM',    'Check algorithm' );
    is( $result->algorithm_version, '2.2g',       'Check algorithm version' );
    is( $result->hmm_name,          'Pfam',       'Check hmm_name' );
    is( $result->sequence_file,     'L77119.faa', 'Check sequence_file' );
    is( $result->query_name, 'gi|1522636|gb|AAC37060.1|',
        'Check query_name' );
    is( $result->query_description,
        'M. jannaschii predicted coding region MJECS02 [Methanococcus jannaschii]',
        'Check query_description'
    );
    is( $result->num_hits(), 1, 'Check num_hits' );
    my $hit = $result->next_hit;
    is( $hit->name, 'Methylase_M', 'Check hit name' );
    is( $hit->description,
        'Type I restriction modification system, M',
        'Check for hit description'
    );
    float_is( $hit->significance, 0.0022, 'Check hit significance' );
    is( $hit->raw_score, -105.2, 'Check hit raw_score' );
    my $hsp = $hit->next_hsp;
    is( $hsp->score, -105.2, 'Check for hsp score' );
    float_is( $hsp->evalue, 0.0022, 'Check for hsp evalue' );
    is( $hsp->query->start, 280, 'Check for query alifrom value' );
    is( $hsp->query->end,   481, 'Check for query ali to value' );
    is( $hsp->hit->start,   1,   'Check for hit hmmfrom value' );
    is( $hsp->hit->end,     279, 'Check for hit hmm to value' );
    is( $hsp->query->seq_id(),
        'gi|1522636|gb|AAC37060.1|', 'Check for query seq_id' );
    is( $hsp->hit->seq_id(), 'Methylase_M', 'Check for hit seq_id' );
    is( $hsp->hit_string,
        'lrnELentLWavADkLRGsmDaseYKdyVLGLlFlKYiSdkFlerrieieerktdtesepsldyakledqyeqlededlekedfyqkkGvFilPsqlFwdfikeaeknkldedigtdldkifseledqialgypaSeedfkGlfpdldfnsnkLgskaqarnetLtelidlfselelgtPmHNG-dfeelgikDlfGDaYEYLLgkFAeneGKsGGeFYTPqeVSkLiaeiLtigqpsegdfsIYDPAcGSGSLllqaskflgehdgkrnaisyYGQEsn',
        'Check for hiy string'
    );
    is( $hsp->query_string,
        'NTSELDKKKFAVLLMNR--------------LIFIKFLEDK------GIV---------PRDLLRRTYEDY---KKSNVLI-NYYDAY-L----KPLFYEVLNTPEDER--KENIRT-NPYYKDIPYL---N-G-------GLFRSNNV--PNELSFTIKDNEIIGEVINFLERYKFTLSTSEGsEEVELNP-DILGYVYEKLINILAEKGQKGLGAYYTPDEITSYIAKNT-IEPIVVE----------------RFKEIIK--NWKINDINF----ST',
        'Check for query string'
    );
    is( $hsp->homology_string,
        ' ++EL+++  av+   R              L+F K++ dk      +i+         p +   + +++y   ++   ++ ++y ++      + lF++++   e ++  ++++ + +    ++      + +       Glf ++++  ++ +s+   +ne ++e+i+ +++ +++     G++ +el   D++G +YE L+   Ae   K+ G +YTP e++  ia+ + i+  ++                  +++ ++    k+n+i +    s+',
        'Check for homology string'
    );
    is( join( ' ', $hsp->seq_inds( 'query', 'nomatch', 1 ) ),
        '280 288 289 293-295 300 304 311 313-315 317 324-326 332 335 337 344-346 348 355 358-361 364-366 372 379 383-385 389 396 400 404-408 412 416 417 422 426 429-431 434-436 439 441 446 450 451 455 459 460 463 464 468 471 472 478',
        'Check for nomatch indices in query'
    );
    is( join( ' ', $hsp->seq_inds( 'hit', 'nomatch', 1 ) ),
        '1 9 10 14-16 18-31 35 39 42-47 51-59 61 63-65 67 72-74 77-79 82 86 89-94 96 103-105 107 110 111 116 118 120-123 126-131 133 135-141 145 150 151 154 158-160 164 171 175 179-183 187 191-193 198 202 205-207 210-212 215 217 222 226 227 231 233 236 237 240-257 261 264-267 273 275-278',
        'Check for nomatch indices in hit'
    );
    is( join( ' ', $hsp->seq_inds( 'query', 'gap', 1 ) ),
        '296 306 309 321 328 334 335 350 356 366-368 376 417 456 463 470 479',
        'Check for gap indices in query'
    );
    is( join( ' ', $hsp->seq_inds( 'hit', 'gap', 1 ) ),
        '', 'Check for gap indices in hit' );
}

$searchio = Bio::SearchIO->new(
    -format => 'hmmer',
    -file   => test_input_file('cysprot1b.hmmsearch')
);

while ( $result = $searchio->next_result ) {
    is( ref($result),
        'Bio::Search::Result::HMMERResult',
        'Check for the correct result reference type'
    );
    is( $result->algorithm,         'HMMSEARCH', 'Check algorithm' );
    is( $result->algorithm_version, '2.2g',      'Check algorithm version' );
    is( $result->hmm_name,
        'Peptidase_C1.hmm [Peptidase_C1]',
        'Check hmm_name'
    );
    is( $result->database_name,   'cysprot1b.fa', 'Check database_name' );
    is( $result->sequence_file,   'cysprot1b.fa', 'Check sequence_file' );
    is( $result->query_name,      'Peptidase_C1', 'Check query_name' );
    is( $result->query_accession, 'PF00112',      'Check query_accession' );
    is( $result->query_description,
        'Papain family cysteine protease',
        'Check query_description'
    );
    is( $result->num_hits(), 4, 'Check num_hits' );
    my $hit = $result->next_hit;
    is( $hit->name,        'CATL_RAT', 'Check hit name' );
    is( $hit->description, '',         'Check for hit description' );
    float_is( $hit->significance, 2e-135, 'Check hit significance' );
    is( $hit->raw_score, 449.4, 'Check hit raw_score' );
    my $hsp = $hit->next_hsp;
    is( $hsp->score, 449.4, 'Check for hsp score' );
    float_is( $hsp->evalue, 2e-135, 'Check for hsp evalue' );
    is( $hsp->query->start, 1,   'Check for query alifrom value' );
    is( $hsp->query->end,   337, 'Check for query ali to value' );
    is( $hsp->hit->start,   114, 'Check for hit hmmfrom value' );
    is( $hsp->hit->end,     332, 'Check for hit hmm to value' );
    is( $hsp->query->seq_id(), 'Peptidase_C1', 'Check for query seq_id' );
    is( $hsp->hit->seq_id(),   'CATL_RAT',     'Check for hit seq_id' );
    is( $hsp->hit_string,
        'IPKTVDWRE-KG-CVTPVKNQG-QCGSCWAFSASGCLEGQMFLKT------GKLISLSEQNLVDCSH-DQGNQ------GCNG-GLMDFAFQYIKE-----NGGLDSEESY-----PYE----AKD-------------------GSCKYR-AEYAV-----ANDTGFVDIPQQ-----EKALMKAVATVGPISVAMDASHPS---LQFYSSG-------IYYEP---NCSSK---DLDHGVLVVGYGYEG-T------------------------------------DSNKDKYWLVKNSWGKEWGMDGYIKIAKDRN----NHCGLATAASYPI',
        'Check for hiy string'
    );
    is( $hsp->homology_string,
        '+P+++DWRe kg  VtpVK+QG qCGSCWAFSa g lEg+ ++kt      gkl+sLSEQ+LvDC++ d gn+      GCnG Glmd Af+Yik+     NgGl++E++Y     PY+    +kd                   g+Cky+  + ++     a+++g++d+p++     E+al+ka+a++GP+sVa+das+ s    q+Y+sG       +Y+++    C+++   +LdH+Vl+VGYG e+                                      ++++ +YW+VKNSWG++WG++GY++ia+++n    n+CG+a+ asypi',
        'Check for homology string'
    );
    is( $hsp->query_string,
        'lPesfDWReWkggaVtpVKdQGiqCGSCWAFSavgalEgryciktgtkawggklvsLSEQqLvDCdgedygnngesCGyGCnGGGlmdnAfeYikkeqIsnNgGlvtEsdYekgCkPYtdfPCgkdggndtyypCpgkaydpndTgtCkynckknskypktyakikgygdvpynvsTydEealqkalaknGPvsVaidasedskgDFqlYksGendvgyGvYkhtsageCggtpfteLdHAVliVGYGteneggtfdetssskksesgiqvssgsngssgSSgssgapiedkgkdYWIVKNSWGtdWGEnGYfriaRgknksgkneCGIaseasypi',
        'Check for query string'
    );
    $hit = $result->next_hit;
    is( $hit->name,        'CATL_HUMAN', 'Check hit name' );
    is( $hit->description, '',           'Check for hit description' );
    float_is( $hit->significance, 6.1e-134, 'Check hit significance' );
    is( $hit->raw_score, 444.5, 'Check hit raw_score' );
}

# test for bug 2632 - CS lines should get ignored without breaking the parser
$searchio = Bio::SearchIO->new(
    -format => 'hmmer',
    -file   => test_input_file('hmmpfam_cs.out')
);
$result = $searchio->next_result;
my $hit = $result->next_hit;
my $hsp = $hit->next_hsp;
is( $hsp->seq_str,
    'CGV-GFIADVNNVANHKIVVQALEALTCMEHRGACSADRDSGDGAGITTAIPWNLFQKSLQNQNIKFEQnDSVGVGMLFLPAHKLKES--KLIIETVLKEENLEIIGWRLVPTVQEVLGKQAYLNKPHVEQVFCKSSNLSKDRLEQQLFLVRKKIEKYIGINGKDwaheFYICSLSCYTIVYKGMMRSAVLGQFYQDLYHSEYTSSFAIYHRRFSTNTMPKWPLAQPMR---------FVSHNGEINTLLGNLNWMQSREPLLQSKVWKDRIHELKPITNKDNSDSANLDAAVELLIASGRSPEEALMILVPEAFQNQPDFA-NNTEISDFYEYYSGLQEPWDGPALVVFTNGKV-IGATLDRNGL-RPARYVIT----KDNLVIVSSES',
    'Check for hsp seq_str'
);

# Tests for hmmer3 output here
$searchio = Bio::SearchIO->new(
    -format  => 'hmmer',
    -file    => test_input_file('hmmscan.out'),
    -verbose => 1
);
is( ref($searchio), 'Bio::SearchIO::hmmer3',
    'Check if correct searchio object is returned' );
my $counter = 0;
while ( $result = $searchio->next_result ) {
    $counter++;
    if ($counter == 1) {
        is( ref($result),
            'Bio::Search::Result::HMMERResult',
            'Check for the correct result reference type'
        );
        is( $result->algorithm,         'HMMSCAN', 'Check algorithm' );
        is( $result->algorithm_version, '3.0',     'Check algorithm version' );
        is( $result->hmm_name,
            '/data/biodata/HMMerDB/Pfam.hmm',
            'Check hmm_name'
        );
        is( $result->sequence_file,
            'BA000019.orf1.fasta',
            'Check sequence_file'
        );
        is( $result->query_name,        'BA000019.orf1', 'Check query_name' );
        is( $result->query_length,       198,            'Check query_length' );
        is( $result->query_accession,   '',              'Check query_accession' );
        is( $result->query_description, '',              'Check query_description' );
        # 1 hit above and 6 below inclusion threshold
        is( $result->num_hits(), 7, 'Check num_hits' );

        my ( $hsp, $hit );
        if ( $hit = $result->next_model ) {
            is( ref($hit), 'Bio::Search::Hit::HMMERHit',
                'Check for the correct hit reference type' );
            is( $hit->name, 'Peripla_BP_2', 'Check hit name' );
            is( $hit->description,
                'Periplasmic binding protein',
                'Check for hit description'
            );
            is( $hit->raw_score,          105.2, 'Check hit raw_score' );
            float_is( $hit->significance, 6e-30, 'Check hit significance' );
            is( $hit->num_hsps,           1,     'Check num_hsps' );

            # Hit length is unknown for HMMSCAN and HMMSEARCH but not for NHMMER
            is( $hit->length,             0,     'Check hit length absence' );
            is( sprintf( "%.2f", $hit->frac_aligned_query ), 0.87 );
            is( $hit->frac_aligned_hit, undef );

            if ( defined( $hsp = $hit->next_domain ) ) {
                is( ref($hsp), 'Bio::Search::HSP::HMMERHSP',
                    'Check for correct hsp reference type' );
                is( $hsp->hit->start,   59,      'Check for hit hmmfrom value' );
                is( $hsp->hit->end,     236,     'Check for hit hmm to value' );
                is( $hsp->query->start, 2,       'Check for query alifrom value' );
                is( $hsp->query->end,   173,     'Check for query ali to value' );
                is( $hsp->score,       '105.0',  'Check for hsp score' );
                float_is( $hsp->evalue, 1.5e-33, 'Check for hsp c-Evalue' );

                is( $hsp->length('query'), 172, 'Check for hsp query length' );
                is( $hsp->length('hit'),   178, 'Check for hsp hit length' );
                is( $hsp->length('total'), 180, 'Check for hsp total length' );
                is( $hsp->gaps('query'),   8,   'Check for hsp query gaps' );
                is( $hsp->gaps('hit'),     2,   'Check for hsp hit gaps' );
                is( $hsp->gaps('total'),   10,  'Check for hsp total gaps' );

                is( sprintf( "%.2f", $hsp->percent_identity ),        27.78 );
                is( sprintf( "%.3f", $hsp->frac_identical('query') ), 0.291 );
                is( sprintf( "%.3f", $hsp->frac_identical('hit') ),   0.281 );
                is( sprintf( "%.3f", $hsp->frac_conserved('query') ), 0.814 );
                is( sprintf( "%.3f", $hsp->frac_conserved('hit') ),   0.787 );

                is (length($hsp->homology_string), length($hsp->query_string));

                is( $hsp->query_string,
                    'LKPDLIIGREYQ---KNIYNQLSNFAPTVLVDWGSF-TSFQDNFRYIAQVLNEEEQGKLVLQQYQKRIRDLQDRMGERlQKIEVSVIGFSGQSIKSLNR-DAVFNQVLDDAGIKRIsIQKNQQERYLEISIENLNKYDADVLFVINE---SKEQLYPDLKNPLWHHLRAVKKQQVYVVNQ',
                    'Check for query string'
                );
                is( $hsp->hit_string,
                    'lkPDlvivsafgalvseieellelgipvvavessstaeslleqirllgellgeedeaeelvaelesridavkaridsl-kpktvlvfgyadegikvvfgsgswvgdlldaaggeni-iaeakgseseeisaEqilaadpdviivsgrgedtktgveelkenplwaelpAvkngrvyllds',
                    'Check for hit string'
                );
                is( $hsp->homology_string,
                    'lkPDl+i+ +++   ++i+++l++ +p+v v+  s+  s+++ +r ++++l+ee++++ + +++++ri+++++r  +  ++ +v+v+g+++ +ik+++  +  ++++ld+ag++ i i++++++ + eis+E+++++d+dv++v       k+ +   ++nplw +l+Avk+++vy++++',
                    'Check for homology string'
                );
                is( $hsp->posterior_string,
                    '8***********...********************9.*****************************************999999999999997777776.5678999999****99777777*************************...77777777899***************9976',
                    'Check for posterior probability string'
                );
            }
        }
    }
    # Check for errors in HSP caused by the existence of 2 hits with the same ID
    elsif ($counter == 2) {
        is( $result->algorithm,         'HMMSCAN', 'Check algorithm' );
        is( $result->algorithm_version, '3.0',     'Check algorithm version' );
        is( $result->hmm_name,
            '/data/biodata/HMMerDB/Pfam.hmm',
            'Check hmm_name'
        );
        is( $result->sequence_file,
            'BA000019.orf1.fasta',
            'Check sequence_file'
        );
        is( $result->query_name,        'lcl|Test_ID.1|P1', 'Check query_name' );
        is( $result->query_length,       463,               'Check query_length' );
        is( $result->query_description, '281521..282909',   'Check query_description' );
        is( $result->num_hits(),         2,                 'Check num_hits' );

        my ( $hsp, $hit );
        my $hit_counter = 0;
        while ( $hit = $result->next_model ) {
            $hit_counter++;
            if ($hit_counter == 1) {
                is( ref($hit), 'Bio::Search::Hit::HMMERHit',
                    'Check for the correct hit reference type' );
                is( $hit->name,        'IS4.original', 'Check hit name' );
                is( $hit->description, '',             'Check for hit description' );
                is( $hit->num_hsps,     1,             'Check num_hsps' );
                if ( defined( $hsp = $hit->next_domain ) ) {
                    is( ref($hsp), 'Bio::Search::HSP::HMMERHSP',
                        'Check for correct hsp reference type' );
                    is( $hsp->hit->start,   315,     'Check for hit hmmfrom value' );
                    is( $hsp->hit->end,     353,     'Check for hit hmm to value' );
                    is( $hsp->query->start, 335,     'Check for query alifrom value' );
                    is( $hsp->query->end,   369,     'Check for query ali to value' );
                    is( $hsp->score,        18.9,    'Check for hsp score' );
                    float_is( $hsp->evalue, 8.9e-08, 'Check for hsp c-Evalue' );
                }
            }
            elsif ($hit_counter == 2) {
                is( ref($hit), 'Bio::Search::Hit::HMMERHit',
                    'Check for the correct hit reference type' );
                is( $hit->name,        'IS4.original', 'Check hit name' );
                is( $hit->description, '',             'Check for hit description' );
                is( $hit->num_hsps,     1,             'Check num_hsps' );
                if ( defined( $hsp = $hit->next_domain ) ) {
                    is( ref($hsp), 'Bio::Search::HSP::HMMERHSP',
                        'Check for correct hsp reference type' );
                    is( $hsp->hit->start,   315,    'Check for hit hmmfrom value' );
                    is( $hsp->hit->end,     353,    'Check for hit hmm to value' );
                    is( $hsp->query->start, 335,    'Check for query alifrom value' );
                    is( $hsp->query->end,   369,    'Check for query ali to value' );
                    is( $hsp->score,        18.8,   'Check for hsp score' );
                    float_is( $hsp->evalue, 9e-08, 'Check for hsp c-Evalue' );
                }
            }
        }
    }
}

$searchio = Bio::SearchIO->new(
    -format  => 'hmmer',
    -file    => test_input_file('hmmsearch3.out'),
    -verbose => 1
);
while ( $result = $searchio->next_result ) {
    is( ref($result),
        'Bio::Search::Result::HMMERResult',
        'Check for the correct result reference type'
    );
    is( $result->algorithm,         'HMMSEARCH', 'Check algorithm' );
    is( $result->algorithm_version, '3.0',       'Check algorithm version' );
    is( $result->hmm_name,          'Kv9.hmm',   'Check hmm_name' );
    is( $result->sequence_file,
        '/home/pboutet/Desktop/databases/nr_May26',
        'Check sequence_file'
    );
    is( $result->query_name,        'Kv9', 'Check query_name' );
    is( $result->query_length,      '481', 'Check query_length' );
    is( $result->query_description, '',    'Check query_description' );
    is( $result->num_hits(),        2,     'Check num_hits' );

    while ( my $hit = $result->next_model ) {
    }
}

$searchio = Bio::SearchIO->new(
    -format  => 'hmmer',
    -file    => test_input_file('hmmsearch3_multi.out'),
    -verbose => 1
);
is( ref($searchio), 'Bio::SearchIO::hmmer3',
    'Check if correct searchio object is returned' );
$counter = 0;
while ( $result = $searchio->next_result ) {
    $counter++;
    if ($counter == 1) {
        is( ref($result),
            'Bio::Search::Result::HMMERResult',
            'Check for the correct result reference type'
        );
        is( $result->algorithm,         'HMMSEARCH',             'Check algorithm' );
        is( $result->algorithm_version, '3.0',                   'Check algorithm version' );
        is( $result->hmm_name,          'Pfam-A.hmm',            'Check hmm_name' );
        is( $result->sequence_file,     'test_seqs.seq_raw.txt', 'Check sequence_file' );

        is( $result->query_name,      '1-cysPrx_C', 'Check query_name' );
        is( $result->query_length,     40,          'Check query_length' );
        is( $result->query_accession, 'PF10417.4',  'Check query_accession' );
        is( $result->query_description,
            'C-terminal domain of 1-Cys peroxiredoxin',
            'Check query_description'
        );
        is( $result->num_hits(), 0, 'Check num_hits' );
    }
    elsif ($counter == 2) {
        is( ref($result),
            'Bio::Search::Result::HMMERResult',
            'Check for the correct result reference type'
        );
        is( $result->algorithm,         'HMMSEARCH',             'Check algorithm' );
        is( $result->algorithm_version, '3.0',                   'Check algorithm version' );
        is( $result->hmm_name,          'Pfam-A.hmm',            'Check hmm_name' );
        is( $result->sequence_file,     'test_seqs.seq_raw.txt', 'Check sequence_file' );

        is( $result->query_name,      'DUF4229',   'Check query_name' );
        is( $result->query_length,     69,         'Check query_length' );
        is( $result->query_accession, 'PF14012.1', 'Check query_accession' );
        is( $result->query_description,
            'Protein of unknown function (DUF4229)',
            'Check query_description'
        );
        is( $result->num_hits(), 1, 'Check num_hits' );

        my ( $hsp, $hit );
        if ( $hit = $result->next_model ) {
            is( ref($hit), 'Bio::Search::Hit::HMMERHit',
                'Check for the correct hit reference type' );
            is( $hit->name, 'lcl|Protein_ID1.3|M3', 'Check hit name' );
            is( $hit->description,
                'complement(48376..51420)',
                'Check for hit description'
            );
            is( $hit->raw_score,         -17.8, 'Check hit raw_score' );
            float_is( $hit->significance, 3,    'Check hit significance' );
            is( $hit->num_hsps,           5,    'Check num_hsps' );

            # Check first HSP
            if ( defined( $hsp = $hit->next_domain ) ) {
                is( ref($hsp), 'Bio::Search::HSP::HMMERHSP',
                    'Check for correct hsp reference type' );
                is( $hsp->hit->start,   305, 'Check for hit alifrom value' );
                is( $hsp->hit->end,     311, 'Check for hit ali to value' );
                is( $hsp->query->start, 34,  'Check for query hmmfrom value' );
                is( $hsp->query->end,   40,  'Check for query hmm to value' );
                is( $hsp->score,       -4.3, 'Check for hsp score' );
                float_is( $hsp->evalue, 1,   'Check for hsp c-Evalue' );
                is( $hsp->consensus_structure,
                    '',
                    'Check for consensus structure string'
                );
                is( $hsp->query_string,
                    'laallAl',
                    'Check for query string'
                );
                is( $hsp->hit_string,
                    'LAILSAI',
                    'Check for hit string'
                );
                is( $hsp->homology_string,
                    'la+l A+',
                    'Check for homology string'
                );
                is( $hsp->posterior_string,
                    '3333332',
                    'Check for posterior probability string'
                );
            }
        }
    }
    elsif ($counter == 3) {
        is( ref($result),
            'Bio::Search::Result::HMMERResult',
            'Check for the correct result reference type'
        );
        is( $result->algorithm,         'HMMSEARCH',             'Check algorithm' );
        is( $result->algorithm_version, '3.0',                   'Check algorithm version' );
        is( $result->hmm_name,          'Pfam-A.hmm',            'Check hmm_name' );
        is( $result->sequence_file,     'test_seqs.seq_raw.txt', 'Check sequence_file' );

        is( $result->query_name,      'ACR_tran',   'Check query_name' );
        is( $result->query_length,     1021,        'Check query_length' );
        is( $result->query_accession, 'PF00873.14', 'Check query_accession' );
        is( $result->query_description,
            'AcrB/AcrD/AcrF family',
            'Check query_description'
        );
        is( $result->num_hits(), 1, 'Check num_hits' );

        my ( $hsp, $hit );
        if ( $hit = $result->next_model ) {
            is( ref($hit), 'Bio::Search::Hit::HMMERHit',
                'Check for the correct hit reference type' );
            is( $hit->name, 'lcl|Protein_ID1.3|M3', 'Check hit name' );
            is( $hit->description,
                'complement(48376..51420)',
                'Check for hit description'
            );
            is( $hit->raw_score,          616.9,    'Check hit raw_score' );
            float_is( $hit->significance, 9.3e-189, 'Check hit significance' );
            is( $hit->num_hsps,           1,        'Check num_hsps' );

            # Hit length is unknown for HMMSCAN and HMMSEARCH but not for NHMMER
            is( $hit->length,             0,        'Check hit length absence' );
            is( sprintf( "%.2f", $hit->frac_aligned_query ), 0.93 );
            is( $hit->frac_aligned_hit, undef );

            if ( defined( $hsp = $hit->next_domain ) ) {
                is( ref($hsp), 'Bio::Search::HSP::HMMERHSP',
                    'Check for correct hsp reference type' );
                is( $hsp->hit->start,   11,       'Check for hit alifrom value' );
                is( $hsp->hit->end,     1000,     'Check for hit ali to value' );
                is( $hsp->query->start, 71,       'Check for query hmmfrom value' );
                is( $hsp->query->end,   1021,     'Check for query hmm to value' );
                is( $hsp->score,        616.6,    'Check for hsp score' );
                float_is( $hsp->evalue, 3.9e-189, 'Check for hsp c-Evalue' );

                is( $hsp->length('query'), 951,  'Check for hsp query length' );
                is( $hsp->length('hit'),   990,  'Check for hsp hit length' );
                is( $hsp->length('total'), 1003, 'Check for hsp total length' );
                is( $hsp->gaps('query'),   52,   'Check for hsp query gaps' );
                is( $hsp->gaps('hit'),     13,   'Check for hsp hit gaps' );
                is( $hsp->gaps('total'),   65,   'Check for hsp total gaps' );

                is( sprintf( "%.2f", $hsp->percent_identity ),        26.12 );
                is( sprintf( "%.3f", $hsp->frac_identical('query') ), 0.275 );
                is( sprintf( "%.3f", $hsp->frac_identical('hit') ),   0.265 );
                is( sprintf( "%.3f", $hsp->frac_conserved('query') ), 0.726 );
                is( sprintf( "%.3f", $hsp->frac_conserved('hit') ),   0.697 );

                is (length($hsp->homology_string), length($hsp->query_string));

                is( $hsp->consensus_structure,
                    'S-TTEEEEEEEETTSEEEEEEEESTTS-HHHHHHHHHHHHHHHGGGS-HHHHHH-EEEEEEECCECEEEEEEESSSTS-HHHHHHHHHHCTHHHHHTSTTEEEEEESS.--EEEEEEE-HHHHHCTT--HHHHHHHHHHHSSB-EEEECTT-SB-EEEE-SB---SCCHHCT-EEEETTSEEEEHHHCEEEEEEESSSS-EEEETTCEEEEEEEEEETTSBHHHHHHHHHHHHHCCGGGSSTTEEEEEEEESHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHSSHCCCHHHHHHHHHHHHHHHHHHHHTT--EEHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHCSS-HHHHHHHHHHHHCCHHHHHHHHHHHHCCGGGGSBHHHHHHHHHHHHHHHHHHHHHHHHHHCCHHHHHHHCS----TT-CC..............................CHHHHHHHHHHHHHHHHHHHHHHHHHSCHHHHHHHHHHHHH.HHHHHCCS-BESS----TSEEEEEEE-STTC-HHHHHHHHHHHHHHHH...TTTTEEEEEEEESESSSS..E........CTTEEEEEEEE--CTTS-SCCCSHHHHHHHHHHHC.CTSTSSEEEEEE-SSSCCCSSSSSEEEEEEE.TSSSCHHHHHHHHHHHHHHHCCSTTEECEEESS-S-EEEEEEEE-HHHHHHCTB-HHHHHHHHHHHHT-..EEEEEEEETTE...EEEEEEEE-GGGSSSGGGGCC-EEEETTSE.EEECGGCEEEEEEEE-SEEEEETTCEEEEEEEEESTTS...-HHHHHHHHHHCCTT..SSTTEEEEEECHHHHHHHHCCCHHHHHHHHHHHHHHHHHHHCTSSSTCHHHHTTHHHHHHHHHHHHHHTT--BSHHHHHHHHHHHHHHHHHHHHHHHHHHHHHCTTTBHHHHHHHHHHHHCHHHHHHHHHHHHHCCHHHHTT-STTHHHHHHHHHHHHHHHHHHHHCHHHHHHHHHHHHH',
                    'Check for consensus structure string'
                );
                is( $hsp->query_string,
                    'gldglkyvsSqSseglssitvtFedgtdidiArqqvqnrlqeaknkLPeevqepgiskiktssseilvlavtskdgsltktdlrdlaesnikdqlsrveGVgdvqliGgsekavriwldpqklaklgltltdvvsalkeqnvqvaaGqlegqqeelliraqgrlqsaediekiivksqdgskvrlrDvAkvelgaeeeriaatlngkpavllavkklpganaievvkavkekleelketlPegveivvvydttefvrasieeVvktlleaivLvvlvlflFLqnlratlipaiavPlsllgtfavlkalglsiNlltlfgLvlAiGlvvDdAiVvvEnverkleeegekpleaalksmkeiegalvaialvllavfvPilflgGveGklfrqfaltivlaillsvlvaltltPalcallLkarkeekek..............................gffrefnrlfdalerrYekllekvlrhravvllvalllvvg.slllfvripkeflPeedegvlvtsvqlppgvsleqtekvlkqvekilk...ekpevesvfavtGfafagdta........gqnsakvfisLkpekerkeeektvealierlrkel.ekikganvellapiqlreletlsgvrlelqvklfgddleaLseareqllaalkqlpeladvrseqqedepqlqvkidrekaaalGvsiadinetlstalgg..syvndfieegr...vvkvvvqleedlrsspedlkklyvrnkkgk.mvplsavakieeekgpnsierenglrsveisgevaegd...slgeaeeavekiakqvklPagvgiewtglseqeqeagnsllllvalalllvflvLaalyeslsdpllvlltvPlalvGallalllrglelsviaqvGlilliGlavkNailivefakelrekeglsleeAileaaklRLrPiLMTalaailGvlPLalstGaGselqqplgivvlGGlvtstvLtlllvPvlYvlva',
                    'Check for query string'
                );
                is( $hsp->hit_string,
                    'TVNDIEHIESQSLFGYGIVKIFFQPDVDIRTANAQVTAISQTVLKQMPPGITPPLILNYNAATVPILQLALSSK--VLSEDRIFDLGQNFIRPQLATVRGSAVPSPYGGKVRQIQIDLDPQAMQSKRVSPDDVARALSQQNLVLSPGTEKIGSFEYNVKINDSPDEFTLLNNLPIKNVGGVTIFIHDVAHVRDGFPPQINVVRDDGRRSVLMTILKNGATSTLDIIQGTKELIPKLKETLPNNLVLKVVGDQSIFVKSAISGVVREGTIAGILTSVMILLFLGSWRSTIIISMSIPLAILSAIIFLSLTGNTLNVMTLGGLALAVGMLVDDATVVIENINHHLEM-GKPTTKAIIDAARQIIQPALVSTLSICIVFVPMFSLTGVPRYLFIPMAEAVIFGMLSSFVLSQTFVPTVANKLLKYQTQHFKHehhtdahrpehdpnfkvhrsvkasifqffiNIQQGFEKRFTKVRLVYRSILHFALDHRKKFITLFLGFVIVsCVTLFPLLGKNFFPEVDSGDMKIHIRVQVGTRIEETAKQFDLIENTIRrlvPQNELDTIVDNIGLSVSGINTaysstgtiGPQDGDILIHLNEN------HHPTKEYMKKLRETLpRAFPGVS-FAFLPADITSQILNFGVPAPIDIRVDGPNHDNNLKFVRAILKDIRNVPGIADLRVQQATNYPQFNVDIDRSQAKNYGLTEGDITNSLVATLAGtsQVAPTFWLNNKngvSYPIVIQMPQYKINSLADLANIPITTKESSsMQVLGGLGSIERDQSDSVISHYNIKPSFDIFASLQGRDlgsISGDIETIIQHHHQE--LPKGVSVKLQGQVPIMQDSYRGLSLGLVASIILIYFLVVVNFESWLDPFVIITALPAALAGIVWMLYLTGTTLSVPALTGAIMCMGVATANSILVISFARERLA-IVKDSTQAALEAGYTRFRPVLMTASAMLIGMIPMALGLGDGGEQNAPLGRAVIGGLLLATIATLIFVPVVFSVVH',
                    'Check for hit string'
                );
                is( $hsp->homology_string,
                    ' ++ +++++SqS  g   + + F+ + di  A+ qv++  q + +++P ++++p i   +++  +il+la++sk   l++  + dl ++ i++ql+ v G +    +Gg+ ++++i ldpq++++ +++++dv++al++qn   + G+ +  + e+++++++   +   ++++ +k+  g  + ++DvA+v +g   + ++++ +g   vl+++ k     ++++++  ke +++lketlP+++ ++vv d++ fv+++i+ Vv +  +a +L  ++++lFL+++r+t+i+ +++Pl++l ++++l++ g ++N++tl+gL+lA+G++vDdA Vv+En+  +le+ g+   +a++ ++++i  + + ++l++++vfvP+++l+Gv   lf ++a ++++ +l s +++ t++P ++  lLk + ++ ++                              ++ + f++ f ++   Y+ +l++ l hr+  ++++l +v++ ++ lf+ ++k+f+Pe d g++ ++++++ g+ +e+t+k  + +e++++    ++e + ++   G + +g +         g++ +++ i+L ++      ++  ++ +++lr+ l ++++g++ +++ p +++ +    gv + ++  + g ++++  + ++++l+ ++++p++ad+r++q ++ pq++v+idr +a+++G++  di + l + l g  +++ +f  +++    + +v+q+++ + +s+ dl+++++++k++  m  l+ + +ie+ ++ + i+++n ++s+ i ++++ +d   ++g++e+++++ +++  lP+gv+++ +g+    q ++  l+l ++++++l++++  + +es++dp+++++ +P al+G +  l+l+g++lsv a+ G i+ +G+a  N il+++fa+e  +   ++  +A+lea+ +R+rP+LMTa a+++G++P+al+ G+G e   plg +v+GGl+++t+ tl +vPv++ +v+',
                    'Check for homology string'
                );
                is( $hsp->posterior_string,
                    '578899********************************************************************..*****************************************************************************************************************************************************************************************************************************************************************************.***************************************************************************8776544446799********************9655555578*************************999999887775899******************************************8875446889999999999888774331111111134445555555444......45688999999999945678887.7888999*999************************************************************************8877666655434556776544422279***********************998764889*******************************8876222578999999999888..********************************************************************************************************.888899*****************************************************************9997',
                    'Check for posterior probability string'
                );
            }
        }
    }
}

$searchio = Bio::SearchIO->new(
    -format  => 'hmmer',
    -file    => test_input_file('hmmscan_multi_domain.out'),
    -verbose => 1
);

my @multi_hits = (
    [   'PPC',
        'Bacterial pre-peptidase C-terminal domain',
        '111.0', 3.1e-32, 6,
        [   [ 4,  59, 117,  183,  0.5,  0.16 ],
            [ 12, 58, 347,  388,  -0.6, 0.36 ],
            [ 1,  69, 470,  549,  71.3, 1.3e-23 ],
            [ 15, 25, 582,  603,  -3.2, 2 ],
            [ 13, 36, 987,  1019, -1.1, 0.5 ],
            [ 1,  69, 1087, 1168, 54.4, 2.4e-18 ]
        ]
    ],
    [   'HemolysinCabind',
        'Hemolysin-type calcium-binding repeat (2 cop',
        '47.9', 4.7e-13, 3,
        [   [ 2, 13, 1214, 1225, 5.9,  0.0026 ],
            [ 1, 18, 1231, 1248, 10.8, 6.8e-5 ],
            [ 4, 18, 1243, 1257, 11.4, 4.3e-05 ]
        ]
    ]
);

while ( $result = $searchio->next_result ) {
    is( ref($result),
        'Bio::Search::Result::HMMERResult',
        'Check for the correct result reference type'
    );
    is( $result->algorithm,         'HMMSCAN', 'Check algorithm' );
    is( $result->algorithm_version, '3.0',     'Check algorithm version' );
    is( $result->hmm_name,
        '/data/biodata/HMMerDB/Pfam-A.hmm',
        'Check hmm_name'
    );
    is( $result->sequence_file, 'BA000019.orf37.fasta',
        'Check sequence_file' );
    is( $result->query_name, 'BA000019.orf37', 'Check query_name' );
    is( $result->query_length, '1418', 'Check query_length' );
    is( $result->query_description, '', 'Check query_description' );
    is( $result->num_hits(),        2,  'Check num_hits' );
    my ( $hsp, $hit );

    while ( $hit = $result->next_model ) {
        my @expected = @{ shift @multi_hits };
        is( ref($hit), 'Bio::Search::Hit::HMMERHit',
            'Check for the correct hit reference type' );
        is( $hit->name,        shift @expected, 'Check hit name' );
        is( $hit->description, shift @expected, 'Check for hit description' );
        is( $hit->raw_score,   shift @expected, 'Check hit raw_score' );
        float_is(
            $hit->significance,
            shift @expected,
            'Check hit significance'
        );
        is( $hit->num_hsps, shift @expected, 'Check num_hsps' );
        my @hsp_list = @{ shift @expected };

        while ( defined( $hsp = $hit->next_domain ) ) {
            my @hsp_exp = @{ shift @hsp_list };
            is( ref($hsp), 'Bio::Search::HSP::HMMERHSP',
                'Check for correct hsp reference type' );
            is( $hsp->hit->start,
                shift @hsp_exp,
                'Check for hit envfrom value'
            );
            is( $hsp->hit->end, shift @hsp_exp,
                'Check for hit env to value' );
            is( $hsp->query->start,
                shift @hsp_exp,
                'Check for query hmmfrom value'
            );
            is( $hsp->query->end,
                shift @hsp_exp,
                'Check for query hmm to value'
            );
            is( $hsp->score, shift @hsp_exp, 'Check for hsp score' );
            float_is( $hsp->evalue, shift @hsp_exp,
                'Check for hsp c-Evalue' );
        }
    }
}

$searchio = Bio::SearchIO->new(
    -format  => 'hmmer',
    -file    => test_input_file('hmmscan_sec_struct.out'),
    -verbose => 1
);

@multi_hits = (
    [   'HTH_AraC',
        'Bacterial regulatory helix-turn-helix proteins, Ara',
        '41.3', 6.7e-11, 2,
        [   [ 'siadiAeevgfSpsyfsrlFkkytGvt', 'SLMELSRQVGLNDCTLKRGFRLVFDTT' ],
            [   'nwsiadiAeevgf-SpsyfsrlFkkytGvtPsqyr',
                'EINISQAARRVGFsSRSYFATAFRKKFGINPKEFL'
            ]
        ]
    ],
    [   'PKSI-KS_m3',
        '', '38.2', 3.8e-12, 2,
        [   [ 'GPSvtVDTACSSSLvA', 'GPSVTVDTLCSSSLVA' ],
            [ 'GPSvtVDTACSSSLv',  'GPNLVIDSACSSALV' ]
        ]
    ],
    [   'DUF746',
        'Domain of Unknown Function (DUF746)',
        '13.9', 0.023, 2,
        [   [   'rllIrlLsqplslaeaadqlgtdegiiak',
                'EILIRNLENPPSLMELSRQVGLNDCTLKR'
            ],
            [ 'plslaeaadqlgtdeg', 'EINISQAARRVGFSSR' ]
        ]
    ]
);

while ( $result = $searchio->next_result ) {
    is( ref($result),
        'Bio::Search::Result::HMMERResult',
        'Check for the correct result reference type'
    );
    is( $result->algorithm,         'HMMSCAN',    'Check algorithm' );
    is( $result->algorithm_version, '3.0',        'Check algorithm version' );
    is( $result->hmm_name,          'Pfam-A.hmm', 'Check hmm_name' );
    is( $result->sequence_file, 'BA000019.orf8.fasta',
        'Check sequence_file' );
    is( $result->query_name, 'BA000019.orf8', 'Check query_name' );
    is( $result->query_length, '348', 'Check query_length' );
    is( $result->query_description, '', 'Check query_description' );
    is( $result->num_hits(),        3,  'Check num_hits' );
    my ( $hsp, $hit );

    while ( $hit = $result->next_model ) {
        my @expected = @{ shift @multi_hits };
        is( ref($hit), 'Bio::Search::Hit::HMMERHit',
            'Check for the correct hit reference type' );
        is( $hit->name,        shift @expected, 'Check hit name' );
        is( $hit->description, shift @expected, 'Check for hit description' );
        is( $hit->raw_score,   shift @expected, 'Check hit raw_score' );
        float_is(
            $hit->significance,
            shift @expected,
            'Check hit significance'
        );
        is( $hit->num_hsps, shift @expected, 'Check num_hsps' );
        my @hsp_list = @{ shift @expected };

        while ( defined( $hsp = $hit->next_domain ) ) {
            my @hsp_exp = @{ shift @hsp_list };
            is( ref($hsp), 'Bio::Search::HSP::HMMERHSP',
                'Check for correct hsp reference type' );
            is( $hsp->hit_string,   shift @hsp_exp, 'Check hit sequence' );
            is( $hsp->query_string, shift @hsp_exp, 'Check query sequence' );
        }
    }
}

# Make sure that you can also directly call the hmmer2 and hmmer3 subclasses
$searchio = Bio::SearchIO->new(
    -format => 'hmmer2',
    -file   => test_input_file('hmmpfam.out')
);
is( ref($searchio), 'Bio::SearchIO::hmmer2',
    'Check if loading hmmpfam output via the hmm2 parser directly works' );
is( ref( $searchio->next_result ),
    'Bio::Search::Result::HMMERResult',
    'Check for the correct result reference type'
);

$searchio = Bio::SearchIO->new(
    -format => 'hmmer2',
    -file   => test_input_file('hmmsearch.out')
);
is( ref($searchio), 'Bio::SearchIO::hmmer2',
    'Check if loading hmmsearch2 output via the hmm2 parser directly works' );
is( ref( $searchio->next_result ),
    'Bio::Search::Result::HMMERResult',
    'Check for the correct result reference type'
);

$searchio = Bio::SearchIO->new(
    -format => 'hmmer3',
    -file   => test_input_file('hmmscan.out')
);
is( ref($searchio), 'Bio::SearchIO::hmmer3',
    'Check if loading hmmscan output via the hmm3 parser directly works' );
is( ref( $searchio->next_result ),
    'Bio::Search::Result::HMMERResult',
    'Check for the correct result reference type'
);

$searchio = Bio::SearchIO->new(
    -format => 'hmmer',
    -file   => test_input_file('hmmsearch3.out')
);
is( ref($searchio), 'Bio::SearchIO::hmmer3',
    'Check if loading hmmsearch3 output via the hmm3 parser directly works' );
is( ref( $searchio->next_result ),
    'Bio::Search::Result::HMMERResult',
    'Check for the correct result reference type'
);

# Make sure that you can also specify the -version parameter directly
$searchio = Bio::SearchIO->new(
    -format  => 'hmmer',
    -file    => test_input_file('hmmpfam.out'),
    -version => 2
);
is( ref($searchio), 'Bio::SearchIO::hmmer2',
    'Check if selecting the correct hmmpfam parser using -version works' );
is( ref( $searchio->next_result ),
    'Bio::Search::Result::HMMERResult',
    'Check for the correct result reference type'
);

$searchio = Bio::SearchIO->new(
    -format  => 'hmmer',
    -file    => test_input_file('hmmsearch.out'),
    -version => 2
);
is( ref($searchio), 'Bio::SearchIO::hmmer2',
    'Check if selecting the correct hmmsearch2 parser using -version works' );
is( ref( $searchio->next_result ),
    'Bio::Search::Result::HMMERResult',
    'Check for the correct result reference type'
);

$searchio = Bio::SearchIO->new(
    -format  => 'hmmer3',
    -file    => test_input_file('hmmscan.out'),
    -version => 3
);
is( ref($searchio), 'Bio::SearchIO::hmmer3',
    'Check if selecting the correct hmmscan parser using -version works' );
is( ref( $searchio->next_result ),
    'Bio::Search::Result::HMMERResult',
    'Check for the correct result reference type'
);

$searchio = Bio::SearchIO->new(
    -format  => 'hmmer',
    -file    => test_input_file('hmmsearch3.out'),
    -version => 3
);
is( ref($searchio), 'Bio::SearchIO::hmmer3',
    'Check if selecting the correct hmmsearch3 parser using -version works' );
is( ref( $searchio->next_result ),
    'Bio::Search::Result::HMMERResult',
    'Check for the correct result reference type'
);

my $cat_command = ($^O =~ m/mswin/i) ? 'type' : 'cat';
my $pipestr = "$cat_command " . test_input_file('hmmpfam.out') . " |";
open( my $pipefh, $pipestr );

$searchio = Bio::SearchIO->new(
    -format => 'hmmer',
    -fh     => $pipefh
);
is( ref($searchio), 'Bio::SearchIO::hmmer2',
    'Check if reading from a pipe works' );
$result = $searchio->next_result;
is( ref($result),
    'Bio::Search::Result::HMMERResult',
    'Check for the correct result reference type'
);
is( $result->num_hits(), 2, 'Check num_hits' );

# bug 3376
{
    my $in = Bio::SearchIO->new(
        -format => 'hmmer',
        -file   => test_input_file('pfamOutput-bug3376.out')
    );
    my $result = $in->next_result;
    my $hit    = $result->next_hit;
    my $hsp    = $hit->next_hsp;
    is( $hsp->hit_string,
        'svfqqqqssksttgstvtAiAiAigYRYRYRAvtWnsGsLssGvnDnDnDqqsdgLYtiYYsvtvpssslpsqtviHHHaHkasstkiiikiePr',
        'bug3376'
    );
}
# end bug 3376

# bug 3421 - making sure a full line of dashes in an HSP is parsed correctly
{
    my $in = Bio::SearchIO->new(
        -format => 'hmmer',
        -file   => test_input_file('hmmpfam_HSPdashline.txt')
    );
    my $result = $in->next_result;
    my $hit    = $result->next_hit;
    my $hsp    = $hit->next_hsp;
    is( $hsp->length, '561',
        'bug3421 - Check if can correctly parse an HSP with line full of dashes'
    );
}
# end bug 3421

# bug 3302
{
    my $in = Bio::SearchIO->new(
        -format => 'hmmer',
        -file   => test_input_file('hmmpfam_multiresult.out')
    );
    my $result = $in->next_result;
    $result = $in->next_result;
    my $hit = $result->next_hit;
    is( $hit->name, 'IS66_ORF3.uniq', 'bug3302 - Check if can parse multiresult hmmer' );
}
# end bug 3302

# HMMER 3.1 nhmmer output
{
    my $in = Bio::SearchIO->new(
        -format  => 'hmmer',
        -version => 3,
        -file    => test_input_file('nhmmer-3.1.out')
    );
    my $result = $in->next_result;
    is( $result->algorithm,         'NHMMER', 'Check algorithm' );
    is( $result->algorithm_version, '3.1b1',  'Check nhmmer algorithm version' );
    is( $result->hmm_name,
        '../HMMs/A_HA_H7_CDS_nucleotide.hmm',
        'Check hmm_name'
    );
    is( $result->sequence_file,
        'tmp.fa',
        'Check sequence_file'
    );
    is( $result->query_name,        'A_HA_H7_CDS_nucleotide', 'Check query_name' );
    is( $result->query_length,       1683,                    'Check query_length' );
    is( $result->query_accession,   '',                       'Check query_accession' );
    is( $result->query_description, '',                       'Check query_description' );
    is( $result->num_hits(),         2,                       'Check num_hits' );

    my $hit = $result->next_hit;
    is( ref($hit), 'Bio::Search::Hit::HMMERHit',
        'Check for the correct hit reference type' );
    is( $hit->name,              'seq1',                'Check nhmmer hit name' );
    is( $hit->description,       'Description of seq1', 'Check nhmmer hit description' );
    is( $hit->score,              148.2,                'Check nhmmer hit score' );
    float_is( $hit->significance, 3.2e-48,              'Check nhmmer hit significance' );
    is( $hit->num_hsps,           1,                    'Check num_hsps' );

    # Hit length is unknown for HMMSCAN and HMMSEARCH but not for NHMMER
    is( $hit->length,             151,                  'Check nhmmer hit length' );
    is( sprintf( "%.2f", $hit->frac_aligned_query ), 0.09 );
    is( sprintf( "%.2f", $hit->frac_aligned_hit ),  '1.00' );

    my $hsp = $hit->next_hsp;
    is( ref($hsp), 'Bio::Search::HSP::HMMERHSP',
        'Check for correct hsp reference type' );

    is( $hsp->start('hit'),       1,       'Check nhmmer hsp hit start' );
    is( $hsp->end('hit'),         151,     'Check nhmmer hsp hit end' );
    is( $hsp->start('query'),     258,     'Check nhmmer hsp query start' );
    is( $hsp->end('query'),       411,     'Check nhmmer hsp query end' );
    is( $hsp->strand('hit'),      1,       'Check nhmmer hsp hit strand' );
    is( $hsp->strand('query'),    1,       'Check nhmmer hsp query strand' );
    is( $hsp->score,              148.2,   'Check nhmmer hsp score' );
    float_is( $hsp->significance, 3.2e-48, 'Check nhmmer hsp evalue' );

    is( $hsp->length('query'), 154, 'Check for hsp query length' );
    is( $hsp->length('hit'),   151, 'Check for hsp hit length' );
    is( $hsp->length('total'), 154, 'Check for hsp total length' );
    is( $hsp->gaps('query'),   0,   'Check for hsp query gaps' );
    is( $hsp->gaps('hit'),     3,   'Check for hsp hit gaps' );
    is( $hsp->gaps('total'),   3,   'Check for hsp total gaps' );

    is( sprintf( "%.2f", $hsp->percent_identity ),        94.81 );
    is( sprintf( "%.3f", $hsp->frac_identical('query') ), 0.948 );
    is( sprintf( "%.3f", $hsp->frac_identical('hit') ),   0.967 );
    is( sprintf( "%.3f", $hsp->frac_conserved('query') ), 0.981 );
    is( sprintf( "%.3f", $hsp->frac_conserved('hit') ),  '1.000' );

    is (length($hsp->homology_string), length($hsp->query_string));

    is( $hsp->consensus_structure,
        '',
        'Check for consensus structure string'
    );
    is( $hsp->query_string,
        'attcctagaattttcagctgatttaattattgagaggcgagaaggaagtaatgatgtctgttatcctgggaaattcgtaaatgaagaagctctgaggcaaattctcagggggtcaggcggaattgacaaggagacaatgggattcacatatagc',
        'Check for nhmmer query string'
    );
    is( $hsp->homology_string,
        'attcctagaattttcagc+gatttaattattgagaggcgagaaggaagt   gatgtctgttatcctgggaaattcgt+aatgaagaagctctgaggcaaattctcaggg+gtcaggcggaattgacaaggagacaatgggattcac+ta+agc',
        'Check for nhmmer homology string'
    );
    is( $hsp->hit_string,
        'ATTCCTAGAATTTTCAGCCGATTTAATTATTGAGAGGCGAGAAGGAAGT---GATGTCTGTTATCCTGGGAAATTCGTGAATGAAGAAGCTCTGAGGCAAATTCTCAGGGAGTCAGGCGGAATTGACAAGGAGACAATGGGATTCACCTACAGC',
        'Check for nhmmer hit string'
    );
    is( $hsp->posterior_string,
       '689*******************************************777...***************************************************************************************************986',
        'Check for nhmmer posterior probability string'
    );
    is( length( $hsp->homology_string ),
        length( $hsp->hit_string ),
        'Check if nhmmer homology string and hit string have an equal length'
    );
    is( length( $hsp->query_string ),
        length( $hsp->homology_string ),
        'Check if nhmmer query string and homology string have an equal length'
    );

    $hit = $result->next_hit;
    is( $hit->name,              'seq2',                'Check nhmmer hit name' );
    is( $hit->description,       'Description of seq2', 'Check nhmmer hit description' );
    is( $hit->score,              38.6,                 'Check nhmmer hit score' );
    float_is( $hit->significance, 3.9e-15,              'Check nhmmer hit significance' );
    is( $hit->length,             60,                   'Check nhmmer hit length' );

    $hsp = $hit->next_hsp;
    is( $hsp->score,              38.6,    'Check nhmmer hsp score' );
    float_is( $hsp->significance, 3.9e-15, 'Check nhmmer hsp evalue' );
    is( $hsp->start('query'),     34,      'Check nhmmer hsp query start' );
    is( $hsp->end('query'),       92,      'Check nhmmer hsp query end' );
    is( $hsp->start('hit'),       1,       'Check nhmmer hsp hit start' );
    is( $hsp->end('hit'),         59,      'Check nhmmer hsp hit end' );
    is( $hsp->strand('hit'),     -1,       'Check nhmmer hsp hit strand' );
    is( $hsp->strand('query'),    1,       'Check nhmmer hsp query strand' );

    is( $hsp->gaps('query'), 0, 'Check for hsp query gaps' );
    is( $hsp->gaps('hit'),   0, 'Check for hsp hit gaps' );
    is( $hsp->gaps('total'), 0, 'Check for hsp total gaps' );

    is( $hsp->consensus_structure,
        '',
        'Check for consensus structure string'
    );
    is( $hsp->query_string,
        'gtgatgattgcaacaaatgcagacaaaatctgccttgggcaccatgctgtgtcaaacgg',
        'Check for nhmmer query string'
    );
    is( $hsp->homology_string,
        'g+gat+att+c+acaaatgcagacaa atctgccttgggca+catgc+gtgtcaaacgg',
        'Check for nhmmer homology string'
    );
    is( $hsp->hit_string,
        'GCGATCATTCCGACAAATGCAGACAAGATCTGCCTTGGGCATCATGCCGTGTCAAACGG',
        'Check for nhmmer hit string'
    );
    is( $hsp->posterior_string,
        '6899****************************************************986',
        'Check for nhmmer posterior probability string' );
    is( length( $hsp->homology_string ),
        length( $hsp->hit_string ),
        'Check if nhmmer homology string and hit string have an equal length'
    );
    is( length( $hsp->query_string ),
        length( $hsp->homology_string ),
        'Check if nhmmer query string and homology string have an equal length'
    );
}
# end HMMER 3.1 nhmmer output
