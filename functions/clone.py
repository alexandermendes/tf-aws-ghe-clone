import os
import hashlib
import hmac
import json
import boto3 # pylint: disable=import-error


def validate_signature(body, sig):
    """Validate a GitHub hash signature.

    https://developer.github.com/webhooks/securing/
    """
    key_bytes = bytes(os.environ['GITHUB_WEBHOOK_SECRET'], 'utf-8')
    hash_msg = hmac.new(key_bytes, body.encode('utf-8'), hashlib.sha1)
    digest = hash_msg.hexdigest()

    return hmac.compare_digest(digest, sig.split('=')[1])


def get_response(statusCode = 200, headers = {}, body = '', isBase64Encoded = False):
    """Get a response for the CloudWatch event with all expected params."""
    return {
      'statusCode': statusCode,
      'headers': headers,
      'body': body,
      'isBase64Encoded': isBase64Encoded,
    }


def clone_and_zip(repository, zip_name):
    """Clone and zip the GitHub repository."""
    tmp_dir = '/tmp'
    clone_url = repository['clone_url']
    full_name = repository['full_name']
    token = os.environ['GITHUB_TOKEN']

    url = clone_url.replace(r'/^https:\/\//', 'https://{0}@'.format(token))

    os.system('rm -rf {0}/*'.format(tmp_dir))
    os.system('cd {0} && git clone --depth 1 {1} {2}'.format(tmp_dir, url, full_name))
    os.system('cd {0} && tar -zcvf {1} {2}'.format(tmp_dir, zip_name, full_name))

    return '{0}/{1}'.format(tmp_dir, zip_name)


def upload_to_s3(zip_path, zip_name):
    """Update a zipped object to S3."""
    s3 = boto3.client('s3')
    s3.upload_file(zip_path, os.environ['S3_BUCKET'], zip_name)


def handler(event, context):
    """Run the Lambda function."""
    if (
      'headers' not in event
      or 'GitHub-Hookshot' not in event['headers']['User-Agent']
      or not validate_signature(event['body'], event['headers']['X-Hub-Signature'])
    ):
      return get_response(statusCode = 403, body = 'Invalid token')

    repository = json.loads(event['body'])['repository']
    zip_name = "{0}.tar.gz".format(repository['full_name'])

    zip_path = clone_and_zip(repository, zip_name)

    upload_to_s3(zip_path, zip_name)

    return get_response(body = '{} created'.format(zip_name))
