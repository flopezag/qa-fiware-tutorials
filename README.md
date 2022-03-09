# <a name="top"></a>FIWARE BDD Step by Step Tutorials
[![License badge](https://img.shields.io/badge/license-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

This script has been developed to test the correct behaviour of the FIWARE Generic Enablers
based on the information that we have from the Step by Step tutorials. Besides, it helps us
to check if the proper information of the tutorials are correct based on the last version of
the FIWARE Generic Enablers.

This script is based on the python implementation of Behave. For more details about it, you
can take a look to this [Behave tutorial](https://jenisys.github.io/behave.example/)

[Top](#top)

## Install

### Requirements

The following software must be installed:

- Python 3.9
- pip
- virtualenv

## Structure of the Project

The structure of the project is very easy. you can take a look on the following schematic
representation of it.

```bash
[project root directory]
|-- features
|   |-- environment.py
|   |-- *.feature
|   |-- data
|       |-- 101.Getting_started
|       |-- 102.Entity_Relationships
|   `-- steps
|       `-- *_steps.py
`-- [behave.ini]
```

The description of the content is the following:
- `environment.py`, contain all the pre and post operations to be executed for each feature.
  It means, the download of the configuration files of the tutorial and the execution of the
  docker-compose.
- `*.feature`, the description file of the BDD to be developed using the Gherkin language. There
  will be one file for each of the corresponding Step by Step tutorials, both NGSIv2 and NGSI-LD.
- `data`, this folder will contains all the data required to the execution of the corresponding
  requests and the associate responses obtained from it. To facilitate the comprehensive of all
  the data, it is classified in subfolders for each of the Step by Step tutorials.
- `steps`, this folder contains the implementation of the steps. Keep in mind that it is possible
  that some of the steps are defined in previous steps implementation files.

Therefore, if you want to increase the tutorial with a new feature (new analysis of a Step by Step
tutorial), you only need to specify the corresponding *.feature, *_steps.py, and the corresponding
json data for the different requests and responses. Just create a new branch from develop with the
name of the new tutorial, e.g.

```bash
git checkout develop
git checkout -b 102.Entity_Relationships
```

After finish the creation of it, just create a PR to the develop branch.

## Description of the feature file

All the *.feature files must start with the same information:

```bash
Feature: test tutorial 101.Getting Started

  This is the feature file of the FIWARE Step by Step tutorial for NGSI-v2
  url: [url of the Step by Step tutorial]
  docker-compose: [url of the raw data of the docker-compose file used in this tutorial]
  environment: [url of the raw data of the environment configuration of the docker compose]
```

> Note: In the next tutorials will be needed also to include the `init-script` to localize the
> proper bash script to initialize the data and `aux`, and array of script files used during the
> execution of the init-script. To be implemented...


### Steps

The recommended installation method is using a virtualenv. Actually, the installation
process is only about the python dependencies, because the python code do not need
installation.

1. Clone this repository.
2. Create the virtualenv: `virtualenv -ppython3.9 venv`
3. Activate the python environment: `source ./venv/bin/activate`
5. Install the requirements: `pip install -r requirements.txt

[Top](#top)

## Execution

To execute behave, just go into the root folder of the repository and execute the following
command:

```bash
behave
```

It will execute all the features defined in the folder `features`. If you want to execute only
one of the features, you only need to specify which one to execute, for example:

```bash
behave features/102.Entity_Relationships.feature
```

will execute just the steps corresponding to the Tutorial 102 feature.

[Top](#top)


## License

This script is licensed under Apache License 2.0.
