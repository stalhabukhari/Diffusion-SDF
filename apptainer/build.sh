#!/bin/bash
apptainer build -B $(dirname $(pwd)):/code-dir diffusionsdf.sif ApptainerFile
