@echo off

set root=C:\ProgramData\Anaconda3
set env_root=%root%/envs
set env_name=maskless
set version=3.7
set precommit_config=.pre-commit-config.yaml

call %root%/Scripts/activate.bat

if exist %env_root%/%env_name% (
	echo Find conda environment ::: %env_name%
) else (
	echo Cannot find environment ::: %env_name%
	echo Make environment ::: %env_name%
	call conda create -n %env_name% python=%version% -y
	call conda activate %env_name%
    call conda install swig -y
	call pip install tox
	call pip install pre-commit

	if not exist %precommit_config% (
		call pre-commit sample-config > %precommit_config%
	)

)

call conda activate %env_name%
call tox -e %env_name%
