# Example files to support ABI's BEES effort
Terraform templates, making use of MongoDB Atlas Provider v1.4.latest to:
  - Create Project, given Organization
  - Create two Cluster in that Project (source and target clusters) - note: does not load data into source cluster
  - Create backup scheme for source Cluster
  - Create ad hoc snapshot on source Cluster
  - Restore existing backup snapshot to target Cluster (overwriting data)

Note: Cluster creation logic is also included in main.tf (for source and target clusters), and would likely be something different in actual production code
Note: API Key must already exist AND have an API Access List with the desired IP Address or CIDR

Author: eric.reid@mongodb.com
Repo: https://github.com/ericrreid/bees_terraform

Note: all code is provided with the understanding that it is:
  - Not production-ready
  - Not fully tested in customer target environments
  - Not supported by MongoDB, Inc. in any fashion