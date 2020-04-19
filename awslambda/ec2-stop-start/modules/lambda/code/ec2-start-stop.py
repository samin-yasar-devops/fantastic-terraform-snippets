import json
import boto3

region = 'ap-southeast-1'
ec2 = boto3.resource('ec2', region_name=region)

def list_instances():
    instances = {}
    try:
        for instance in ec2.instances.all():
            tags = [i for i in instance.tags if i.get('Value') == 'Cron']
            instances[instance.id] = {
                "type": instance.instance_type,
                "state": instance.state.get('Name'),
            }
        return instances
    except Exception as e:
        return {"error": str(e)}

def start_instance(id):
    ec2_client = boto3.client('ec2')
    try:
        response = ec2_client.start_instances(InstanceIds=[id], DryRun=False)
        return response
    except Exception as e:
        return {"error": str(e)}

def stop_instance(id):
    ec2_client = boto3.client('ec2')
    try:
        response = ec2_client.stop_instances(InstanceIds=[id], DryRun=False)
        return response
    except Exception as e:
        return {"error": str(e)}

# Lambda Handler

def lambda_handler(event, context):
    query = event["queryStringParameters"]
    action = query.get('action', None)
    instance_id = query.get('id', None)
    response_body = ""

    if action == "list":
        response_body = list_instances()
    elif action == "start" and instance_id:
        response_body = start_instance(instance_id)
    elif action == "stop" and instance_id:
        response_body = stop_instance(instance_id)
    else:
        response_body = {"error": "Invalid or missing parameters"}

    return {
        'statusCode': 200 if "error" not in response_body else 400,
        'body': json.dumps(response_body),
        'headers': { 'Content-Type': "application/json" }
    }
