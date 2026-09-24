# Terraform Practice

Infrastructure as code with Terraform and AWS. This repository is a working log of my Terraform learning path, organised as progressive, self-contained exercises.

Each numbered folder is an independent Terraform configuration with its own state. Work through them in order, or run any one on its own.

---

## Prerequisites

| Requirement | Notes |
|---|---|
| [Terraform CLI](https://developer.hashicorp.com/terraform/install) | v1.16 or later |
| [AWS CLI v2](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) | Optional, but useful for verifying credentials |
| An AWS account | Free tier is sufficient for every exercise here |
| IAM user with programmatic access | Least privilege where possible, never the root account |

### Configuring credentials

Terraform reads the standard AWS credentials files. It does not need the AWS CLI installed, but the files must exist.

`~/.aws/credentials` (`%USERPROFILE%\.aws\credentials` on Windows):

```ini
[default]
aws_access_key_id = YOUR_ACCESS_KEY_ID
aws_secret_access_key = YOUR_SECRET_ACCESS_KEY
```

`~/.aws/config`:

```ini
[default]
region = us-east-1
output = json
```

Confirm it works before running Terraform:

```bash
aws sts get-caller-identity
```

**Credentials never belong in this repository.** No `.tf` file here contains an access key, and none ever should.

---

## Repository structure

```
Terraform_Practice/
├── .gitignore
├── README.md
└── 000_getting_started/
    ├── main.tf
    └── .terraform.lock.hcl
```

---

## Exercises

| Folder | Topic | What it builds |
|---|---|---|
| `000_getting_started` | Providers, resources, data sources, outputs, remote modules | An EC2 instance with a dynamically resolved Amazon Linux AMI, plus a multi-AZ VPC using the `terraform-aws-modules/vpc/aws` module |

*New exercises are appended here as they are completed.*

---

## Running an exercise

From inside the exercise folder:

```bash
terraform init      # download providers and modules, once per folder
terraform validate  # check syntax, no API calls
terraform plan      # show what would change, creates nothing
terraform apply      # create the infrastructure
terraform destroy    # tear it all down
```

To review and apply exactly the same plan:

```bash
terraform plan -out=tfplan
terraform apply tfplan
```

---

## Cost and safety notes

Most exercises stay inside the AWS free tier, but some do not. Read the plan output before applying.

**Resources that cost money regardless of free tier:**

| Resource | Approximate cost | Notes |
|---|---|---|
| NAT Gateway | ~0.045 USD/hour, ~35 USD/month each | The VPC module creates one per AZ by default. Set `single_nat_gateway = true`, or `enable_nat_gateway = false` for pure learning |
| VPN Gateway | ~0.05 USD/hour, ~36 USD/month | Billed even with nothing attached |
| Elastic IP | ~0.005 USD/hour | Billed whether attached or not |

**Habits that prevent surprise bills:**

- Run `terraform destroy` at the end of every session.
- Set a monthly budget alert in the AWS Billing console. 5 USD with an email alert at 80 percent is enough to catch anything unexpected.
- After a destroy, verify nothing was orphaned:

```bash
aws ec2 describe-addresses --output table
aws ec2 describe-nat-gateways --filter "Name=state,Values=available" --output table
```

---

## What is not tracked

`.gitignore` excludes everything that either leaks data or bloats the repository:

| Pattern | Reason |
|---|---|
| `*.tfstate`, `*.tfstate.*` | Plain-text JSON containing every resource attribute, including secrets |
| `*.tfvars` | Commonly holds credentials and environment-specific values |
| `.terraform/` | Downloaded provider binaries, hundreds of MB, and over GitHub's 100 MB file limit |
| `tfplan`, `*.tfplan` | Binary plan files with fully resolved values |

`.terraform.lock.hcl` **is** tracked, deliberately. It pins provider versions so anyone cloning this repository resolves the same dependencies.

---

## Status

Active. This repository grows as I work through Terraform and AWS. Exercises, structure and notes will change.
