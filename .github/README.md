# AWS Advanced Network Specialty Repository

Repository to store terraform code used while studying for the ANS-C01 exam. I am using Adrian Cantrill's [AWS Certified Advanced Networking - Specialty](https://learn.cantrill.io/p/aws-certified-advanced-networking-specialty) course to study for the exam. The course does provide CloudFormation stacks for a number of the demos, but I thought it would be ~~fun~~ challenging to recreate ~~all~~ some of the CloudFormation stacks with terraform code.

[![OpenSSF Scorecard](https://api.scorecard.dev/projects/github.com/3ware/aws-network-speciality/badge)](https://scorecard.dev/viewer/?uri=github.com/3ware/aws-network-speciality) [![semantic-release: conventionalcommits](https://img.shields.io/badge/semantic--release-conventionalcommits-blue?logo=semantic-release)](https://github.com/semantic-release/semantic-release) [![GitHub release](https://img.shields.io/github/release/3ware/aws-network-speciality?include_prereleases=&sort=semver&color=yellow)](https://github.com/3ware/workflows/aws-network-speciality/) [![issues - workflows](https://img.shields.io/github/issues/3ware/aws-network-speciality)](https://github.com/3ware/aws-network-speciality/issues) [![infracost](https://img.shields.io/endpoint?url=https://dashboard.api.infracost.io/shields/json/ee68bc5e-0846-48a1-9604-f0b69656619d/repos/6ed3ecbf-a95a-4051-a22a-85d43185ae51/branch/aa09234f-aace-4239-9083-5f38ebb6e5f2)](https://dashboard.infracost.io/org/3ware-lxub1/repos/6ed3ecbf-a95a-4051-a22a-85d43185ae51?tab=settings) [![CI](https://img.shields.io/github/actions/workflow/status/3ware/aws-network-speciality/wait-for-checks.yaml?label=CI&logo=githubactions&logoColor=white)](https://github.com/3ware/workflows/actions/aws-network-speciality/wait-for-checks.yaml)

## Demos

- :white_check_mark: VPC Deep Dive :rocket:
- :white_check_mark: CloudTrail :rocket:
- :white_check_mark: CloudFront - but see open [issue](https://github.com/3ware/aws-network-speciality/issues/8)
- :white_check_mark: VPC Peering :rocket:

## Workflow - this section is WIP

### Linting

We use [trunk.io's](https://trunk.io) code quality function for formatting and linting. Trunk git hooks run pre-commit and pre-push.

### Pipeline

~~#### Find TF files~~

~~The first job of the [tofu-ci](.workflows/tofu-ci.yaml) workflow is to look for tf and tfvars files that have changed in the dev folder. The output from this job is used to define the matrix strategy for remaining jobs. A matrix strategy is used in case tf files have changed in different directories. Each job will run in a separate directory for `init`, `plan` and `apply`.~~

#### Trunk Check TF

Trunk linting also runs in CI. [Trunk's GitHub Integration](https://docs.trunk.io/code-quality/setup-and-installation/github-integration) is not used because a composite action is required to customise the setup and perform tasks like downloading plugins for TFLint and initialising the working directory. Composite actions do not support secrets or token permissions. Both are required in the pipeline for [TFLint AWS deep checking](https://github.com/terraform-linters/tflint-ruleset-aws/blob/master/docs/deep_checking.md). Instead, [trunk's GitHub Action](https://github.com/trunk-io/trunk-action) has been used as the last step of this job after the initialisation of tofu and TFLint, and downloading the TFLint AWS plugin.

This job only runs on pull requests prior to running a plan.

#### Plan and Apply
