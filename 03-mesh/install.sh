kubectl apply -f namespace.yaml

kubectl apply -f mesh.yaml

kubectl describe mesh my-mesh

aws appmesh describe-mesh --mesh-name my-mesh

kubectl apply -f virtual-node.yaml

kubectl describe virtualnode my-service-a -n my-apps

aws appmesh describe-virtual-node --mesh-name my-mesh --virtual-node-name my-service-a_my-apps

kubectl apply -f virtual-router.yaml

kubectl describe virtualrouter my-service-a-virtual-router -n my-apps

kubectl describe virtualrouter my-service-a-virtual-router -n my-apps

aws appmesh describe-virtual-router --virtual-router-name my-service-a-virtual-router_my-apps --mesh-name my-mesh

aws appmesh describe-route \
    --route-name my-service-a-route \
    --virtual-router-name my-service-a-virtual-router_my-apps \
    --mesh-name my-mesh
    
kubectl apply -f virtual-service.yaml

kubectl describe virtualservice my-service-a -n my-apps

aws appmesh describe-virtual-service --virtual-service-name my-service-a.my-apps.svc.cluster.local --mesh-name my-mesh

aws iam create-policy --policy-name my-policy --policy-document file://proxy-auth.json
