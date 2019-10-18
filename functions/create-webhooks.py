import os
import re
import json
import urllib
import urllib.request
import urllib.parse
import base64
from datetime import datetime


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
    req = urllib.request.Request(
        url,
        data=data,
        headers=get_headers()
    )
    urllib.request.urlopen(req)


def handler():
    """Run the Lambda function."""
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

    repos = json.load(os.environ['REPOSITORIES'] or '{}')
    api_url = os.environ['GITHUB_API_URL']

    for repo in repos:
        endpoint = 'repos/{0}/{1}/hooks'.format(repo.owner, repo.name)
        url = urllib.parse.urljoin(api_url, endpoint)
        post(url, data)
