# terraformDeployTest

This repository contains the code for a microservice written in Go and the Terraform configuration files required to deploy it on an Azure Kubernetes Service (AKS) cluster.

## Project Structure

The project is organized into the following directories:

- **microservice**: This directory contains the Go code for the microservice and the Dockerfile required to build the container image for deploying the microservice. It should be noted that the service contains CRUD endpoints for the "User" entity, and the operations are purely exemplifying and mocked (not actually writing to a database).

- **postman**: This directory contains the Postman collection that allows for executing HTTP requests to test the deployed microservice.

- **cluster**: This directory contains the Terraform configuration file that allows for setting up the AKS cluster.

- **deployment**: This directory contains the Terraform configuration files required to deploy a pod containing the microservice and a service connected to it to expose it to the internal network of the cluster.

- **ingress**: This directory contains the Terraform configuration files required to set up the ingress controller and define the ingress rules for the microservice's endpoint routes.

## Project Overview

As anticipated, this repository contains Terraform configuration files useful for deploying a small, mock-up microservice.
The deployment takes place on an AKS cluster; unfortunately, the project is limited in some respects due to the restrictions imposed by Azure's free tier.

The cluster consists of a single node based on a "standard_d2_v2" machine, normally a Kubernetes cluster consists of at least 3 nodes, in this case it was necessary to limit it to 1 in order not to consume too many resources.
The pod is also deployed as a single replica and without an autoscaler.

The microservice (developed in Golang) is containerised with Docker (via a Dockerfile), tagged and pushed up to Docker Hub at the link https://hub.docker.com/repository/docker/antoniocapizzi95/terraform-deploy-test . It was decided not to use Azure's Container Registry to avoid consuming other resources available in the Free tier.

For simplicity in this project, both the pod and the Ingress have been placed in the 'default' namespace.

## Running the Project

Before starting the deployment process, make sure you have the Azure CLI installed locally and have logged in to your Azure account using the `az login` command.

### Cluster Deployment

1. Navigate to the `cluster` folder in the repository and run the following commands:

   ```
   terraform init
   terraform apply
   ```

   Optionally, you can execute `terraform plan` before applying the changes to verify the resources that will be added/modified.

2. Once the cluster is up and running, execute the following commands to download the cluster references and access keys to your local `~/.kube/config` folder:

   ```
   az account set --subscription <cluster-id>
   az aks get-credentials --resource-group testK8sGroup --name test-k8s-cluster
   ```

### Deploying the Microservice

1. Navigate to the `deployment` folder in the repository and run the following commands:

   ```
   terraform init
   terraform apply
   ```

   This will execute the deployment of the pod containing the microservice and the associated service.

### Ingress Configuration

1. Navigate to the `ingress` folder and run the following commands:

   ```
   terraform init
   terraform apply
   ```

2. Retrieve the external IP address of `nginx-ingress-controller` by executing the command:

   ```
   kubectl get svc -n default
   ```
The output will be something like this:

    NAME                                       TYPE           CLUSTER-IP     EXTERNAL-IP     PORT(S)                      AGE
    kubernetes                                 ClusterIP      10.0.0.1       <none>          443/TCP                      43h
    microservice1-service                      ClusterIP      10.0.82.252    <none>          8080/TCP                     43h
    nginx-ingress-controller                   LoadBalancer   10.0.180.3     20.105.x.x   80:31374/TCP,443:32080/TCP   43h
    nginx-ingress-controller-default-backend   ClusterIP      10.0.142.162   <none>          80/TCP                       43h
    
   
   This IP address (in this example `20.105.x.x`) will be used to access the microservice API. You can use it in Postman by importing the provided collection located in the `postman` folder.

Now, you should be able to access the microservice APIs using the obtained public IP address.