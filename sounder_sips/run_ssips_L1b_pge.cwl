#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool

requirements:
  InlineJavascriptRequirement: {}
  InitialWorkDirRequirement:
    listing:
      #- $(inputs.input_dir)
      #- $(inputs.static_dir)
      - entryname: my_script.sh
        entry: |-
          export input_dir=$3
          export output_dir=$6
          export static_dir=$9
          echo "Input Directory:"
          ls -l $input_dir
          echo "Static Directory:"
          ls -l $static_dir
          echo "Output Directory:"
          mkdir -p $output_dir
          ls -l $output_dir

          papermill /pge/interface/run_l1b_pge.ipynb -p input_path $input_dir -p output_path $output_dir -p data_static_path $static_dir -
          echo "Output Directory:"
          ls -lR $output_dir
          echo "Input Directory:"
          ls -l $input_dir

hints:
  DockerRequirement:
    # dockerPull: unity-sds/sounder_sips_l1b_pge:r0.4.0
    dockerPull: lucacinquini/sounder_sips_l1b_pge:r0.4.0
  EnvVarRequirement:
      envDef:
        SIPS_STATIC_DIR: $(inputs.static_dir.path)

#baseCommand: ["sh", "my_script.sh"]
baseCommand: ["papermill", "/pge/interface/run_l1b_pge.ipynb"]
arguments: [
  "$(runtime.outdir)/processed_notebook.ipynb",
  "-p",
  "input_path",
  "$(inputs.input_dir)",
  "-p",
  "output_path",
  "$(runtime.outdir)/out",
  "-p",
  "data_static_path",
  "$(inputs.static_dir)"
]


inputs:
  input_dir:
    type: Directory
  static_dir:
    type: Directory

outputs:
  output_dir:
    type: Directory
    outputBinding:
      glob: "out"
  stdout_file:
    type: stdout
  stderr_file:
    type: stderr

stdout: run_ssips_l1b_pge_stdout.txt
stderr: run_ssips_l1b_pge_stderr.txt
