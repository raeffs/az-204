
kubectl apply -f app.yml
kubectl apply -f service.yml

kubectl get service nginx-service --watch

kubectl delete services nginx-service
kubectl delete deployment nginx-deployment
