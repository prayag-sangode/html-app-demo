version: 0.2

env:
  variables:
    AWS_REGION: us-east-1
    ECR_REGISTRY: 058264559032.dkr.ecr.us-east-1.amazonaws.com
    IMAGE_NAME: my-html-app
    APP_NAME: my-html-app
    CLUSTER_NAME: my-cluster
    BUILD_NUMBER: ${CODEBUILD_BUILD_ID}  # Use build ID as image tag

phases:
  install:
    commands:
      - echo Logging in to Amazon ECR...
      - aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_REGISTRY

  pre_build:
    commands:
      - echo "Build Number is ${BUILD_NUMBER}"
      - echo "Building the Docker image..."
      - docker build -t $IMAGE_NAME:$BUILD_NUMBER -t $IMAGE_NAME:latest .
      - echo Tagging the Docker image...
      - docker tag $IMAGE_NAME:$BUILD_NUMBER $ECR_REGISTRY/$IMAGE_NAME:$BUILD_NUMBER
      - docker tag $IMAGE_NAME:latest $ECR_REGISTRY/$IMAGE_NAME:latest
      - echo Updating deployment.yaml...
      - sed -i "s|{{IMAGE}}|${ECR_REGISTRY}/${IMAGE_NAME}:${BUILD_NUMBER}|g" deployment.yaml
      - sed -i "s|{{APP_NAME}}|${APP_NAME}|g" deployment.yaml

  build:
    commands:
      - echo Pushing the Docker image to Amazon ECR...
      - docker push $ECR_REGISTRY/$IMAGE_NAME:$BUILD_NUMBER
      - docker push $ECR_REGISTRY/$IMAGE_NAME:latest

  post_build:
    commands:
      - echo Updating kubeconfig for EKS cluster...
      - aws eks update-kubeconfig --name $CLUSTER_NAME --region $AWS_REGION
      - echo Checking nodes in EKS cluster...
      - kubectl get nodes
      - echo Applying deployment.yaml to EKS...
      - kubectl apply -f deployment.yaml

artifacts:
  files:
    - deployment.yaml
