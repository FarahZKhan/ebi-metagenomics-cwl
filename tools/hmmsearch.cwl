cwlVersion: v1.0
class: CommandLineTool
label: search profile(s) against a sequence database

requirements:
  ResourceRequirement:
    coresMax: 4
    ramMin: 1024
  DockerRequirement:
    dockerPull: sglim2/hmmer-3.1b2

hints:
  SoftwareRequirement:
    packages:
      hmmer:
        specs: [ "https://identifiers.org/rrid/RRID:SCR_005305" ]
        version: [ "3.1b2" ]

inputs:
  hmm_profiles:
    type: File
    inputBinding:
      position: 1
    format: edam:format_1370  # HMMER

  sequence_query:
    type: File
    inputBinding:
      position: 2

  e_threshold:
    type: string?
    label: report sequences <= this E-value threshold in output
    inputBinding:
      prefix: -E

baseCommand: [ hmmsearch ]

arguments:
 - valueFrom: $(inputs.sequence_query.nameroot)_$(inputs.hmm_profiles.nameroot)_per_domain_summary.txt
   prefix: --domtblout
 - valueFrom: $(runtime.cores)
   prefix: --cpu

outputs:
  per_domain_summary:
    type: File
    outputBinding:
      glob: $(inputs.sequence_query.nameroot)_$(inputs.hmm_profiles.nameroot)_per_domain_summary.txt

$namespaces:
 edam: http://edamontology.org/
 s: http://schema.org/
$schemas:
 - http://edamontology.org/EDAM_1.16.owl
 - https://schema.org/docs/schema_org_rdfa.html

 s:author:
   - class: s:Person
     s:id: https://orcid.org/0000-0002-2961-9670
     s:email: mrc@commonwl.org
     s:name: Michael R. Crusoe

s:license: "https://www.apache.org/licenses/LICENSE-2.0"
s:copyrightHolder: "EMBL - European Bioinformatics Institute"
