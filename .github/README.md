# AWS Advanced Network Specialty Repository

Repository to store terraform code used while studying for the ANS-C01 exam. I am using Adrian Cantrill's [AWS Certified Advanced Networking - Specialty](https://learn.cantrill.io/p/aws-certified-advanced-networking-specialty) course to study for the exam. The course does provide CloudFormation stacks for a number of the demos, but I thought it would be ~~fun~~ challenging to recreate ~~all~~ some of the CloudFormation stacks with terraform code.

[![OpenSSF Scorecard](https://api.scorecard.dev/projects/github.com/3ware/aws-network-speciality/badge)](https://scorecard.dev/viewer/?uri=github.com/3ware/aws-network-speciality) [![semantic-release: conventionalcommits](https://img.shields.io/badge/semantic--release-conventionalcommits-blue?logo=semantic-release)](https://github.com/semantic-release/semantic-release) [![GitHub release](https://img.shields.io/github/release/3ware/aws-network-speciality?include_prereleases=&sort=semver&color=yellow)](https://github.com/3ware/workflows/aws-network-speciality/) [![issues - workflows](https://img.shields.io/github/issues/3ware/aws-network-speciality)](https://github.com/3ware/aws-network-speciality/issues) [![infracost](https://img.shields.io/endpoint?url=https://dashboard.api.infracost.io/shields/json/ee68bc5e-0846-48a1-9604-f0b69656619d/repos/6ed3ecbf-a95a-4051-a22a-85d43185ae51/branch/aa09234f-aace-4239-9083-5f38ebb6e5f2)](https://dashboard.infracost.io/org/3ware-lxub1/repos/6ed3ecbf-a95a-4051-a22a-85d43185ae51?tab=settings) [![CI](https://img.shields.io/github/actions/workflow/status/3ware/aws-network-speciality/tofu-ci.yaml?label=CI&logo=githubactions&logoColor=white)](https://github.com/3ware/workflows/actions/aws-network-speciality/tofu-ci.yaml)

## Demos

- :white_check_mark: VPC Deep Dive :rocket:
- :white_check_mark: CloudTrail :rocket:
- :white_check_mark: CloudFront - but see open [issue](https://github.com/3ware/aws-network-speciality/issues/8)
- :white_check_mark: VPC Peering :rocket:

## Workflow

We use [trunk.io's](https://trunk.io) code quality function for formatting and linting. Trunk git hooks run pre-commit and pre-push. The Github App is integrated into the repository to run trunk in pull requests. Because OpenTofu and tflint, with the AWS plugin and deep checking, are enabled, some additional setup for trunk is required. This is done using a GitHub composite action stored in the [.trunk/setup-ci](.trunk/setup-ci) folder described in [trunk's CI custom setup logic documentation](https://docs.trunk.io/code-quality/setup-and-installation/github-integration#optional-custom-setup-logic).

This action runs a series of steps to find terraform changes in the dev environment, login to the AWS dev environment, using the GitHub OIDC provider, and store the credentials as environment variables. Subsequent steps, install tflint and OpenTofu and then `init` both those tools in the directories discovered in the first step. The AWS environment variable credentials are passed into trunk's environment via the tflint definition to allow the tflint AWS plugin to perform [deep checking](https://github.com/terraform-linters/tflint-ruleset-aws/blob/master/docs/deep_checking.md). The AWS plugin is kept up to date by [renovate bot](https://docs.renovatebot.com/modules/manager/tflint-plugin/).

> [!NOTE]
> To keep things simple, tflint deep checking will only work in the dev environment currently because the setup action is configured with the AWS dev account role. A nested action could be used in the future for other accounts.
