const { execSync } = require('child_process')

exports.handler = async(event) => {
  const { repository } = event;
  const tmpRootDir = '/tmp';
  const tmpRepoDir = `${tmpRootDir}/${repository.name}`;
  const execOpts = {
    encoding: 'utf8',
    stdio: 'inherit',
  };

  execSync(`rm -rf ${tmpRootDir}/*`, execOpts);

  execSync(`cd ${tmpRootDir} && git clone --depth 1 ${repository.html_url}`, execOpts);

  return execSync(`ls ${tmpRepoDir}`, { encoding: 'utf8' }).split('\n')
}
