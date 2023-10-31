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

## Running the Project

(TODO)