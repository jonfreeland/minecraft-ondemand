TASK_ARN=$(aws ecs list-tasks --region us-east-1 --cluster "minecraft" --desired-status "RUNNING" --output text --query 'taskArns[0]')

NETWORK_CONFIG=$(aws ecs describe-services --cluster minecraft --services minecraft-server --query 'services[0].deployments[0].networkConfiguration' --output json | tr -d '\n')

OVERRIDES="{\"containerOverrides\": [{\"name\": \"minecraft-server\", \"command\": [\"sleep\", \"7200\"]}]}"

aws ecs run-task --region us-east-1 --cluster "minecraft" \
    --task-definition "minecraftserverstackTaskDefinitionA2AB0E93:4" \
    --count 1 --enable-execute-command --launch-type FARGATE \
    --network-configuration "${NETWORK_CONFIG}" \
    --overrides "${OVERRIDES}" \
    --started-by $(whoami) --group manual --output text --query 'tasks[0].taskArn'