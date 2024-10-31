@echo off

set root=C:\Anaconda3
set env_root=%root%/envs
set env_name=maskless
set version=3.7

set swig_path=sm9_controller_swig
set interface_file=SM9_Controller.i

call %root%/Scripts/activate.bat
@REM call conda update -n base -c defaults conda -y

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
	call pip install mypy
	call pip install pycodestyle
	call pip install black

	if not exist %precommit_config% (
		call pre-commit sample-config > %precommit_config%
	)

)

call conda activate %env_name%
call cd %swig_path%
call swig -python -c++ %interface_file%
call python setup.py build_ext --inplace
