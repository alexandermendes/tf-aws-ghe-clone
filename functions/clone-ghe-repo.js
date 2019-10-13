const { execSync } = require('child_process');
const AWS = require('aws-sdk');
const fs = require('fs');

/**
 * Clone and zip a git repo.
 * @param {object} repository
 *   The repository details.
 */
const cloneAndZip = ({ name, url }) => {
  const tmpDir = '/tmp';
  const zipName = 'repo.tar.gz';
  const execOpts = {
    encoding: 'utf8',
    stdio: 'inherit',
  };

  execSync(`rm -rf ${tmpDir}/*`, execOpts);

  execSync(`cd ${tmpDir} && git clone --depth 1 ${url}`, execOpts);

  execSync(`cd ${tmpDir} && tar -zcvf ${zipName} ${name}`);

  return `${tmpDir}/${zipName}`;
};

/**
 * Upload the zip to S3.
 */
const uploadToS3 = async (zipPath) => {
  const s3 = new AWS.S3({
    apiVersion: '2006-03-01',
  });
  const params = {
    Bucket: process.env.S3_BUCKET,
    Key: 'repo.tar.gz',
    Body: fs.createReadStream(zipPath),
  };

  await s3.upload(params).promise();
};

/**
 * Run.
 */
exports.handler = async(event) => {
  const { repository } = event;

  const zipPath = cloneAndZip(repository);

  await uploadToS3(zipPath);
}
