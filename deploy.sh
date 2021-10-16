docker build -t duclu/multi-client:latest -t duclu/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t duclu/multi-server:latest -t duclu/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t duclu/multi-worker:latest -t duclu/multi-worker:$SHA -f ./worker/Dockerfile ./worker
  # Logged in to the docker CLI from travis
  # Take those images and push them to docker hub
docker push duclu/multi-client:latest
docker push duclu/multi-server:latest
docker push duclu/multi-worker:latest

docker push duclu/multi-client:$SHA
docker push duclu/multi-server:$SHA
docker push duclu/multi-worker:$SHA

kubectl apply -f k8s
kubectl set image deployments/server-deployment server=duclu/multi-server:$SHA
kubectl set image deployments/client-deployment client=duclu/multi-client:$SHA
kubectl set image deployments/worker-deployment worker=duclu/multi-worker:$SHA