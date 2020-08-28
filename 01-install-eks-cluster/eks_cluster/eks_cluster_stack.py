from aws_cdk import (
    core,
    aws_iam as iam,
    aws_ec2 as ec2,
    aws_eks as eks,
)

from eks_cluster.load_config_files import read_k8s_resource, read_docker_daemon_resource
from env import get_eks_admin_iam_username

class EksClusterStack(core.Stack):

    def __init__(self, scope: core.Construct, name: str, vpc: ec2.IVpc, **kwargs) -> None:
        super().__init__(scope, name, **kwargs)

        cluster = eks.Cluster(
            self, 'isito-eks-control-plane',
            name="istio-eks",
            vpc=vpc,
            default_capacity=0
        )

        asg_worker_nodes = cluster.add_capacity(
            'worker-node',
            instance_type=ec2.InstanceType('t3.medium'),
            desired_capacity=2,
        )

        eks_master_role = iam.Role(
            self, 'AdminRole',
            assumed_by=iam.ArnPrincipal(get_eks_admin_iam_username())
        )

        cluster.aws_auth.add_masters_role(eks_master_role)

        helm_tiller_rbac = eks.KubernetesResource(
            self, 'helm-tiller-rbac',
            cluster=cluster,
            manifest=read_k8s_resource('kubernetes_resources/helm-tiller-rbac.yaml')
        )
