@echo off

set root=C:\Anaconda3
set env_root=%root%/envs
set env_name=maksless
set version=3.7
set precommit_config=.pre-commit-config.yaml

start chrome "%~dp0htmlcov/index.html"

call %root%/Scripts/activate.bat

if exist %env_root%/%env_name% (
	echo Find conda environment ::: %env_name%
) else (
	echo Cannot find environment ::: %env_name%
	echo Make environment ::: %env_name%
	call conda create -n %env_name% python=%version% -y
	call conda activate %env_name%
	call pip install tox
	call pip install pre-commit
	call pip install mypy
	call pip install pycodestyle
	call pip install black

	if not exist %precommit_config% (
		call pre-commit sample-config > %precommit_config%
	)

)

call conda activate %env_name%
call code .
call pre-commit autoupdate
call pre-commit install
call tox
