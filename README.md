# CICD Pipeline for Containers on AWS
This code repository is part of the Amazon EKS Cluster Setup tutorial: "Building a CI/CD Pipeline for Amazon EKS Workloads with Native AWS Services". It includes a sample application, a dockerfile, configuration files for AWS CodeBuild and AWS CodePipeline, and Hashicorp Terraform Infrastructure as Code to set up the CI/CD pipeline.

## About 

This repository is dedicated to setting up an end-to-end CI/CD pipeline for hosting and testing application code, building a container image from the code, pushing and storing the container image to Elastic Container Registry, and deploying this container on EKS as a deployment. It includes the following components:

* Creating the networking layer with a VPC and an EKS cluster to run the sample application. The IAM role for AWS CodeBuild is added to the aws-auth configmap to allow deployment to Amazon EKS.
* AWS CodePipeline is configured to orchestrate the CI/CD flow from a new code commit, to testing, building, and deploying the sample app on EKS.
* An AWS CodeCommit repository is used to store the sample application. A new code push on a specific branch of this git repository triggers AWS CodePipeline, initiating the CI/CD flow. We use AWS EventBridge and create an event rule that detects new commits to the repository and triggers the pipeline.
* As a second stage of the CI/CD pipeline, we leverage AWS CodeBuild to lint and test the sample application code. The configurations for linting and testing are provided as YAML files to AWS CodeBuild.
* As a third stage of the CI/CD pipeline, we build the container image based on the provided Dockerfile and the application source code with AWS CodeBuild. The configuration file for building the Docker container image is proved as YAML file to CodeBuild. After successfully building the container image, we push it on the Elastic Container Registry repository. 
* Finally, as the last step of the CI/CD pipeline, we trigger an action with CodeBuild to deploy the newly created container image to Amazon EKS as a deployment. For this deployment, we use the helm Kuberentes package manager in the CodeBuild environment and provide the YAML deployment charts for our application.


## Disclaimer

The Sample Cluster Application used for the purposes of this demo was taken from this GitHub Repository: [eks-container-pipeline-cdk-template/sample-cluster-app](https://github.com/aws-samples/eks-container-pipeline-cdk-template/tree/main/sample-cluster-app).

## Security

See [CONTRIBUTING](CONTRIBUTING.md#security-issue-notifications) for more information.

## License

This library is licensed under the MIT-0 License. See the LICENSE file.

