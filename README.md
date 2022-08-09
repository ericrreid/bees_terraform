# Example files to support ABI's BEES effort:
#  Terraform templates, making use of MongoDB Atlas Provider (anywhere from v1.2.0 to v1.4.x) to:
#   - Create backup scheme for existing Cluster
#     - Assumes existing Cluster
#   - Restore existing backup snapshot to a Cluster (overwriting data)
#     - Assumes existing Cluster
#     - Assumes existing Snapshot of that Cluster
#     - Assumes existing Target Cluster
#
#  eric.reid@mongodb.com
#  https://github.com/ericrreid/abi_bees
#
#  Note: all code is provided with the understanding that it is:
#  - Not production-ready
#  - Not fully tested in customer target environments
#  - Not supported by MongoDB, Inc. in any fashion
