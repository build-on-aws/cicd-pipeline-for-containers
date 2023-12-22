# CICD Pipeline for Containers on AWS
This code repository is part of the Amazon EKS Cluster Setup tutorial: "Building a CI/CD Pipeline for Amazon EKS Workloads with Native AWS Services". It includes a sample application, a dockerfile, configuration files for AWS CodeBuild and AWS CodePipeline, and [Hashicorp Terraform](https://www.terraform.io/) Infrastructure as Code to set up the CI/CD pipeline.

## About 

This repository is dedicated to setting up an end-to-end CI/CD pipeline for hosting and testing application code, building a container image from the code, pushing and storing the container image to [Elastic Container Registry](https://aws.amazon.com/ecr/), and deploying this container on EKS as a deployment. It includes the following components:

![GitHub Image](/images/orverview.png)

* **Preparing the dedicated VPC for the cluster**: As a basis, we created a dedicated [Amazon VPC](https://docs.aws.amazon.com/vpc/latest/userguide/what-is-amazon-vpc.html) to host the EKS cluster. The VPC uses the CIDR `10.0.0.0/16`, 3 private, and 3 public subnets. We create also an [Internet Gateway](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Internet_Gateway.html) and a [NAT Gateway](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-nat-gateway.html). You can find the VPC configuration in the [ekc_cluster.tf file](https://github.com/build-on-aws/cicd-pipeline-for-containers/blob/66044ac88b76edd0ca9fbf74de902836751956c4/eks_cluster.tf#L12).
* **Creating the EKS Cluster**: We built an [EKS Cluster](https://github.com/build-on-aws/cicd-pipeline-for-containers/blob/66044ac88b76edd0ca9fbf74de902836751956c4/eks_cluster.tf#L39) with a managed node group with a minimum size 1 and maximum size 5, and one instance type of `t3.small`. 
* **Storing the Application Code to AWS CodeCommit**: Utilize the [AWS CodeCommit](https://aws.amazon.com/codecommit/) service to create a Git repository for the application code. A new code push on a specific branch of this git repository triggers CodePipeline, initiating the CI/CD flow. We use [AWS EventBridge](https://aws.amazon.com/eventbridge/) and create an event rule that detects new commits to the repository and triggers the pipeline.
* **Testing the Application Code with AWS CodeBuild**: As a second stage of the CI/CD pipeline, we leverage CodeBuild to lint and test our application code. The configurations for linting and testing are provided as YAML files to [AWS CodeBuild](https://aws.amazon.com/codebuild/). CodeBuild expects a [build specification (buildspec) file](https://docs.aws.amazon.com/codebuild/latest/userguide/build-spec-ref.html) with the collection of commands and related sesttings that CodeBuild uses to run a specific stage in the pipeline.
* **Building a Container Image with AWS CodeBuild and storing it in Elastic Container Registry**: As a third stage of the CI/CD pipeline, we build the container image based on the provided Dockerfile and the application source code with CodeBuild. The configuration file for building the Docker container image is proved as YAML file to CodeBuild. After successfully building the container image, we push it on the Elastic Container Registry repository. 
* **Deploying the Container Image on EKS**: Finally, as the last step of the CI/CD pipeline, we trigger an action with CodeBuild to deploy the newly created container image to EKS as a deployment. For this deployment, we use the helm Kubernetes package manager in the CodeBuild environment and provide the YAML deployment charts for our application.

## How to Deploy

1. First, open a terminal and execute the command below to clone the demo code repository locally:

```
git clone https://github.com/build-on-aws/cicd-pipeline-for-containers.git
```

2. Next, navigate to the top directory of the demo code repository:

```
cd cicd-pipeline-for-containers
```

3. Before applying the Terraform manifests, we have to initialize the project. Run the terraform init command, which  performs several different initialization steps in order to prepare the current working directory for use with Terraform:

```
terraform init
```

4. After the successful project initialization, run this command to create the necessary AWS components and infrastructure: 

```
terraform apply
```

## How to Test the CI/CD Pipeline

1. Navigate via the AWS CodeCommit Console to your newly created AWS CodeCommit repository `demo-codecommit-repo` and clone the empty code repository locally.

2. Then copy these 3 directories from the first code repository you cloned to the new one and push the code changes.

```
cp -r cicd-pipeline-for-containers-demo/helm_charts demo-codecommit-repo/helm_charts/ 
cp -r cicd-pipeline-for-containers-demo/pipeline_files demo-codecommit-repo/pipeline_files/
cp -r cicd-pipeline-for-containers-demo/sample-cluster-app demo-codecommit-repo/sample-cluster-app/ 
```

3. Then, navigate to the demo-codecommit-repo directory, add, commit, and push the changes:

```
cd demo-codecommit-repo
git add helm_charts/ pipeline_files/ sample-cluster-app/
git commit -m "Add demo application code, CodeBuild config files, and helm charts"
git push origin main
```

4. After successfully pushing the new code, navigate via the AWS Console to AWS CodePipeline to see it in action. Your new code, should trigger a new release change and kickstart the CI/CD process.

## Clean up

To clean up, run on the initial cloned repository:

```
terraform destroy
```

## Disclaimer

The Sample Cluster Application used for the purposes of this demo was taken from this GitHub Repository: [eks-container-pipeline-cdk-template/sample-cluster-app](https://github.com/aws-samples/eks-container-pipeline-cdk-template/tree/main/sample-cluster-app).

## Security

See [CONTRIBUTING](CONTRIBUTING.md#security-issue-notifications) for more information.

## License

This library is licensed under the MIT-0 License. See the LICENSE file.

