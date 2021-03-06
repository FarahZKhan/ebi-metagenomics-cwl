#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool

requirements:
  InlineJavascriptRequirement: {}
  ResourceRequirement:
    coresMax: 1
    ramMin: 100  # just a default, could be lowered
  SchemaDefRequirement:
    types:
      - $import: biom-convert-table.yaml

hints:
  SoftwareRequirement:
    packages:
      biom-format:
        specs: [ "https://doi.org/10.1186/2047-217X-1-7" ]
        version: [ "2.1.6" ]

inputs:
  biom:
    type: File
    format: edam:format_3746  # BIOM
    inputBinding:
      prefix: --input-fp

  table_type:
    type: biom-convert-table.yaml#table_type?
    inputBinding:
      prefix: --table-type

  json:
    type: boolean?
    label: Output as JSON-formatted table.
    inputBinding:
      prefix: --to-json

  hdf5:
    type: boolean?
    label: Output as HDF5-formatted table.
    inputBinding:
      prefix: --to-hdf5

  tsv:
    type: boolean?
    label: Output as TSV-formatted (classic) table.
    inputBinding:
      prefix: --to-tsv

  header_key:
    type: string?
    doc: |
      The observation metadata to include from the input BIOM table file when
      creating a tsv table file. By default no observation metadata will be
      included.
    inputBinding:
      prefix: --header-key

baseCommand: [ biom, convert ]

arguments:
  - valueFrom: |
     ${ var ext = "";
        if (inputs.json) { ext = ".json"; }
        if (inputs.hdf5) { ext = ".hdf5"; }
        if (inputs.tsv) { ext = ".tsv"; }
        return inputs.biom.nameroot + ext; }
    prefix: --output-fp

outputs:
  result:
    type: File
    outputBinding: { glob: "$(inputs.biom.nameroot)*" }

$namespaces:
 edam: http://edamontology.org/
 s: http://schema.org/
$schemas:
 - http://edamontology.org/EDAM_1.16.owl
 - https://schema.org/docs/schema_org_rdfa.html

s:license: "https://www.apache.org/licenses/LICENSE-2.0"
s:copyrightHolder: "EMBL - European Bioinformatics Institute"
