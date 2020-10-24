#!/bin/bash

#Find the script file parent directory (project home)
pushd . > /dev/null
SCRIPT_DIRECTORY="${BASH_SOURCE[0]}"
while([ -h "${SCRIPT_DIRECTORY}" ])
do
  cd "$(dirname "${SCRIPT_DIRECTORY}")"
  SCRIPT_DIRECTORY="$(readlink "$(basename "${SCRIPT_DIRECTORY}")")"
done
cd "$(dirname "${SCRIPT_DIRECTORY}")" > /dev/null
SCRIPT_DIRECTORY="$(pwd)"
popd  > /dev/null
APP_HOME="$(dirname "${SCRIPT_DIRECTORY}")"


num_of_arg=$#


if [ ${num_of_arg} -eq 0 ]
then
  echo "At least one argument required. Following are the expected arguments:-"
  echo "1. 'nlp' - complete all the NLP operations and save the annotations."
  echo "2. 'train' - training process of all the 7 models required or a single Neural Network."
  echo "3. 'test' - test the empirical accuracy of the system to predict 'coarse:fine' class"
  echo "4. 'api' - runs a server providing HTTP REST API for real-time question classification"
else
  if [ ${1} == "nlp" ]
  then
    # start the python process
    python -m qc.nlp "${APP_HOME}"
  elif [ ${1} == "train" ]
  then
    if [ ${num_of_arg} -eq 2 ]
    then
      # start the python process
      python -m qc.ml "train" "${2}" "${APP_HOME}"
    else
      echo "Command 'train' expects one argument. Model: The class of model. e.g 'train linear_svm' or 'train lr'"
    fi
  elif [ ${1} == "test" ]
  then
    if [ ${num_of_arg} -eq 2 ]
    then
      # start the python process
      python -m qc.ml "test" "${2}" "${APP_HOME}"
    else
      echo "Command 'test' expects one argument. Model: The class of model. e.g 'test linear_svm' or 'test lr'"
    fi
  elif [ ${1} == "api" ]
  then
    if [ ${num_of_arg} -eq 2 ]
    then
      # start the python process
      python -m qc.ml "api" "${2}" "${APP_HOME}"
    else
      echo "Command 'api' expects one argument. Model: The class of model. e.g 'api linear_svm' or 'api lr'"
    fi
  else
    echo "Invalid first argument. ${1} as first argument is unexpected."
  fi
fi
