import os
import git #pylint: disable=import-error

commit_env = os.environ
commit_env['GIT_AUTHOR_NAME'] = 'My Name'
commit_env['GIT_AUTHOR_EMAIL'] = 'me@email.com'
commit_env['GIT_COMMITTER_NAME'] = 'My Name'
commit_env['GIT_COMMITTER_EMAIL'] = 'me@email.com'

new_repo_path = '/tmp/my-new-repo'

def handler_name(event, context):
    ...
    git.exec_command('add', '.', cwd=new_repo_path)
    git.exec_command('commit', '-m "first commit"', cwd=new_repo_path, env=commit_env)

    return {}
