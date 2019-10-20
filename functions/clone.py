import json

def validate_signature(body, sig):
    """Validate a GitHub hash signature.

    https://developer.github.com/webhooks/securing/
    """

def get_response(statusCode = 500, headers = {}, body = '', isBase64Encoded = False):
    """Get a response for the CloudWatch event with all expected params."""
    return {
      'statusCode': statusCode,
      'headers': headers,
      'body': body,
      'isBase64Encoded': isBase64Encoded,
    }

def handler(event, context):
    """Run the Lambda function."""
    headers = event['headers']
    body = event['body']
    repository = json.load(event['repository'])
    zip_name = "{0}.tar.gz".format(repository['full_name'])

    if (
      'headers' not in event
      or 'GitHub-Hookshot' not in event['headers']['User-Agent']
      or not validate_signature(body, event['headers']['X-Hub-Signature'])
    ):
      return get_response(statusCode = 403, body = 'Invalid token')
