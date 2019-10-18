import os
import json
import urllib
import urllib.request
import urllib.parse
import base64


def get_basic_auth():
    """Get GitHub basic auth header value."""
    github_username = os.environ["GITHUB_USERNAME"].strip()
    github_token = os.environ["GITHUB_TOKEN"].strip()
    auth = base64.b64encode(f'{github_username}:{github_token}'.encode('utf-8')).decode('utf-8')
    return f"Basic {auth}"


def get_headers():
    """Get headers for making requests to the GitHub API."""
    return {
        'Content-Type': 'application/json',
        'Authorization': get_basic_auth()
    }


def post(url, data):
    """POST some JSON data."""
    payload = json.dumps(data).encode("utf-8")
    req = urllib.request.Request(
        url,
        data=payload,
        headers=get_headers()
    )
    urllib.request.urlopen(req)


def create_webhooks():
    """Create the webhooks."""
    data = {
        'name': 'web',
        'events': [
            'push'
        ],
        'active': True,
        'config': {
        'content_type': 'json',
        'url': os.environ['WEBHOOK_URL'],
        'secret': os.environ['WEBHOOK_SECRET'],
        },
    }

    repos = json.loads(os.environ['REPOSITORIES'] or '{}')
    api_url = os.environ['GITHUB_API_URL']

    for repo in repos:
        endpoint = 'repos/{0}/{1}/hooks'.format(repo['owner'], repo['name'])
        url = urllib.parse.urljoin(api_url, endpoint)
        try:
            post(url, data)
        except urllib.error.HTTPError as err:
            # 422 will be returned if webhook already created
            if err.code != 422:
                raise


def handler(event, context):
    """Run the Lambda function."""
    create_webhooks()
